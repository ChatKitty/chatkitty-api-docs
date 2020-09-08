---
title: Platform API Documentation

language_tabs:
  - shell
  - http

toc_footers:
  - <a href='https://www.chatkitty.com'>&copy; ChatKitty 2020. All rights reserved</a>

includes:
  - platform_files
  - platform_errors

search: true

code_clipboard: true
---
# Introduction
The Platform API provides a RESTful interface for administrators and server-side back-ends to manage
their ChatKitty applications. 

<aside class="success">
ChatKitty provides an <a href="https://api.chatkitty.com/v1/explorer/index.html#hkey0=Content-Type&hval0=application/json&uri=/v1/applications/me">API Explorer</a> to
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

```http
GET / HTTP/1.1
Host: {{users_link}}
Content-Type: application/json
Authorization: {{access_token}}
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

# V1 API
The following describes endpoints and resources exposed by the V1 ChatKitty API.

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#v1-api) | [GET](#v1-api-get-api-root) | Self link to the V1 API. 
[application](#application) | [GET](#application-get-application) | The ChatKitty application currently authenticated.

## Get API Root
```shell
curl --location --request GET 'https://api.chatkitty.com/v1' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: https://api.chatkitty.com/v1
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns a HAL resource with links to top-level ChatKitty resources:

```json
{
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1"
    },
    "application": {
      "href": "https://api.chatkitty.com/v1/applications/me"
    }
  }
}
```

This endpoint returns the root of your ChatKitty application graph. 

### HTTP Request
`GET https://api.chatkitty.com/v1`

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
[self](#application) | [GET](#application-get-application) | Self link to this application. 
[users](#user) | [POST](#user-create-a-user), [GET](#user-get-users) | Users belonging to this application.
[channels](#channel) | [POST](#channel-create-a-channel), [GET](#channel-get-channels) | Channels belonging to this application.
[messages](#message) | [POST](#message-create-a-message), [GET](#message-get-messages) | Messages belonging to this application.
[pushNotificationCredentials](#push-notification-credentials) | POST, [GET](#push-notification-credentials-get-credentials) | Push Notification Credentials belonging to this application.

## Templated HAL links
Link | Methods | Description
--------- | ----------- | -----------
[find:users](#user) | [GET](#user-get-users) | Finds users belonging to this application. Supports searching users by __username__.
[find:channels](#channel) | [GET](#channel-get-channels) | Finds channels belonging to this application. Supports searching channels by __member usernames__ and filtering by __direct channels__.

## Get Application
```shell
curl --location --request GET '{{application_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: {{application_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns an application HAL resource:

```json
{
  "id": 1,
  "name": "ChatKitty Application",
  "key": "107a326f-bfab-4d2c-9a5a-fa79bd896929",
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1"
    },
    "users": {
      "href": "https://api.chatkitty.com/v1/applications/1/users"
    },
    "channels": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels"
    },
    "messages": {
      "href": "https://api.chatkitty.com/v1/applications/1/messages"
    },
    "pushNotificationCredentials": {
      "href": "https://api.chatkitty.com/v1/applications/1/push_notification_credentials"
    },
    "find:users": {
      "href": "https://api.chatkitty.com/v1/applications/1/users{?page,size,name}",
      "templated": true
    },
    "find:channels": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels{?page,size,direct,members}",
      "templated": true
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

There are four types of channels; [Open Channels](#channel-open-channel), [Public Channels](#channel-public-channel), [Private Channels](#channel-private-channel), 
and [Direct Channels](#channel-direct-channel). 

Public, private and direct channels require users to join the channel before they can send or receive messages from the channels. 
These channels are known as **Group Channels** 

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

## Direct Channel
Direct channels let users have private conversations between **up to 9** other users.
New users cannot be added to a direct channel and there can only exist one direct channel between a set of users.

## Properties
Name | Type | Description 
--------- | ----------- | -----------
id | Long | 64 bit integer identifier associated with this channel 
type | Enum | The type of this channel. __Possible values__ are [OPEN](#channel-open-channel), [PUBLIC](#channel-public-channel), [PRIVATE](#channel-private-channel), and [DIRECT](#channel-direct-channel)
name | String | The name of this channel

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#channel) | [GET](#channel-get-a-channel), [DELETE](#channel-delete-a-channel) | Self link to this channel.
[messages](#message) | [POST](#message-create-a-message), [GET](#message-get-messages) | Messages sent in this channel. 
[application](#application) | [GET](#application-get-application) | Link to your application resource. 

### Group Channel HAL links
Link | Methods | Description
--------- | ----------- | -----------
[members](#user) | [POST](#channel-add-a-channel-member), [GET](#channel-get-channel-members) | Users that are members of this channel.

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

```http
POST / HTTP/1.1
Host: {{channels_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}

{
    "type": "OPEN",
    "name": "Open Chat"
}
```

> The command above returns a channel HAL resource:

```json
{
  "id": 1,
  "type": "OPEN",
  "name": "Open Chat",
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/1"
    },
    "messages": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/1/messages"
    },
    "application": {
      "href": "https://api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint creates a new channel.

### HTTP Request
`POST {{channels_link}}`

### Request Parameters
Parameter | Type | Description 
--------- | ----------- | -----------
type | Enum | The type of the channel. __Possible values__ are [OPEN](#channel-open-channel), [PUBLIC](#channel-public-channel), [PRIVATE](#channel-private-channel), and [DIRECT](#channel-direct-channel).

#### Open Channel Parameters
Parameter | Type | Description
--------- | ----------- | -----------
name | String | __Optional:__ The name of the channel.

#### Public Channel Parameters
Parameter | Type | Description 
--------- | ----------- | -----------
name | String | __Optional:__ The name of the channel.

#### Private Channel Parameters
Parameter | Type | Description
--------- | ----------- | -----------
name | String | __Optional:__ The name of the channel.

#### Direct Channel Parameters
Parameter | Type | Description
--------- | ----------- | -----------
members | Link Array | Self links of the members of this channel. The same direct channel is always returned for the same set of members.

## Get Channels
```shell
curl --location --request GET '{{channels_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: {{channels_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
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
            "href": "https://api.chatkitty.com/v1/applications/1/channels/1"
          },
          "messages": {
            "href": "https://api.chatkitty.com/v1/applications/1/channels/1/messages"
          },
          "application": {
            "href": "https://api.chatkitty.com/v1/applications/1"
          }
        }
      },
      {
        "id": 2,
        "type": "PUBLIC",
        "name": "Public Chat",
        "_links": {
          "self": {
            "href": "https://api.chatkitty.com/v1/applications/1/channels/2"
          },
          "messages": {
            "href": "https://api.chatkitty.com/v1/applications/1/channels/2/messages"
          },
          "application": {
            "href": "https://api.chatkitty.com/v1/applications/1"
          }
        }
      }
    ]
  },
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels?page=0&size=20"
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

```http
GET / HTTP/1.1
Host: {{channel_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns a channel HAL resource:

```json
{
  "id": 1,
  "type": "OPEN",
  "name": "Open Chat",
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/1"
    },
    "messages": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/1/messages"
    },
    "application": {
      "href": "https://api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint returns a channel resource.

### HTTP Request
`GET {{channel_link}}`

## Add a Channel Member
```shell
curl --location --request POST '{{channel_members_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}' \
--data-raw '{
    "href": "{{user_link}}"
}'
```

```http
POST / HTTP/1.1
Host: {{channel_members_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}

{
    "href": "{{user_link}}"
}
```

> The command above returns a channel HAL resource:

```json
{
  "id": 2,
  "type": "PUBLIC",
  "name": "Public Chat",
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/2"
    },
    "messages": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/2/messages"
    },
    "application": {
      "href": "https://api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint adds a new member to a channel.

### HTTP Request
`POST {{channel_members_link}}`

### Request Parameters
Parameter | Type | Description 
--------- | ----------- | -----------
href | String | The link href of the user to be added as a member

## Get Channel Members
```shell
curl --location --request GET '{{channel_members_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: {{channel_members_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns a page of channel members:

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
      "href": "https://api.chatkitty.com/v1/applications/1/group_channels/2/members?page=0&size=2"
    },
    "prev": {
      "href": "https://api.chatkitty.com/v1/applications/1/group_channels/2/members?page=0&size=2"
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

This endpoint returns a user [page](#pagination) resource of channel members.

### HTTP Request
`GET {{channel_members_link}}`

## Delete a Channel
```shell
curl --location --request DELETE '{{channel_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
DELETE / HTTP/1.1
Host: {{channel_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns your application's HAL resource:

```json
{
  "id": 1,
  "name": "ChatKitty Application",
  "key": "107a326f-bfab-4d2c-9a5a-fa79bd896929",
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1"
    },
    "users": {
      "href": "https://api.chatkitty.com/v1/applications/1/users"
    },
    "channels": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels"
    },
    "messages": {
      "href": "https://api.chatkitty.com/v1/applications/1/messages"
    },
    "pushNotificationCredentials": {
      "href": "https://api.chatkitty.com/v1/applications/1/push_notification_credentials"
    },
    "find:users": {
      "href": "https://api.chatkitty.com/v1/applications/1/users{?page,size,name}",
      "templated": true
    },
    "find:channels": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels{?page,size,direct,members}",
      "templated": true
    }
  }
}
```

This endpoint deletes a channel.

### HTTP Request
`DELETE {{channel_link}}`

# Message
[Users](#user) send messages through your application and administrators can send messages through the Platform API. 

There are four types of messages; [Text Messages](#message-text-message), [File Messages](#message-file-message), 
[System Text Messages](#message-system-text-message), and [System File Messages](#message-system-file-message).

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
type | Enum | The type of this message. __Possible values__ are [TEXT](#message-text-message), [FILE](#message-file-message), [SYSTEM_TEXT](#message-system-text-message), and [SYSTEM_FILE](#message-system-file-message)
createdTime | String | ISO 8601 instant when this message was created

### Text Message Properties
Name | Type | Description 
--------- | ----------- | -----------
body | String | Text body of this message.

### File Message Properties
Name | Type | Description 
--------- | ----------- | -----------
file | File Properties | [Properties](#files-properties) of the file attached to this message.

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#message) | [GET](#message-get-a-message), [DELETE](#message-delete-a-message) | __Optional:__ Self link to this message. __Present if__ this message is persistent.
[channel](#channel) | [GET](#channel-get-a-channel) | Link to channel this message was sent in.
[application](#application) | [GET](#application-get-application) | Link to your application resource. 

### Text Message and File Message HAL links
Link | Methods | Description
--------- | ----------- | -----------
[user](#user) | [GET](#user-get-a-user) | Link to the user who sent this message.

## Create a Message

> This creates a new system text message:

```shell
curl --location --request POST '{{messages_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}' \
--data-raw '{
    "type": "TEXT",
    "body": "Hello world!"
}'
```

```http
POST / HTTP/1.1
Host: {{messages_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}

{
    "type": "TEXT",
    "body": "Hello world!"
}
```

> The command above returns a text message HAL resource:

```json
{
  "id": 1,
  "type": "SYSTEM_TEXT",
  "body": "Hello world!",
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1/messages/1"
    },
    "channel": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/2"
    },
    "application": {
      "href": "https://api.chatkitty.com/v1/applications/1"
    }
  }
}
```
This endpoint creates a new message.

### HTTP Request
`POST {{messages_link}}`

### Request Parameters
Parameter | Type | Description 
--------- | ----------- | -----------
type | Enum | The type of message. __Possible values__ are [TEXT](#message-text-message) and [FILE](#message-file-message)

#### System Text Message Parameters
Parameter | Type | Description 
--------- | ----------- | -----------
body | String | The text body of the message

#### System File Upload Message Parameters

> To upload a system file message:

```shell
curl --location --request POST '{{messages_link}}' \
--header 'Content-Type: multipart/form-data' \
--header 'Authorization: Bearer {{access_token}}' \
--form 'file=@./files/message_file.png' \
--form 'groupTag=my_file_message_group_tag'
```

```http
POST / HTTP/1.1
Host: {{messages_link}}
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
Authorization: Bearer {{access_token}}

----WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="file"; filename="./files/message_file.png"
Content-Type: image/png

(data)
----WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="groupTag"

my_file_message_group_tag
----WebKitFormBoundary7MA4YWxkTrZu0gW
```
Parameter | Type | Description 
--------- | ----------- | -----------
file | File | Multipart file to be [uploaded](#files-file-uploads).
groupTag | String | __Optional:__ Tag to group file message by (like an album name). __Present if__ this file message is part of a file message group.

#### System External File Message Parameters

> This creates a new system external file message:

```shell
curl --location --request POST ''{{messages_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}' \
--data-raw '{
    "type": "FILE",
    "file": {
        "url": "https://www.chatkitty.com/images/logo.png",
        "name": "ChatKitty Logo",
        "contentType": "image/png",
        "size": 5393
    },
    "groupTag": "my_file_message_group_tag"
}'
```

```http
POST / HTTP/1.1
Host: {{channels_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}

{
    "type": "FILE",
    "file": {
        "url": "https://www.chatkitty.com/images/logo.png",
        "name": "ChatKitty Logo",
        "contentType": "image/png",
        "size": 5393
    },
    "groupTag": "my_file_message_group_tag"
}

```
Parameter | Type | Description 
--------- | ----------- | -----------
file | File | [External](#files-external-files) file parameters.
groupTag | String | __Optional:__ Tag to group file message by (like an album name). __Present if__ this file message is part of a file message group.

## Get Messages
```shell
curl --location --request GET '{{messages_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: {{messages_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
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
            "href": "https://api.chatkitty.com/v1/applications/1/messages/2"
          },
          "user": {
            "href": "https://api.chatkitty.com/v1/applications/1/users/1"
          },
          "channel": {
            "href": "https://api.chatkitty.com/v1/applications/1/channels/2"
          },
          "application": {
            "href": "https://api.chatkitty.com/v1/applications/1"
          }
        }
      },
      {
        "id": 1,
        "type": "SYSTEM_TEXT",
        "body": "Hello world!",
        "_links": {
          "self": {
            "href": "https://api.chatkitty.com/v1/applications/1/messages/1"
          },
          "channel": {
            "href": "https://api.chatkitty.com/v1/applications/1/channels/2"
          },
          "application": {
            "href": "https://api.chatkitty.com/v1/applications/1"
          }
        }
      }
    ]
  },
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/2/messages?start=8184870605946882&size=20&relation=SELF"
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

```http
GET / HTTP/1.1
Host: {{message_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns a message HAL resource:

```json
{
  "id": 1,
  "type": "SYSTEM_TEXT",
  "body": "Hello world!",
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1/messages/1"
    },
    "channel": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/2"
    },
    "application": {
      "href": "https://api.chatkitty.com/v1/applications/1"
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

```http
DELETE / HTTP/1.1
Host: {{message_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns the message channel's HAL resource:

```json
{
  "id": 2,
  "type": "PUBLIC",
  "name": "Public Chat",
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/2"
    },
    "messages": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels/2/messages"
    },
    "application": {
      "href": "https://api.chatkitty.com/v1/applications/1"
    }
  }
}
```

This endpoint deletes a message.

### HTTP Request
`DELETE {{message_link}}`

# Push Notification Credentials
Register your [Apple Push Notification service](https://developer.apple.com/go/?id=push-notifications) ([APNs](#push-notification-credentials-apns))
and/or [Firebase Cloud Messaging](https://firebase.google.com/products/cloud-messaging) ([FCM](#push-notification-credentials-fcm))
credentials to begin receiving push notifications from the ChatKitty platform. 

## APNs
Follow the introductions [here](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/establishing_a_certificate-based_connection_to_apns)
to create an APNs certificate for your application.

Once you create your APNs certificate, export it as a P12 file and use it as the **file** property in the **Create APNs Credentials** file upload [POST](#push-notification-credentials-create-apns-credential)
request body.

## FCM
Create a new Firebase Cloud Messaging **Server Key**, from the [Firebase Console](https://console.firebase.google.com/) 
go to **Project settings** > **Cloud Messaging** > **Project credentials** > **Add server key**.

Once you create your Server Key, use it as the **API Key** property in the **Create FCM Credentials** [POST](#push-notification-credentials-create-fcm-credential) 
request body.

## Properties
Name | Type | Description 
--------- | ----------- | -----------
type | Enum | The type of this credentials set. __Possible values__ are [FCM](#push-notification-credentials-fcm), and [APNs](#push-notification-credentials-apns)

### APNs Credential Properties
Name | Type | Description
--------- | ----------- | -----------
certificate | String | The APNs **Public certificate** of this application.
privateKey | String | The APNs **Private key** of this application.
isSandbox | Boolean | Flag indicating if this APNs was issued as a sandbox certificate.

### FCM Credential Properties
Name | Type | Description 
--------- | ----------- | -----------
apiKey | String | The FCM **Server Key** of this application.

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#push-notification-credentials) | [GET](#push-notification-credentials-get-credential), [DELETE](#push-notification-credentials-delete-credential) | Self link to this set of credentials.
[application](#application) | [GET](#application-get-application) | Link to your application resource.

## Create APNs Credential

> This creates a new APNS credential:

```shell
curl --location --request POST '{{push_notification_credentials_link}}' \
--header 'Content-Type: multipart/form-data' \
--header 'Authorization: Bearer {{access_token}}' \
--form 'type=APNS' \
--form 'file=@./files/apns_certificate_file.p12' \
--form 'password=my_apns_certificate_password'
```

```http
POST / HTTP/1.1
Host: {{push_notification_credentials_link}}
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW
Authorization: Bearer {{access_token}}

----WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="type"

APNS
----WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="file"; filename="./files/apns_certificate_file.p12"
Content-Type: application/x-pkcs12

(data)
----WebKitFormBoundary7MA4YWxkTrZu0gW
Content-Disposition: form-data; name="password"

my_apns_certificate_password
----WebKitFormBoundary7MA4YWxkTrZu0gW
```

> The command above returns an APNs push notification credential HAL resource:

```json
{
    "type": "APNS",
    "certificate": "{{your_public_cert}}",
    "privateKey": "{{your_private_key}}",
    "_links": {
        "self": {
            "href": "https://api.chatkitty.com/v1/applications/1/push_notification_credentials/2"
        },
        "application": {
            "href": "https://api.chatkitty.com/v1/applications/1"
        }
    }
}
```
This endpoint [uploads](#files-file-uploads) a new set of APNs credentials.

### HTTP Request
`POST {{push_notification_credentials_link}}`

### File Upload Request Parameters
Parameter | Type | Description 
--------- | ----------- | -----------
type | Enum | The type of this credentials set. Always [APNS](#push-notification-credentials-apns).
file | File | Multipart P12 certificate file to be [uploaded](#files-file-uploads).
password | String | Password set when the APNs P12 certificate file was exported.
isSandbox | Boolean | **Optional:** Flag indicating if this APNs certificate was issued as a sandbox certificate. **Default: false**

## Create FCM Credential

> This creates a new FCM credential:

```shell
curl --location --request POST '{{push_notification_credentials_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}' \
--data-raw '{
    "type": "FCM",
    "apiKey": "{{your_server_key}}"
}'
```

```http
POST / HTTP/1.1
Host: {{push_notification_credentials_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}

{
    "type": "FCM",
    "apiKey": "{{your_server_key}}"
}
```

> The command above returns a FCM push notification credential HAL resource:

```json
{
    "type": "FCM",
    "apiKey": "{{your_server_key}}",
    "_links": {
        "self": {
            "href": "https://api.chatkitty.com/v1/applications/1/push_notification_credentials/1"
        },
        "application": {
            "href": "https://api.chatkitty.com/v1/applications/1"
        }
    }
}
```
This endpoint creates a new set of FCM credentials.

### HTTP Request
`POST {{push_notification_credentials_link}}`

### Request Parameters
Parameter | Type | Description
--------- | ----------- | -----------
type | Enum | The type of this credentials set. Always [FCM](#push-notification-credentials-fcm).
apiKey | String | The FCM **Server Key** of this application.

## Get Credentials
```shell
curl --location --request GET '{{push_notification_credentials_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: {{push_notification_credentials_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns a push notification credentials page HAL resource:

```json
{
    "_embedded": {
        "credentials": [
            {
                "type": "FCM",
                "apiKey": "{{your_server_key}}",
                "_links": {
                    "self": {
                        "href": "https://api.chatkitty.com/v1/applications/1/push_notification_credentials/1"
                    },
                    "application": {
                        "href": "https://api.chatkitty.com/v1/applications/1"
                    }
                }
            },
            {
                "type": "APNS",
                "certificate": "{{your_public_cert}}",
                "privateKey": "{{your_private_key}}",
                "_links": {
                    "self": {
                        "href": "https://api.chatkitty.com/v1/applications/1/push_notification_credentials/2"
                    },
                    "application": {
                        "href": "https://api.chatkitty.com/v1/applications/1"
                    }
                }
            }
        ]
    },
    "_links": {
        "self": {
            "href": "https://api.chatkitty.com/v1/applications/1/push_notification_credentials?page=0&size=20"
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

This endpoint returns a push notification credentials [page](#pagination) resource.

### HTTP Request
`GET {{push_notification_credentials_link}}`

## Get Credential
```shell
curl --location --request GET '{{push_notification_credential_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: {{push_notification_credential_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns a push notification credential HAL resource:

```json
{
    "type": "FCM",
    "apiKey": "{{your_server_key}}",
    "_links": {
        "self": {
            "href": "https://api.chatkitty.com/v1/applications/1/push_notification_credentials/1"
        },
        "application": {
            "href": "https://api.chatkitty.com/v1/applications/1"
        }
    }
}
```

This endpoint returns a push notification credential resource.

### HTTP Request
`GET {{push_notification_credential_link}}`

## Delete Credential
```shell
curl --location --request DELETE '{push_notification_credential_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
DELETE / HTTP/1.1
Host: {{push_notification_credential_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns your application's HAL resource:

```json
{
  "id": 1,
  "name": "ChatKitty Application",
  "key": "107a326f-bfab-4d2c-9a5a-fa79bd896929",
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1"
    },
    "users": {
      "href": "https://api.chatkitty.com/v1/applications/1/users"
    },
    "channels": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels"
    },
    "messages": {
      "href": "https://api.chatkitty.com/v1/applications/1/messages"
    },
    "pushNotificationCredentials": {
      "href": "https://api.chatkitty.com/v1/applications/1/push_notification_credentials"
    },
    "find:users": {
      "href": "https://api.chatkitty.com/v1/applications/1/users{?page,size,name}",
      "templated": true
    },
    "find:channels": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels{?page,size,direct,members}",
      "templated": true
    }
  }
}
```

This endpoint deletes a push notification credential.

### HTTP Request
`DELETE {{push_notification_credential_link}}`

# User
Users can chat with each other by joining channels. They are identified by their own unique user name.

## Properties
Name | Type | Description 
--------- | ----------- | -----------
id | Long | 64 bit integer identifier associated with this user.
name | String | The unique name of the user.
displayName | String | Human readable name of this user that will be shown to other users.
isGuest | Boolean | __Optional__ Included if this user was created as a guest.

## HAL links
Link | Methods | Description
--------- | ----------- | -----------
[self](#user) | [GET](#user-get-a-user), [DELETE](#user-delete-a-user) | Self link to this user.
[channels](#channel) | [GET](#channel-get-channels) | Channels this user has access to - meaning the user has joined or can join. 
tokens | [POST](#user-add-a-user-token), [GET](#user-get-user-tokens) | Challenge tokens used to authenticate this user's sessions client-side. 
[application](#application) | [GET](#application-get-application) | Link to your application resource. 

## Create a User
```shell
curl --location --request POST '{{users_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}' \
--data-raw '{
    "name": "1017562554",
    "displayName": "Jane Doe"
}'
```

```http
POST / HTTP/1.1
Host: {{users_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}

{
    "name": "1017562554",
    "displayName": "Jane Doe"
}
```

> The command above returns a user HAL resource:

```json
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
}
```

This endpoint creates a new ChatKitty user.

### HTTP Request
`POST {{users_link}}`

### Request Parameters
Parameter | Type | Description 
--------- | ----------- | -----------
name | String | The unique name of the user.
displayName | String | Human readable name of this user that will be shown to other users.
isGuest | Boolean | __Optional__ Ture if this user should be created as a guest.

## Get Users
```shell
curl --location --request GET '{{users_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: {{users_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns a user page HAL resource:

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

This endpoint returns a user [page](#pagination) resource.

### HTTP Request
`GET {{users_link}}`

## Get a User
```shell
curl --location --request GET '{{user_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: {{user_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns a user HAL resource:

```json
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
}
```

This endpoint returns a resource representing a ChatKitty user.

### HTTP Request
`GET {{user_link}}`

## Add a User Token
```shell
curl --location --request POST '{{user_tokens_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}' \
--data-raw '{}'
```

```http
POST / HTTP/1.1
Host: {{user_tokens_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}

{}
```

> The command above returns a user token resource:

```json
{
    "token": "1bfd29e7-26f6-4a8e-aa89-45c9bb53f1e4"
}
```

This endpoint adds a new challenge token. The challenge token can be used client-side to authenticate this user.

<aside class="notice">
A <b>maximum of 10</b> challenge tokens can exists for a user.
</aside>

### HTTP Request
`POST {{user_tokens_link}}`

## Get User Tokens
```shell
curl --location --request GET '{{user_tokens_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
GET / HTTP/1.1
Host: {{user_tokens_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns a page of user challenge tokens:

```json
{
    "_embedded": {
        "tokens": [
            {
                "token": "1bfd29e7-26f6-4a8e-aa89-45c9bb53f1e4"
            }
        ]
    },
    "_links": {
        "self": {
            "href": "https://api.chatkitty.com/v1/applications/1/users/1/tokens?page=0&size=20"
        }
    },
    "page": {
        "size": 20,
        "totalElements": 1,
        "totalPages": 1,
        "number": 0
    }
}
```

This endpoint returns a user challenge token [page](#pagination) resource.

### HTTP Request
`GET {{users_link}}`

## Update a User
```shell
curl --location --request PUT '{{user_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}' \
--data-raw '{
    "id": 1,
    "name": "1017562554",
    "displayName": "Jane Anne Doe",
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
}'
```

```http
PUT / HTTP/1.1
Host: {{users_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}

{
    "id": 1,
    "name": "1017562554",
    "displayName": "Jane Anne Doe",
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
}
```

> The command above returns a user HAL resource:

```json
{
  "id": 1,
  "name": "1017562554",
  "displayName": "Jane Anne Doe",
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
}
```

This endpoint updates a ChatKitty user.

### HTTP Request
`PUT {{user_link}}`

### Updatable Properties
- displayName
- isGuest

## Delete a User
```shell
curl --location --request DELETE '{{user_link}}' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer {{access_token}}'
```

```http
DELETE / HTTP/1.1
Host: {{user_link}}
Content-Type: application/json
Authorization: Bearer {{access_token}}
```

> The command above returns your application's HAL resource:

```json
{
  "id": 1,
  "name": "ChatKitty Application",
  "key": "107a326f-bfab-4d2c-9a5a-fa79bd896929",
  "_links": {
    "self": {
      "href": "https://api.chatkitty.com/v1/applications/1"
    },
    "users": {
      "href": "https://api.chatkitty.com/v1/applications/1/users"
    },
    "channels": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels"
    },
    "messages": {
      "href": "https://api.chatkitty.com/v1/applications/1/messages"
    },
    "pushNotificationCredentials": {
      "href": "https://api.chatkitty.com/v1/applications/1/push_notification_credentials"
    },
    "find:users": {
      "href": "https://api.chatkitty.com/v1/applications/1/users{?page,size,name}",
      "templated": true
    },
    "find:channels": {
      "href": "https://api.chatkitty.com/v1/applications/1/channels{?page,size,direct,members}",
      "templated": true
    }
  }
}
```

This endpoint deletes a ChatKitty user.

### HTTP Request
`DELETE {{user_link}}`
