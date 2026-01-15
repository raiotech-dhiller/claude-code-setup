---
name: api-design
description: |
  REST API design patterns, versioning, and documentation.
  Use when designing APIs, implementing endpoints, or documenting APIs.
---

# API Design

## REST Conventions
- `GET /resources`: List all
- `GET /resources/:id`: Get one
- `POST /resources`: Create
- `PUT /resources/:id`: Full update
- `PATCH /resources/:id`: Partial update
- `DELETE /resources/:id`: Delete

## Response Format
```json
{
  "data": { /* resource */ },
  "meta": {
    "page": 1,
    "total": 100
  },
  "error": null
}
```

## Error Format
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input",
    "details": [
      { "field": "email", "message": "Invalid format" }
    ]
  }
}
```

## Status Codes
- 200: Success
- 201: Created
- 204: No Content (delete)
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 422: Unprocessable Entity
- 500: Server Error

## Pagination
```
GET /resources?page=1&limit=20
GET /resources?cursor=abc123&limit=20
```

## Filtering & Sorting
```
GET /resources?status=active&sort=-created_at
```
