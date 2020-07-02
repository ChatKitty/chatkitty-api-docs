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

# Authentication

**Initialize the Chat SDK with your API key**  
> Get a ChatKitty instance with your application API key

```javascript
let kitty = ChatKitty.getInstance(CHATKITTY_API_KEY);
```

Get a `ChatKitty` instance by passing your application's API key to the `ChatKitty.getInstance(String)` method as a parameter.

## Begin a user session
To make calls to ChatKitty through the Chat SDK, a user session must be initiated.

You can initiate a user session using the [unique username](/platform#properties-6) of a user, or 
using a username and a **challenge code** if the user isn't a guest.

<aside class="notice">
 A username must be unique within a ChatKitty application.<br/>
 We recommend you use as a hashed email address or phone number as your ChatKitty usernames.
</aside>

### Begin a user session with a user name (Guest user session)  
> Starting a guest user session

```javascript
kitty.startSession(CHATKITTY_USERNAME, function(result) {
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

If your application has the **guest user** feature enabled, you can begin a user session by calling the 
`ChatKitty.startSession(String, function)` method with your user's unique name.

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
After starting a ChatKitty [user session](#begin-a-user-session), you can request the current user 
anytime by calling the `ChatKitty.getCurrentUser(function)` method.

# Channels
Channels are the backbone of the ChatKitty chat experience. Users can join channels and receive 
or send messages. ChatKitty broadcasts messages created in channels to **channel members** with active 
**chat sessions** and sends **push notifications** to offline members.

## Channel Types

There are three types of channels;

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

## Get channels
> Get channels accessible by the current user

```javascript
kitty.getChannels(function(result) {
  if (result.isSuccess) {
    let iterator = result.iterator();

    while (iterator.hasNext()) {
      let channel = iterator.next();

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

You can get channels the current user has joined or can join by calling the `ChatKitty.getChannels(function)` method.

## Listen to channel events
When an event involving a channel happens, like a message sent in the channel or a user joining the channel, 
a `ChannelEvent` is sent to registered channel event listeners.

### Registering a channel event listener
> Register a channel event listener

```javascript
let registration = kitty.registerChannelEventListener(channel, 'message.received', function(event) {
  let message = event.message;

  // Handle message
});
```

Register a channel event listener by calling the `ChatKitty.registerChannelEventListener(Channel, String, function)` method.
The `String` passed is the [type](#channel-event-types) of event the passed-in function handles.  
This method returns a `ChannelEventListenerRegistration` object.

#### Channel Event Types
Type | Description 
---- | -----------
`message.received` | Fired when the device receives a sent message.

### Deregistering a channel event listener
> Deregister a channel event listener

```javascript
registration.deregister(); // ChannelEventListenerRegistration
```

Deregister a `ChannelEventListener` by calling the `ChannelEventListenerRegistration.deregister()` method on 
`ChannelEventListenerRegistration` object returned from registering the event listener.

# Messages
Users send messages through your application and administrators can send messages through the Platform API. 

## Messages Types
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
kitty.getMessages(function(result) {
  if (result.isSuccess) {
    let iterator = result.iterator();

    while (iterator.hasNext()) {
      let message = iterator.next();

      // Handle message
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
