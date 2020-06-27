---
title: Platform API Documentation

language_tabs:
  - shell

toc_footers:
  - <a href='https://www.chatkitty.com'>&copy; ChatKitty 2020. All rights reserved</a>

includes:
  - platform_errors

search: true

code_clipboard: true
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
curl --location --request GET '{{users_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns a user page HAL resource.

```json
{
  "_embedded": {
    "users": [
      {
        "id": 1,
        "name": "1017562554",
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1"
          },
          "channels": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1/channels"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1"
          }
        }
      },
      {
        "id": 2,
        "name": "102746681",
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/2"
          },
          "channels": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/2/channels"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1"
          }
        }
      }
    ]
  },
  "_links": {
    "first": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users?page=0&size=2"
    },
    "prev": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users?page=0&size=2"
    },
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users?page=1&size=2"
    },
    "next": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users?page=2&size=2"
    },
    "last": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users?page=2&size=2"
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
[page](#page-metadata) | PageMetadata | Metadata about the page

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#pagination) | [GET](#pagination) | Self link to this page.
[first](#pagination) | [GET](#pagination) | __Optional:__ Link to the first page of this collection. __Present if__ known.
[prev](#pagination) | [GET](#pagination) | __Optional:__ Link to the previous page of this collection. __Present if__ there are more items before the first item in this page.
[next](#pagination) | [GET](#pagination) | __Optional:__ Link to the next page of this collection. __Present if__ there are more items after the last item in this page.
[last](#pagination) | [GET](#pagination) | __Optional:__ Link to the last page of this collection. __Present if__ known.

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
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1"
          },
          "channels": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1/channels"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1"
          }
        }
      },
      ...
    ]
  },
  ...
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
[channels](#channel) | [POST](#create-a-channel), [GET](#get-a-channel) | Channels belonging to this application.

## Get Application
```shell
curl --location --request GET '{{application_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns an application HAL resource:

```json
{
  "id": 1,
  "name": "ChatKitty Application",
  "key": "107a326f-bfab-4d2c-9a5a-fa79bd896929",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1"
    },
    "users": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users"
    },
    "channels": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels"
    }
  }
}
```

This endpoint returns a resource representing your ChatKitty application.

### HTTP Request
`GET {{application_link}}`

# Channel
Channels are the backbone of the ChatKitty chat experience. [Users](#user) can join channels and receive 
or send [messages](#message). ChatKitty broadcasts messages created in channels to channel members via 
a chat session or push notifications.

There are three types of channels; [Open Channels](#open-channel), [Public Channels](#public-channel), 
and [Private Channels](#private-channel).

## Open Channel
Open channels provide Twitch-style chats where many users can join the chat without invites and send 
messages. 

<aside class="notice">
Messages sent in open channels are <b>ephemeral</b> and not persisted by ChatKitty.
</aside>

## Public Channel
Users can join public channels by themselves (like an open chat) or via invites from an existing channel member.
ChatKitty persists messages sent in public channels by default but this behaviour can be configured.

## Private Channel
Users can only join private channels via invites from an existing channel member.
ChatKitty persists messages sent in private channels by default but this behaviour can be configured.

## Properties
Name | Type | Description 
--------- | ----------- | -----------
id | Long | 64 bit integer identifier associated with this channel 
type | Enum | The type of this channel. __Possible values__ are [OPEN](#open-channel), [PUBLIC](#public-channel), and [PRIVATE](#private-channel)
name | String | The name of this channel

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#channel) | [GET](#get-a-channel), [DELETE](#delete-a-channel) | Self link to this channel.
[messages](#message) | [POST](#create-a-message), [GET](#get-messages) | Messages sent in this channel. 
[application](#application) | [GET](#get-application) | Link to your application resource. 

## Create a Channel
```shell
curl --location --request POST '{{channels_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}' \
--data-raw '{
    "type": "OPEN"
    "name": "Open Chat"
}'
```

> The command above returns a channel HAL resource:

```json
{
  "id": 1,
  "type": "OPEN",
  "name": "Open Chat",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/1"
    },
    "messages": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/1/messages"
    },
    "application": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint creates a new channel.

### HTTP Request
`POST {{channels_link}}`

### Request Body (JSON)
Parameter | Type | Description 
--------- | ----------- | -----------
type | Enum | The type of the channel. __Possible values__ are [OPEN](#open-channel), [PUBLIC](#public-channel), and [PRIVATE](#private-channel)
name | String | The name of the channel

## Get Channels
```shell
curl --location --request GET '{{channels_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns a channel page HAL resource:

```json
{
  "_embedded": {
    "channels": [
      {
        "id": 1,
        "type": "OPEN",
        "name": "Open Chat",
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/1"
          },
          "messages": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/1/messages"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1"
          }
        }
      },
      {
        "id": 2,
        "type": "PUBLIC",
        "name": "Public Chat",
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/2"
          },
          "messages": {
            "href": "https://staging-api.chatkitty.com/v1/applications/2/channels/2/messages"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1"
          }
        }
      }
    ]
  },
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels?page=0&size=20"
    }
  },
  "page": {
    "size": 20,
    "totalElements": 2,
    "totalPages": 1,
    "number": 0
  }
}
```

This endpoint returns a channel [page](#pagination) resource.

### HTTP Request
`GET {{channels_link}}`

## Get a Channel
```shell
curl --location --request GET '{{channel_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns a channel HAL resource:

```json
{
  "id": 1,
  "type": "OPEN",
  "name": "Open Chat",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/1"
    },
    "messages": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/1/messages"
    },
    "application": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint returns a channel resource.

### HTTP Request
`GET {{channel_link}}`

## Delete a Channel
```shell
curl --location --request DELETE '{{channel_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns your application's HAL resource:

```json
{
  "id": 1,
  "name": "ChatKitty Application",
  "key": "107a326f-bfab-4d2c-9a5a-fa79bd896929",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1"
    },
    "users": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users"
    },
    "channels": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels"
    }
  }
}
```

This endpoint deletes a channel.

### HTTP Request
`DELETE {{channel_link}}`

# Message
[Users](#user) send messages through your application and administrators can send messages through the Platform API. 

There are four types of messages; [Text Messages](#text-message), [File Messages](#file-message), 
[System Text Messages](#system-text-message), and [System File Messages](#system-file-message).

## Text Message
Users can send text messages containing a unicode text body. These messages can contain emojis and other unicode characters
 but have no file attachments.
 
 <aside class="notice">
  Text messages cannot be sent using the Platform API.
 </aside>

## File Message
Users can send files messages with one, or many file attachments.

<aside class="notice">
 File messages cannot be sent using the Platform API.
</aside>

## System Text Message
Administrators can send text messages containing a unicode text body. These messages can contain emojis and other unicode characters
 but have no file attachments.
 
<aside class="notice">
 System text messages can only be sent using the Platform API.
</aside>

## System File Message
Administrators can send files messages with one, or many file attachments.

<aside class="notice">
 System file messages can only be sent using the Platform API.
</aside>

## Properties
Name | Type | Description 
--------- | ----------- | -----------
id | Long | __Optional:__ 64 bit integer identifier associated with this message. __Present if__ this message is persistent.
type | Enum | The type of this message. __Possible values__ are [TEXT](#text-message), [FILE](#file-message), [SYSTEM_TEXT](#system-text-message), and [SYSTEM_FILE](#system-file-message)
body | String | __Optional:__ Text body of this message. __Present if__ this is a [text message](#text-message) or [system text message](#system-text-message).

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#message) | [GET](#get-a-message), [DELETE](#delete-a-message) | __Optional:__ Self link to this message. __Present if__ this message is persistent.
[channel](#channel) | [GET](#get-a-channel) | Link to channel this message was sent in.
[user](#user) | [GET](#get-a-user) | __Optional:__ Link to the user who sent this message. __Present if__ this is a [text message](#text-message) or [file message](#file-message).
[application](#application) | [GET](#get-application) | Link to your application resource. 

## Create a Message
```shell
curl --location --request POST '{{messages_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}' \
--data-raw '{
    "name": "Hello world!"
}'
```

> The command above returns a message HAL resource:

```json
{
  "id": 1,
  "type": "SYSTEM_TEXT",
  "body": "Hello world!",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/messages/1"
    },
    "channel": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/2"
    },
    "application": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint creates a new message.

### HTTP Request
`POST {{messages_link}}`

### Request Body (JSON)
Parameter | Type | Description 
--------- | ----------- | -----------
body | String | The text body of the message

## Get Messages
```shell
curl --location --request GET '{{messages_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns a message page HAL resource:

```json
{
  "_embedded": {
    "messages": [
      {
        "id": 2,
        "type": "TEXT",
        "body": "Hello from client!",
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/messages/2"
          },
          "user": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1"
          },
          "channel": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/2"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1"
          }
        }
      },
      {
        "id": 1,
        "type": "SYSTEM_TEXT",
        "body": "Hello world!",
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/messages/1"
          },
          "channel": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/2"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1"
          }
        }
      }
    ]
  },
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/2/messages?start=8184870605946882&size=20&relation=SELF"
    }
  },
  "page": {
    "size": 2
  }
}
```

This endpoint returns a message [page](#pagination) resource.

### HTTP Request
`GET {{messages_link}}`

## Get a Message
```shell
curl --location --request GET '{{message_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns a message HAL resource:

```json
{
  "id": 1,
  "type": "SYSTEM_TEXT",
  "body": "Hello world!",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/messages/1"
    },
    "channel": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/2"
    },
    "application": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint returns a message resource.

### HTTP Request
`GET {{message_link}}`

## Delete a Message
```shell
curl --location --request DELETE '{message_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns the message channel's HAL resource:

```json
{
  "id": 2,
  "type": "PUBLIC",
  "name": "Public Chat",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels/2"
    },
    "messages": {
      "href": "https://staging-api.chatkitty.com/v1/applications/2/channels/2/messages"
    },
    "application": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint deletes a message.

### HTTP Request
`DELETE {{message_link}}`

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
[self](#user) | [GET](#get-a-user), [DELETE](#delete-a-user) | Self link to this user.
[channels](#channel) | [GET](#get-channels) | Channels this user has access to - meaning the user has joined or can join. 
[application](#application) | [GET](#get-application) | Link to your application resource. 

## Create a User
```shell
curl --location --request POST '{{users_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}' \
--data-raw '{
    "name": "37282832193"
}'
```

> The command above returns a user HAL resource:

```json
{
  "id": 1,
  "name": "37282832193",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1"
    },
    "channels": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1/channels"
    },
    "application": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint creates a new ChatKitty user.

### HTTP Request
`POST {{users_link}}`

### Request Body (JSON)
Parameter | Type | Description 
--------- | ----------- | -----------
name | String | The unique name of the user.

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
        "id": 1,
        "name": "1017562554",
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1"
          },
          "channels": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1/channels"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1"
          }
        }
      },
      {
        "id": 2,
        "name": "102746681",
        "_links": {
          "self": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/2"
          },
          "channels": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1/users/2/channels"
          },
          "application": {
            "href": "https://staging-api.chatkitty.com/v1/applications/1"
          }
        }
      }
    ]
  },
  "_links": {
    "first": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users?page=0&size=2"
    },
    "prev": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users?page=0&size=2"
    },
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users?page=1&size=2"
    },
    "next": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users?page=2&size=2"
    },
    "last": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users?page=2&size=2"
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

This endpoint returns a user [page](#pagination) resource.

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
  "id": 1,
  "name": "1017562554",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1"
    },
    "channels": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users/1/channels"
    },
    "application": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint returns a resource representing a ChatKitty user.

### HTTP Request
`GET {{user_link}}`

## Delete a User
```shell
curl --location --request DELETE '{{user_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

> The command above returns your application's HAL resource:

```json
{
  "id": 1,
  "name": "ChatKitty Application",
  "key": "107a326f-bfab-4d2c-9a5a-fa79bd896929",
  "_links": {
    "self": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1"
    },
    "users": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/users"
    },
    "channels": {
      "href": "https://staging-api.chatkitty.com/v1/applications/1/channels"
    }
  }
}
```

This endpoint deletes a ChatKitty user.

### HTTP Request
`DELETE {{user_link}}`
