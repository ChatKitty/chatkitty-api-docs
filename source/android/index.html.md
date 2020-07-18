---
title: Android SDK Documentation

language_tabs:
  - java

toc_footers:
  - <a href='https://www.chatkitty.com'>&copy; ChatKitty 2020. All rights reserved</a>

search: true

code_clipboard: true
---
# Introduction
Integrate **real-time chat** into your Android application with the ChatKitty SDK for Android.   

# Authentication

**Initialize the Chat SDK with your API key**  
> Get a ChatKitty instance with your application API key

```java
ChatKitty kitty = ChatKitty.getInstance(CHATKITTY_API_KEY);
```

Get a `ChatKitty` instance by passing your application's API key to the `ChatKitty.getInstance(String)` method as a parameter.

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

```java
kitty.startSession(CHATKITTY_USERNAME, CHATKITTY_CHALLENGE_TOKEN, new ChatKittyCallback<SessionStartResult>() {
  @Override
  public void onSuccess(SessionStartResult result) {
    CurrentUser user = result.getCurrentUser();

    // Handle user
  }
    
  @Override
  public void onCancel() {
    // Handle request cancellation
  }

  @Override
  public void onError(ChatKittyException error) {
    // Handle error
  }
});
```

Create a challenge token for a user server-side using the **Platform API**. You can then begin a user session by calling the 
`ChatKitty.startSession(String, String, ChatKittyCallback<SessionStartResult>)` method with your user's unique name and challenge token.

<aside class="notice">
 You should store user challenge tokens securely to your persistent storage. <br>
 When a user logs into your client application, load the user's username and challenge token from storage 
 and use them to start a user session. 
</aside>

### Begin a user session with a user name (Guest user session)  
> Starting a guest user session

```java
kitty.startSession(CHATKITTY_USERNAME, new ChatKittyCallback<SessionStartResult>() {
  @Override
  public void onSuccess(SessionStartResult result) {
    CurrentUser user = result.getCurrentUser();

    // Handle user
  }
    
  @Override
  public void onCancel() {
    // Handle request cancellation
  }

  @Override
  public void onError(ChatKittyException error) {
    // Handle error
  }
});
```

If your application has the **guest user** feature enabled, you can begin a user session by calling the 
`ChatKitty.startSession(String, ChatKittyCallback<SessionStartResult>)` method with your user's unique name.

<aside class="notice">
 Guest users are appropriate when your application in development, if your application supports anonymous chat, or if you don't have back-end authentication.
</aside>

<aside class="success">
  Go to the <a href="#callbacks">Callbacks</a> page to learn more about ChatKitty callbacks.
</aside>

# Current User
> Get the current user

```java
kitty.getCurrentUser(new ChatKittyCallback<GetCurrentUserResult>() {
  @Override
  public void onSuccess(GetCurrentUserResult result) {
    CurrentUser user = result.getCurrentUser();

    // Handle user
  }
    
  @Override
  public void onCancel() {
    // Handle request cancellation
  }

  @Override
  public void onError(ChatKittyException error) {
    // Handle error
  }
});
```
After starting a ChatKitty [user session](#begin-a-user-session), you can request the current user 
anytime by calling the `ChatKitty.getCurrentUser(ChatKittyCallback<GetCurrentUserResult>)` method.

# Channels
Channels are the backbone of the ChatKitty chat experience. Users can join channels and receive 
or send messages. ChatKitty broadcasts messages created in channels to **channel members** with active 
**chat sessions** and sends **push notifications** to offline members.

## Channel Types

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

```java
kitty.getChannels(new ChatKittyCallback<GetChannelsResult>() {
  @Override
  public void onSuccess(GetChannelsResult result) {
    PageIterator<Channel> iterator = result.iterator();

    while(iterator.hasNext()) {
      Channel channel = iterator.next();
            
      // Handle channel
    }
  }
    
  @Override
  public void onCancel() {
    // Handle request cancellation
  }

  @Override
  public void onError(ChatKittyException error) {
    // Handle error
  }
});
```

You can get channels the current user has joined or can join by calling the `ChatKitty.getChannels(ChatKittyCallback<GetChannelsResult>)` method.

## Listen to channel events
When an event involving a channel happens, like a message sent in the channel or a user joining the channel, 
a `ChannelEvent` is sent to registered `ChannelEventListener`s.

### Registering a channel event listener
> Register a channel event listener

```java
ChannelEventListenerRegistration registration = kitty.registerChannelEventListener(channel, new ChannelEventListener() {
  @Override
  public void onMessageReceived(MessageReceivedEvent event) { 
    Message message = event.getMessage();
    
    // Handle message
  }
});
```

Register a `ChannelEventListener` by calling the `ChatKitty.registerChannelEventListener(Channel, ChannelEventListener)` method. 
This method returns a `ChannelEventListenerRegistration` object.

### Deregistering a channel event listener
> Deregister a channel event listener

```java
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

```java
kitty.getChannelMessages(channel, new ChatKittyCallback<GetMessagesResult>() {
  @Override
  public void onSuccess(GetMessagesResult result) {
    PageIterator<Message> iterator = result.iterator();

    while(iterator.hasNext()) {
      Message messages = iterator.next();
            
      // Handle messages
    }
  }
    
  @Override
  public void onCancel() {
    // Handle request cancellation
  }

  @Override
  public void onError(ChatKittyException error) {
    // Handle error
  }
});
```

You can get messages in a [channel](#channels) by calling the `ChatKitty.getChannelMessages(Channel, ChatKittyCallback<GetMessagesResult>)` method.

## Send a message
> Send a message to a channel

```java
kitty.sendChannelMessage(channel, 
  new CreateTextMessageRequest("Hello world!"), 
  new ChatKittyCallback<CreateMessageResult>() {
    @Override
    public void onSuccess(CreateMessageResult result) {
      Message message = result.getMessage();
  
      // Handle message
    }
      
    @Override
    public void onCancel() {
      // Handle request cancellation
    }
  
    @Override
    public void onError(ChatKittyException error) {
      // Handle error
    }
});
```

You can send a message to a [channel](#channels) by calling the `ChatKitty.sendChannelMessage(Channel, CreateMessageRequest, ChatKittyCallback<CreateMessageResult>)` method.
