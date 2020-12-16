---
title: Platform API Documentation

language_tabs:
  - shell
  - http
  - python

toc_footers:
  - <a href='https://www.chatkitty.com'>&copy; ChatKitty 2020. All rights reserved</a>

includes:
  - platform_chat_functions
  - platform_open_api
  - platform_files
  - platform_errors

search: true

code_clipboard: true
---
# Introduction
The Platform API provides a RESTful interface for administrators and server-side back-ends to manage
their ChatKitty applications. 

<aside class="success">
ChatKitty provides an <a href="https://docs.chatkitty.com/platform/v1/">API Explorer</a> to
access the Platform API.
</aside>

# Headers
Making a request to the Platform API requires HTTP `Content-Type` and `Authorization` headers.

Most resources exposed by the API are represented as JSON [HAL](http://stateless.co/hal_specification.html) responses.

For these resources, set request `Content-Type` headers to `application/json`.

ChatKitty's API requires a [OAuth 2.0](https://oauth.net/2/) Bearer access token `Authorization` header values
to access protected resources. A valid access token can be retrieved from the ChatKitty Authorization Service 
using your application's client ID and client secret. 

# Authentication
> To authorize use this replacing `acme` with your client ID and `acmesecret` with your client secret:

```shell
curl --location --request POST 'https://authorization.chatkitty.com/oauth/token' \
--user 'acme:acmesecret' \
--form 'grant_type=client_credentials' \
--form 'username=acme' \
--form 'password=acmesecret'
```

```http
POST /oauth/token HTTP/1.1
Host: https://authorization.chatkitty.com/oauth/token
Authorization: Basic YWNtZTphY21lc2VjcmV0Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW

----WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="grant_type"

client_credentials
----WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="username"

acme
----WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="password"

acmesecret
----WebKitFormBoundary7MA4YWxkTrZu0gW
```

```python
import requests

url = "https://authorization.chatkitty.com/oauth/token"

payload = {'grant_type': 'client_credentials',
'username': 'acme',
'password': 'acmesecret'}

response = requests.request("POST", url, data = payload, auth=('acme', 'acmesecret'))
```

> Returns a JSON response with the Bearer access token.

```json
{
  "access_token": "d4327889-26a8-49ac-997c-56d8b1bcb09c",
  "token_type": "bearer",
  "expires_in": 42892,
  "scope": "org:1:app"
}
```

> `access_token` is the bearer access token.
> `expires_in` represents the access token's validity in seconds.

Retrieve an **OAuth 2.0 Bearer access token** with the client credentials OAuth flow.

Retrieving a Bearer access token requires a ChatKitty application client ID and client secret. 

You can create a ChatKitty application and receive client credentials by [contacting us](https://www.chatkitty.com/contact/).

ChatKitty expects a valid Bearer access token to be included in all API requests like this:

`Authorization: Bearer {{access_token}}`

<aside class="notice">
You must replace <code>{{access_token}}</code> with an access token gotten using your client credentials.
</aside>

# Pagination
> This requests a user resource page

```shell
curl --location --request GET '{{users_url}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: {{users_url}}
Content-Type: application/json
Authorization: {{access_token}}
```

```python
import requests

url = "https://staging-api.chatkitty.com/v1/applications/2/users?page=0&size=20"

headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer {{access_token}}'
}

response = requests.request("GET", url, headers=headers)
```

> The command above returns a user page HAL resource.

```json
{
  "_embedded": {
    "users": [
      {
        "id": 1,
        "name": "1017562554",
        "displayName": "Jane Doe",
        "_links": {
          "self": {
            "href": "https://api.chatkitty.com/v1/applications/1/users/1"
          },
          "channels": {
            "href": "https://api.chatkitty.com/v1/applications/1/users/1/channels"
          },
          "application": {
            "href": "https://api.chatkitty.com/v1/applications/1"
          }
        }
      },
      {
        "id": 2,
        "name": "102746681",
        "displayName": "John Doe",
        "_links": {
          "self": {
            "href": "https://api.chatkitty.com/v1/applications/1/users/2"
          },
          "channels": {
            "href": "https://api.chatkitty.com/v1/applications/1/users/2/channels"
          },
          "application": {
            "href": "https://api.chatkitty.com/v1/applications/1"
          }
        }
      }
    ]
  },
  "_links": {
    "first": {
      "href": "https://api.chatkitty.com/v1/applications/1/users?page=0&size=2"
    },
    "prev": {
      "href": "https://api.chatkitty.com/v1/applications/1/users?page=0&size=2"
    },
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1/users?page=1&size=2"
    },
    "next": {
      "href": "https://api.chatkitty.com/v1/applications/1/users?page=2&size=2"
    },
    "last": {
      "href": "https://api.chatkitty.com/v1/applications/1/users?page=2&size=2"
    }
  },
  "page": {
    "size": 2,
    "totalElements": 6,
    "totalPages": 3,
    "number": 1
  }
}
```

ChatKitty **paginates** all collection resources. Requesting a resource collection returns 
the first page of the collection optionally with HAL hypermedia links to subsequent pages if more pages are available.

Traverse the page links to iterate through a collection.
 
## Properties
Name | Type | Description 
--------- | ----------- | -----------
[page](#pagination-page-metadata) | PageMetadata | Metadata about the page

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
self | GET | Self link to this page.
first | GET | __Optional:__ Link to the first page of this collection. __Present if__ known.
prev | GET | __Optional:__ Link to the previous page of this collection. __Present if__ there are more items before the first item in this page.
next | GET | __Optional:__ Link to the next page of this collection. __Present if__ there are more items after the last item in this page.
last | GET | __Optional:__ Link to the last page of this collection. __Present if__ known.

## Embedded properties 
A page resources embeds a slice of a resource collection in a JSON array property with the same name 
as the resource collection. For example, with a collection of users resources, the resource collection name would be `users`, 
and the page would include a JSON array in its `_embedded` property named `users`, as per the [HAL](http://stateless.co/hal_specification.html) specification.

> `users` is the name of a user resource collection

```json
{
  "_embedded": {
    "users": [
      {
        "id": 1,
        "name": "1017562554",
        "displayName": "Jane Doe",
        "_links": {
          "self": {
            "href": "https://api.chatkitty.com/v1/applications/1/users/1"
          },
          "channels": {
            "href": "https://api.chatkitty.com/v1/applications/1/users/1/channels"
          },
          "application": {
            "href": "https://api.chatkitty.com/v1/applications/1"
          }
        }
      },
      // ...
    ]
  },
  // ...
}
```


## Page Metadata
Metadata about a page containing its size, total number of elements in the collection, total number of pages in the collection, and the page number.

## Properties
Name | Type | Description 
--------- | ----------- | -----------
size | Int | The number of elements in this page.
number | Int | __Optional:__ The zero-based index of this page. __Present if__ known.
totalElements | Long | __Optional:__ The total number of elements in the collection. __Present if__ known.
totalPages | Int | __Optional:__ The total number of pages in the collection. __Present if__ known.
