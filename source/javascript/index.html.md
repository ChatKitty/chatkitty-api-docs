---
title: JavaScript SDK Documentation

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

> Install the ChatKitty npm package with yarn...

```shell
yarn add chatkitty
```

> ...or with npm

```shell
npm install chatkitty
```

# Authentication
**Initialize the Chat SDK with your API key**  
> Get a ChatKitty instance with your API key

```javascript
import ChatKitty from 'chatkitty';

export const kitty = ChatKitty.getInstance(CHATKITTY_API_KEY);
```

Create a `ChatKitty` instance by passing your application's API key to the 
`ChatKitty.getInstance(string)` method as a parameter.

## Starting a user session
To make calls to ChatKitty through the Chat SDK, a user session must be **started**. A user session creates 
an open connection to ChatKitty belonging a user throughout the duration of their usage of your application, 
until the user session is **ended**. A user session is **active** from when it was started until it's ended 
by the user, or the session connection is lost.

You can start a user session using the unique **username** of a user and optional authentication 
parameters to secure the user session.

<aside class="notice">
 A username must be unique within a ChatKitty application.<br/>
 We recommend you use hashed email address or phone number as your ChatKitty usernames.
</aside>

<aside class="notice">
 Only one user session can be active at a time for a ChatKitty client instance.
</aside>

### Starting a user session with a username and authentication parameters
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

If you're using [ChatKitty Chat Functions](https://docs.chatkitty.com/platform/#chat-functions), you 
can provide custom authentication logic or proxy user authentication through your backend using a 
**User Attempted Start Session** chat function. The chat function will be passed the username and 
authentication parameters from a `ChatKitty.startSession(StartSessionRequest)` call. Your logic will 
determine if the user is allowed to start a session with their credentials.

### Starting a user session with just a username (guest user session)
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

## Ending a user session
> Ending a user session

```javascript
kitty.endSession();
```

To end a user ChatKitty session, call the `ChatKitty.endSession()` method.

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
let unsubscribe = kitty.onCurrentUserChanged((user) => {
  // handle new current user or current user changes
});

unsubscribe(); // call unsubscribe function when you're no longer interested in current user changes
```
Get updates when the current user changes by using the `ChatKitty.onCurrentUserChanged((user: CurrentUser | null) => void)` 
method. 

<aside class="notice">
 The observer function passed to onCurrentUserChanged is called with the current user value when first registered.
</aside>

## Updating the current user
> Updating the current user

```javascript
await kitty.updateCurrentUser((user) => {
  user.properties = {
    ...user.properties,
    "new-property": newPropertyValue,
  };

  return user;
});
```

Update the current user by using the `ChatKitty.updateCurrentUser((user: CurrentUser) => CurrentUser)` 
method, taking the current user and returning a user with the changes to be applied.

# Channels
Channels are the backbone of the ChatKitty chat experience. Users can join channels and receive 
or send messages. ChatKitty broadcasts messages created in channels to **channel members** with active 
**chat sessions** and sends **push notifications** to offline members.

## Channel types
There are four types of channels;

### Public Channel
Users can join public channels by themselves or via invites from an existing channel member.
ChatKitty persists messages sent in public channels by default but this behaviour can be configured.

### Private Channel
Users can only join private channels via invites from an existing channel member.
ChatKitty persists messages sent in private channels by default but this behaviour can be configured.

### Direct Channel
Direct channels let users have private conversations between **up to 9** other users.
New users cannot be added to a direct channel and there can only exist one direct channel between a set of users.

### Open Channel
Open channels provide Twitch-style chats where many users can join the chat without invites and send 
messages. 

<aside class="notice">
Messages sent in open channels are <b>ephemeral</b> and not persisted by ChatKitty.
</aside>

## Creating a channel
> Creating a new channel

```javascript
let result = await kitty.createChannel({
  type: "PUBLIC",
  name: channelName,
});

if (result.succeeded) {
  let channel = result.channel; // Handle channel
}

if (result.failed) {
  let error = result.error; // Handle error
}
```

Create a new channel by using the `ChatKitty.createChannel(CreateChannelRequest)` method. A user is 
automatically a member of a group channel they created.

## Get channels
> Get channels the current user can begin chat sessions in

```javascript
let result = await kitty.getChannels();

if (result.succeeded) {
  let channels = result.paginator.items; // Handle channels
}

if (result.failed) {
  let error = result.error; // Handle error
}
```

You can get channels the current user can chat in by calling the `ChatKitty.getChannels()` method.

## Get joinable channels
> Get group channels the current user can become a member of

```javascript
let result = await kitty.getJoinableChannels();

if (result.succeeded) {
  let channels = result.paginator.items; // Handle channels
}

if (result.failed) {
  let error = result.error; // Handle error
}
```

Get channels the current user can join, becoming a member, by calling the `ChatKitty.getJoinableChannels()` 
method.

## Getting a channel
> Getting a channel by id

```javascript
let result = await kitty.getChannel(channelId);

if (result.succeeded) {
  let channel = result.channel; // Handle channel
}

if (result.failed) {
  let error = result.error; // Handle error
}
```

Get a channel by searchable properties like channel ID by using the `ChatKitty.getChannel(property)` 
method.

## Joining a channel
> Joining a group channel

```javascript
const result = await kitty.joinChannel({ channel: channel });

if (result.succeeded) {
  let channel = result.channel; // Handle channel
}

if (result.failed) {
  let error = result.error; // Handle error
}
```

The current user can join a group channel, becoming a member, by using the `ChatKitty.joinChannel(JoinChannelRequest)` 
method.

# Chat Sessions
Before a user can begin sending and receiving real-time messages and use in-app chat features like 
typing indicators, delivery and read receipts, emoji and like reactions, etc, their device needs to 
start a chat session. 

<aside class="notice">
 A user device can start up to 10 chat sessions at a time.
</aside>

## Starting a chat session
> Starting a chat session

```javascript
let result = kitty.startChatSession({
      channel: channel,
      onReceivedMessage: (message) => {},
    });

if (result.succeeded) {
  let session = result.session; // Handle session
}

if (result.failed) {
  let error = result.error; // Handle error
}
```

Start a chat session by calling the `ChatKitty.startChatSession(StartChatSessionRequest)` method. 
This method returns a `StartChatSessionResult` object with a `ChatSession`, which can be used to later 
[end the chat session](#chat-sessions-ending-a-chat-session), if the session was successfully started.

<aside class="notice">
 Before starting a chat session, a connection to ChatKitty must be established by <a href="#authentication-starting-a-user-session">starting a user session</a>. 
</aside>

## Listening to chat session events
> Registering chat session event handler methods when starting a chat session

```javascript
kitty.startChatSession({
 channel: channel,
 onReceivedMessage: (message) => {
  // handle received messages
 },
 onReceivedKeystrokes: (keystrokes) => {
  // handle received typing keystrokes
 },
 onTypingStarted: (user) => {
  // handle user starts typing
 },
 onTypingStopped: (user) => {
  // handle user stops typing
 },
 onParticipantEnteredChat: (user) => {
  // handle user who just entered the chat
 },
 onParticipantLeftChat: (user) => {
  // handle user who just left the chat
 },
 onParticipantPresenceChanged: (user) => {
  // handle user who became online, offline, do not distrub, invisible
 },
});
```

When an event involving a chat session channel happens, like a message sent in the channel or another 
user joined the channel, a corresponding chat session event handler method registered when starting 
the session is called.

<aside class="notice">
 All handler methods are optional, so you only needed to register handlers for chat events your application cares about.
</aside>

#### Chat session event handler methods
Name | Parameter Type | Description 
---- | -------------- | -----------
`onReceivedMessage` | `Message` | Called when a message is sent to this channel.
`onReceivedKeystrokes` | `Keystrokes` | Called when typing keystrokes are made by users actively chatting in this channel.
`onTypingStarted` | `User` | Called when a user starts typing in this channel.
`onTypingStopped` | `User` | Called when a user stops typing in this channel.
`onParticipantEnteredChat` | `User` | Called when another user starts an active chat session in this channel.
`onParticipantLeftChat` | `User` | Called when another user ends their active chat session in this channel.
`onParticipantPresenceChanged` | `User` | Called when a member of this channel changes their presence status or goes online or offline.

## Ending a chat session
> Ending a chat session using its chat session object

```javascript
session.end(); // Ends the session
```
> 

>Ending a chat session using the ChatKitty client

```javascript
ChatKitty.endChatSession(session);
```

If you no longer wish to participate in a channel's live chat and receive its events, you must end 
your chat session with the channel. 

End a chat session by calling either the `ChatSession`'s `end()` or `ChatKitty.endChatSession(ChatSession)` method.

# Messages
Users send messages through your application and administrators can send messages through the Platform API. 

<aside class="notice">
 Before sending or receiving messages, a chat session must be created for the channel the messages belong to by <a href="#chat-sessions-starting-a-chat-session">starting a chat session</a>. 
</aside>

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

## Send a message
> Send a message to a channel

```javascript
let result = await kitty.sendMessage({
  channel: channel,
  body: messageText,
});

if (result.succeeded) {
  let message = result.message; // Handle message
}

if (result.failed) {
  let error = result.error; // Handle error
}
```

You can send a message by calling the `ChatKitty.sendMessage(SendMessageRequest)` method.

## Receiving messages in real-time
> Receiving chat session messages in real-time

```javascript
kitty.startChatSession({
 channel: channel,
 onReceivedMessage: (message) => {
  // Handle recevied message
 },
});
```

You can receive messages in real-time by [starting a chat session](#chat-sessions-starting-a-chat-session) 
and registering a `onReceivedMessage` handler.

## Get messages
> Get messages inside a channel

```javascript
let result = await kitty.getMessages({
  channel: channel,
});

if (result.succeeded) {
  let messages = result.paginator.items; // Handle messages
}

if (result.failed) {
  let error = result.error; // Handle error
}
```

You can get messages in a [channel](#channels) by calling the `ChatKitty.getChannelMessages(GetMessagesRequest)` method.

# Notifications
Notifications inform a user of relevant actions related to another screen in your application from 
their current screen. ChatKitty sends notifications to your app through the ChatKitty JavaScript SDK 
when an action outside of an active chat session occurs. 
You can listen for these notifications and use them to build in-app notification views.

## Listening to in-app notifications
> Listening for new in-app notifications

```javascript
let unsubscribe = kitty.onNotificationReceived((notification) => {
  // handle notification
});

unsubscribe(); // call unsubscribe function when you're no longer interested in recieving notifications
```

When an event outside of an active chat session happens, like a message sent, a notification is sent 
to registered notification listeners. Register a notification listener using the 
`ChatKitty.onNotificationReceived((notification: Notification) => void)` method.

#### Notification types
> Handling notification types

```javascript
kitty.onNotificationReceived((notification) => {
  switch (notification.data.type) {
    case "USER:SENT:MESSAGE":
      // handle notification data
      break;
    case "SYSTEM:SENT:MESSAGE":
      // handle notification data
      break;
  }
});
```

Type | Description 
---- | -----------
`SYSTEM:SENT:MESSAGE` | Called when a system message was sent in another channel.
`USER:SENT:MESSAGE` | Called when a user sent a message in another channel.
