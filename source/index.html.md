---
title: ChatKitty API Documentation

language_tabs:
- javascript

toc_footers:
  - <a href='https://www.chatkitty.com'>&copy; ChatKitty 2020. All rights reserved</a>

---

# Overview
> Simple and convenient API

```javascript
kitty.startChatSession({
  channel: channel,
  onReceivedMessage: (message) => {
    showMessage(message);
  },
});
```

ChatKitty provides a client JavaScript SDK and Platform API for you to interact with your ChatKitty 
application. 

<p align="center"><img src="https://www.chatkitty.com/images/blog/posts/building-a-chat-app-with-react-native-and-gifted-chat-part-4/screenshot-simple-typing-indicator.png" width=344 alt="Realtime Chat Demo"></p>

<p align="center"><em>The example above was created with ChatKitty. Check it out at <a href="https://demo.chatkitty.com/">demo.chatkitty.com</a>.</em></p>

[The JavaScript client library](https://docs.chatkitty.com/javascript/) provides an asynchronous 
WebSocket based real-time messaging interface to ChatKitty's user-side functionality. [The Platform API](https://docs.chatkitty.com/platform/) 
provides a RESTful HTTP interface for you to manage and control your application server-side.

## Getting started

### Getting an API key
You'll need [a ChatKitty account](https://dashboard.chatkitty.com/authorization/register) before you can
begin building chat with ChatKitty. After creating your account, create a ChatKitty application using the dashboard
and copy its API key from your application's setting page.

### Installation
ChatKitty is available as an [npm package](https://www.npmjs.com/package/chatkitty). Install the 
ChatKitty client SDK into front-end application using NPM or Yarn.

> Installing the JavaScript SDK using NPM

```shell
npm install chatkitty
```

### Initialize the SDK with your API key
With your API key you can initialize a new instance of the **ChatKitty client**.

> Initialize ChatKitty SDK client 

```javascript
const kitty = ChatKitty.getInstance(CHATKITTY_API_KEY);
```

### Starting a user session
To make calls to ChatKitty as a user, a user session must be started.

You can start a user session using the unique username of a user and optional authentication
parameters to secure the user session.

> Starting a user session as a guest user without authParams

```javascript
await kitty.startSession({
  username: email,
});
```

# Client SDK

ChatKitty provides a JavaScript client SDK to integrate chat into your front-end application.

We've provided the following resources to help you implement chat with the ChatKitty JavaScript SDK.

- [SDK Documentation](/javascript)
- [SDK TSDoc Reference Documentation](https://chatkitty.github.io/chatkitty-js/)
- [Guides And Tutorials](https://www.chatkitty.com/guides/)

<aside class="notice">
 The Platform API is not designed for client-side use.
</aside>
