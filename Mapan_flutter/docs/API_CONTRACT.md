# API Contract Documentation

## Overview

This document defines the complete API contract for the Mapan (Plant Disease Detection) application. The API follows a dual-prefix structure for authentication control.

**Base URL:** `http://localhost:8000` (development)

---

## API Architecture

### Dual-Prefix Structure

```
/public/api/v1/*   → No authentication required (GET endpoints, login, register)
/private/api/v1/*  → Authentication required (Bearer token via Sanctum)
```

### Authentication

All `/private/api/v1/*` endpoints require:
```
Authorization: Bearer {token}
```

**Note:** Bootstrap app.php sets `apiPrefix: ''` (empty). Full paths are defined in routes file.

---

## Response Format

All API responses follow a consistent JSON structure:

### Success Response (200-299)
```json
{
  "data": { /* response payload */ },
  "message": "Success message",
  "code": 200
}
```

### Error Response (400+)
```json
{
  "message": "Error description",
  "errors": { /* validation errors */ },
  "code": 400
}
```

---

## ✅ PUBLIC API - `/public/api/v1`

### No authentication required

---

### Authentication Endpoints

#### POST `/public/api/v1/login`
**Description:** User login and get authentication token

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password"
}
```

**Response (200):**
```json
{
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "name": "John Doe",
      "role": "user"
    },
    "token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
  },
  "message": "Login successful"
}
```

**Error (401):**
```json
{
  "message": "Invalid credentials",
  "code": 401
}
```

---

#### POST `/public/api/v1/register`
**Description:** Register new user account

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password",
  "password_confirmation": "password"
}
```

**Response (201):**
```json
{
  "data": {
    "user": {
      "id": 1,
      "email": "john@example.com",
      "name": "John Doe",
      "role": "user"
    },
    "token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
  },
  "message": "Registration successful"
}
```

**Error (422):**
```json
{
  "message": "Validation failed",
  "errors": {
    "email": ["Email already exists"]
  },
  "code": 422
}
```

---

### Disease Endpoints

#### GET `/public/api/v1/diseases`
**Description:** List all diseases with basic information

**Query Parameters:**
```
?page=1&per_page=15&search=blast
```

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Blast",
      "slug": "blast",
      "description": "A serious fungal disease...",
      "image_url": "https://...",
      "symptoms_count": 5,
      "treatments_count": 3
    }
  ],
  "meta": {
    "total": 11,
    "per_page": 15,
    "current_page": 1,
    "last_page": 1
  }
}
```

---

#### GET `/public/api/v1/diseases/{slug}`
**Description:** Get detailed disease information including symptoms and treatments

**Path Parameters:**
- `slug` (string) - Disease slug, e.g., "blast", "brown-spot"

**Response (200):**
```json
{
  "data": {
    "id": 1,
    "name": "Blast",
    "slug": "blast",
    "description": "A serious fungal disease affecting rice crops...",
    "image_url": "https://...",
    "causes": "Fungal infection by Pyricularia oryzae",
    "prevention": "Practice crop rotation, use resistant varieties...",
    "symptoms": [
      {
        "id": 1,
        "name": "Brown lesions with grey center",
        "severity": "high"
      }
    ],
    "treatments": [
      {
        "id": 1,
        "name": "Fungicide application",
        "description": "Apply triazole fungicides...",
        "dosage": "2-3 ml per liter"
      }
    ]
  }
}
```

**Error (404):**
```json
{
  "message": "Disease not found",
  "code": 404
}
```

---

### Symptoms Endpoints

#### GET `/public/api/v1/symptoms`
**Description:** List all available symptoms for the expert system

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Brown lesions with grey center",
      "description": "Circular brown spots with ashy grey center",
      "diseases": ["blast", "brown-spot"]
    }
  ]
}
```

---

### Detection Endpoints (Read-Only)

#### GET `/public/api/v1/detections`
**Description:** List all detections (public view)

**Query Parameters:**
```
?page=1&per_page=20
```

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "disease": "Blast",
      "confidence": 0.95,
      "status": "confirmed",
      "created_at": "2024-01-15T10:30:00Z"
    }
  ],
  "meta": {
    "total": 150,
    "per_page": 20,
    "current_page": 1
  }
}
```

---

#### GET `/public/api/v1/detections/{id}`
**Description:** Get detection details (public view)

**Path Parameters:**
- `id` (integer) - Detection ID

**Response (200):**
```json
{
  "data": {
    "id": 1,
    "user_id": 1,
    "disease": "Blast",
    "confidence": 0.95,
    "image_url": "https://...",
    "symptoms_detected": [
      "Brown lesions",
      "Grey center"
    ],
    "recommended_treatment": "Apply fungicide immediately",
    "status": "confirmed",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

## 🔒 PRIVATE API - `/private/api/v1`

### ✅ Authentication Required: `Authorization: Bearer {token}`

---

### Authentication Endpoints

#### GET `/private/api/v1/user`
**Description:** Get current authenticated user information

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "role": "user",
    "permissions": {
      "canManageKnowledgeBase": false,
      "canManageSystem": false,
      "canManageUsers": false,
      "canViewAllDetections": false
    }
  }
}
```

---

#### POST `/private/api/v1/logout`
**Description:** Logout and revoke authentication token

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "message": "Logout successful"
}
```

---

### Detection Management Endpoints

#### POST `/private/api/v1/detections`
**Description:** Create a new detection record

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "disease_id": 1,
  "image": "base64_encoded_image",
  "location": "Field A, Plot 1",
  "notes": "Found on rice leaf"
}
```

**Response (201):**
```json
{
  "data": {
    "id": 10,
    "user_id": 1,
    "disease_id": 1,
    "image_url": "https://...",
    "location": "Field A, Plot 1",
    "notes": "Found on rice leaf",
    "status": "pending",
    "created_at": "2024-01-20T14:30:00Z"
  },
  "message": "Detection created successfully"
}
```

---

#### POST `/private/api/v1/detections/predict`
**Description:** Predict disease from image using ML model

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "image": "base64_encoded_image"
}
```

**Response (200):**
```json
{
  "data": {
    "predictions": [
      {
        "disease": "Blast",
        "confidence": 0.95,
        "probability": 0.95
      },
      {
        "disease": "Brown Spot",
        "confidence": 0.04,
        "probability": 0.04
      }
    ],
    "top_prediction": {
      "disease": "Blast",
      "confidence": 0.95
    }
  }
}
```

---

#### DELETE `/private/api/v1/detections/{id}`
**Description:** Delete a detection record

**Path Parameters:**
- `id` (integer) - Detection ID

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "message": "Detection deleted successfully"
}
```

**Error (404):**
```json
{
  "message": "Detection not found",
  "code": 404
}
```

---

### Expert System Endpoints

#### POST `/private/api/v1/expert-system/diagnose`
**Description:** Diagnose disease based on selected symptoms

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "symptoms": [1, 3, 5],
  "location": "Field A",
  "crop_stage": "flowering"
}
```

**Response (200):**
```json
{
  "data": {
    "diagnosis": [
      {
        "disease": "Blast",
        "confidence": 0.92,
        "probability": 0.92,
        "treatments": [
          {
            "id": 1,
            "name": "Fungicide application",
            "dosage": "2-3 ml per liter"
          }
        ]
      }
    ]
  }
}
```

---

#### POST `/private/api/v1/expert-system`
**Description:** Create an expert system diagnosis record

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "symptoms": [1, 3, 5],
  "diagnosis": "Blast",
  "confidence": 0.92,
  "location": "Field A"
}
```

**Response (201):**
```json
{
  "data": {
    "id": 5,
    "user_id": 1,
    "diagnosis": "Blast",
    "confidence": 0.92,
    "created_at": "2024-01-20T14:30:00Z"
  }
}
```

---

## 🔑 KNOWLEDGE BASE MANAGEMENT - `/private/api/v1/admin/knowledge-base`

**Required Roles:** `pakar` or `super_admin`

---

### Diseases Management

#### GET `/private/api/v1/admin/knowledge-base/diseases`
**Description:** List all diseases (management view)

**Headers:**
```
Authorization: Bearer {token}
```

**Query Parameters:**
```
?page=1&per_page=20&search=blast
```

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Blast",
      "slug": "blast",
      "description": "A serious fungal disease...",
      "image_url": "https://...",
      "causes": "Fungal infection",
      "prevention": "Practice crop rotation...",
      "symptoms_count": 5,
      "treatments_count": 3,
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

---

#### POST `/private/api/v1/admin/knowledge-base/diseases`
**Description:** Create a new disease entry

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "New Disease",
  "description": "Detailed description",
  "causes": "Root cause",
  "prevention": "Prevention methods",
  "image": "base64_or_url"
}
```

**Response (201):**
```json
{
  "data": {
    "id": 12,
    "name": "New Disease",
    "slug": "new-disease",
    "description": "Detailed description",
    "causes": "Root cause",
    "prevention": "Prevention methods",
    "image_url": "https://..."
  }
}
```

---

#### PUT `/private/api/v1/admin/knowledge-base/diseases/{id}`
**Description:** Update disease information

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Updated Disease Name",
  "description": "Updated description",
  "causes": "Updated causes",
  "prevention": "Updated prevention",
  "image": "base64_or_url"
}
```

**Response (200):**
```json
{
  "data": {
    "id": 1,
    "name": "Updated Disease Name",
    "description": "Updated description",
    "updated_at": "2024-01-20T14:30:00Z"
  }
}
```

---

#### DELETE `/private/api/v1/admin/knowledge-base/diseases/{id}`
**Description:** Delete a disease entry

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "message": "Disease deleted successfully"
}
```

**Error (404):**
```json
{
  "message": "Disease not found",
  "code": 404
}
```

---

### Symptoms Management

#### GET `/private/api/v1/admin/knowledge-base/symptoms`
**Description:** List all symptoms (management view)

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Brown lesions with grey center",
      "description": "Circular brown spots with ashy grey center",
      "severity": "high",
      "diseases_count": 3,
      "created_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

#### POST `/private/api/v1/admin/knowledge-base/symptoms`
**Description:** Create a new symptom entry

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Symptom Name",
  "description": "Detailed description",
  "severity": "high|medium|low",
  "diseases": [1, 2, 3]
}
```

**Response (201):**
```json
{
  "data": {
    "id": 10,
    "name": "Symptom Name",
    "description": "Detailed description",
    "severity": "high"
  }
}
```

---

#### PUT `/private/api/v1/admin/knowledge-base/symptoms/{id}`
**Description:** Update symptom information

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Updated Symptom",
  "description": "Updated description",
  "severity": "medium",
  "diseases": [1, 2]
}
```

**Response (200):**
```json
{
  "data": {
    "id": 1,
    "name": "Updated Symptom",
    "description": "Updated description",
    "severity": "medium"
  }
}
```

---

#### DELETE `/private/api/v1/admin/knowledge-base/symptoms/{id}`
**Description:** Delete a symptom entry

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "message": "Symptom deleted successfully"
}
```

---

### Treatments Management

#### GET `/private/api/v1/admin/knowledge-base/treatments`
**Description:** List all treatments (management view)

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Fungicide application",
      "description": "Apply triazole fungicides",
      "dosage": "2-3 ml per liter",
      "application_method": "Spraying",
      "diseases_count": 5,
      "created_at": "2024-01-01T00:00:00Z"
    }
  ]
}
```

---

#### POST `/private/api/v1/admin/knowledge-base/treatments`
**Description:** Create a new treatment entry

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Treatment Name",
  "description": "Detailed description",
  "dosage": "2-3 ml per liter",
  "application_method": "Spraying|Dusting|Irrigation",
  "cost": 50000,
  "diseases": [1, 2]
}
```

**Response (201):**
```json
{
  "data": {
    "id": 15,
    "name": "Treatment Name",
    "description": "Detailed description",
    "dosage": "2-3 ml per liter",
    "application_method": "Spraying",
    "cost": 50000
  }
}
```

---

#### PUT `/private/api/v1/admin/knowledge-base/treatments/{id}`
**Description:** Update treatment information

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Updated Treatment",
  "description": "Updated description",
  "dosage": "3-4 ml per liter",
  "application_method": "Spraying",
  "cost": 60000
}
```

**Response (200):**
```json
{
  "data": {
    "id": 1,
    "name": "Updated Treatment",
    "description": "Updated description",
    "dosage": "3-4 ml per liter"
  }
}
```

---

#### DELETE `/private/api/v1/admin/knowledge-base/treatments/{id}`
**Description:** Delete a treatment entry

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "message": "Treatment deleted successfully"
}
```

---

## 🛠️ SYSTEM MANAGEMENT - `/private/api/v1/admin/system`

**Required Roles:** `admin` or `super_admin`

---

### Dashboard Endpoints

#### GET `/private/api/v1/admin/system/dashboard/stats`
**Description:** Get system dashboard statistics

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "data": {
    "total_users": 150,
    "total_detections": 1200,
    "total_diseases": 11,
    "detections_today": 45,
    "pending_detections": 12,
    "recent_detections": [
      {
        "id": 100,
        "user": "John Doe",
        "disease": "Blast",
        "confidence": 0.95,
        "created_at": "2024-01-20T14:30:00Z"
      }
    ],
    "disease_statistics": [
      {
        "name": "Blast",
        "count": 320,
        "percentage": 26.7
      }
    ]
  }
}
```

---

### Users Management (super_admin only)

#### GET `/private/api/v1/admin/system/users`
**Description:** List all users in the system

**Headers:**
```
Authorization: Bearer {token}
```

**Query Parameters:**
```
?page=1&per_page=20&role=user&search=john
```

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "role": "user",
      "detections_count": 15,
      "created_at": "2024-01-01T00:00:00Z"
    }
  ],
  "meta": {
    "total": 150,
    "per_page": 20,
    "current_page": 1
  }
}
```

---

#### PUT `/private/api/v1/admin/system/users/{id}`
**Description:** Update user information or role

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Updated Name",
  "email": "newemail@example.com",
  "role": "pakar"
}
```

**Response (200):**
```json
{
  "data": {
    "id": 1,
    "name": "Updated Name",
    "email": "newemail@example.com",
    "role": "pakar",
    "updated_at": "2024-01-20T14:30:00Z"
  }
}
```

---

#### DELETE `/private/api/v1/admin/system/users/{id}`
**Description:** Delete a user from the system

**Headers:**
```
Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "message": "User deleted successfully"
}
```

**Error (403):**
```json
{
  "message": "You don't have permission to delete this user",
  "code": 403
}
```

---

## 👥 SHARED ADMIN ROUTES - `/private/api/v1/admin`

**Required Roles:** `super_admin`, `admin`, or `pakar`

---

### Detections Management

#### GET `/private/api/v1/admin/detections`
**Description:** List all detections (admin view with filters)

**Headers:**
```
Authorization: Bearer {token}
```

**Query Parameters:**
```
?page=1&per_page=20&status=confirmed&disease=blast&user_id=1&date_from=2024-01-01&date_to=2024-01-31
```

**Response (200):**
```json
{
  "data": [
    {
      "id": 1,
      "user": {
        "id": 1,
        "name": "John Doe",
        "email": "john@example.com"
      },
      "disease": {
        "id": 1,
        "name": "Blast",
        "slug": "blast"
      },
      "image_url": "https://...",
      "confidence": 0.95,
      "status": "confirmed",
      "location": "Field A",
      "created_at": "2024-01-20T14:30:00Z"
    }
  ],
  "meta": {
    "total": 450,
    "per_page": 20,
    "current_page": 1
  }
}
```

---

## Error Codes & Status Codes

| Code | Meaning | Common Causes |
|------|---------|---------------|
| 200 | OK | Request successful |
| 201 | Created | Resource created successfully |
| 204 | No Content | Successful request with no content |
| 400 | Bad Request | Invalid request parameters |
| 401 | Unauthorized | Missing or invalid token |
| 403 | Forbidden | Insufficient permissions/role |
| 404 | Not Found | Resource does not exist |
| 422 | Unprocessable Entity | Validation error |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Server Error | Internal server error |

---

## Role-Based Access Control

### Role Hierarchy

```
super_admin
├── Full system access
├── Can manage users
├── Can manage knowledge base (diseases, symptoms, treatments)
├── Can view all detections
└── Can access system dashboard

admin
├── System operations only
├── Can view all detections
└── Can access system dashboard

pakar
├── Knowledge base management (diseases, symptoms, treatments)
├── Can view all detections
└── Cannot manage users or system settings

user
├── Can view public content (diseases, symptoms)
├── Can create and manage own detections
├── Can use expert system
└── Cannot access admin features
```

### Required Permissions by Endpoint

| Endpoint Group | Required Role(s) |
|---|---|
| Public API | None |
| User detections | `user`, `pakar`, `admin`, `super_admin` |
| Expert system | `user`, `pakar`, `admin`, `super_admin` |
| Knowledge base management | `pakar`, `super_admin` |
| System dashboard | `admin`, `super_admin` |
| User management | `super_admin` |
| Admin detections view | `pakar`, `admin`, `super_admin` |

---

## Frontend Integration Examples

### Authentication Flow

```javascript
// 1. Login
const loginResponse = await fetch('/public/api/v1/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, password })
});
const { data } = await loginResponse.json();
localStorage.setItem('token', data.token);

// 2. Get current user
const userResponse = await fetch('/private/api/v1/user', {
  headers: { 'Authorization': `Bearer ${data.token}` }
});

// 3. Logout
await fetch('/private/api/v1/logout', {
  method: 'POST',
  headers: { 'Authorization': `Bearer ${data.token}` }
});
localStorage.removeItem('token');
```

### API Request Helper

```javascript
async function apiCall(endpoint, options = {}) {
  const token = localStorage.getItem('token');
  const headers = {
    'Content-Type': 'application/json',
    ...(token && { 'Authorization': `Bearer ${token}` }),
    ...options.headers
  };

  const response = await fetch(`${endpoint}`, {
    ...options,
    headers
  });

  return response.json();
}

// Usage
const diseases = await apiCall('/public/api/v1/diseases');
const user = await apiCall('/private/api/v1/user');
```

---

## Notes for Frontend Development

1. **Always use full paths** - Don't rely on apiPrefix being set in bootstrap
2. **Public endpoints** - Use `/public/api/v1/*` for GET requests without auth
3. **Private endpoints** - Use `/private/api/v1/*` with Bearer token for authenticated requests
4. **Admin endpoints** - Use `/private/api/v1/admin/*` with proper role permissions
5. **Error handling** - Check response status codes and validate error structure
6. **Token storage** - Store JWT token in localStorage or session storage (never cookies for XSS safety)
7. **CORS** - CORS is configured in config/cors.php to allow frontend requests

---

## Testing Accounts

```
Email                   Password      Role
user@mapan.test         password      user
pakar@mapan.test        password      pakar
admin@mapan.test        password      admin
superadmin@mapan.test   password      super_admin
```

---

## API Validation Rules

### Input Validation

- All `email` fields must be valid email format
- All `password` fields must be at least 8 characters
- All `required` fields must not be empty
- Image uploads must be valid base64 or image URLs
- Numeric IDs must be positive integers
- Enum fields must be one of predefined values

### Output Validation

- All timestamps are in ISO 8601 format (UTC)
- All URLs are absolute and accessible
- All numerical confidences are between 0 and 1
- All text fields are properly escaped for security

---

**Last Updated:** 2024-01-20
**API Version:** v1
**Status:** Production Ready
