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
Integrate real-time chat into your Android application with the ChatKitty SDK for Android. The Android SDK handles 
integrating chat features from your ChatKitty application with your Android client app.   

# Authentication

**Initialize the Chat SDK with your API key**  
> Get a ChatKitty instance with your application API key

```java
ChatKitty kitty = ChatKitty.getInstance(CHATKITTY_API_KEY);
```

Get a `ChatKitty` instance by passing your application's API key to the `ChatKitty.getInstance(String)` method as a parameter.

## Begin a user session
To make calls to ChatKitty through the Chat SDK, a user session must be initiated.

You can initiate a user session using the [unique username](/platform#properties-6) of a user, or 
with the user's name and a **challenge code** if the user isn't a guest.

<aside class="notice">
 A username must be unique within a ChatKitty application.<br/>
 We recommend you use as a hashed email address or phone number as your ChatKitty usernames.
</aside>

**Begin a user session with a user name (Guest user session)**  
> Starting a guest user session

```java
kitty.startSession(CHATKITTY_USERNAME, new ChatKittyCallback<SessionStartResult>() {
    @Override
    public void onSuccess(SessionStartResult result) {
        // Handle result
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
        // Handle result
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
or send messages. ChatKitty broadcasts messages created in channels to **channel members** via 
a **chat session** or **push notifications**.

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

```java
kitty.getChannels(new ChatKittyCallback<GetChannelsResult>() {
    @Override
    public void onSuccess(GetChannelsResult result) {
        PageIterator<Channel> iterator = result.iterator;

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
        PageIterator<Message> iterator = result.iterator;

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
