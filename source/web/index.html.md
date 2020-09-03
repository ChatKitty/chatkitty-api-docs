---
title: Web SDK Documentation

language_tabs:
  - javascript

toc_footers:
  - <a href='https://www.chatkitty.com'>&copy; ChatKitty 2020. All rights reserved</a>

search: true

code_clipboard: true
---
# Introduction
Integrate **real-time chat** into your Web application with the ChatKitty SDK for Web.  

# Installation
ChatKitty is available as an [npm package](https://www.npmjs.com/package/chatkitty-sdk-web).

> Install the ChatKitty npm package with npm...

```shell
npm install chatkitty-sdk-web
```

> ...or with yarn

```shell
yarn add chatkitty-sdk-web
```

# Authentication

**Initialize the Chat SDK with your App ID**  
> Get a ChatKitty instance with your application App ID

```javascript
let kitty = new ChatKitty({
                  appID: CHATKITTY_APP_ID,
                });
```

Create a `ChatKitty` instance by passing your application's App ID to the `new ChatKitty(ChatKittyConfiguration)` method as a parameter.

## Begin a user session
To make calls to ChatKitty through the Chat SDK, a user session must be initiated.

You can initiate a user session using the unique **username** of a user and a **challenge token**, or 
using a just username if the user is a guest.

<aside class="notice">
 A username must be unique within a ChatKitty application.<br/>
 We recommend you use as a hashed email address or phone number as your ChatKitty usernames.
</aside>

### Begin a user session with a user name and challenge token  
> Starting a user session

```javascript
kitty.startSession({
          username: CHATKITTY_USERNAME,
          challengeToken: CHATKITTY_CHALLENGE_TOKEN,
          callback: function(result) {
              if (result.isSuccess) {
                let user = result.currentUser;
            
                // Handle user
              }
            
              if (result.isCancelled) {
                // Handle request cancellation
              }
            
              if (result.isError) {
                // Handle error
              }
            }
        });
```

Create a challenge token for a user server-side using the **Platform API**. You can then begin a user session by calling the 
`ChatKitty.startSession(StartSessionParams)` method with your user's unique name and challenge token.

<aside class="notice">
 You should store user challenge tokens securely to your persistent storage. <br>
 When a user logs into your client application, load the user's username and challenge token from storage 
 and use them to start a user session. 
</aside>

### Begin a user session with a user name (guest user session)
> Starting a guest user session

```javascript
kitty.startSession({
          username: CHATKITTY_USERNAME,
          callback: function(result) {
              if (result.isSuccess) {
                let user = result.currentUser;
            
                // Handle user
              }
            
              if (result.isCancelled) {
                // Handle request cancellation
              }
            
              if (result.isError) {
                // Handle error
              }
            }
        });
```

If your application has the **guest user** feature enabled, you can begin a user session by calling the 
`ChatKitty.startSession(StartSessionParams)` method with your user's unique name.

<aside class="notice">
 Guest users are appropriate when your application in development, if your application supports anonymous chat, or if you don't have back-end authentication.
</aside>

# Current User
> Get the current user

```javascript
kitty.getCurrentUser(function(result) {
  if (result.isSuccess) {
    let user = result.currentUser;

    // Handle user
  }

  if (result.isCancelled) {
    // Handle request cancellation
  }

  if (result.isError) {
    // Handle error
  }
});
```
After starting a ChatKitty [user session](#authentication-begin-a-user-session), you can request the current user 
anytime by calling the `ChatKitty.getCurrentUser(function)` method.

## Listen to current user events
When an event involving the current user happens, like joining or exiting a channel, 
a `CurrentUserEvent` is sent to registered channel event listeners.

### Registering a current user event listener
> Register a current user event listener

```javascript
let registration = kitty.registerCurrentUserEventListener(TYPE, function(event) {
      switch (event.type) {
          case "CURRENT_USER.CHANNEL.JOINED":
             let channelJoined = result.channel;
              // Handle channel joined
             break
          case "CURRENT_USER.CHANNEL.LEFT":
             let channelLeft = result.channel;
             // Handle channel joined
             break
          default:
            break
      }
});
```

To beginning listening to current user events, register a current user event listener by calling the `ChatKitty.registerCurrentUserEventListener(String, function)` method.
Where `String` is the **type** of event the function handles.  
This method returns a `CurrentUserEventListenerRegistration` object.

#### Current user event types
Type | Description 
---- | -----------
`CURRENT_USER.CHANNEL.CHANGED_STATUS` | Fired when the current user joins or leaves a channel.

# Push Notifications
ChatKitty Web SDK offers functionality for sending notification messages to your mobile users. 
Currently, the ChatKitty SDK supports registering push notification devices with [React Native](https://reactnative.dev/).

## Push notification types
There are two push notification services that are supported by ChatKitty. 

### Firebase Cloud Messaging
This refers to the Push Notification service for Android devices. 
Documentation for setting up FCM can be founding in our [FCM Setup Gudie](../platform/#push-notification-credentials-fcm) 

### Apple Push Notification Service
This refers to the Push Notification service for iOS devices. 
Documentation for setting up APNs can be founding in our [APNs Setup Gudie](../platform/#push-notification-credentials-apns) 

## Get registered devices
> Get registered devices for the current user

```javascript
kitty.getRegisteredDevices(function(result) {
  if (result.isSuccess) {
    let devices = result.devices
    for (let device of devices) {
       // Handle device
    }
  }

  if (result.isCancelled) {
    // Handle request cancellation
  }

  if (result.isError) {
    // Handle error
  }
});
```

You can get registered devices for the current user by calling the `ChatKitty.getRegisteredDevices(function)` method.

## Register a device
> Register a device 

```javascript
kitty.registerPushNotificationDevice(TYPE, TOKEN, function(result) {
  if (result.isSuccess) {
     // Successfully registered a device
  }

  if (result.isCancelled) {
    // Handle request cancellation
  }

  if (result.isError) {
    // Handle error
  }
});
```

You can register a device by calling the `ChatKitty.registerPushNotificationDevice(string, string, function)` method.

#### Push notification device types
Type | Description 
---- | -----------
`FCM` | Indicates the Firebase Cloud Messaging Service
`APNS` | Indicates the Apple Push Notification Service

## Handling push notification data
> Handling push notification data

```javascript
kitty.handlePushNotificationData(notification.data, function(result) {
  if (result.isSuccess) {
     // Check the type of push notification
     const type = result.type
     // Extract the recipient from the push notification
     const recipient = result.recipient
     // Extract the message from the push notification (if applicable)
     const message = result.message
  }
});
```

You can retrieve data from a push notification by calling the `ChatKitty.handlePushNotificationData(PushNotificationData, function)` method.

#### Push notification types
Type | Description 
---- | -----------
`SYSTEM:SENT:MESSAGE` | Received when an application administrator sends a system message through the platform API. This includes a `message` payload, which is the message resource of the **system message** sent.
`USER:SENT:MESSAGE` | Received when a chat user sends a message client-side. This includes a `message` payload, which is the message resource of the **user message** sent.

## Delete registered devices
> Deleting a registered device 

```javascript
kitty.removeDevice(device, function(result) {
  if (result.isSuccess) {
     // Successfully removed a device
  }

  if (result.isCancelled) {
    // Handle request cancellation
  }

  if (result.isError) {
    // Handle error
  }
});
```

You can remove a push notification device by calling the `ChatKitty.removeDevice(Device, function)` method. 
This will stop sending notifications to the device.

# Channels
Channels are the backbone of the ChatKitty chat experience. Users can join channels and receive 
or send messages. ChatKitty broadcasts messages created in channels to **channel members** with active 
**chat sessions** and sends **push notifications** to offline members.

## Channel types

There are four types of channels;

### Open Channel
Open channels provide Twitch-style chats where many users can join the chat without invites and send 
messages. 

<aside class="notice">
Messages sent in open channels are <b>ephemeral</b> and not persisted by ChatKitty.
</aside>

### Public Channel
Users can join public channels by themselves (like an open chat) or via invites from an existing channel member.
ChatKitty persists messages sent in public channels by default but this behaviour can be configured.

### Private Channel
Users can only join private channels via invites from an existing channel member.
ChatKitty persists messages sent in private channels by default but this behaviour can be configured.

### Direct Channel
Direct channels let users have private conversations between **up to 9** other users.
New users cannot be added to a direct channel and there can only exist one direct channel between a set of users.

## Get channels
> Get channels accessible by the current user

```javascript
kitty.getChannels(function(result) {
  if (result.isSuccess) {
    let channels = result.channel
    for (let channel of channels) {
       // Handle channel
    }
  }

  if (result.isCancelled) {
    // Handle request cancellation
  }

  if (result.isError) {
    // Handle error
  }
});
```

You can get channels the current user has joined by calling the `ChatKitty.getChannels(function)` method.

## Get joinable channels
> Get channels that can be joined by the current user

```javascript
kitty.getJoinableChannels(function(result) {
  if (result.isSuccess) {
    let channels = result.channels
    for (let channel of channels) {
       // Handle channel
    }
  }

  if (result.isCancelled) {
    // Handle request cancellation
  }

  if (result.isError) {
    // Handle error
  }
});
```

You can get channels the current user can join by calling the `ChatKitty.getJoinableChannels(function)` method.

## Get channel members
> Get members of a particular channel

```javascript
kitty.getChannelMembers(channel, function(result) {
  if (result.isSuccess) {
    let members = result.members
    for (let member of members) {
       // Handle member
    }
  }

  if (result.isCancelled) {
    // Handle request cancellation
  }

  if (result.isError) {
    // Handle error
  }
});
```

You can get the members of a channel by calling the `ChatKitty.getChannelMembers(Channel, function)` method.

## Entering a channel
> Entering a channel

```javascript
 let registration = kitty.enterChannel(channel, function(result) {
      if (result.isSuccess) {
        // Listen to channel events. 
      }
    });
```

You must first enter a channel to receive messages and other events related to the channel.

Enter a channel by calling the `ChatKitty.enterChannel(Channel, function)` method. This method returns a `ChannelEnterRegistration` object.

## Listen to channel events
When an event involving a channel happens, like a message sent in the channel or a user joining the channel, 
a `ChannelEvent` is sent to registered channel event listeners.

### Registering a channel event listener
> Register a channel event listener

```javascript
let registration = kitty.registerChannelEventListener(channel, TYPE, function(event) {
      switch (message.type) {
          case "MESSAGE.RECEIVED":
             let message = result.message;
              // Handle message
             break
          case "PARTICIPANT.ENTERED":
             let enteredUser = result.user;
              // Handle user who entered.
             break
          case "PARTICIPANT.EXITED":
              let exitedUser = result.user;
              // Handle user who exited.
             break
          case "KEYSTROKES.CREATED":
             let keystrokeUser = result.user;
             let keys = result.keys;
              // Handle typing indicator for user and keys.
            break
          default:
            break
      }
});
```

To beginning listening to channel events, register a channel event listener by calling the `ChatKitty.registerChannelEventListener(Channel, String, function)` method.
Where `String` is the **type** of event the function handles.  
This method returns a `ChannelEventListenerRegistration` object.

#### Channel event types
Type | Description 
---- | -----------
`MESSAGE.RECEIVED` | Fired when the device receives a sent message.
`PARTICIPANT.CHANGED_STATUS` | Fired when a participant has entered or exited a channel.

#### Group Channel event types
Type | Description
---- | -----------
`MESSAGE.DELIVERY_RECEIPT.CREATED` | Fired when a message has been delivered in a group channel.
`KEYSTROKES.CREATED` | Fired when a participant has started typing characters.

### Deregistering a channel event listener
> Deregister a channel event listener

```javascript
registration.deregister(); // ChannelEventListenerRegistration
```

If you no longer wish to receive events with a channel event listener, deregister it by 
calling the `ChannelEventListenerRegistration.deregister()` method on 
`ChannelEventListenerRegistration` object returned from registering the event listener.

## Creating typing indicators
> Creating typing indicators

```javascript
let keystroke = {
    keys: "abc"
}

kitty.sendChannelKeyStrokes(channel, keystroke, function(event) {
    if (result.isSuccess) {
      // Handle successful keystroke. 
    }

    if (result.isCancelled) {
      // Handle request cancellation
    }

    if (result.isError) {
      // Handle error
    }
})
```

You can send keystrokes to a [channel](#channels) by calling 
the `ChatKitty.sendChannelKeyStrokes(Channel, CreateReplyThreadKeystrokesRequest, function)` method. 

## Exiting a channel
> Exiting a channel

```javascript
registration.exitChannel(); // ChannelEnterRegistration
```

If you no longer wish to receive events related to a channel you must exit the channel. 

Exit a channel by calling the `ChannelEnterRegistration.exitChannel()` method.

# Messages
Users send messages through your application and administrators can send messages through the Platform API. 

## Messages types
There are four types of messages;

### Text Message
Users can send text messages containing a unicode text body. These messages can contain emojis and other unicode characters
 but have no file attachments.

### File Message
Users can send files messages with one, or many file attachments.

### System Text Message
Administrators can send text messages containing a unicode text body. These messages can contain emojis and other unicode characters
 but have no file attachments.
 
<aside class="notice">
 System text messages can only be sent using the Platform API.
</aside>

### System File Message
Administrators can send files messages with one, or many file attachments.

<aside class="notice">
 System file messages can only be sent using the Platform API.
</aside>

## Get messages
> Get messages inside a channel

```javascript
kitty.getChannelMessages(channel, function(result) {
  if (result.isSuccess) {
    let messages = result.messages
    // Array of messages
  }

  if (result.isCancelled) {
    // Handle request cancellation
  }

  if (result.isError) {
    // Handle error
  }
  
  // Pagination
  if (result.next) {
    kitty.getNextMessages(result, function(result) {
      if (result.isSuccess) {
        let nextMessages = result.messages
      }
    });
  }
});
```

You can get messages in a [channel](#channels) by calling the `ChatKitty.getChannelMessages(Channel, function)` method.

## Send a message
> Send a message to a channel

```javascript
kitty.sendChannelMessage(
  channel,
  new CreateTextMessageRequest('Hello world!'),
  function(result) {
    if (result.isSuccess) {
      let message = result.message;

      // Handle message
    }

    if (result.isCancelled) {
      // Handle request cancellation
    }

    if (result.isError) {
      // Handle error
    }
  }
);
```

You can send a message to a [channel](#channels) by calling the `ChatKitty.sendChannelMessage(Channel, CreateMessageRequest, function)` method.

## Message delivery receipts
With message delivery receipts, you can see when messages get delivered on another user's devices.

When a user receives or fetches a message sent by another user for the first time, a delivery receipt is created.

Delivery receipts are automatically created by the ChatKitty platform and this SDK.

<aside class="notice">
 Delivery receipts are only created for messages sent inside <b>group channels</b>.
</aside>

## Get message delivery receipts
> Get delivery receipts for a message

```javascript
kitty.getMessageDeliveryReceipts(
  message,
  function(result) {
    if (result.isSuccess) {
     for (let receipt of result.receipts) {
        let user = receipt.user
     }
    }
  }
);
```

You can get delivery receipts for a [message](#messages) by calling the `ChatKitty.getMessageDeliveryReceipts(Message, function)` method.

## Message read receipts
With message read receipts, you can see when messages are read by other users

When a user reads a message for the first time, a read receipt is created.

<aside class="notice">
 Read receipts are only created for messages sent inside <b>group channels</b>.
</aside>

## Read a message
> Marking a message as read

```javascript
kitty.markMessageRead(
  message,
  function(result) {
    if (result.isSuccess) {
     // Handle success
    }
  }
);
```

You can mark a [message](#messages) as read by calling the `ChatKitty.markMessageRead(Message, function)` method. Mark a message
as read when a message is displayed to the current user.

## Get message read receipts
> Get read receipts for a message

```javascript
kitty.getReadReceipts(
  message,
  function(result) {
    if (result.isSuccess) {
     for (let receipt of result.receipts) {
        let user = receipt.user
     }
    }
  }
);
```

You can get read receipts for a message by calling the `ChatKitty.getMessageReadReceipts(Message, function)` method.