import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'main.dart'; // To access ApiClient and UserProfile

class ChatMessage {
  final String id;
  final String role;
  final String content;
  final bool isError;

  ChatMessage({required this.id, required this.role, required this.content, this.isError = false});
}

class ChatbotPage extends StatefulWidget {
  final ApiClient api;
  final String token;
  final UserProfile user;

  const ChatbotPage({
    super.key,
    required this.api,
    required this.token,
    required this.user,
  });

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${widget.api.baseUrl}/private/api/v1/chatbot/history'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
          'X-App-Secret': 'MapanRahasia2026',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _messages.clear();
            for (var item in data['data']) {
              _messages.add(ChatMessage(
                id: item['id'].toString(),
                role: item['role'],
                content: item['content'],
                isError: false,
              ));
            }
          });
          _scrollToBottom();
        }
      }
    } catch (e) {
      debugPrint('Error loading chat history: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendMessage({String? retryText}) async {
    final text = retryText ?? _controller.text.trim();
    if (text.isEmpty) return;

    if (retryText == null) {
      _controller.clear();
      
      // Add user message optimistically
      final userMsg = ChatMessage(id: DateTime.now().toString(), role: 'user', content: text);
      setState(() {
        _messages.add(userMsg);
        _isLoading = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
    }
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse('${widget.api.baseUrl}/private/api/v1/chatbot'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-App-Secret': 'MapanRahasia2026',
          'Idempotency-Key': widget.api.generateUuid(),
        },
        body: jsonEncode({'message': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _messages.add(ChatMessage(
              id: data['data']['id'].toString(),
              role: data['data']['role'],
              content: data['data']['content'],
              isError: false,
            ));
          });
        }
      } else {
        // Show error message
        String errMsg = 'Maaf, terjadi kesalahan saat menghubungi server.';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['message'] != null) {
            errMsg = errorData['message'];
          }
        } catch (_) {}

        setState(() {
          _messages.add(ChatMessage(
            id: DateTime.now().toString(),
            role: 'model',
            content: errMsg,
            isError: true,
          ));
        });
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
      setState(() {
        _messages.add(ChatMessage(
          id: DateTime.now().toString(),
          role: 'model',
          content: 'Maaf, terjadi kesalahan jaringan.',
          isError: true,
        ));
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _scrollToBottom();
      }
    }
  }

  Future<void> _retryMessage(int errorIndex) async {
    String? userText;
    for (int i = errorIndex - 1; i >= 0; i--) {
      if (_messages[i].role == 'user') {
        userText = _messages[i].content;
        break;
      }
    }
    if (userText != null) {
      setState(() {
        _messages.removeAt(errorIndex);
      });
      await _sendMessage(retryText: userText);
    }
  }

  void _clearHistory() async {
    try {
      await http.delete(
        Uri.parse('${widget.api.baseUrl}/private/api/v1/chatbot/history'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
          'X-App-Secret': 'MapanRahasia2026',
          'Idempotency-Key': widget.api.generateUuid(),
        },
      );
      setState(() {
        _messages.clear();
      });
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.smart_toy, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tanya Mapan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Asisten Sawah AI', style: TextStyle(fontSize: 12, color: Colors.green.shade100)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus Riwayat',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Hapus Riwayat?'),
                  content: const Text('Apakah Anda yakin ingin menghapus semua riwayat obrolan ini?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _clearHistory();
                      },
                      child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty && !_isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.eco, size: 80, color: Colors.green.withOpacity(0.2)),
                        const SizedBox(height: 16),
                        Text(
                          'Halo ${widget.user.name}!',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Saya Tanya Mapan, asisten AI Anda.\nTanyakan apa saja tentang pertanian!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isLoading) {
                        return _buildLoadingBubble();
                      }
                      return _buildMessageBubble(_messages[index], index);
                    },
                  ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, int index) {
    final isUser = msg.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: isUser ? Colors.green.shade600 : (msg.isError ? Colors.red.shade50 : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 0),
            bottomRight: Radius.circular(isUser ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: isUser
            ? Text(
                msg.content,
                style: const TextStyle(color: Colors.white),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarkdownBody(
                    data: msg.content,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(color: msg.isError ? Colors.red.shade900 : Colors.grey.shade800),
                      strong: const TextStyle(fontWeight: FontWeight.bold),
                      listBullet: TextStyle(color: msg.isError ? Colors.red.shade900 : Colors.green.shade700),
                    ),
                  ),
                  if (msg.isError) ...[
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => _retryMessage(index),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red.shade700,
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.red.shade200),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green.shade400),
            ),
            const SizedBox(width: 8),
            Text('Berpikir...', style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -2),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Tanyakan sesuatu...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
