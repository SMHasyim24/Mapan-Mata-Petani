import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'glass_auth_widgets.dart';
import 'package:flutter/services.dart';
import 'main.dart'; // To access ApiClient, ClimateShell, context.colors etc.

// ============================================================================
// ONBOARDING PAGE
// ============================================================================
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> _getOnboardingData(BuildContext context) {
    return [
      {
        "title": context.t('onboarding_1_title'),
        "desc": context.t('onboarding_1_desc'),
        "image": "assets/images/onboarding_1.png",
        "pill": context.t('onboarding_1_pill'),
      },
      {
        "title": context.t('onboarding_2_title'),
        "desc": context.t('onboarding_2_desc'),
        "image": "assets/images/onboarding_2.png",
        "pill": context.t('onboarding_2_pill'),
      },
      {
        "title": context.t('onboarding_3_title'),
        "desc": context.t('onboarding_3_desc'),
        "image": "assets/images/onboarding_3.png",
        "pill": context.t('onboarding_3_pill'),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final onboardingData = _getOnboardingData(context);
    return Theme(
      data: MapanApp.buildTheme(Brightness.light, context.colors),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
            // Background Image Layer
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Image.asset(
                  onboardingData[_currentPage]["image"]!,
                  key: ValueKey<int>(_currentPage),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            // Gradient shadow from bottom
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.5, 0.85, 1.0],
                  ),
                ),
              ),
            ),

            // Content Layer
            SafeArea(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    _currentPage = value;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 40.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Glassmorphism Pill (Tilted slightly like the reference image)
                        Transform.rotate(
                          angle: -0.05,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(6, 6, 20, 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                      width: 1,
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        onboardingData[index]["image"]!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  onboardingData[index]["pill"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          onboardingData[index]["title"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.2,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Text(
                          onboardingData[index]["desc"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 120), // Space for bottom button
                      ],
                    ),
                  );
                },
              ),
            ),

            // Circular Arrow Button Layer
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (_currentPage < onboardingData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Progress Arc
                        SizedBox(
                          width: 76,
                          height: 76,
                          child: CircularProgressIndicator(
                            value: (_currentPage + 1) / onboardingData.length,
                            strokeWidth: 4,
                            color: Colors.greenAccent,
                            backgroundColor: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        // White Circular Button
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Header Layer (App Name & Skip Button)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'MAPAN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3.0,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 15.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_currentPage < onboardingData.length - 1)
                        TextButton(
                          onPressed: () {
                            _pageController.animateToPage(
                              onboardingData.length - 1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: const Text(
                            'Lewati',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 64, height: 48),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
    ),
  );
}
}

// ============================================================================
// LOGIN PAGE
// ============================================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

const String _googleServerClientId =
    '1031947360489-4tfluv3kvcd97ht5h8psf1lpk1lgqfa6.apps.googleusercontent.com';

class _LoginPageState extends State<LoginPage> {
  final ApiClient _api = ApiClient(baseUrl: apiBaseUrl);
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError('Email dan Password tidak boleh kosong.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _api.login(email, password);
      final token = response.token;
      final user = response.user;

      await _saveSession(token, user);

      if (mounted) {
        _showSuccess(
          'Berhasil masuk! Selamat datang, ${user.name.split(' ')[0]}.',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ClimateShell()),
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      final errorMsg = e.toString().replaceAll('Exception:', '').trim();
      _showError(
        errorMsg.isNotEmpty
            ? errorMsg
            : 'Maaf, email atau password Anda salah. Silakan coba lagi.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _googleServerClientId,
    scopes: ['email'],
  );

  Future<void> _loginWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _showError('Proses masuk Google dibatalkan.');
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        try {
          final response = await _api.loginWithGoogle(idToken, action: 'login');
          final token = response.token;
          var user = response.user;

          if (response.isNewUser) {
            final String? selectedRole = await _showRoleSelectionDialog();
            if (selectedRole != null && selectedRole != user.role) {
              await _api.updateRole(token, selectedRole);
              user = UserProfile(
                name: user.name,
                email: user.email,
                role: selectedRole,
                avatarUrl: user.avatarUrl,
              );
            }
          }

          await _saveSession(token, user);
          if (mounted) {
            _showSuccess('Berhasil masuk dengan akun Google! Selamat datang, ${user.name.split(' ')[0]}.');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ClimateShell()),
            );
          }
        } catch (e) {
          debugPrint('Google login server error: $e');
          final errorMsg = e.toString().replaceAll('Exception:', '').trim();
          _showError(
            errorMsg.isNotEmpty
                ? errorMsg
                : 'Maaf, gagal menghubungkan akun Google Anda dengan server.',
          );
          await _googleSignIn.signOut();
        }
      } else {
        _showError(context.t('google_token_failed', listen: false));
      }
    } catch (error) {
      debugPrint('Google Sign-In error: $error');
      _showError(
        'Maaf, proses masuk dengan Google dibatalkan atau terjadi kesalahan.',
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<String?> _showRoleSelectionDialog() {
    return showModalBottomSheet<String>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Satu Langkah Lagi!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006948),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Anda ingin bergabung sebagai apa di komunitas Mapan?',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'user'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF006948),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Petani / Umum',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context, 'pakar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF006948),
                    side: const BorderSide(color: Color(0xFF006948), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Pakar Ahli',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveSession(String token, UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_role', user.role);
    if (user.pendingRole != null) {
      await prefs.setString('pending_role', user.pendingRole!);
    } else {
      await prefs.remove('pending_role');
    }
    if (user.avatarUrl != null) {
      await prefs.setString('user_photo', user.avatarUrl!);
    } else {
      await prefs.remove('user_photo');
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset('assets/images/onboarding_1.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: FadeInSlide(
                  delay: const Duration(milliseconds: 100),
                  child: GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const OnboardingPage()),
                                  );
                                }
                              },
                            ),
                            Expanded(
                              child: Text(
                                context.t('welcome'),
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 48), // Spacer to center the text
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Silakan masuk untuk melanjutkan',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        AnimatedGlassField(
                          controller: _emailController,
                          labelText: context.t('email'),
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        AnimatedGlassField(
                          controller: _passwordController,
                          labelText: context.t('password'),
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Lupa Password?',
                              style: TextStyle(color: Colors.greenAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        GlassBouncingButton(
                          onPressed: _isLoading || _isGoogleLoading ? null : _login,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF006948), Color(0xFF009668)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF006948).withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Masuk',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Colors.white30)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(context.t('or_text'), style: const TextStyle(color: Colors.white54)),
                            ),
                            const Expanded(child: Divider(color: Colors.white30)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        GlassBouncingButton(
                          onPressed: _isLoading || _isGoogleLoading ? null : _loginWithGoogle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isGoogleLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Icon(
                                        Icons.g_mobiledata,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Masuk dengan Google',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.t('dont_have_account'), style: const TextStyle(color: Colors.white70)),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Daftar',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// REGISTER PAGE
// ============================================================================
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final ApiClient _api = ApiClient(baseUrl: apiBaseUrl);
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  double _passwordStrength = 0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;

  bool _isGoogleLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: _googleServerClientId,
    scopes: ['email'],
  );

  Future<void> _loginWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _showError('Proses pendaftaran Google dibatalkan.');
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken != null) {
        try {
          final response = await _api.loginWithGoogle(
            idToken,
            action: 'register',
          );
          final token = response.token;
          var user = response.user;



          await _saveSession(token, user);
          if (mounted) {
            _showSuccess('Pendaftaran dengan Google berhasil! Selamat datang.');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ClimateShell()),
            );
          }
        } catch (e) {
          debugPrint('Google register server error: $e');
          final errorMsg = e.toString().replaceAll('Exception:', '').trim();
          _showError(
            errorMsg.isNotEmpty
                ? errorMsg
                : 'Maaf, gagal mendaftarkan akun Google Anda dengan server.',
          );
          await _googleSignIn.signOut();
        }
      } else {
        _showError(context.t('google_token_failed', listen: false));
      }
    } catch (error) {
      debugPrint('Google Sign-In error (register): $error');
      _showError(
        'Maaf, proses pendaftaran dengan Google dibatalkan atau terjadi kesalahan.',
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }


  Future<void> _saveSession(String token, UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_role', user.role);
    if (user.pendingRole != null) {
      await prefs.setString('pending_role', user.pendingRole!);
    } else {
      await prefs.remove('pending_role');
    }
    if (user.avatarUrl != null) {
      await prefs.setString('user_photo', user.avatarUrl!);
    } else {
      await prefs.remove('user_photo');
    }
  }

  void _checkPasswordStrength(String password) {
    double strength = 0;
    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    setState(() {
      _passwordStrength = strength;
      if (strength <= 0.25) {
        _passwordStrengthText = 'Sangat Lemah';
        _passwordStrengthColor = Colors.red;
      } else if (strength <= 0.5) {
        _passwordStrengthText = 'Lemah';
        _passwordStrengthColor = Colors.orange;
      } else if (strength <= 0.75) {
        _passwordStrengthText = 'Sedang';
        _passwordStrengthColor = Colors.yellow.shade700;
      } else {
        _passwordStrengthText = 'Kuat';
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  Future<void> _register() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showError('Semua kolom wajib diisi.');
      return;
    }

    if (password != confirmPassword) {
      _showError(context.t('password_confirm_mismatch', listen: false));
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Semua otomatis menjadi 'user' (Petani) saat mendaftar
      final role = 'user';
      await _api.register(name, email, password, role);

      if (mounted) {
        _showSuccess('Registrasi berhasil! Silakan masuk dengan akun Anda.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception:', '').trim();
      _showError(
        errorMsg.isNotEmpty
            ? errorMsg
            : 'Maaf, pendaftaran gagal. Email mungkin sudah terdaftar.',
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/onboarding_1.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: FadeInSlide(
                  delay: const Duration(milliseconds: 100),
                  child: GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                'Buat Akun Baru',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Bergabunglah bersama komunitas Mapan',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        AnimatedGlassField(
                          controller: _nameController,
                          labelText: context.t('full_name'),
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        AnimatedGlassField(
                          controller: _emailController,
                          labelText: context.t('email'),
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        AnimatedGlassField(
                          controller: _passwordController,
                          labelText: context.t('password'),
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          onChanged: _checkPasswordStrength,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedGlassField(
                          controller: _confirmPasswordController,
                          labelText: context.t('repeat_password'),
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_passwordController.text.isNotEmpty) ...[
                          Row(
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _passwordStrength,
                                    backgroundColor: Colors.white24,
                                    color: _passwordStrengthColor,
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _passwordStrengthText,
                                style: TextStyle(
                                  color: _passwordStrengthColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Min 8 karakter, kapital, angka, simbol.',
                            style: TextStyle(fontSize: 10, color: Colors.white54),
                          ),
                        ],

                        const SizedBox(height: 32),
                        GlassBouncingButton(
                          onPressed: _isLoading || _isGoogleLoading ? null : _register,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF006948), Color(0xFF009668)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF006948).withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'Daftar Sekarang',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Expanded(child: Divider(color: Colors.white30)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(context.t('or_text'), style: const TextStyle(color: Colors.white54)),
                            ),
                            const Expanded(child: Divider(color: Colors.white30)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        GlassBouncingButton(
                          onPressed: _isLoading || _isGoogleLoading ? null : _loginWithGoogle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _isGoogleLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : const Icon(Icons.g_mobiledata, size: 32, color: Colors.white),
                                const SizedBox(width: 8),
                                const Text(
                                  'Daftar dengan Google',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.t('already_have_account'), style: const TextStyle(color: Colors.white70)),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                              },
                              child: const Text(
                                'Masuk',
                                style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// FORGOT PASSWORD PAGE
// ============================================================================
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final ApiClient _api = ApiClient(baseUrl: apiBaseUrl);
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showError('Silakan masukkan email Anda.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _api.forgotPassword(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t('otp_sent_to_email', listen: false)),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordPage(email: email),
          ),
        );
      }
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      _showError('${context.t('failed_send_otp', listen: false)} $msg');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/onboarding_1.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: FadeInSlide(
                  delay: const Duration(milliseconds: 100),
                  child: GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text(
                                'Lupa Password',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Kami akan mengirimkan Kode OTP ke email Anda.',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        AnimatedGlassField(
                          controller: _emailController,
                          labelText: context.t('your_email'),
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 32),
                        GlassBouncingButton(
                          onPressed: _isLoading ? null : _sendOtp,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF006948), Color(0xFF009668)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF006948).withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text(
                                      'Kirim Kode',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// RESET PASSWORD PAGE
// ============================================================================
class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final ApiClient _api = ApiClient(baseUrl: apiBaseUrl);
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // new
  bool _isLoading = false;
  bool _isOtpVerified = false; // new
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true; // new
  double _passwordStrength = 0;

  void _checkPasswordStrength(String value) {
    if (value.isEmpty) {
      setState(() => _passwordStrength = 0);
    } else if (value.length < 6) {
      setState(() => _passwordStrength = 0.3);
    } else if (value.length < 8) {
      setState(() => _passwordStrength = 0.6);
    } else {
      setState(() => _passwordStrength = 1.0);
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.isEmpty) {
      _showError('Kode OTP wajib diisi.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _api.verifyOtp(widget.email, otp);
      if (mounted) {
        setState(() {
          _isOtpVerified = true;
        });
      }
    } catch (e) {
      _showError('Kode OTP tidak valid atau salah.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    final otp = _otpController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showError('Semua field wajib diisi.');
      return;
    }

    if (password != confirmPassword) {
      _showError(context.t('password_confirm_mismatch', listen: false));
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _api.resetPassword(widget.email, otp, password);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.t('password_changed_login', listen: false)),
            backgroundColor: Colors.green,
          ),
        );
        // Kembali ke halaman Login dengan menghapus stack halaman lain
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      _showError('Kode OTP tidak valid atau password tidak memenuhi syarat.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/onboarding_1.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: FadeInSlide(
                  delay: const Duration(milliseconds: 100),
                  child: GlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text(
                                'Ubah Password',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Masukkan kode 6 digit dari email ${widget.email}',
                          style: const TextStyle(fontSize: 16, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        AnimatedGlassField(
                          controller: _otpController,
                          labelText: context.t('otp_code'),
                          prefixIcon: Icons.key,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        if (!_isOtpVerified) ...[
                          GlassBouncingButton(
                            onPressed: _isLoading ? null : _verifyOtp,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF006948), Color(0xFF009668)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF006948).withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text(
                                        'Verifikasi OTP',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                        ] else ...[
                          AnimatedGlassField(
                            controller: _passwordController,
                            labelText: context.t('new_password', listen: false),
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscurePassword,
                            onChanged: _checkPasswordStrength,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedGlassField(
                            controller: _confirmPasswordController,
                            labelText: context.t('repeat_password', listen: false),
                            prefixIcon: Icons.lock_outline,
                            obscureText: _obscureConfirmPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                            ),
                          ),
                          if (_passwordStrength > 0) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: _passwordStrength,
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      color: _passwordStrength <= 0.3
                                          ? Colors.red
                                          : _passwordStrength <= 0.6
                                              ? Colors.orange
                                              : Colors.greenAccent,
                                      minHeight: 6,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _passwordStrength <= 0.3
                                      ? 'Lemah'
                                      : _passwordStrength <= 0.6
                                          ? 'Sedang'
                                          : 'Kuat',
                                  style: TextStyle(
                                    color: _passwordStrength <= 0.3
                                        ? Colors.red
                                        : _passwordStrength <= 0.6
                                            ? Colors.orange
                                            : Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 32),
                          GlassBouncingButton(
                            onPressed: _isLoading ? null : _resetPassword,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF006948), Color(0xFF009668)],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF006948).withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : const Text(
                                        'Simpan Password Baru',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
