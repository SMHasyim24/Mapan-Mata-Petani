---
title: Laravel v0.0.1
language_tabs:
  - shell: Shell
  - http: HTTP
  - javascript: JavaScript
  - ruby: Ruby
  - python: Python
  - php: PHP
  - java: Java
  - go: Go
toc_footers: []
includes: []
search: true
highlight_theme: darkula
headingLevel: 2

---

<!-- Generator: Widdershins v4.0.1 -->

<h1 id="laravel">Laravel v0.0.1</h1>

> Scroll down for code samples, example requests and responses. Select a language for code samples from the tabs above or the mobile navigation menu.

# Dokumentasi API Mapan

Selamat datang di Dokumentasi API untuk aplikasi **Mapan** (Sistem Cerdas Pendeteksi Hama dan Penyakit Tanaman Padi). Dokumentasi ini dihasilkan secara otomatis menggunakan [Scramble](https://scramble.dedoc.co/) untuk membantu Anda dalam proses integrasi aplikasi *frontend* maupun *client* lainnya.

---

## 1. Struktur URL dan Prefix

API Mapan membagi *endpoints* ke dalam dua kategori utama yang menggunakan *prefix* URL berbeda. Perbedaan ini bergantung pada apakah *endpoint* tersebut membutuhkan autentikasi (Login) atau dapat diakses secara publik.

### A. Public API (`/public/api/v1/`)
- Rute ini **tidak memerlukan token autentikasi**.
- Biasanya digunakan untuk fitur-fitur seperti Pendaftaran (Register), Login, Request OTP, Reset Password, atau pengambilan data-data umum yang tidak sensitif.
- **Contoh endpoint**: `POST /public/api/v1/login`

### B. Private API (`/private/api/v1/`)
- Rute ini **wajib menyertakan Token Autentikasi** (Bearer Token) pada *header* HTTP.
- Meliputi fitur utama aplikasi seperti *Dashboard*, Pengajuan Pakar/Admin, Deteksi Penyakit Daun, *Chatbot*, dan Manajemen Data.
- **Contoh endpoint**: `GET /private/api/v1/dashboard/user`

---

## 2. Kunci Keamanan Aplikasi (App Secret)

Sebagai lapisan keamanan tambahan, **semua endpoint API** (baik Public maupun Private) diwajibkan untuk menyertakan *header* rahasia aplikasi. Jika *header* ini tidak disertakan, server akan menolak permintaan tersebut (Unauthorized).

- **Header Key**: `X-App-Secret`
- **Header Value**: `MapanRahasia2026` (atau nilai dari `.env` `APP_SECRET_KEY`)

Pastikan Anda selalu menyisipkan *header* ini di setiap *request* yang Anda buat!

---

## 2. Panduan Autentikasi (Sanctum)

Aplikasi Mapan menggunakan **Laravel Sanctum** untuk menangani proses autentikasi via Token.

### Mendapatkan Token
1. Lakukan *request* `POST` ke *endpoint* `/public/api/v1/login`.
2. Kirimkan *payload* berupa `email` dan `password`.
3. Jika kredensial benar, server akan membalas dengan status `200 OK` dan Anda akan mendapatkan *key* `token` di dalam JSON *response*.

### Menggunakan Token
Untuk mengakses *endpoint* Private (seperti memindai penyakit atau melihat riwayat), Anda harus melampirkan Token tersebut di *header* HTTP Anda. Formatnya adalah:

```http
Authorization: Bearer <TULIS_TOKEN_ANDA_DI_SINI>
Accept: application/json
```

> **Note:** Pada halaman dokumentasi (Scramble) ini, Anda bisa menekan tombol **"Authorize"** di panel sebelah kiri atau atas, kemudian memasukkan token Anda secara langsung untuk melakukan tes *endpoint* langsung dari *browser*.

---

## 3. Cara Penggunaan di Postman

Jika Anda lebih memilih melakukan *testing* API melalui aplikasi **Postman**, dokumentasi ini menyediakan spesifikasi OpenAPI lengkap yang dapat diimpor secara langsung. Berikut langkah-langkahnya:

### Langkah 1: Salin URL OpenAPI
Scramble menyediakan *file* spesifikasi OpenAPI berekstensi `.json`. Silakan salin URL berikut (sesuaikan domain jika Anda meletakkannya di *server* / *hosting*):
`http://localhost:8000/docs/api.json`

### Langkah 2: Impor ke Postman
1. Buka aplikasi **Postman**.
2. Klik tombol **Import** (biasanya berada di panel kiri atas).
3. Pilih opsi **Link / URL**, lalu *paste* URL `http://localhost:8000/docs/api.json` yang telah Anda salin.
4. Klik **Import** dan tunggu beberapa detik. Postman akan secara otomatis membangun struktur *Collection* API beserta *request/response* secara utuh.

### Langkah 3: Mengatur Environment (Variabel Token)
Agar Anda tidak perlu menyalin-tempel token ke setiap *request* Private, konfigurasikan Environment di Postman:
1. Pergi ke bagian **Environments** di panel kiri Postman, dan buat *Environment* baru (misal: "Mapan Local").
2. Buat variabel baru bernama `token` (biarkan kosong) dan variabel `app_secret` (isi dengan `MapanRahasia2026`).
3. Edit *Collection* Mapan yang baru saja diimpor $\rightarrow$ masuk ke *tab* **Authorization**.
4. Ubah tipe menjadi **Bearer Token**.
5. Pada kolom *Token*, ketikkan `{{token}}`. Jangan lupa **Save**.
6. Selanjutnya, masuk ke *tab* **Pre-request Script** di *Collection* yang sama, lalu tambahkan kode berikut agar *header* `X-App-Secret` selalu disisipkan ke semua *request* secara otomatis:
   ```javascript
   pm.request.headers.add({
       key: 'X-App-Secret',
       value: pm.environment.get("app_secret")
   });
   ```
   Lalu tekan **Save**.
7. Sekarang, setiap kali Anda login, ambil nilai *token*-nya dan tempelkan ke variabel `token` di Environment Anda. Seluruh *request* lain akan otomatis memakai token beserta rahasia aplikasi (`X-App-Secret`)!

Base URLs:

* <a href="https://arturo-untaunting-thrawnly.ngrok-free.dev/api">https://arturo-untaunting-thrawnly.ngrok-free.dev/api</a>

# Authentication

* API Key (apiKey)
    - Parameter Name: **X-App-Secret**, in: header. Masukkan Kunci Rahasia Aplikasi (MapanRahasia2026) di sini untuk seluruh endpoint.

- HTTP Authentication, scheme: bearer 

<h1 id="laravel-default">Default</h1>

## post__public_api_v1_test-fcm

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/test-fcm \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/test-fcm HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "token": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/test-fcm',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/test-fcm',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/test-fcm', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/test-fcm', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/test-fcm");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/test-fcm", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /public/api/v1/test-fcm`

> Body parameter

```json
{
  "token": "string"
}
```

<h3 id="post__public_api_v1_test-fcm-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|false|none|
|» token|body|string|false|none|

> Example responses

> 200 Response

```json
{
  "message": "string"
}
```

<h3 id="post__public_api_v1_test-fcm-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|none|Inline|
|500|[Internal Server Error](https://tools.ietf.org/html/rfc7231#section-6.6.1)|none|Inline|

<h3 id="post__public_api_v1_test-fcm-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **400**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» error|string|true|none|none|

Status Code **500**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» error|string|true|none|none|

<aside class="success">
This operation does not require authentication
</aside>

<h1 id="laravel-adminapi">AdminApi</h1>

## adminApi.diseases

<a id="opIdadminApi.diseases"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/knowledge-base/diseases`

> Example responses

> 200 Response

```json
{
  "diseases": [
    {
      "id": 0,
      "name": "string",
      "slug": "string",
      "latin_name": "string",
      "description": "string",
      "cause": "string",
      "image": "string",
      "created_at": "2019-08-24T14:15:22Z",
      "updated_at": "2019-08-24T14:15:22Z"
    }
  ]
}
```

<h3 id="adminapi.diseases-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="adminapi.diseases-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» diseases|[[Disease](#schemadisease)]|true|none|none|
|»» Disease|[Disease](#schemadisease)|false|none|none|
|»»» id|integer|true|none|none|
|»»» name|string|true|none|none|
|»»» slug|string|true|none|none|
|»»» latin_name|string,null|true|none|none|
|»»» description|string|true|none|none|
|»»» cause|string|true|none|none|
|»»» image|string,null|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.storeDisease

<a id="opIdadminApi.storeDisease"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "name": "string",
  "latin_name": "string",
  "description": "string",
  "cause": "string",
  "symptoms": [
    {
      "id": 0,
      "weight": 0.1
    }
  ]
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/admin/knowledge-base/diseases`

> Body parameter

```json
{
  "name": "string",
  "latin_name": "string",
  "description": "string",
  "cause": "string",
  "symptoms": [
    {
      "id": 0,
      "weight": 0.1
    }
  ]
}
```

<h3 id="adminapi.storedisease-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» name|body|string|true|none|
|» latin_name|body|string,null|false|none|
|» description|body|string|true|none|
|» cause|body|string|true|none|
|» symptoms|body|array,null|false|none|
|»» id|body|integer|false|none|
|»» weight|body|number|false|none|

> Example responses

> 201 Response

```json
{
  "message": "Penyakit berhasil ditambahkan.",
  "disease": {
    "id": 0,
    "name": "string",
    "slug": "string",
    "latin_name": "string",
    "description": "string",
    "cause": "string",
    "image": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="adminapi.storedisease-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="adminapi.storedisease-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» disease|[Disease](#schemadisease)|true|none|none|
|»» id|integer|true|none|none|
|»» name|string|true|none|none|
|»» slug|string|true|none|none|
|»» latin_name|string,null|true|none|none|
|»» description|string|true|none|none|
|»» cause|string|true|none|none|
|»» image|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.updateDisease

<a id="opIdadminApi.updateDisease"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease} \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "name": "string",
  "latin_name": "string",
  "description": "string",
  "cause": "string",
  "symptoms": [
    {
      "id": 0,
      "weight": 0.1
    }
  ]
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.put 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.put('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /private/api/v1/admin/knowledge-base/diseases/{disease}`

> Body parameter

```json
{
  "name": "string",
  "latin_name": "string",
  "description": "string",
  "cause": "string",
  "symptoms": [
    {
      "id": 0,
      "weight": 0.1
    }
  ]
}
```

<h3 id="adminapi.updatedisease-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|disease|path|integer|true|The disease ID|
|body|body|object|true|none|
|» name|body|string|true|none|
|» latin_name|body|string,null|false|none|
|» description|body|string|true|none|
|» cause|body|string|true|none|
|» symptoms|body|array,null|false|none|
|»» id|body|integer|false|none|
|»» weight|body|number|false|none|

> Example responses

> 200 Response

```json
{
  "message": "Penyakit berhasil diperbarui.",
  "disease": {
    "id": 0,
    "name": "string",
    "slug": "string",
    "latin_name": "string",
    "description": "string",
    "cause": "string",
    "image": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="adminapi.updatedisease-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="adminapi.updatedisease-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» disease|[Disease](#schemadisease)|true|none|none|
|»» id|integer|true|none|none|
|»» name|string|true|none|none|
|»» slug|string|true|none|none|
|»» latin_name|string,null|true|none|none|
|»» description|string|true|none|none|
|»» cause|string|true|none|none|
|»» image|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.destroyDisease

<a id="opIdadminApi.destroyDisease"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease} \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.delete 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.delete('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/diseases/{disease}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /private/api/v1/admin/knowledge-base/diseases/{disease}`

<h3 id="adminapi.destroydisease-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|disease|path|integer|true|The disease ID|

> Example responses

> 200 Response

```json
{
  "message": "Penyakit berhasil dihapus."
}
```

<h3 id="adminapi.destroydisease-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="adminapi.destroydisease-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.symptoms

<a id="opIdadminApi.symptoms"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/knowledge-base/symptoms`

> Example responses

> 200 Response

```json
{
  "symptoms": [
    {
      "id": 0,
      "code": "string",
      "name": "string",
      "description": "string",
      "created_at": "2019-08-24T14:15:22Z",
      "updated_at": "2019-08-24T14:15:22Z"
    }
  ]
}
```

<h3 id="adminapi.symptoms-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="adminapi.symptoms-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» symptoms|[[Symptom](#schemasymptom)]|true|none|none|
|»» Symptom|[Symptom](#schemasymptom)|false|none|none|
|»»» id|integer|true|none|none|
|»»» code|string|true|none|none|
|»»» name|string|true|none|none|
|»»» description|string,null|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.storeSymptom

<a id="opIdadminApi.storeSymptom"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "code": "string",
  "name": "string",
  "description": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/admin/knowledge-base/symptoms`

> Body parameter

```json
{
  "code": "string",
  "name": "string",
  "description": "string"
}
```

<h3 id="adminapi.storesymptom-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» code|body|string|true|none|
|» name|body|string|true|none|
|» description|body|string,null|false|none|

> Example responses

> 201 Response

```json
{
  "message": "Gejala berhasil ditambahkan.",
  "symptom": {
    "id": 0,
    "code": "string",
    "name": "string",
    "description": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="adminapi.storesymptom-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="adminapi.storesymptom-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» symptom|[Symptom](#schemasymptom)|true|none|none|
|»» id|integer|true|none|none|
|»» code|string|true|none|none|
|»» name|string|true|none|none|
|»» description|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.updateSymptom

<a id="opIdadminApi.updateSymptom"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom} \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "code": "string",
  "name": "string",
  "description": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.put 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.put('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /private/api/v1/admin/knowledge-base/symptoms/{symptom}`

> Body parameter

```json
{
  "code": "string",
  "name": "string",
  "description": "string"
}
```

<h3 id="adminapi.updatesymptom-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|symptom|path|integer|true|The symptom ID|
|body|body|object|true|none|
|» code|body|string|true|none|
|» name|body|string|true|none|
|» description|body|string,null|false|none|

> Example responses

> 200 Response

```json
{
  "message": "Gejala berhasil diperbarui.",
  "symptom": {
    "id": 0,
    "code": "string",
    "name": "string",
    "description": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="adminapi.updatesymptom-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="adminapi.updatesymptom-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» symptom|[Symptom](#schemasymptom)|true|none|none|
|»» id|integer|true|none|none|
|»» code|string|true|none|none|
|»» name|string|true|none|none|
|»» description|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.destroySymptom

<a id="opIdadminApi.destroySymptom"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom} \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.delete 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.delete('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/symptoms/{symptom}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /private/api/v1/admin/knowledge-base/symptoms/{symptom}`

<h3 id="adminapi.destroysymptom-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|symptom|path|integer|true|The symptom ID|

> Example responses

> 200 Response

```json
{
  "message": "Gejala berhasil dihapus."
}
```

<h3 id="adminapi.destroysymptom-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="adminapi.destroysymptom-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.treatments

<a id="opIdadminApi.treatments"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/knowledge-base/treatments`

> Example responses

> 200 Response

```json
{
  "treatments": [
    {
      "id": 0,
      "disease_id": 0,
      "type": "string",
      "description": "string",
      "dosage": "string",
      "dosage_unit": "string",
      "priority": 0,
      "created_at": "2019-08-24T14:15:22Z",
      "updated_at": "2019-08-24T14:15:22Z"
    }
  ]
}
```

<h3 id="adminapi.treatments-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="adminapi.treatments-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» treatments|[[Treatment](#schematreatment)]|true|none|none|
|»» Treatment|[Treatment](#schematreatment)|false|none|none|
|»»» id|integer|true|none|none|
|»»» disease_id|integer|true|none|none|
|»»» type|string|true|none|none|
|»»» description|string|true|none|none|
|»»» dosage|string,null|true|none|none|
|»»» dosage_unit|string,null|true|none|none|
|»»» priority|integer|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.storeTreatment

<a id="opIdadminApi.storeTreatment"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "disease_id": 0,
  "type": "prevention",
  "description": "string",
  "dosage": "string",
  "dosage_unit": "string",
  "priority": 0
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/admin/knowledge-base/treatments`

> Body parameter

```json
{
  "disease_id": 0,
  "type": "prevention",
  "description": "string",
  "dosage": "string",
  "dosage_unit": "string",
  "priority": 0
}
```

<h3 id="adminapi.storetreatment-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» disease_id|body|integer|true|none|
|» type|body|string|true|none|
|» description|body|string|true|none|
|» dosage|body|string,null|false|none|
|» dosage_unit|body|string,null|false|none|
|» priority|body|integer|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|» type|prevention|
|» type|chemical|
|» type|biological|
|» type|cultural|

> Example responses

> 201 Response

```json
{
  "message": "Penanganan berhasil ditambahkan.",
  "treatment": {
    "id": 0,
    "disease_id": 0,
    "type": "string",
    "description": "string",
    "dosage": "string",
    "dosage_unit": "string",
    "priority": 0,
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="adminapi.storetreatment-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="adminapi.storetreatment-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» treatment|[Treatment](#schematreatment)|true|none|none|
|»» id|integer|true|none|none|
|»» disease_id|integer|true|none|none|
|»» type|string|true|none|none|
|»» description|string|true|none|none|
|»» dosage|string,null|true|none|none|
|»» dosage_unit|string,null|true|none|none|
|»» priority|integer|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.updateTreatment

<a id="opIdadminApi.updateTreatment"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment} \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "disease_id": 0,
  "type": "prevention",
  "description": "string",
  "dosage": "string",
  "dosage_unit": "string",
  "priority": 0
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.put 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.put('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /private/api/v1/admin/knowledge-base/treatments/{treatment}`

> Body parameter

```json
{
  "disease_id": 0,
  "type": "prevention",
  "description": "string",
  "dosage": "string",
  "dosage_unit": "string",
  "priority": 0
}
```

<h3 id="adminapi.updatetreatment-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|treatment|path|integer|true|The treatment ID|
|body|body|object|true|none|
|» disease_id|body|integer|true|none|
|» type|body|string|true|none|
|» description|body|string|true|none|
|» dosage|body|string,null|false|none|
|» dosage_unit|body|string,null|false|none|
|» priority|body|integer|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|» type|prevention|
|» type|chemical|
|» type|biological|
|» type|cultural|

> Example responses

> 200 Response

```json
{
  "message": "Penanganan berhasil diperbarui.",
  "treatment": {
    "id": 0,
    "disease_id": 0,
    "type": "string",
    "description": "string",
    "dosage": "string",
    "dosage_unit": "string",
    "priority": 0,
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="adminapi.updatetreatment-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="adminapi.updatetreatment-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» treatment|[Treatment](#schematreatment)|true|none|none|
|»» id|integer|true|none|none|
|»» disease_id|integer|true|none|none|
|»» type|string|true|none|none|
|»» description|string|true|none|none|
|»» dosage|string,null|true|none|none|
|»» dosage_unit|string,null|true|none|none|
|»» priority|integer|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.destroyTreatment

<a id="opIdadminApi.destroyTreatment"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment} \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.delete 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.delete('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/knowledge-base/treatments/{treatment}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /private/api/v1/admin/knowledge-base/treatments/{treatment}`

<h3 id="adminapi.destroytreatment-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|treatment|path|integer|true|The treatment ID|

> Example responses

> 200 Response

```json
{
  "message": "Penanganan berhasil dihapus."
}
```

<h3 id="adminapi.destroytreatment-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="adminapi.destroytreatment-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.users

<a id="opIdadminApi.users"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/system/users`

> Example responses

> 200 Response

```json
{
  "users": {
    "current_page": 1,
    "data": [
      {
        "id": 0,
        "name": "string",
        "email": "string",
        "email_verified_at": "2019-08-24T14:15:22Z",
        "created_at": "2019-08-24T14:15:22Z",
        "updated_at": "2019-08-24T14:15:22Z",
        "role": "string",
        "two_factor_confirmed_at": "2019-08-24T14:15:22Z",
        "avatar_url": "string",
        "fcm_token": "string",
        "google_id": "string",
        "avatar": "string",
        "pending_role": "string",
        "agency_name": "string"
      }
    ],
    "first_page_url": "string",
    "from": 1,
    "last_page_url": "string",
    "last_page": 1,
    "links": [
      {
        "url": "string",
        "label": "string",
        "active": true
      }
    ],
    "next_page_url": "string",
    "path": "string",
    "per_page": 0,
    "prev_page_url": "string",
    "to": 1,
    "total": 0
  },
  "roles": [
    "super_admin",
    "admin",
    "pakar",
    "user"
  ]
}
```

<h3 id="adminapi.users-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="adminapi.users-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» users|object|true|none|none|
|»» current_page|integer|true|none|none|
|»» data|[[User](#schemauser)]|true|none|none|
|»»» User|[User](#schemauser)|false|none|none|
|»»»» id|integer|true|none|none|
|»»»» name|string|true|none|none|
|»»»» email|string|true|none|none|
|»»»» email_verified_at|string,null(date-time)|true|none|none|
|»»»» created_at|string,null(date-time)|true|none|none|
|»»»» updated_at|string,null(date-time)|true|none|none|
|»»»» role|string|true|none|none|
|»»»» two_factor_confirmed_at|string,null(date-time)|true|none|none|
|»»»» avatar_url|string,null|true|none|none|
|»»»» fcm_token|string,null|true|none|none|
|»»»» google_id|string,null|true|none|none|
|»»»» avatar|string,null|true|none|none|
|»»»» pending_role|string,null|true|none|none|
|»»»» agency_name|string,null|true|none|none|
|»» first_page_url|string,null|true|none|none|
|»» from|integer,null|true|none|none|
|»» last_page_url|string,null|true|none|none|
|»» last_page|integer|true|none|none|
|»» links|[object]|true|none|Generated paginator links.|
|»»» url|string,null|true|none|none|
|»»» label|string|true|none|none|
|»»» active|boolean|true|none|none|
|»» next_page_url|string,null|true|none|none|
|»» path|string,null|true|none|Base path for paginator generated URLs.|
|»» per_page|integer|true|none|Number of items shown per page.|
|»» prev_page_url|string,null|true|none|none|
|»» to|integer,null|true|none|Number of the last item in the slice.|
|»» total|integer|true|none|Total number of items being paginated.|
|» roles|array|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.updateUser

<a id="opIdadminApi.updateUser"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user} \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "name": "string",
  "email": "user@example.com",
  "role": "super_admin"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.put 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.put('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /private/api/v1/admin/system/users/{user}`

> Body parameter

```json
{
  "name": "string",
  "email": "user@example.com",
  "role": "super_admin"
}
```

<h3 id="adminapi.updateuser-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|user|path|integer|true|The user ID|
|body|body|object|true|none|
|» name|body|string|true|none|
|» email|body|string(email)|true|none|
|» role|body|string|true|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|» role|super_admin|
|» role|admin|
|» role|pakar|
|» role|user|

> Example responses

> 200 Response

```json
{
  "message": "string",
  "user": {
    "id": 0,
    "name": "string",
    "email": "string",
    "email_verified_at": "2019-08-24T14:15:22Z",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "role": "string",
    "two_factor_confirmed_at": "2019-08-24T14:15:22Z",
    "avatar_url": "string",
    "fcm_token": "string",
    "google_id": "string",
    "avatar": "string",
    "pending_role": "string",
    "agency_name": "string"
  }
}
```

<h3 id="adminapi.updateuser-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|none|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="adminapi.updateuser-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» user|any|true|none|none|

*anyOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|»» *anonymous*|[User](#schemauser)|false|none|none|
|»»» id|integer|true|none|none|
|»»» name|string|true|none|none|
|»»» email|string|true|none|none|
|»»» email_verified_at|string,null(date-time)|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|
|»»» role|string|true|none|none|
|»»» two_factor_confirmed_at|string,null(date-time)|true|none|none|
|»»» avatar_url|string,null|true|none|none|
|»»» fcm_token|string,null|true|none|none|
|»»» google_id|string,null|true|none|none|
|»»» avatar|string,null|true|none|none|
|»»» pending_role|string,null|true|none|none|
|»»» agency_name|string,null|true|none|none|

*or*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|»» *anonymous*|null|false|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **403**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.destroyUser

<a id="opIdadminApi.destroyUser"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user} \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.delete 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.delete('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/users/{user}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /private/api/v1/admin/system/users/{user}`

<h3 id="adminapi.destroyuser-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|user|path|integer|true|The user ID|

> Example responses

> 200 Response

```json
{
  "message": "User berhasil dihapus."
}
```

<h3 id="adminapi.destroyuser-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|none|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="adminapi.destroyuser-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.detections

<a id="opIdadminApi.detections"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/detections`

<h3 id="adminapi.detections-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|method|query|string|false|none|
|city|query|string|false|none|
|disease_id|query|string|false|none|
|time_range|query|string|false|none|

> Example responses

> 200 Response

```json
{
  "current_page": 1,
  "data": [
    {
      "id": 0,
      "user_id": 0,
      "disease_id": 0,
      "method": "string",
      "image_path": "string",
      "label": "string",
      "confidence": "string",
      "temperature": "string",
      "scanned_at": "2019-08-24T14:15:22Z",
      "scan_duration_ms": 0,
      "latitude": "string",
      "longitude": "string",
      "connection_status": "string",
      "predictions": [
        null
      ],
      "selected_symptoms": [
        null
      ],
      "notes": "string",
      "created_at": "2019-08-24T14:15:22Z",
      "updated_at": "2019-08-24T14:15:22Z",
      "status": "string",
      "expert_notes": "string",
      "images": [
        null
      ],
      "ai_disease_id": 0,
      "city": "string",
      "province": "string",
      "pakar_id": 0,
      "is_hidden_from_user": 0,
      "severity": "string"
    }
  ],
  "first_page_url": "string",
  "from": 1,
  "last_page_url": "string",
  "last_page": 1,
  "links": [
    {
      "url": "string",
      "label": "string",
      "active": true
    }
  ],
  "next_page_url": "string",
  "path": "string",
  "per_page": 0,
  "prev_page_url": "string",
  "to": 1,
  "total": 0
}
```

<h3 id="adminapi.detections-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="adminapi.detections-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» current_page|integer|true|none|none|
|» data|[[Detection](#schemadetection)]|true|none|none|
|»» Detection|[Detection](#schemadetection)|false|none|none|
|»»» id|integer|true|none|none|
|»»» user_id|integer|true|none|none|
|»»» disease_id|integer,null|true|none|none|
|»»» method|string|true|none|none|
|»»» image_path|string,null|true|none|none|
|»»» label|string,null|true|none|none|
|»»» confidence|string,null|true|none|none|
|»»» temperature|string,null|true|none|none|
|»»» scanned_at|string,null(date-time)|true|none|none|
|»»» scan_duration_ms|integer,null|true|none|none|
|»»» latitude|string,null|true|none|none|
|»»» longitude|string,null|true|none|none|
|»»» connection_status|string|true|none|none|
|»»» predictions|array,null|true|none|none|
|»»» selected_symptoms|array,null|true|none|none|
|»»» notes|string,null|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|
|»»» status|string|true|none|none|
|»»» expert_notes|string,null|true|none|none|
|»»» images|array,null|true|none|none|
|»»» ai_disease_id|integer,null|true|none|none|
|»»» city|string,null|true|none|none|
|»»» province|string,null|true|none|none|
|»»» pakar_id|integer,null|true|none|none|
|»»» is_hidden_from_user|integer|true|none|none|
|»»» severity|string,null|true|none|none|
|» first_page_url|string,null|true|none|none|
|» from|integer,null|true|none|none|
|» last_page_url|string,null|true|none|none|
|» last_page|integer|true|none|none|
|» links|[object]|true|none|Generated paginator links.|
|»» url|string,null|true|none|none|
|»» label|string|true|none|none|
|»» active|boolean|true|none|none|
|» next_page_url|string,null|true|none|none|
|» path|string,null|true|none|Base path for paginator generated URLs.|
|» per_page|integer|true|none|Number of items shown per page.|
|» prev_page_url|string,null|true|none|none|
|» to|integer,null|true|none|Number of the last item in the slice.|
|» total|integer|true|none|Total number of items being paginated.|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApi.updateDetection

<a id="opIdadminApi.updateDetection"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections/{detection} \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections/{detection} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "disease_id": 0,
  "status": "diprediksi_ai",
  "expert_notes": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections/{detection}',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.put 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections/{detection}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.put('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections/{detection}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections/{detection}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections/{detection}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/detections/{detection}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /private/api/v1/admin/detections/{detection}`

> Body parameter

```json
{
  "disease_id": 0,
  "status": "diprediksi_ai",
  "expert_notes": "string"
}
```

<h3 id="adminapi.updatedetection-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|detection|path|integer|true|The detection ID|
|body|body|object|true|none|
|» disease_id|body|integer,null|false|none|
|» status|body|string|true|none|
|» expert_notes|body|string,null|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|» status|diprediksi_ai|
|» status|pending|
|» status|diproses_pakar|
|» status|verified|
|» status|rejected|

> Example responses

> 200 Response

```json
{
  "message": "Status deteksi berhasil diperbarui.",
  "detection": {
    "id": 0,
    "user_id": 0,
    "disease_id": 0,
    "method": "string",
    "image_path": "string",
    "label": "string",
    "confidence": "string",
    "temperature": "string",
    "scanned_at": "2019-08-24T14:15:22Z",
    "scan_duration_ms": 0,
    "latitude": "string",
    "longitude": "string",
    "connection_status": "string",
    "predictions": [
      null
    ],
    "selected_symptoms": [
      null
    ],
    "notes": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "status": "string",
    "expert_notes": "string",
    "images": [
      null
    ],
    "ai_disease_id": 0,
    "city": "string",
    "province": "string",
    "pakar_id": 0,
    "is_hidden_from_user": 0,
    "severity": "string"
  }
}
```

<h3 id="adminapi.updatedetection-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="adminapi.updatedetection-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» detection|any|true|none|none|

*anyOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|»» *anonymous*|[Detection](#schemadetection)|false|none|none|
|»»» id|integer|true|none|none|
|»»» user_id|integer|true|none|none|
|»»» disease_id|integer,null|true|none|none|
|»»» method|string|true|none|none|
|»»» image_path|string,null|true|none|none|
|»»» label|string,null|true|none|none|
|»»» confidence|string,null|true|none|none|
|»»» temperature|string,null|true|none|none|
|»»» scanned_at|string,null(date-time)|true|none|none|
|»»» scan_duration_ms|integer,null|true|none|none|
|»»» latitude|string,null|true|none|none|
|»»» longitude|string,null|true|none|none|
|»»» connection_status|string|true|none|none|
|»»» predictions|array,null|true|none|none|
|»»» selected_symptoms|array,null|true|none|none|
|»»» notes|string,null|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|
|»»» status|string|true|none|none|
|»»» expert_notes|string,null|true|none|none|
|»»» images|array,null|true|none|none|
|»»» ai_disease_id|integer,null|true|none|none|
|»»» city|string,null|true|none|none|
|»»» province|string,null|true|none|none|
|»»» pakar_id|integer,null|true|none|none|
|»»» is_hidden_from_user|integer|true|none|none|
|»»» severity|string,null|true|none|none|

*or*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|»» *anonymous*|null|false|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-adminapplication">AdminApplication</h1>

## adminApplication.index

<a id="opIdadminApplication.index"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/user/admin-application`

*Get the current user's admin application status*

> Example responses

> 200 Response

```json
{
  "status": "success",
  "data": {
    "id": 0,
    "user_id": 0,
    "agency_name": "string",
    "document_path": "string",
    "notes": "string",
    "status": "string",
    "reviewed_by": 0,
    "reviewed_at": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="adminapplication.index-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="adminapplication.index-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» data|any|true|none|none|

*anyOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|»» *anonymous*|[AdminApplication](#schemaadminapplication)|false|none|none|
|»»» id|integer|true|none|none|
|»»» user_id|integer|true|none|none|
|»»» agency_name|string|true|none|none|
|»»» document_path|string|true|none|none|
|»»» notes|string,null|true|none|none|
|»»» status|string|true|none|none|
|»»» reviewed_by|integer,null|true|none|none|
|»»» reviewed_at|string,null|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|

*or*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|»» *anonymous*|null|false|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApplication.store

<a id="opIdadminApplication.store"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application \
  -H 'Content-Type: multipart/form-data' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: multipart/form-data
Accept: application/json

```

```javascript
const inputBody = '{
  "agency_name": "string",
  "document": "string",
  "notes": "string"
}';
const headers = {
  'Content-Type':'multipart/form-data',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'multipart/form-data',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'multipart/form-data',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'multipart/form-data',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"multipart/form-data"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/admin-application", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/user/admin-application`

*Submit a new admin application*

> Body parameter

```yaml
agency_name: string
document: string
notes: string

```

<h3 id="adminapplication.store-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» agency_name|body|string|true|none|
|» document|body|string(binary)|true|none|
|» notes|body|string,null|false|Max 5MB|

> Example responses

> 201 Response

```json
{
  "status": "success",
  "message": "Pengajuan berhasil dikirim. Silakan tunggu peninjauan dari Super Admin.",
  "data": {
    "id": 0,
    "user_id": 0,
    "agency_name": "string",
    "document_path": "string",
    "notes": "string",
    "status": "string",
    "reviewed_by": 0,
    "reviewed_at": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="adminapplication.store-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="adminapplication.store-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|
|» data|[AdminApplication](#schemaadminapplication)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» agency_name|string|true|none|none|
|»» document_path|string|true|none|none|
|»» notes|string,null|true|none|none|
|»» status|string|true|none|none|
|»» reviewed_by|integer,null|true|none|none|
|»» reviewed_at|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-adminapplicationmanagement">AdminApplicationManagement</h1>

## adminApplicationManagement.index

<a id="opIdadminApplicationManagement.index"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/system/admin-applications`

*Get all pending admin applications*

> Example responses

> 200 Response

```json
{
  "status": "success",
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 0,
        "user_id": 0,
        "agency_name": "string",
        "document_path": "string",
        "notes": "string",
        "status": "string",
        "reviewed_by": 0,
        "reviewed_at": "string",
        "created_at": "2019-08-24T14:15:22Z",
        "updated_at": "2019-08-24T14:15:22Z"
      }
    ],
    "first_page_url": "string",
    "from": 1,
    "last_page_url": "string",
    "last_page": 1,
    "links": [
      {
        "url": "string",
        "label": "string",
        "active": true
      }
    ],
    "next_page_url": "string",
    "path": "string",
    "per_page": 0,
    "prev_page_url": "string",
    "to": 1,
    "total": 0
  }
}
```

<h3 id="adminapplicationmanagement.index-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="adminapplicationmanagement.index-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» data|object|true|none|none|
|»» current_page|integer|true|none|none|
|»» data|[[AdminApplication](#schemaadminapplication)]|true|none|none|
|»»» AdminApplication|[AdminApplication](#schemaadminapplication)|false|none|none|
|»»»» id|integer|true|none|none|
|»»»» user_id|integer|true|none|none|
|»»»» agency_name|string|true|none|none|
|»»»» document_path|string|true|none|none|
|»»»» notes|string,null|true|none|none|
|»»»» status|string|true|none|none|
|»»»» reviewed_by|integer,null|true|none|none|
|»»»» reviewed_at|string,null|true|none|none|
|»»»» created_at|string,null(date-time)|true|none|none|
|»»»» updated_at|string,null(date-time)|true|none|none|
|»» first_page_url|string,null|true|none|none|
|»» from|integer,null|true|none|none|
|»» last_page_url|string,null|true|none|none|
|»» last_page|integer|true|none|none|
|»» links|[object]|true|none|Generated paginator links.|
|»»» url|string,null|true|none|none|
|»»» label|string|true|none|none|
|»»» active|boolean|true|none|none|
|»» next_page_url|string,null|true|none|none|
|»» path|string,null|true|none|Base path for paginator generated URLs.|
|»» per_page|integer|true|none|Number of items shown per page.|
|»» prev_page_url|string,null|true|none|none|
|»» to|integer,null|true|none|Number of the last item in the slice.|
|»» total|integer|true|none|Total number of items being paginated.|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApplicationManagement.show

<a id="opIdadminApplicationManagement.show"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application} \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/system/admin-applications/{application}`

*Get details of a single admin application*

<h3 id="adminapplicationmanagement.show-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|application|path|integer|true|The application ID|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "data": {
    "id": 0,
    "user_id": 0,
    "agency_name": "string",
    "document_path": "string",
    "notes": "string",
    "status": "string",
    "reviewed_by": 0,
    "reviewed_at": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="adminapplicationmanagement.show-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="adminapplicationmanagement.show-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» data|[AdminApplication](#schemaadminapplication)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» agency_name|string|true|none|none|
|»» document_path|string|true|none|none|
|»» notes|string,null|true|none|none|
|»» status|string|true|none|none|
|»» reviewed_by|integer,null|true|none|none|
|»» reviewed_at|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApplicationManagement.approve

<a id="opIdadminApplicationManagement.approve"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/approve \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/approve HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/approve',
{
  method: 'POST',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/approve',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/approve', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/approve', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/approve");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/approve", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/admin/system/admin-applications/{application}/approve`

*Approve an admin application*

<h3 id="adminapplicationmanagement.approve-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|application|path|integer|true|The application ID|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "Pengajuan berhasil disetujui. Peran pengguna telah diperbarui menjadi Admin."
}
```

<h3 id="adminapplicationmanagement.approve-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|none|Inline|

<h3 id="adminapplicationmanagement.approve-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## adminApplicationManagement.reject

<a id="opIdadminApplicationManagement.reject"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/reject \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/reject HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/reject',
{
  method: 'POST',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/reject',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/reject', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/reject', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/reject");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/admin-applications/{application}/reject", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/admin/system/admin-applications/{application}/reject`

*Reject an admin application*

<h3 id="adminapplicationmanagement.reject-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|application|path|integer|true|The application ID|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "Pengajuan berhasil ditolak."
}
```

<h3 id="adminapplicationmanagement.reject-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|none|Inline|

<h3 id="adminapplicationmanagement.reject-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-auth">Auth</h1>

## auth.login

<a id="opIdauth.login"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "email": "user@example.com",
  "password": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /public/api/v1/login`

*POST /api/v1/login*

> Body parameter

```json
{
  "email": "user@example.com",
  "password": "string"
}
```

<h3 id="auth.login-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» email|body|string(email)|true|none|
|» password|body|string|true|none|

> Example responses

> 200 Response

```json
{
  "message": "Login berhasil.",
  "user": {
    "id": "string",
    "name": "string",
    "email": "string",
    "role": "string",
    "pending_role": "string",
    "avatar_url": "string",
    "agency_name": "string"
  },
  "token": "string"
}
```

<h3 id="auth.login-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|none|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.login-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» user|object|true|none|none|
|»» id|string|true|none|none|
|»» name|string|true|none|none|
|»» email|string|true|none|none|
|»» role|string|true|none|none|
|»» pending_role|string|true|none|none|
|»» avatar_url|string|true|none|none|
|»» agency_name|string|true|none|none|
|» token|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## auth.loginGoogle

<a id="opIdauth.loginGoogle"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login/google \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login/google HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "id_token": "string",
  "action": "login"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login/google',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login/google',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login/google', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login/google', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login/google");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/login/google", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /public/api/v1/login/google`

*POST /api/v1/login/google*

> Body parameter

```json
{
  "id_token": "string",
  "action": "login"
}
```

<h3 id="auth.logingoogle-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» id_token|body|string|true|none|
|» action|body|string|false|none|

> Example responses

> 200 Response

```json
{
  "message": "Login Google berhasil.",
  "user": {
    "id": 0,
    "name": "string",
    "email": "string",
    "role": "string",
    "pending_role": "string",
    "avatar_url": "string",
    "agency_name": "string"
  },
  "token": "string",
  "is_new_user": true
}
```

<h3 id="auth.logingoogle-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|none|Inline|
|409|[Conflict](https://tools.ietf.org/html/rfc7231#section-6.5.8)|none|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.logingoogle-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» user|object|true|none|none|
|»» id|integer|true|none|none|
|»» name|string|true|none|none|
|»» email|string|true|none|none|
|»» role|string|true|none|none|
|»» pending_role|string,null|true|none|none|
|»» avatar_url|string,null|true|none|none|
|»» agency_name|string,null|true|none|none|
|» token|string|true|none|none|
|» is_new_user|boolean|true|none|none|

Status Code **400**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **409**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## auth.register

<a id="opIdauth.register"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/register \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/register HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "name": "string",
  "email": "user@example.com",
  "password": "stringst",
  "role": "user"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/register',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/register',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/register', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/register', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/register");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/register", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /public/api/v1/register`

*POST /api/v1/register*

> Body parameter

```json
{
  "name": "string",
  "email": "user@example.com",
  "password": "stringst",
  "role": "user"
}
```

<h3 id="auth.register-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» name|body|string|true|none|
|» email|body|string(email)|true|none|
|» password|body|string|true|none|
|» role|body|string,null|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|» role|user|
|» role|pakar|

> Example responses

> 201 Response

```json
{
  "message": "Registrasi berhasil.",
  "user": {
    "id": 0,
    "name": "string",
    "email": "string",
    "role": "string",
    "pending_role": "string",
    "avatar_url": "string",
    "agency_name": "string"
  },
  "token": "string"
}
```

<h3 id="auth.register-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|none|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.register-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» user|object|true|none|none|
|»» id|integer|true|none|none|
|»» name|string|true|none|none|
|»» email|string|true|none|none|
|»» role|string|true|none|none|
|»» pending_role|string,null|true|none|none|
|»» avatar_url|string,null|true|none|none|
|»» agency_name|string,null|true|none|none|
|» token|string|true|none|none|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## auth.forgotPassword

<a id="opIdauth.forgotPassword"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/forgot-password \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/forgot-password HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "email": "user@example.com"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/forgot-password',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/forgot-password',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/forgot-password', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/forgot-password', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/forgot-password");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/forgot-password", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /public/api/v1/forgot-password`

*POST /api/v1/forgot-password*

> Body parameter

```json
{
  "email": "user@example.com"
}
```

<h3 id="auth.forgotpassword-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» email|body|string(email)|true|none|

> Example responses

> 200 Response

```json
{
  "message": "Kode OTP untuk reset password telah dikirim ke email Anda."
}
```

<h3 id="auth.forgotpassword-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.forgotpassword-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## auth.verifyOtp

<a id="opIdauth.verifyOtp"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/verify-otp \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/verify-otp HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "email": "user@example.com",
  "token": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/verify-otp',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/verify-otp',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/verify-otp', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/verify-otp', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/verify-otp");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/verify-otp", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /public/api/v1/verify-otp`

*POST /api/v1/verify-otp*

> Body parameter

```json
{
  "email": "user@example.com",
  "token": "string"
}
```

<h3 id="auth.verifyotp-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» email|body|string(email)|true|none|
|» token|body|string|true|none|

> Example responses

> 200 Response

```json
{
  "message": "Kode OTP valid."
}
```

<h3 id="auth.verifyotp-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|none|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.verifyotp-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## auth.resetPassword

<a id="opIdauth.resetPassword"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/reset-password \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/reset-password HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "email": "user@example.com",
  "token": "string",
  "password": "stringst",
  "password_confirmation": "stringst"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/reset-password',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/reset-password',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/reset-password', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/reset-password', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/reset-password");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/reset-password", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /public/api/v1/reset-password`

*POST /api/v1/reset-password*

> Body parameter

```json
{
  "email": "user@example.com",
  "token": "string",
  "password": "stringst",
  "password_confirmation": "stringst"
}
```

<h3 id="auth.resetpassword-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» email|body|string(email)|true|none|
|» token|body|string|true|none|
|» password|body|string|true|none|
|» password_confirmation|body|string|true|none|

> Example responses

> 200 Response

```json
{
  "message": "Password berhasil diubah. Silakan login menggunakan password baru."
}
```

<h3 id="auth.resetpassword-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|none|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.resetpassword-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## auth.user

<a id="opIdauth.user"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/user`

*GET /api/v1/user*

> Example responses

> 200 Response

```json
{
  "user": {
    "id": 0,
    "name": "string",
    "email": "string",
    "email_verified_at": "2019-08-24T14:15:22Z",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "role": "string",
    "two_factor_confirmed_at": "2019-08-24T14:15:22Z",
    "avatar_url": "string",
    "fcm_token": "string",
    "google_id": "string",
    "avatar": "string",
    "pending_role": "string",
    "agency_name": "string"
  }
}
```

<h3 id="auth.user-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="auth.user-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» user|[User](#schemauser)|true|none|none|
|»» id|integer|true|none|none|
|»» name|string|true|none|none|
|»» email|string|true|none|none|
|»» email_verified_at|string,null(date-time)|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|
|»» role|string|true|none|none|
|»» two_factor_confirmed_at|string,null(date-time)|true|none|none|
|»» avatar_url|string,null|true|none|none|
|»» fcm_token|string,null|true|none|none|
|»» google_id|string,null|true|none|none|
|»» avatar|string,null|true|none|none|
|»» pending_role|string,null|true|none|none|
|»» agency_name|string,null|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## auth.destroy

<a id="opIdauth.destroy"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.delete 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.delete('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /private/api/v1/user`

*DELETE /api/v1/user*

> Example responses

> 200 Response

```json
{
  "message": "Akun berhasil dihapus permanen."
}
```

<h3 id="auth.destroy-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="auth.destroy-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## auth.updateProfile

<a id="opIdauth.updateProfile"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/profile \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/profile HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "name": "string",
  "email": "user@example.com"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/profile',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.put 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/profile',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.put('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/profile', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/profile', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/profile");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/profile", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /private/api/v1/user/profile`

*PUT /api/v1/user/profile*

> Body parameter

```json
{
  "name": "string",
  "email": "user@example.com"
}
```

<h3 id="auth.updateprofile-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» name|body|string|true|none|
|» email|body|string(email)|true|none|

> Example responses

> 200 Response

```json
{
  "message": "Profil berhasil diperbarui.",
  "user": {
    "id": 0,
    "name": "string",
    "email": "string",
    "email_verified_at": "2019-08-24T14:15:22Z",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "role": "string",
    "two_factor_confirmed_at": "2019-08-24T14:15:22Z",
    "avatar_url": "string",
    "fcm_token": "string",
    "google_id": "string",
    "avatar": "string",
    "pending_role": "string",
    "agency_name": "string"
  }
}
```

<h3 id="auth.updateprofile-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.updateprofile-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» user|[User](#schemauser)|true|none|none|
|»» id|integer|true|none|none|
|»» name|string|true|none|none|
|»» email|string|true|none|none|
|»» email_verified_at|string,null(date-time)|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|
|»» role|string|true|none|none|
|»» two_factor_confirmed_at|string,null(date-time)|true|none|none|
|»» avatar_url|string,null|true|none|none|
|»» fcm_token|string,null|true|none|none|
|»» google_id|string,null|true|none|none|
|»» avatar|string,null|true|none|none|
|»» pending_role|string,null|true|none|none|
|»» agency_name|string,null|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## auth.updatePassword

<a id="opIdauth.updatePassword"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/password \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/password HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "current_password": "string",
  "password": "stringst",
  "password_confirmation": "stringst"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/password',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.put 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/password',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.put('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/password', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/password', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/password");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/password", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /private/api/v1/user/password`

*PUT /api/v1/user/password*

> Body parameter

```json
{
  "current_password": "string",
  "password": "stringst",
  "password_confirmation": "stringst"
}
```

<h3 id="auth.updatepassword-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» current_password|body|string|true|none|
|» password|body|string|true|none|
|» password_confirmation|body|string|true|none|

> Example responses

> 200 Response

```json
{
  "message": "Kata sandi berhasil diperbarui."
}
```

<h3 id="auth.updatepassword-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.updatepassword-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## auth.updateRole

<a id="opIdauth.updateRole"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/role \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/role HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "role": "user"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/role',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.put 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/role',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.put('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/role', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/role', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/role");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/role", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /private/api/v1/user/role`

*PUT /api/v1/user/role*

> Body parameter

```json
{
  "role": "user"
}
```

<h3 id="auth.updaterole-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» role|body|string|true|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|» role|user|
|» role|pakar|

> Example responses

> 200 Response

```json
{
  "message": "Peran berhasil diperbarui.",
  "user": {
    "id": 0,
    "name": "string",
    "email": "string",
    "role": "string",
    "pending_role": "string",
    "avatar_url": "string",
    "agency_name": "string"
  }
}
```

<h3 id="auth.updaterole-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.updaterole-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» user|object|true|none|none|
|»» id|integer|true|none|none|
|»» name|string|true|none|none|
|»» email|string|true|none|none|
|»» role|string|true|none|none|
|»» pending_role|string,null|true|none|none|
|»» avatar_url|string,null|true|none|none|
|»» agency_name|string,null|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## auth.uploadPhoto

<a id="opIdauth.uploadPhoto"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo \
  -H 'Content-Type: multipart/form-data' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: multipart/form-data
Accept: application/json

```

```javascript
const inputBody = '{
  "photo": "string"
}';
const headers = {
  'Content-Type':'multipart/form-data',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'multipart/form-data',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'multipart/form-data',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'multipart/form-data',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"multipart/form-data"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/user/photo`

*POST /api/v1/user/photo*

> Body parameter

```yaml
photo: string

```

<h3 id="auth.uploadphoto-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» photo|body|string(binary)|true|none|

> Example responses

> 200 Response

```json
{
  "message": "Foto profil berhasil diunggah.",
  "user": {
    "id": 0,
    "name": "string",
    "email": "string",
    "email_verified_at": "2019-08-24T14:15:22Z",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "role": "string",
    "two_factor_confirmed_at": "2019-08-24T14:15:22Z",
    "avatar_url": "string",
    "fcm_token": "string",
    "google_id": "string",
    "avatar": "string",
    "pending_role": "string",
    "agency_name": "string"
  }
}
```

<h3 id="auth.uploadphoto-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.uploadphoto-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» user|[User](#schemauser)|true|none|none|
|»» id|integer|true|none|none|
|»» name|string|true|none|none|
|»» email|string|true|none|none|
|»» email_verified_at|string,null(date-time)|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|
|»» role|string|true|none|none|
|»» two_factor_confirmed_at|string,null(date-time)|true|none|none|
|»» avatar_url|string,null|true|none|none|
|»» fcm_token|string,null|true|none|none|
|»» google_id|string,null|true|none|none|
|»» avatar|string,null|true|none|none|
|»» pending_role|string,null|true|none|none|
|»» agency_name|string,null|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## auth.deletePhoto

<a id="opIdauth.deletePhoto"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.delete 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.delete('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/photo", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /private/api/v1/user/photo`

*DELETE /api/v1/user/photo*

> Example responses

> 200 Response

```json
{
  "message": "Foto profil berhasil dihapus.",
  "user": {
    "id": 0,
    "name": "string",
    "email": "string",
    "email_verified_at": "2019-08-24T14:15:22Z",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "role": "string",
    "two_factor_confirmed_at": "2019-08-24T14:15:22Z",
    "avatar_url": "string",
    "fcm_token": "string",
    "google_id": "string",
    "avatar": "string",
    "pending_role": "string",
    "agency_name": "string"
  }
}
```

<h3 id="auth.deletephoto-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="auth.deletephoto-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» user|[User](#schemauser)|true|none|none|
|»» id|integer|true|none|none|
|»» name|string|true|none|none|
|»» email|string|true|none|none|
|»» email_verified_at|string,null(date-time)|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|
|»» role|string|true|none|none|
|»» two_factor_confirmed_at|string,null(date-time)|true|none|none|
|»» avatar_url|string,null|true|none|none|
|»» fcm_token|string,null|true|none|none|
|»» google_id|string,null|true|none|none|
|»» avatar|string,null|true|none|none|
|»» pending_role|string,null|true|none|none|
|»» agency_name|string,null|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## auth.logout

<a id="opIdauth.logout"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/logout \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/logout HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/logout',
{
  method: 'POST',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/logout',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/logout', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/logout', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/logout");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/logout", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/logout`

*POST /api/v1/logout*

> Example responses

> 200 Response

```json
{
  "message": "Logout berhasil."
}
```

<h3 id="auth.logout-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="auth.logout-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## auth.updateFcmToken

<a id="opIdauth.updateFcmToken"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/fcm-token \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/fcm-token HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "fcm_token": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/fcm-token',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/fcm-token',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/fcm-token', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/fcm-token', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/fcm-token");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/fcm-token", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/fcm-token`

*POST /api/v1/fcm-token*

> Body parameter

```json
{
  "fcm_token": "string"
}
```

<h3 id="auth.updatefcmtoken-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|false|none|
|» fcm_token|body|string,null|false|none|

> Example responses

> 200 Response

```json
{
  "message": "FCM Token berhasil diperbarui."
}
```

<h3 id="auth.updatefcmtoken-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="auth.updatefcmtoken-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-chatbot">Chatbot</h1>

## chatbot.getHistory

<a id="opIdchatbot.getHistory"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/chatbot/history`

> Example responses

> 200 Response

```json
{
  "status": "success",
  "data": [
    {
      "id": 0,
      "role": "string",
      "content": "string",
      "created_at": "string"
    }
  ]
}
```

<h3 id="chatbot.gethistory-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="chatbot.gethistory-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» data|[object]|true|none|none|
|»» id|integer|true|none|none|
|»» role|string|true|none|none|
|»» content|string|true|none|none|
|»» created_at|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## chatbot.clearHistory

<a id="opIdchatbot.clearHistory"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.delete 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.delete('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot/history", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /private/api/v1/chatbot/history`

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "Chat history cleared."
}
```

<h3 id="chatbot.clearhistory-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="chatbot.clearhistory-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## chatbot.chat

<a id="opIdchatbot.chat"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "message": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/chatbot", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/chatbot`

> Body parameter

```json
{
  "message": "string"
}
```

<h3 id="chatbot.chat-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» message|body|string|true|none|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "data": {
    "id": 0,
    "role": "model",
    "content": null,
    "created_at": "string"
  }
}
```

<h3 id="chatbot.chat-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|
|500|[Internal Server Error](https://tools.ietf.org/html/rfc7231#section-6.6.1)|none|Inline|

<h3 id="chatbot.chat-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» data|object|true|none|none|
|»» id|integer|true|none|none|
|»» role|string|true|none|none|
|»» content|any|true|none|none|
|»» created_at|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-dashboardapi">DashboardApi</h1>

## dashboardApi.stats

<a id="opIddashboardApi.stats"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/dashboard/stats \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/dashboard/stats HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/dashboard/stats',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/dashboard/stats',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/dashboard/stats', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/dashboard/stats', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/dashboard/stats");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/dashboard/stats", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/dashboard/stats`

*GET /api/v1/dashboard/stats*

> Example responses

> 200 Response

```json
{
  "stats": {
    "total_detections": "string",
    "total_all_time": "string",
    "detections_this_month": "string",
    "average_confidence": 0,
    "total_expert_applications": 0
  },
  "disease_distribution": "string",
  "recent_detections": "string",
  "insight": {
    "has_insight": true,
    "disease_name": "string",
    "count": "string",
    "recommendation": "string"
  },
  "trending_diseases": [
    {
      "disease_id": "string",
      "title": "string",
      "count": "string",
      "percentage": 0,
      "image": "string"
    }
  ]
}
```

<h3 id="dashboardapi.stats-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="dashboardapi.stats-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» stats|object|true|none|none|
|»» total_detections|string|true|none|none|
|»» total_all_time|string|true|none|Return 30 days total for trend UI or keep original|
|»» detections_this_month|string|true|none|none|
|»» average_confidence|number|true|none|none|
|»» total_expert_applications|integer|true|none|none|
|» disease_distribution|string|true|none|none|
|» recent_detections|string|true|none|none|
|» insight|object|true|none|none|
|»» has_insight|boolean|true|none|none|
|»» disease_name|string|true|none|none|
|»» count|string|true|none|none|
|»» recommendation|any|true|none|none|

*anyOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|»»» *anonymous*|string|false|none|none|

*or*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|»»» *anonymous*|string|false|none|none|

*continued*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» trending_diseases|[object]|true|none|none|
|»» disease_id|string|true|none|none|
|»» title|string|true|none|none|
|»» count|string|true|none|none|
|»» percentage|number|true|none|none|
|»» image|string,null|true|none|none|

#### Enumerated Values

|Property|Value|
|---|---|
|*anonymous*|Konsultasikan dengan pakar untuk penanganan lebih lanjut.|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-detectionapi">DetectionApi</h1>

## detectionApi.index

<a id="opIddetectionApi.index"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections \
  -H 'Accept: application/json'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /public/api/v1/detections`

*GET /public/api/v1/detections
Public endpoint - returns all detections (no auth required)*

<h3 id="detectionapi.index-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|method|query|string,null|false|none|
|per_page|query|integer,null|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|method|image|
|method|expert_system|

> Example responses

> 200 Response

```json
{
  "current_page": 1,
  "data": [
    {
      "id": 0,
      "user_id": 0,
      "disease_id": 0,
      "method": "string",
      "image_path": "string",
      "label": "string",
      "confidence": "string",
      "temperature": "string",
      "scanned_at": "2019-08-24T14:15:22Z",
      "scan_duration_ms": 0,
      "latitude": "string",
      "longitude": "string",
      "connection_status": "string",
      "predictions": [
        null
      ],
      "selected_symptoms": [
        null
      ],
      "notes": "string",
      "created_at": "2019-08-24T14:15:22Z",
      "updated_at": "2019-08-24T14:15:22Z",
      "status": "string",
      "expert_notes": "string",
      "images": [
        null
      ],
      "ai_disease_id": 0,
      "city": "string",
      "province": "string",
      "pakar_id": 0,
      "is_hidden_from_user": 0,
      "severity": "string"
    }
  ],
  "first_page_url": "string",
  "from": 1,
  "last_page_url": "string",
  "last_page": 1,
  "links": [
    {
      "url": "string",
      "label": "string",
      "active": true
    }
  ],
  "next_page_url": "string",
  "path": "string",
  "per_page": 0,
  "prev_page_url": "string",
  "to": 1,
  "total": 0
}
```

<h3 id="detectionapi.index-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="detectionapi.index-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» current_page|integer|true|none|none|
|» data|[[Detection](#schemadetection)]|true|none|none|
|»» Detection|[Detection](#schemadetection)|false|none|none|
|»»» id|integer|true|none|none|
|»»» user_id|integer|true|none|none|
|»»» disease_id|integer,null|true|none|none|
|»»» method|string|true|none|none|
|»»» image_path|string,null|true|none|none|
|»»» label|string,null|true|none|none|
|»»» confidence|string,null|true|none|none|
|»»» temperature|string,null|true|none|none|
|»»» scanned_at|string,null(date-time)|true|none|none|
|»»» scan_duration_ms|integer,null|true|none|none|
|»»» latitude|string,null|true|none|none|
|»»» longitude|string,null|true|none|none|
|»»» connection_status|string|true|none|none|
|»»» predictions|array,null|true|none|none|
|»»» selected_symptoms|array,null|true|none|none|
|»»» notes|string,null|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|
|»»» status|string|true|none|none|
|»»» expert_notes|string,null|true|none|none|
|»»» images|array,null|true|none|none|
|»»» ai_disease_id|integer,null|true|none|none|
|»»» city|string,null|true|none|none|
|»»» province|string,null|true|none|none|
|»»» pakar_id|integer,null|true|none|none|
|»»» is_hidden_from_user|integer|true|none|none|
|»»» severity|string,null|true|none|none|
|» first_page_url|string,null|true|none|none|
|» from|integer,null|true|none|none|
|» last_page_url|string,null|true|none|none|
|» last_page|integer|true|none|none|
|» links|[object]|true|none|Generated paginator links.|
|»» url|string,null|true|none|none|
|»» label|string|true|none|none|
|»» active|boolean|true|none|none|
|» next_page_url|string,null|true|none|none|
|» path|string,null|true|none|Base path for paginator generated URLs.|
|» per_page|integer|true|none|Number of items shown per page.|
|» prev_page_url|string,null|true|none|none|
|» to|integer,null|true|none|Number of the last item in the slice.|
|» total|integer|true|none|Total number of items being paginated.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## detectionApi.show

<a id="opIddetectionApi.show"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections/{detection} \
  -H 'Accept: application/json'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections/{detection} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections/{detection}',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections/{detection}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections/{detection}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections/{detection}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections/{detection}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/detections/{detection}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /public/api/v1/detections/{detection}`

*GET /public/api/v1/detections/{detection}
Public endpoint - returns single detection detail (no auth required)*

<h3 id="detectionapi.show-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|detection|path|integer|true|The detection ID|

> Example responses

> 200 Response

```json
{
  "data": {
    "id": 0,
    "user_id": 0,
    "disease_id": 0,
    "method": "string",
    "image_path": "string",
    "label": "string",
    "confidence": "string",
    "temperature": "string",
    "scanned_at": "2019-08-24T14:15:22Z",
    "scan_duration_ms": 0,
    "latitude": "string",
    "longitude": "string",
    "connection_status": "string",
    "predictions": [
      null
    ],
    "selected_symptoms": [
      null
    ],
    "notes": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "status": "string",
    "expert_notes": "string",
    "images": [
      null
    ],
    "ai_disease_id": 0,
    "city": "string",
    "province": "string",
    "pakar_id": 0,
    "is_hidden_from_user": 0,
    "severity": "string"
  }
}
```

<h3 id="detectionapi.show-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="detectionapi.show-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» data|[Detection](#schemadetection)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» disease_id|integer,null|true|none|none|
|»» method|string|true|none|none|
|»» image_path|string,null|true|none|none|
|»» label|string,null|true|none|none|
|»» confidence|string,null|true|none|none|
|»» temperature|string,null|true|none|none|
|»» scanned_at|string,null(date-time)|true|none|none|
|»» scan_duration_ms|integer,null|true|none|none|
|»» latitude|string,null|true|none|none|
|»» longitude|string,null|true|none|none|
|»» connection_status|string|true|none|none|
|»» predictions|array,null|true|none|none|
|»» selected_symptoms|array,null|true|none|none|
|»» notes|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|
|»» status|string|true|none|none|
|»» expert_notes|string,null|true|none|none|
|»» images|array,null|true|none|none|
|»» ai_disease_id|integer,null|true|none|none|
|»» city|string,null|true|none|none|
|»» province|string,null|true|none|none|
|»» pakar_id|integer,null|true|none|none|
|»» is_hidden_from_user|integer|true|none|none|
|»» severity|string,null|true|none|none|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="success">
This operation does not require authentication
</aside>

## detectionApi.history

<a id="opIddetectionApi.history"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/detections`

*GET /private/api/v1/detections
Returns detection history for the authenticated user*

<h3 id="detectionapi.history-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|method|query|string,null|false|none|
|per_page|query|integer,null|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|method|image|
|method|expert_system|

> Example responses

> 200 Response

```json
{
  "current_page": 1,
  "data": [
    {
      "id": 0,
      "user_id": 0,
      "disease_id": 0,
      "method": "string",
      "image_path": "string",
      "label": "string",
      "confidence": "string",
      "temperature": "string",
      "scanned_at": "2019-08-24T14:15:22Z",
      "scan_duration_ms": 0,
      "latitude": "string",
      "longitude": "string",
      "connection_status": "string",
      "predictions": [
        null
      ],
      "selected_symptoms": [
        null
      ],
      "notes": "string",
      "created_at": "2019-08-24T14:15:22Z",
      "updated_at": "2019-08-24T14:15:22Z",
      "status": "string",
      "expert_notes": "string",
      "images": [
        null
      ],
      "ai_disease_id": 0,
      "city": "string",
      "province": "string",
      "pakar_id": 0,
      "is_hidden_from_user": 0,
      "severity": "string"
    }
  ],
  "first_page_url": "string",
  "from": 1,
  "last_page_url": "string",
  "last_page": 1,
  "links": [
    {
      "url": "string",
      "label": "string",
      "active": true
    }
  ],
  "next_page_url": "string",
  "path": "string",
  "per_page": 0,
  "prev_page_url": "string",
  "to": 1,
  "total": 0
}
```

<h3 id="detectionapi.history-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="detectionapi.history-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» current_page|integer|true|none|none|
|» data|[[Detection](#schemadetection)]|true|none|none|
|»» Detection|[Detection](#schemadetection)|false|none|none|
|»»» id|integer|true|none|none|
|»»» user_id|integer|true|none|none|
|»»» disease_id|integer,null|true|none|none|
|»»» method|string|true|none|none|
|»»» image_path|string,null|true|none|none|
|»»» label|string,null|true|none|none|
|»»» confidence|string,null|true|none|none|
|»»» temperature|string,null|true|none|none|
|»»» scanned_at|string,null(date-time)|true|none|none|
|»»» scan_duration_ms|integer,null|true|none|none|
|»»» latitude|string,null|true|none|none|
|»»» longitude|string,null|true|none|none|
|»»» connection_status|string|true|none|none|
|»»» predictions|array,null|true|none|none|
|»»» selected_symptoms|array,null|true|none|none|
|»»» notes|string,null|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|
|»»» status|string|true|none|none|
|»»» expert_notes|string,null|true|none|none|
|»»» images|array,null|true|none|none|
|»»» ai_disease_id|integer,null|true|none|none|
|»»» city|string,null|true|none|none|
|»»» province|string,null|true|none|none|
|»»» pakar_id|integer,null|true|none|none|
|»»» is_hidden_from_user|integer|true|none|none|
|»»» severity|string,null|true|none|none|
|» first_page_url|string,null|true|none|none|
|» from|integer,null|true|none|none|
|» last_page_url|string,null|true|none|none|
|» last_page|integer|true|none|none|
|» links|[object]|true|none|Generated paginator links.|
|»» url|string,null|true|none|none|
|»» label|string|true|none|none|
|»» active|boolean|true|none|none|
|» next_page_url|string,null|true|none|none|
|» path|string,null|true|none|Base path for paginator generated URLs.|
|» per_page|integer|true|none|Number of items shown per page.|
|» prev_page_url|string,null|true|none|none|
|» to|integer,null|true|none|Number of the last item in the slice.|
|» total|integer|true|none|Total number of items being paginated.|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## detectionApi.store

<a id="opIddetectionApi.store"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections \
  -H 'Content-Type: multipart/form-data' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: multipart/form-data
Accept: application/json

```

```javascript
const inputBody = '{
  "image": "string",
  "disease_id": 0,
  "method": "image",
  "label": "string",
  "confidence": 100,
  "scanned_at": "2019-08-24T14:15:22Z",
  "temperature": 0,
  "scan_duration_ms": 0,
  "latitude": -90,
  "longitude": -180,
  "city": "string",
  "province": "string",
  "connection_status": "online",
  "predictions": "string",
  "selected_symptoms": "string",
  "notes": "string",
  "is_report": true,
  "images": [
    "string"
  ]
}';
const headers = {
  'Content-Type':'multipart/form-data',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'multipart/form-data',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'multipart/form-data',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'multipart/form-data',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"multipart/form-data"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/detections`

*POST /api/v1/detections*

> Body parameter

```yaml
image: string
disease_id: 0
method: image
label: string
confidence: 100
scanned_at: 2019-08-24T14:15:22Z
temperature: 0
scan_duration_ms: 0
latitude: -90
longitude: -180
city: string
province: string
connection_status: online
predictions: string
selected_symptoms: string
notes: string
is_report: true
images:
  - string

```

<h3 id="detectionapi.store-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» image|body|string,null(binary)|false|none|
|» disease_id|body|integer,null|false|none|
|» method|body|string|true|none|
|» label|body|string,null|false|none|
|» confidence|body|number,null|false|none|
|» scanned_at|body|string,null(date-time)|false|none|
|» temperature|body|number,null|false|none|
|» scan_duration_ms|body|integer,null|false|none|
|» latitude|body|number,null|false|none|
|» longitude|body|number,null|false|none|
|» city|body|string,null|false|none|
|» province|body|string,null|false|none|
|» connection_status|body|string,null|false|none|
|» predictions|body|string,null|false|none|
|» selected_symptoms|body|string,null|false|none|
|» notes|body|string,null|false|none|
|» is_report|body|boolean,null|false|none|
|» images|body|array,null|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|» method|image|
|» method|expert_system|
|» connection_status|online|
|» connection_status|offline|

> Example responses

> 201 Response

```json
{
  "message": "Hasil deteksi berhasil disimpan.",
  "detection": {
    "id": 0,
    "user_id": 0,
    "disease_id": 0,
    "method": "string",
    "image_path": "string",
    "label": "string",
    "confidence": "string",
    "temperature": "string",
    "scanned_at": "2019-08-24T14:15:22Z",
    "scan_duration_ms": 0,
    "latitude": "string",
    "longitude": "string",
    "connection_status": "string",
    "predictions": [
      null
    ],
    "selected_symptoms": [
      null
    ],
    "notes": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "status": "string",
    "expert_notes": "string",
    "images": [
      null
    ],
    "ai_disease_id": 0,
    "city": "string",
    "province": "string",
    "pakar_id": 0,
    "is_hidden_from_user": 0,
    "severity": "string"
  }
}
```

<h3 id="detectionapi.store-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="detectionapi.store-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» detection|[Detection](#schemadetection)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» disease_id|integer,null|true|none|none|
|»» method|string|true|none|none|
|»» image_path|string,null|true|none|none|
|»» label|string,null|true|none|none|
|»» confidence|string,null|true|none|none|
|»» temperature|string,null|true|none|none|
|»» scanned_at|string,null(date-time)|true|none|none|
|»» scan_duration_ms|integer,null|true|none|none|
|»» latitude|string,null|true|none|none|
|»» longitude|string,null|true|none|none|
|»» connection_status|string|true|none|none|
|»» predictions|array,null|true|none|none|
|»» selected_symptoms|array,null|true|none|none|
|»» notes|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|
|»» status|string|true|none|none|
|»» expert_notes|string,null|true|none|none|
|»» images|array,null|true|none|none|
|»» ai_disease_id|integer,null|true|none|none|
|»» city|string,null|true|none|none|
|»» province|string,null|true|none|none|
|»» pakar_id|integer,null|true|none|none|
|»» is_hidden_from_user|integer|true|none|none|
|»» severity|string,null|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## detectionApi.predict

<a id="opIddetectionApi.predict"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/predict \
  -H 'Content-Type: multipart/form-data' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/predict HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: multipart/form-data
Accept: application/json

```

```javascript
const inputBody = '{
  "image": "string"
}';
const headers = {
  'Content-Type':'multipart/form-data',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/predict',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'multipart/form-data',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/predict',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'multipart/form-data',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/predict', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'multipart/form-data',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/predict', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/predict");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"multipart/form-data"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/predict", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/detections/predict`

*POST /private/api/v1/detections/predict
Run ML inference on uploaded image*

> Body parameter

```yaml
image: string

```

<h3 id="detectionapi.predict-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» image|body|string(binary)|true|none|

> Example responses

> 200 Response

```json
{
  "label": "string",
  "confidence": "string",
  "predictions": "string"
}
```

<h3 id="detectionapi.predict-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|
|500|[Internal Server Error](https://tools.ietf.org/html/rfc7231#section-6.6.1)|none|Inline|

<h3 id="detectionapi.predict-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» label|string|true|none|none|
|» confidence|string|true|none|none|
|» predictions|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## detectionApi.review

<a id="opIddetectionApi.review"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/review \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/review HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "status": "verified",
  "expert_notes": "string",
  "disease_id": 0,
  "severity": "Sehat",
  "confidence": 100
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/review',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.put 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/review',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.put('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/review', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/review', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/review");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/review", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /private/api/v1/detections/{detection}/review`

> Body parameter

```json
{
  "status": "verified",
  "expert_notes": "string",
  "disease_id": 0,
  "severity": "Sehat",
  "confidence": 100
}
```

<h3 id="detectionapi.review-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|detection|path|integer|true|The detection ID|
|body|body|object|true|none|
|» status|body|string|true|none|
|» expert_notes|body|string|true|none|
|» disease_id|body|integer|false|none|
|» severity|body|string|true|none|
|» confidence|body|number,null|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|» status|verified|
|» status|rejected|
|» severity|Sehat|
|» severity|Ringan|
|» severity|Waspada|
|» severity|Berbahaya|

> Example responses

> 200 Response

```json
{
  "message": "Detection reviewed successfully",
  "detection": {
    "id": 0,
    "user_id": 0,
    "disease_id": 0,
    "method": "string",
    "image_path": "string",
    "label": "string",
    "confidence": "string",
    "temperature": "string",
    "scanned_at": "2019-08-24T14:15:22Z",
    "scan_duration_ms": 0,
    "latitude": "string",
    "longitude": "string",
    "connection_status": "string",
    "predictions": [
      null
    ],
    "selected_symptoms": [
      null
    ],
    "notes": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "status": "string",
    "expert_notes": "string",
    "images": [
      null
    ],
    "ai_disease_id": 0,
    "city": "string",
    "province": "string",
    "pakar_id": 0,
    "is_hidden_from_user": 0,
    "severity": "string"
  }
}
```

<h3 id="detectionapi.review-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|none|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="detectionapi.review-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» detection|[Detection](#schemadetection)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» disease_id|integer,null|true|none|none|
|»» method|string|true|none|none|
|»» image_path|string,null|true|none|none|
|»» label|string,null|true|none|none|
|»» confidence|string,null|true|none|none|
|»» temperature|string,null|true|none|none|
|»» scanned_at|string,null(date-time)|true|none|none|
|»» scan_duration_ms|integer,null|true|none|none|
|»» latitude|string,null|true|none|none|
|»» longitude|string,null|true|none|none|
|»» connection_status|string|true|none|none|
|»» predictions|array,null|true|none|none|
|»» selected_symptoms|array,null|true|none|none|
|»» notes|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|
|»» status|string|true|none|none|
|»» expert_notes|string,null|true|none|none|
|»» images|array,null|true|none|none|
|»» ai_disease_id|integer,null|true|none|none|
|»» city|string,null|true|none|none|
|»» province|string,null|true|none|none|
|»» pakar_id|integer,null|true|none|none|
|»» is_hidden_from_user|integer|true|none|none|
|»» severity|string,null|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## detectionApi.claim

<a id="opIddetectionApi.claim"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/claim \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/claim HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/claim',
{
  method: 'POST',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/claim',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/claim', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/claim', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/claim");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/claim", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/detections/{detection}/claim`

*POST /private/api/v1/detections/{detection}/claim
Claim a detection report so other pakars cannot review it*

<h3 id="detectionapi.claim-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|detection|path|integer|true|The detection ID|

> Example responses

> 200 Response

```json
{
  "message": "Berhasil mengambil laporan.",
  "detection": {
    "id": 0,
    "user_id": 0,
    "disease_id": 0,
    "method": "string",
    "image_path": "string",
    "label": "string",
    "confidence": "string",
    "temperature": "string",
    "scanned_at": "2019-08-24T14:15:22Z",
    "scan_duration_ms": 0,
    "latitude": "string",
    "longitude": "string",
    "connection_status": "string",
    "predictions": [
      null
    ],
    "selected_symptoms": [
      null
    ],
    "notes": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "status": "string",
    "expert_notes": "string",
    "images": [
      null
    ],
    "ai_disease_id": 0,
    "city": "string",
    "province": "string",
    "pakar_id": 0,
    "is_hidden_from_user": 0,
    "severity": "string"
  }
}
```

<h3 id="detectionapi.claim-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|400|[Bad Request](https://tools.ietf.org/html/rfc7231#section-6.5.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|none|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="detectionapi.claim-responseschema">Response Schema</h3>

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **403**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## detectionApi.unclaim

<a id="opIddetectionApi.unclaim"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/unclaim \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/unclaim HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/unclaim',
{
  method: 'POST',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/unclaim',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/unclaim', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/unclaim', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/unclaim");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}/unclaim", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/detections/{detection}/unclaim`

*POST /private/api/v1/detections/{detection}/unclaim*

<h3 id="detectionapi.unclaim-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|detection|path|integer|true|The detection ID|

> Example responses

> 200 Response

```json
{
  "message": "Laporan dikembalikan ke antrean.",
  "detection": {
    "id": 0,
    "user_id": 0,
    "disease_id": 0,
    "method": "string",
    "image_path": "string",
    "label": "string",
    "confidence": "string",
    "temperature": "string",
    "scanned_at": "2019-08-24T14:15:22Z",
    "scan_duration_ms": 0,
    "latitude": "string",
    "longitude": "string",
    "connection_status": "string",
    "predictions": [
      null
    ],
    "selected_symptoms": [
      null
    ],
    "notes": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "status": "string",
    "expert_notes": "string",
    "images": [
      null
    ],
    "ai_disease_id": 0,
    "city": "string",
    "province": "string",
    "pakar_id": 0,
    "is_hidden_from_user": 0,
    "severity": "string"
  }
}
```

<h3 id="detectionapi.unclaim-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|none|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="detectionapi.unclaim-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» detection|[Detection](#schemadetection)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» disease_id|integer,null|true|none|none|
|»» method|string|true|none|none|
|»» image_path|string,null|true|none|none|
|»» label|string,null|true|none|none|
|»» confidence|string,null|true|none|none|
|»» temperature|string,null|true|none|none|
|»» scanned_at|string,null(date-time)|true|none|none|
|»» scan_duration_ms|integer,null|true|none|none|
|»» latitude|string,null|true|none|none|
|»» longitude|string,null|true|none|none|
|»» connection_status|string|true|none|none|
|»» predictions|array,null|true|none|none|
|»» selected_symptoms|array,null|true|none|none|
|»» notes|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|
|»» status|string|true|none|none|
|»» expert_notes|string,null|true|none|none|
|»» images|array,null|true|none|none|
|»» ai_disease_id|integer,null|true|none|none|
|»» city|string,null|true|none|none|
|»» province|string,null|true|none|none|
|»» pakar_id|integer,null|true|none|none|
|»» is_hidden_from_user|integer|true|none|none|
|»» severity|string,null|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## detectionApi.destroy

<a id="opIddetectionApi.destroy"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection} \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.delete 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.delete('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/detections/{detection}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /private/api/v1/detections/{detection}`

*DELETE /api/v1/detections/{detection}*

<h3 id="detectionapi.destroy-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|detection|path|integer|true|The detection ID|

> Example responses

> 200 Response

```json
{
  "message": "Deteksi berhasil dihapus."
}
```

<h3 id="detectionapi.destroy-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|none|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="detectionapi.destroy-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **403**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-diseaseapi">DiseaseApi</h1>

## diseaseApi.index

<a id="opIddiseaseApi.index"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases \
  -H 'Accept: application/json'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /public/api/v1/diseases`

*GET /api/v1/diseases
Get all diseases with symptoms and treatments*

> Example responses

> 200 Response

```json
{
  "diseases": [
    null
  ]
}
```

<h3 id="diseaseapi.index-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

<h3 id="diseaseapi.index-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» diseases|[any]|true|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## diseaseApi.show

<a id="opIddiseaseApi.show"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases/{disease} \
  -H 'Accept: application/json'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases/{disease} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases/{disease}',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases/{disease}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases/{disease}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases/{disease}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases/{disease}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/diseases/{disease}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /public/api/v1/diseases/{disease}`

*GET /api/v1/diseases/{slug}
Get disease by slug with symptoms and treatments*

<h3 id="diseaseapi.show-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|disease|path|string|true|The disease slug|

> Example responses

> 200 Response

```json
{
  "disease": {
    "id": 0,
    "name": "string",
    "slug": "string",
    "latin_name": "string",
    "description": "string",
    "cause": "string",
    "image": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="diseaseapi.show-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="diseaseapi.show-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» disease|[Disease](#schemadisease)|true|none|none|
|»» id|integer|true|none|none|
|»» name|string|true|none|none|
|»» slug|string|true|none|none|
|»» latin_name|string,null|true|none|none|
|»» description|string|true|none|none|
|»» cause|string|true|none|none|
|»» image|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="success">
This operation does not require authentication
</aside>

<h1 id="laravel-expertapplication">ExpertApplication</h1>

## expertApplication.index

<a id="opIdexpertApplication.index"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/user/expert-application`

*Get the current user's expert application status*

> Example responses

> 200 Response

```json
{
  "status": "success",
  "data": {
    "id": 0,
    "user_id": 0,
    "document_path": "string",
    "notes": "string",
    "status": "string",
    "reviewed_by": 0,
    "reviewed_at": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="expertapplication.index-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="expertapplication.index-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» data|any|true|none|none|

*anyOf*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|»» *anonymous*|[ExpertApplication](#schemaexpertapplication)|false|none|none|
|»»» id|integer|true|none|none|
|»»» user_id|integer|true|none|none|
|»»» document_path|string|true|none|none|
|»»» notes|string,null|true|none|none|
|»»» status|string|true|none|none|
|»»» reviewed_by|integer,null|true|none|none|
|»»» reviewed_at|string,null|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|

*or*

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|»» *anonymous*|null|false|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## expertApplication.store

<a id="opIdexpertApplication.store"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application \
  -H 'Content-Type: multipart/form-data' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: multipart/form-data
Accept: application/json

```

```javascript
const inputBody = '{
  "document": "string",
  "notes": "string"
}';
const headers = {
  'Content-Type':'multipart/form-data',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'multipart/form-data',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'multipart/form-data',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'multipart/form-data',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"multipart/form-data"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/user/expert-application", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/user/expert-application`

*Submit a new expert application*

> Body parameter

```yaml
document: string
notes: string

```

<h3 id="expertapplication.store-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» document|body|string(binary)|true|none|
|» notes|body|string,null|false|Max 5MB|

> Example responses

> 201 Response

```json
{
  "status": "success",
  "message": "Pengajuan berhasil dikirim. Silakan tunggu peninjauan dari Super Admin.",
  "data": {
    "id": 0,
    "user_id": 0,
    "document_path": "string",
    "notes": "string",
    "status": "string",
    "reviewed_by": 0,
    "reviewed_at": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="expertapplication.store-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="expertapplication.store-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|
|» data|[ExpertApplication](#schemaexpertapplication)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» document_path|string|true|none|none|
|»» notes|string,null|true|none|none|
|»» status|string|true|none|none|
|»» reviewed_by|integer,null|true|none|none|
|»» reviewed_at|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-expertapplicationmanagement">ExpertApplicationManagement</h1>

## expertApplicationManagement.index

<a id="opIdexpertApplicationManagement.index"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/system/expert-applications`

*Get all pending expert applications*

> Example responses

> 200 Response

```json
{
  "status": "success",
  "data": {
    "current_page": 1,
    "data": [
      {
        "id": 0,
        "user_id": 0,
        "document_path": "string",
        "notes": "string",
        "status": "string",
        "reviewed_by": 0,
        "reviewed_at": "string",
        "created_at": "2019-08-24T14:15:22Z",
        "updated_at": "2019-08-24T14:15:22Z"
      }
    ],
    "first_page_url": "string",
    "from": 1,
    "last_page_url": "string",
    "last_page": 1,
    "links": [
      {
        "url": "string",
        "label": "string",
        "active": true
      }
    ],
    "next_page_url": "string",
    "path": "string",
    "per_page": 0,
    "prev_page_url": "string",
    "to": 1,
    "total": 0
  }
}
```

<h3 id="expertapplicationmanagement.index-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="expertapplicationmanagement.index-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» data|object|true|none|none|
|»» current_page|integer|true|none|none|
|»» data|[[ExpertApplication](#schemaexpertapplication)]|true|none|none|
|»»» ExpertApplication|[ExpertApplication](#schemaexpertapplication)|false|none|none|
|»»»» id|integer|true|none|none|
|»»»» user_id|integer|true|none|none|
|»»»» document_path|string|true|none|none|
|»»»» notes|string,null|true|none|none|
|»»»» status|string|true|none|none|
|»»»» reviewed_by|integer,null|true|none|none|
|»»»» reviewed_at|string,null|true|none|none|
|»»»» created_at|string,null(date-time)|true|none|none|
|»»»» updated_at|string,null(date-time)|true|none|none|
|»» first_page_url|string,null|true|none|none|
|»» from|integer,null|true|none|none|
|»» last_page_url|string,null|true|none|none|
|»» last_page|integer|true|none|none|
|»» links|[object]|true|none|Generated paginator links.|
|»»» url|string,null|true|none|none|
|»»» label|string|true|none|none|
|»»» active|boolean|true|none|none|
|»» next_page_url|string,null|true|none|none|
|»» path|string,null|true|none|Base path for paginator generated URLs.|
|»» per_page|integer|true|none|Number of items shown per page.|
|»» prev_page_url|string,null|true|none|none|
|»» to|integer,null|true|none|Number of the last item in the slice.|
|»» total|integer|true|none|Total number of items being paginated.|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## expertApplicationManagement.show

<a id="opIdexpertApplicationManagement.show"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application} \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application} HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/system/expert-applications/{application}`

*Get details of a single expert application*

<h3 id="expertapplicationmanagement.show-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|application|path|integer|true|The application ID|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "data": {
    "id": 0,
    "user_id": 0,
    "document_path": "string",
    "notes": "string",
    "status": "string",
    "reviewed_by": 0,
    "reviewed_at": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="expertapplicationmanagement.show-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|

<h3 id="expertapplicationmanagement.show-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» data|[ExpertApplication](#schemaexpertapplication)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» document_path|string|true|none|none|
|»» notes|string,null|true|none|none|
|»» status|string|true|none|none|
|»» reviewed_by|integer,null|true|none|none|
|»» reviewed_at|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## expertApplicationManagement.approve

<a id="opIdexpertApplicationManagement.approve"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/approve \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/approve HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/approve',
{
  method: 'POST',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/approve',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/approve', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/approve', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/approve");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/approve", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/admin/system/expert-applications/{application}/approve`

*Approve an expert application*

<h3 id="expertapplicationmanagement.approve-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|application|path|integer|true|The application ID|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "Pengajuan berhasil disetujui. Peran pengguna telah diperbarui menjadi Pakar."
}
```

<h3 id="expertapplicationmanagement.approve-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|none|Inline|

<h3 id="expertapplicationmanagement.approve-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## expertApplicationManagement.reject

<a id="opIdexpertApplicationManagement.reject"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/reject \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/reject HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/reject',
{
  method: 'POST',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/reject',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/reject', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/reject', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/reject");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/expert-applications/{application}/reject", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/admin/system/expert-applications/{application}/reject`

*Reject an expert application*

<h3 id="expertapplicationmanagement.reject-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|application|path|integer|true|The application ID|

> Example responses

> 200 Response

```json
{
  "status": "success",
  "message": "Pengajuan berhasil ditolak."
}
```

<h3 id="expertapplicationmanagement.reject-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|none|Inline|

<h3 id="expertapplicationmanagement.reject-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» message|string|true|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-expertsystemapi">ExpertSystemApi</h1>

## expertSystemApi.symptoms

<a id="opIdexpertSystemApi.symptoms"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/symptoms \
  -H 'Accept: application/json'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/symptoms HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/symptoms',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/symptoms',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/symptoms', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/symptoms', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/symptoms");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/public/api/v1/symptoms", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /public/api/v1/symptoms`

*GET /api/v1/symptoms*

> Example responses

> 200 Response

```json
{
  "symptoms": [
    {
      "id": 0,
      "code": "string",
      "name": "string",
      "description": "string",
      "created_at": "2019-08-24T14:15:22Z",
      "updated_at": "2019-08-24T14:15:22Z"
    }
  ]
}
```

<h3 id="expertsystemapi.symptoms-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|

<h3 id="expertsystemapi.symptoms-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» symptoms|[[Symptom](#schemasymptom)]|true|none|none|
|»» Symptom|[Symptom](#schemasymptom)|false|none|none|
|»»» id|integer|true|none|none|
|»»» code|string|true|none|none|
|»»» name|string|true|none|none|
|»»» description|string,null|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|

<aside class="success">
This operation does not require authentication
</aside>

## expertSystemApi.diagnose

<a id="opIdexpertSystemApi.diagnose"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system/diagnose \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system/diagnose HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "symptom_ids": [
    0
  ]
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system/diagnose',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system/diagnose',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system/diagnose', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system/diagnose', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system/diagnose");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system/diagnose", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/expert-system/diagnose`

*POST /api/v1/expert-system/diagnose*

> Body parameter

```json
{
  "symptom_ids": [
    0
  ]
}
```

<h3 id="expertsystemapi.diagnose-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» symptom_ids|body|[integer]|true|none|

> Example responses

> 200 Response

```json
{
  "results": [
    {
      "disease": "string",
      "certainty_factor": 0,
      "matching_symptoms": 0,
      "total_symptoms": 0
    }
  ],
  "selected_symptoms": "string"
}
```

<h3 id="expertsystemapi.diagnose-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="expertsystemapi.diagnose-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» results|[object]|true|none|none|
|»» disease|string|true|none|none|
|»» certainty_factor|number|true|none|none|
|»» matching_symptoms|integer|true|none|none|
|»» total_symptoms|integer|true|none|none|
|» selected_symptoms|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## expertSystemApi.store

<a id="opIdexpertSystemApi.store"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "disease_id": 0,
  "label": "string",
  "confidence": 100,
  "temperature": -50,
  "scanned_at": "2019-08-24T14:15:22Z",
  "scan_duration_ms": 0,
  "latitude": -90,
  "longitude": -180,
  "connection_status": "online",
  "selected_symptoms": "string",
  "notes": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/expert-system", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/expert-system`

*POST /api/v1/expert-system*

> Body parameter

```json
{
  "disease_id": 0,
  "label": "string",
  "confidence": 100,
  "temperature": -50,
  "scanned_at": "2019-08-24T14:15:22Z",
  "scan_duration_ms": 0,
  "latitude": -90,
  "longitude": -180,
  "connection_status": "online",
  "selected_symptoms": "string",
  "notes": "string"
}
```

<h3 id="expertsystemapi.store-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|false|none|
|» disease_id|body|integer,null|false|none|
|» label|body|string,null|false|none|
|» confidence|body|number,null|false|none|
|» temperature|body|number,null|false|none|
|» scanned_at|body|string,null(date-time)|false|none|
|» scan_duration_ms|body|integer,null|false|none|
|» latitude|body|number,null|false|none|
|» longitude|body|number,null|false|none|
|» connection_status|body|string,null|false|none|
|» selected_symptoms|body|string,null|false|none|
|» notes|body|string,null|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|» connection_status|online|
|» connection_status|offline|

> Example responses

> 201 Response

```json
{
  "message": "Hasil diagnosis berhasil disimpan.",
  "detection": {
    "id": 0,
    "user_id": 0,
    "disease_id": 0,
    "method": "string",
    "image_path": "string",
    "label": "string",
    "confidence": "string",
    "temperature": "string",
    "scanned_at": "2019-08-24T14:15:22Z",
    "scan_duration_ms": 0,
    "latitude": "string",
    "longitude": "string",
    "connection_status": "string",
    "predictions": [
      null
    ],
    "selected_symptoms": [
      null
    ],
    "notes": "string",
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z",
    "status": "string",
    "expert_notes": "string",
    "images": [
      null
    ],
    "ai_disease_id": 0,
    "city": "string",
    "province": "string",
    "pakar_id": 0,
    "is_hidden_from_user": 0,
    "severity": "string"
  }
}
```

<h3 id="expertsystemapi.store-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="expertsystemapi.store-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» detection|[Detection](#schemadetection)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» disease_id|integer,null|true|none|none|
|»» method|string|true|none|none|
|»» image_path|string,null|true|none|none|
|»» label|string,null|true|none|none|
|»» confidence|string,null|true|none|none|
|»» temperature|string,null|true|none|none|
|»» scanned_at|string,null(date-time)|true|none|none|
|»» scan_duration_ms|integer,null|true|none|none|
|»» latitude|string,null|true|none|none|
|»» longitude|string,null|true|none|none|
|»» connection_status|string|true|none|none|
|»» predictions|array,null|true|none|none|
|»» selected_symptoms|array,null|true|none|none|
|»» notes|string,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|
|»» status|string|true|none|none|
|»» expert_notes|string,null|true|none|none|
|»» images|array,null|true|none|none|
|»» ai_disease_id|integer,null|true|none|none|
|»» city|string,null|true|none|none|
|»» province|string,null|true|none|none|
|»» pakar_id|integer,null|true|none|none|
|»» is_hidden_from_user|integer|true|none|none|
|»» severity|string,null|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-feedback">Feedback</h1>

## feedback.index

<a id="opIdfeedback.index"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/feedbacks`

> Example responses

> 200 Response

```json
{
  "data": [
    {
      "id": 0,
      "user_id": 0,
      "type": "string",
      "content": "string",
      "image_path": "string",
      "status": "string",
      "admin_response": "string",
      "responder_id": 0,
      "created_at": "2019-08-24T14:15:22Z",
      "updated_at": "2019-08-24T14:15:22Z"
    }
  ]
}
```

<h3 id="feedback.index-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="feedback.index-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» data|[[Feedback](#schemafeedback)]|true|none|none|
|»» Feedback|[Feedback](#schemafeedback)|false|none|none|
|»»» id|integer|true|none|none|
|»»» user_id|integer|true|none|none|
|»»» type|string|true|none|none|
|»»» content|string|true|none|none|
|»»» image_path|string,null|true|none|none|
|»»» status|string|true|none|none|
|»»» admin_response|string,null|true|none|none|
|»»» responder_id|integer,null|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## feedback.store

<a id="opIdfeedback.store"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks \
  -H 'Content-Type: multipart/form-data' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: multipart/form-data
Accept: application/json

```

```javascript
const inputBody = '{
  "type": "bug",
  "content": "string",
  "image": "string"
}';
const headers = {
  'Content-Type':'multipart/form-data',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks',
{
  method: 'POST',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'multipart/form-data',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'multipart/form-data',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'multipart/form-data',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"multipart/form-data"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/feedbacks", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/feedbacks`

> Body parameter

```yaml
type: bug
content: string
image: string

```

<h3 id="feedback.store-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|body|body|object|true|none|
|» type|body|string|true|none|
|» content|body|string|true|none|
|» image|body|string,null(binary)|false|none|

#### Enumerated Values

|Parameter|Value|
|---|---|
|» type|bug|
|» type|feature|
|» type|general|

> Example responses

> 201 Response

```json
{
  "message": "Laporan berhasil dikirim.",
  "data": {
    "id": 0,
    "user_id": 0,
    "type": "string",
    "content": "string",
    "image_path": "string",
    "status": "string",
    "admin_response": "string",
    "responder_id": 0,
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="feedback.store-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|201|[Created](https://tools.ietf.org/html/rfc7231#section-6.3.2)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="feedback.store-responseschema">Response Schema</h3>

Status Code **201**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» data|[Feedback](#schemafeedback)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» type|string|true|none|none|
|»» content|string|true|none|none|
|»» image_path|string,null|true|none|none|
|»» status|string|true|none|none|
|»» admin_response|string,null|true|none|none|
|»» responder_id|integer,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## feedback.reply

<a id="opIdfeedback.reply"></a>

> Code samples

```shell
# You can also use wget
curl -X PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/feedbacks/{feedback}/reply \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
PUT https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/feedbacks/{feedback}/reply HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Content-Type: application/json
Accept: application/json

```

```javascript
const inputBody = '{
  "admin_response": "string"
}';
const headers = {
  'Content-Type':'application/json',
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/feedbacks/{feedback}/reply',
{
  method: 'PUT',
  body: inputBody,
  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Content-Type' => 'application/json',
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.put 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/feedbacks/{feedback}/reply',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.put('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/feedbacks/{feedback}/reply', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Content-Type' => 'application/json',
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('PUT','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/feedbacks/{feedback}/reply', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/feedbacks/{feedback}/reply");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("PUT");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Content-Type": []string{"application/json"},
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("PUT", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/system/feedbacks/{feedback}/reply", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`PUT /private/api/v1/admin/system/feedbacks/{feedback}/reply`

> Body parameter

```json
{
  "admin_response": "string"
}
```

<h3 id="feedback.reply-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|feedback|path|integer|true|The feedback ID|
|body|body|object|true|none|
|» admin_response|body|string|true|none|

> Example responses

> 200 Response

```json
{
  "message": "Balasan berhasil dikirim.",
  "data": {
    "id": 0,
    "user_id": 0,
    "type": "string",
    "content": "string",
    "image_path": "string",
    "status": "string",
    "admin_response": "string",
    "responder_id": 0,
    "created_at": "2019-08-24T14:15:22Z",
    "updated_at": "2019-08-24T14:15:22Z"
  }
}
```

<h3 id="feedback.reply-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|403|[Forbidden](https://tools.ietf.org/html/rfc7231#section-6.5.3)|none|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|Not found|Inline|
|422|[Unprocessable Entity](https://tools.ietf.org/html/rfc2518#section-10.3)|Validation error|Inline|

<h3 id="feedback.reply-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|
|» data|[Feedback](#schemafeedback)|true|none|none|
|»» id|integer|true|none|none|
|»» user_id|integer|true|none|none|
|»» type|string|true|none|none|
|»» content|string|true|none|none|
|»» image_path|string,null|true|none|none|
|»» status|string|true|none|none|
|»» admin_response|string,null|true|none|none|
|»» responder_id|integer,null|true|none|none|
|»» created_at|string,null(date-time)|true|none|none|
|»» updated_at|string,null(date-time)|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **403**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **422**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Errors overview.|
|» errors|object|true|none|A detailed description of each field that failed validation.|
|»» **additionalProperties**|[string]|false|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-map">Map</h1>

## map.detections

<a id="opIdmap.detections"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map/detections \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map/detections HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map/detections',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map/detections',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map/detections', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map/detections', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map/detections");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map/detections", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/map/detections`

*GET /api/v1/admin/map/detections
Fetch detection data for the map, filtered by the last 30 days*

> Example responses

> 200 Response

```json
{
  "status": "success",
  "data": [
    {
      "id": 0,
      "disease_name": "string",
      "latitude": 0,
      "longitude": 0,
      "confidence": "string",
      "date": "string",
      "image_url": "string",
      "user_name": "string",
      "severity": "string",
      "city": "string"
    }
  ]
}
```

<h3 id="map.detections-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="map.detections-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» status|string|true|none|none|
|» data|[object]|true|none|none|
|»» id|integer|true|none|none|
|»» disease_name|string|true|none|none|
|»» latitude|number|true|none|none|
|»» longitude|number|true|none|none|
|»» confidence|string,null|true|none|none|
|»» date|string|true|none|none|
|»» image_url|string,null|true|none|none|
|»» user_name|string|true|none|none|
|»» severity|string|true|none|none|
|»» city|string,null|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-mapreport">MapReport</h1>

## mapReport.statistics

<a id="opIdmapReport.statistics"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map-statistics \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map-statistics HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map-statistics',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map-statistics',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map-statistics', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map-statistics', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map-statistics");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/map-statistics", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/map-statistics`

*Get grouped map statistics by city*

<h3 id="mapreport.statistics-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|city|query|string|false|none|
|disease_id|query|string|false|none|
|start_date|query|string|false|none|
|end_date|query|string|false|none|

> Example responses

> 200 Response

```json
{
  "data": "string"
}
```

<h3 id="mapreport.statistics-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="mapreport.statistics-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» data|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## mapReport.export

<a id="opIdmapReport.export"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/export-report \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/export-report HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/export-report',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/export-report',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/export-report', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/export-report', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/export-report");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/admin/export-report", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/admin/export-report`

*Export raw data and statistics to PDF or Excel*

<h3 id="mapreport.export-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|format|query|string|false|none|
|city|query|string|false|none|
|disease_id|query|string|false|none|
|start_date|query|string|false|none|
|end_date|query|string|false|none|

> Example responses

> 401 Response

```json
{
  "message": "string"
}
```

<h3 id="mapreport.export-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|None|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="mapreport.export-responseschema">Response Schema</h3>

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

<h1 id="laravel-notification">Notification</h1>

## notification.index

<a id="opIdnotification.index"></a>

> Code samples

```shell
# You can also use wget
curl -X GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
GET https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications',
{
  method: 'GET',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.get 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.get('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('GET','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("GET");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("GET", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`GET /private/api/v1/notifications`

*Get the authenticated user's notifications*

> Example responses

> 200 Response

```json
{
  "notifications": [
    {
      "id": "string",
      "type": "string",
      "notifiable_type": "string",
      "notifiable_id": 0,
      "data": [
        null
      ],
      "read_at": "2019-08-24T14:15:22Z",
      "created_at": "2019-08-24T14:15:22Z",
      "updated_at": "2019-08-24T14:15:22Z"
    }
  ],
  "unread_count": 0,
  "current_page": 0,
  "last_page": 0
}
```

<h3 id="notification.index-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="notification.index-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» notifications|[[DatabaseNotification](#schemadatabasenotification)]|true|none|none|
|»» DatabaseNotification|[DatabaseNotification](#schemadatabasenotification)|false|none|none|
|»»» id|string|true|none|none|
|»»» type|string|true|none|none|
|»»» notifiable_type|string|true|none|none|
|»»» notifiable_id|integer|true|none|none|
|»»» data|[any]|true|none|none|
|»»» read_at|string,null(date-time)|true|none|none|
|»»» created_at|string,null(date-time)|true|none|none|
|»»» updated_at|string,null(date-time)|true|none|none|
|» unread_count|integer|true|none|none|
|» current_page|integer|true|none|none|
|» last_page|integer|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## notification.destroyAll

<a id="opIdnotification.destroyAll"></a>

> Code samples

```shell
# You can also use wget
curl -X DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
DELETE https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications',
{
  method: 'DELETE',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.delete 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.delete('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('DELETE','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("DELETE");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("DELETE", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`DELETE /private/api/v1/notifications`

*Delete all read notifications*

> Example responses

> 200 Response

```json
{
  "message": "All read notifications have been deleted."
}
```

<h3 id="notification.destroyall-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="notification.destroyall-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## notification.markAllAsRead

<a id="opIdnotification.markAllAsRead"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/mark-read \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/mark-read HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/mark-read',
{
  method: 'POST',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/mark-read',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/mark-read', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/mark-read', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/mark-read");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/mark-read", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/notifications/mark-read`

*Mark all notifications as read*

> Example responses

> 200 Response

```json
{
  "message": "All notifications marked as read."
}
```

<h3 id="notification.markallasread-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|

<h3 id="notification.markallasread-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

## notification.markAsRead

<a id="opIdnotification.markAsRead"></a>

> Code samples

```shell
# You can also use wget
curl -X POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/{id}/mark-read \
  -H 'Accept: application/json' \
  -H 'X-App-Secret: API_KEY'

```

```http
POST https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/{id}/mark-read HTTP/1.1
Host: arturo-untaunting-thrawnly.ngrok-free.dev
Accept: application/json

```

```javascript

const headers = {
  'Accept':'application/json',
  'X-App-Secret':'API_KEY'
};

fetch('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/{id}/mark-read',
{
  method: 'POST',

  headers: headers
})
.then(function(res) {
    return res.json();
}).then(function(body) {
    console.log(body);
});

```

```ruby
require 'rest-client'
require 'json'

headers = {
  'Accept' => 'application/json',
  'X-App-Secret' => 'API_KEY'
}

result = RestClient.post 'https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/{id}/mark-read',
  params: {
  }, headers: headers

p JSON.parse(result)

```

```python
import requests
headers = {
  'Accept': 'application/json',
  'X-App-Secret': 'API_KEY'
}

r = requests.post('https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/{id}/mark-read', headers = headers)

print(r.json())

```

```php
<?php

require 'vendor/autoload.php';

$headers = array(
    'Accept' => 'application/json',
    'X-App-Secret' => 'API_KEY',
);

$client = new \GuzzleHttp\Client();

// Define array of request body.
$request_body = array();

try {
    $response = $client->request('POST','https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/{id}/mark-read', array(
        'headers' => $headers,
        'json' => $request_body,
       )
    );
    print_r($response->getBody()->getContents());
 }
 catch (\GuzzleHttp\Exception\BadResponseException $e) {
    // handle exception or api errors.
    print_r($e->getMessage());
 }

 // ...

```

```java
URL obj = new URL("https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/{id}/mark-read");
HttpURLConnection con = (HttpURLConnection) obj.openConnection();
con.setRequestMethod("POST");
int responseCode = con.getResponseCode();
BufferedReader in = new BufferedReader(
    new InputStreamReader(con.getInputStream()));
String inputLine;
StringBuffer response = new StringBuffer();
while ((inputLine = in.readLine()) != null) {
    response.append(inputLine);
}
in.close();
System.out.println(response.toString());

```

```go
package main

import (
       "bytes"
       "net/http"
)

func main() {

    headers := map[string][]string{
        "Accept": []string{"application/json"},
        "X-App-Secret": []string{"API_KEY"},
    }

    data := bytes.NewBuffer([]byte{jsonReq})
    req, err := http.NewRequest("POST", "https://arturo-untaunting-thrawnly.ngrok-free.dev/api/private/api/v1/notifications/{id}/mark-read", data)
    req.Header = headers

    client := &http.Client{}
    resp, err := client.Do(req)
    // ...
}

```

`POST /private/api/v1/notifications/{id}/mark-read`

*Mark a specific notification as read*

<h3 id="notification.markasread-parameters">Parameters</h3>

|Name|In|Type|Required|Description|
|---|---|---|---|---|
|id|path|string|true|none|

> Example responses

> 200 Response

```json
{
  "message": "Notification marked as read."
}
```

<h3 id="notification.markasread-responses">Responses</h3>

|Status|Meaning|Description|Schema|
|---|---|---|---|
|200|[OK](https://tools.ietf.org/html/rfc7231#section-6.3.1)|none|Inline|
|401|[Unauthorized](https://tools.ietf.org/html/rfc7235#section-3.1)|Unauthenticated|Inline|
|404|[Not Found](https://tools.ietf.org/html/rfc7231#section-6.5.4)|none|Inline|

<h3 id="notification.markasread-responseschema">Response Schema</h3>

Status Code **200**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

Status Code **401**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|Error overview.|

Status Code **404**

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|» message|string|true|none|none|

<aside class="warning">
To perform this operation, you must be authenticated by means of one of the following methods:
apiKey, http, http
</aside>

# Schemas

<h2 id="tocS_AdminApplication">AdminApplication</h2>
<!-- backwards compatibility -->
<a id="schemaadminapplication"></a>
<a id="schema_AdminApplication"></a>
<a id="tocSadminapplication"></a>
<a id="tocsadminapplication"></a>

```json
{
  "id": 0,
  "user_id": 0,
  "agency_name": "string",
  "document_path": "string",
  "notes": "string",
  "status": "string",
  "reviewed_by": 0,
  "reviewed_at": "string",
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z"
}

```

AdminApplication

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|id|integer|true|none|none|
|user_id|integer|true|none|none|
|agency_name|string|true|none|none|
|document_path|string|true|none|none|
|notes|string,null|true|none|none|
|status|string|true|none|none|
|reviewed_by|integer,null|true|none|none|
|reviewed_at|string,null|true|none|none|
|created_at|string,null(date-time)|true|none|none|
|updated_at|string,null(date-time)|true|none|none|

<h2 id="tocS_DatabaseNotification">DatabaseNotification</h2>
<!-- backwards compatibility -->
<a id="schemadatabasenotification"></a>
<a id="schema_DatabaseNotification"></a>
<a id="tocSdatabasenotification"></a>
<a id="tocsdatabasenotification"></a>

```json
{
  "id": "string",
  "type": "string",
  "notifiable_type": "string",
  "notifiable_id": 0,
  "data": [
    null
  ],
  "read_at": "2019-08-24T14:15:22Z",
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z"
}

```

DatabaseNotification

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|id|string|true|none|none|
|type|string|true|none|none|
|notifiable_type|string|true|none|none|
|notifiable_id|integer|true|none|none|
|data|[any]|true|none|none|
|read_at|string,null(date-time)|true|none|none|
|created_at|string,null(date-time)|true|none|none|
|updated_at|string,null(date-time)|true|none|none|

<h2 id="tocS_Detection">Detection</h2>
<!-- backwards compatibility -->
<a id="schemadetection"></a>
<a id="schema_Detection"></a>
<a id="tocSdetection"></a>
<a id="tocsdetection"></a>

```json
{
  "id": 0,
  "user_id": 0,
  "disease_id": 0,
  "method": "string",
  "image_path": "string",
  "label": "string",
  "confidence": "string",
  "temperature": "string",
  "scanned_at": "2019-08-24T14:15:22Z",
  "scan_duration_ms": 0,
  "latitude": "string",
  "longitude": "string",
  "connection_status": "string",
  "predictions": [
    null
  ],
  "selected_symptoms": [
    null
  ],
  "notes": "string",
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z",
  "status": "string",
  "expert_notes": "string",
  "images": [
    null
  ],
  "ai_disease_id": 0,
  "city": "string",
  "province": "string",
  "pakar_id": 0,
  "is_hidden_from_user": 0,
  "severity": "string"
}

```

Detection

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|id|integer|true|none|none|
|user_id|integer|true|none|none|
|disease_id|integer,null|true|none|none|
|method|string|true|none|none|
|image_path|string,null|true|none|none|
|label|string,null|true|none|none|
|confidence|string,null|true|none|none|
|temperature|string,null|true|none|none|
|scanned_at|string,null(date-time)|true|none|none|
|scan_duration_ms|integer,null|true|none|none|
|latitude|string,null|true|none|none|
|longitude|string,null|true|none|none|
|connection_status|string|true|none|none|
|predictions|array,null|true|none|none|
|selected_symptoms|array,null|true|none|none|
|notes|string,null|true|none|none|
|created_at|string,null(date-time)|true|none|none|
|updated_at|string,null(date-time)|true|none|none|
|status|string|true|none|none|
|expert_notes|string,null|true|none|none|
|images|array,null|true|none|none|
|ai_disease_id|integer,null|true|none|none|
|city|string,null|true|none|none|
|province|string,null|true|none|none|
|pakar_id|integer,null|true|none|none|
|is_hidden_from_user|integer|true|none|none|
|severity|string,null|true|none|none|

<h2 id="tocS_Disease">Disease</h2>
<!-- backwards compatibility -->
<a id="schemadisease"></a>
<a id="schema_Disease"></a>
<a id="tocSdisease"></a>
<a id="tocsdisease"></a>

```json
{
  "id": 0,
  "name": "string",
  "slug": "string",
  "latin_name": "string",
  "description": "string",
  "cause": "string",
  "image": "string",
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z"
}

```

Disease

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|id|integer|true|none|none|
|name|string|true|none|none|
|slug|string|true|none|none|
|latin_name|string,null|true|none|none|
|description|string|true|none|none|
|cause|string|true|none|none|
|image|string,null|true|none|none|
|created_at|string,null(date-time)|true|none|none|
|updated_at|string,null(date-time)|true|none|none|

<h2 id="tocS_ExpertApplication">ExpertApplication</h2>
<!-- backwards compatibility -->
<a id="schemaexpertapplication"></a>
<a id="schema_ExpertApplication"></a>
<a id="tocSexpertapplication"></a>
<a id="tocsexpertapplication"></a>

```json
{
  "id": 0,
  "user_id": 0,
  "document_path": "string",
  "notes": "string",
  "status": "string",
  "reviewed_by": 0,
  "reviewed_at": "string",
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z"
}

```

ExpertApplication

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|id|integer|true|none|none|
|user_id|integer|true|none|none|
|document_path|string|true|none|none|
|notes|string,null|true|none|none|
|status|string|true|none|none|
|reviewed_by|integer,null|true|none|none|
|reviewed_at|string,null|true|none|none|
|created_at|string,null(date-time)|true|none|none|
|updated_at|string,null(date-time)|true|none|none|

<h2 id="tocS_Feedback">Feedback</h2>
<!-- backwards compatibility -->
<a id="schemafeedback"></a>
<a id="schema_Feedback"></a>
<a id="tocSfeedback"></a>
<a id="tocsfeedback"></a>

```json
{
  "id": 0,
  "user_id": 0,
  "type": "string",
  "content": "string",
  "image_path": "string",
  "status": "string",
  "admin_response": "string",
  "responder_id": 0,
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z"
}

```

Feedback

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|id|integer|true|none|none|
|user_id|integer|true|none|none|
|type|string|true|none|none|
|content|string|true|none|none|
|image_path|string,null|true|none|none|
|status|string|true|none|none|
|admin_response|string,null|true|none|none|
|responder_id|integer,null|true|none|none|
|created_at|string,null(date-time)|true|none|none|
|updated_at|string,null(date-time)|true|none|none|

<h2 id="tocS_Symptom">Symptom</h2>
<!-- backwards compatibility -->
<a id="schemasymptom"></a>
<a id="schema_Symptom"></a>
<a id="tocSsymptom"></a>
<a id="tocssymptom"></a>

```json
{
  "id": 0,
  "code": "string",
  "name": "string",
  "description": "string",
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z"
}

```

Symptom

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|id|integer|true|none|none|
|code|string|true|none|none|
|name|string|true|none|none|
|description|string,null|true|none|none|
|created_at|string,null(date-time)|true|none|none|
|updated_at|string,null(date-time)|true|none|none|

<h2 id="tocS_Treatment">Treatment</h2>
<!-- backwards compatibility -->
<a id="schematreatment"></a>
<a id="schema_Treatment"></a>
<a id="tocStreatment"></a>
<a id="tocstreatment"></a>

```json
{
  "id": 0,
  "disease_id": 0,
  "type": "string",
  "description": "string",
  "dosage": "string",
  "dosage_unit": "string",
  "priority": 0,
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z"
}

```

Treatment

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|id|integer|true|none|none|
|disease_id|integer|true|none|none|
|type|string|true|none|none|
|description|string|true|none|none|
|dosage|string,null|true|none|none|
|dosage_unit|string,null|true|none|none|
|priority|integer|true|none|none|
|created_at|string,null(date-time)|true|none|none|
|updated_at|string,null(date-time)|true|none|none|

<h2 id="tocS_User">User</h2>
<!-- backwards compatibility -->
<a id="schemauser"></a>
<a id="schema_User"></a>
<a id="tocSuser"></a>
<a id="tocsuser"></a>

```json
{
  "id": 0,
  "name": "string",
  "email": "string",
  "email_verified_at": "2019-08-24T14:15:22Z",
  "created_at": "2019-08-24T14:15:22Z",
  "updated_at": "2019-08-24T14:15:22Z",
  "role": "string",
  "two_factor_confirmed_at": "2019-08-24T14:15:22Z",
  "avatar_url": "string",
  "fcm_token": "string",
  "google_id": "string",
  "avatar": "string",
  "pending_role": "string",
  "agency_name": "string"
}

```

User

### Properties

|Name|Type|Required|Restrictions|Description|
|---|---|---|---|---|
|id|integer|true|none|none|
|name|string|true|none|none|
|email|string|true|none|none|
|email_verified_at|string,null(date-time)|true|none|none|
|created_at|string,null(date-time)|true|none|none|
|updated_at|string,null(date-time)|true|none|none|
|role|string|true|none|none|
|two_factor_confirmed_at|string,null(date-time)|true|none|none|
|avatar_url|string,null|true|none|none|
|fcm_token|string,null|true|none|none|
|google_id|string,null|true|none|none|
|avatar|string,null|true|none|none|
|pending_role|string,null|true|none|none|
|agency_name|string,null|true|none|none|

