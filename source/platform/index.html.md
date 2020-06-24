---
title: Platform API Documentation

language_tabs:
  - shell

toc_footers:
  - <a href='https://www.chatkitty.com'>&copy; ChatKitty 2020. All rights reserved</a>

includes:
  - platform_errors

search: true
---
# Introduction

The Platform API provides a RESTful interface for administrators and server-side back-ends to manage
their ChatKitty applications. 

<aside class="success">
ChatKitty provides a <a href="https://staging-api.chatkitty.com/v1/explorer/index.html#hkey0=Content-Type&hval0=application/json&uri=/v1/applications/me">API Explorer</a> to 
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
curl --location --request POST 'https://staging-authorization.chatkitty.com/oauth/token' \
--user 'acme:acmesecret' \
--form 'grant_type=client_credentials' \
--form 'username=acme' \
--form 'password=acmesecret'
```

> Returns a JSON response with the Bearer access token.

```json
{
  "access_token": "d4327889-26a8-49ac-997c-56d8b1bcb09c",
  "token_type": "bearer",
  "expires_in": 42892,
  "scope": "org:52:app"
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

# V1 API
The following describes endpoints and resources exposed by the V1 ChatKitty API.

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#v1-api) | [GET](#get-api-root) | Self link to the V1 API. 
[application](#application) | [GET](#get-application) | The ChatKitty application currently authenticated.

## Get API Root

```shell
curl --location --request GET 'https://staging-api.chatkitty.com/v1' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns a HAL resource with links to top-level ChatKitty resources:

```json
{
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1"
    },
    "application": {
      "href": "https://staging-api.chatkitty.com/v1/applications/me"
    }
  }
}
```

This endpoint returns the root of your ChatKitty application graph. 

### HTTP Request

`GET https://staging-api.chatkitty.com/v1`

<aside class="success">
This is the only URL needed to discover the rest of the Platform API as every other URL is returned as a REST link.
</aside>

# Application
An application resource represents the current ChatKitty application and can be used to configure the application.

## Properties
Name | Type | Description 
--------- | ----------- | -----------
id | Long | 64 bit integer identifier associated with this application 
name | String | The name of the ChatKitty application 
key | String | Unique string used as an API key for this application client-side 

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#application) | [GET](#get-application) | Self link to this application. 
[users](#user) | [POST](#create-a-user), [GET](#get-users) | Users belonging to this application.
[channels](#channel) | [POST](#create-a-channel), [GET](#get-channel) | Channels belonging to this application.
[organization](#organization) | [GET](#get-organization) | Organization this application belongs to. 

## Get Application

```shell
curl --location --request GET '{{application_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns an application HAL resource:

```json
{
  "id": 52,
  "name": "ChatKitty",
  "key": "107a326f-bfab-4d2c-9a5a-fa79bd896929",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52"
    },
    "users": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52/users"
    },
    "channels": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52/channels"
    },
    "organization": {
      "href": "https://staging-api.chatkitty.com/v1/organizations/52"
    }
  }
}
```

This endpoint returns a resource representing your ChatKitty application.

### HTTP Request
`GET {{application_link}}`

# User
Users can chat with each other by joining channels. They are identified by their own unique user name.

## Properties
Name | Type | Description 
--------- | ----------- | -----------
id | Long | 64 bit integer identifier associated with this user 
name | String | The unique name of the user.

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#user) | [GET](#get-a-user) | Self link to this user.
[channels](#channel) | [GET](#get-a-channel) | Channels this user has access to - meaning the user has joined or can join. 
[application](#application) | [GET](#get-application) | Link to your application resource. 

## Get Users

```shell
curl --location --request GET '{{users_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns a user page HAL resource:

```json
{
  "_embedded": {
    "users": [
      {
        "id": 53,
        "name": "1017562554",
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/52/users/53"
          },
          "channels": {
            "href": "https://staging-api.chatkitty.com/v1/applications/52/users/53/channels"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/52"
          }
        }
      },
      {
        "id": 54,
        "name": "1027466852",
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/52/users/54"
          },
          "channels": {
            "href": "https://staging-api.chatkitty.com/v1/applications/52/users/54/channels"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/52"
          }
        }
      }
    ]
  },
  "_links": {
    "first": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52/users?page=0&size=2"
    },
    "prev": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52/users?page=0&size=2"
    },
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52/users?page=1&size=2"
    },
    "next": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52/users?page=2&size=2"
    },
    "last": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52/users?page=2&size=2"
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

This endpoint returns a page resource of ChatKitty users.

### HTTP Request
`GET {{users_link}}`

## Get a User

```shell
curl --location --request GET '{{user_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns a user HAL resource:

```json
{
  "id": 53,
  "name": "1017562554",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52/users/53"
    },
    "channels": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52/users/53/channels"
    },
    "application": {
      "href": "https://staging-api.chatkitty.com/v1/applications/52"
    }
  }
}
```

This endpoint returns a resource representing a ChatKitty user.

### HTTP Request
`GET {{user_link}}`