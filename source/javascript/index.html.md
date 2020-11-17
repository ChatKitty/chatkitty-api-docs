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
Integrate **real-time chat** into your React Native or Web application with the ChatKitty JavaScript SDK.  

# Installation
ChatKitty is available as an [npm package](https://www.npmjs.com/package/chatkitty).

> Install the ChatKitty npm package with npm...

```shell
npm install chatkitty
```

> ...or with yarn

```shell
yarn add chatkitty
```

# Authentication
**Initialize the Chat SDK with your API key**  
> Get a ChatKitty instance with your API key

```javascript
import ChatKitty from 'chatkitty';

export const kitty = ChatKitty.getInstance(CHATKITTY_APP_ID);
```

Create a `ChatKitty` instance by passing your application's API key to the 
`ChatKitty.getInstance(string)` method as a parameter.

## Starting a user session
To make calls to ChatKitty through the Chat SDK, a user session must be started.

You can start a user session using the unique **username** of a user and optional authentication 
parameters to secure the user session.

<aside class="notice">
 A username must be unique within a ChatKitty application.<br/>
 We recommend you use as a hashed email address or phone number as your ChatKitty usernames.
</aside>

### Starting a user session with a user name and authentication parameters
> Starting a user session

```javascript
let result = await kitty.startSession({
  username: email,
  authParams: { // parameters to pass to authentication chat function
    password: password, 
  },
});

if (result.succeeded) {
  let session = result.session; // Handle session
}

if (result.failed) {
  let error = result.error; // Handle error
}
```

### Begin a user session with just a user name (guest user session)
> Starting a guest user session

```javascript
let result = await kitty.startSession({
  username: email,
});

if (result.succeeded) {
  let session = result.session; // Handle session
}

if (result.failed) {
  let error = result.error; // Handle error
}
```

If your application has the **guest user** feature enabled, you can start a user session by calling the 
`ChatKitty.startSession(StartSessionRequest)` method with only your user's unique name.

<aside class="notice">
 Guest users are appropriate when your application in development, if your application supports anonymous chat, or if you don't need back-end authentication.
</aside>

# Current User
> Get the current user

```javascript
let result = await kitty.getCurrentUser();

let user = result.user; // Handle user
```
After starting a ChatKitty [user session](#authentication-starting-a-user-session), you can request the current user 
anytime by calling the `ChatKitty.getCurrentUser()` method.

## Observing the current user
> Observing the current user changes

```javascript
kitty.onCurrentUserChanged((user) => {
  // handle new current user or current user changes
});
```
Get updates when the current user changes by using the `ChatKitty.onCurrentUserChanged((user: CurrentUser | null) => void)` 
method. 

<aside class="notice">
 The observer function passed to onCurrentUserChanged is called when first registered, with the current user value.
</aside>

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
> Get channels the current user can begin chat sessions in channel

```javascript
kitty.getChannels().then((result) => {
  if (result.succeeded) {
    let channels = result.paginator.items; // Handle channels
  }

  if (result.failed) {
    let error = result.error; // Handle error
  }
});
```

You can get channels the current user can chat in by calling the `ChatKitty.getChannels()` method.

## Get joinable channels
> Get group channels the current user can become a member of

```javascript
kitty.getJoinableChannels().then((result) => {
  if (result.succeeded) {
    let channels = result.paginator.items; // Handle channels
  }

  if (result.failed) {
    let error = result.error; // Handle error
  }
});
```

You can get channels the current user can join, becoming a member, by calling the `ChatKitty.getJoinableChannels()` 
method.

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
