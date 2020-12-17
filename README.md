# ChatKitty API Docs

<p align="center">
  <img src="https://www.chatkitty.com/images/banner-logo-dark.png" alt="ChatKitty: Cloud Chat Platform" width="315">
  <br/>
</p>

<p align="center">ChatKitty helps you build real-time chat without any back-end.</p>

Features
------------
* **Private chat** - Provide secure and encrypted direct messaging to your users.

* **Group chat** - Your users can request to join or be invited to group chats.

* **Message threads** - Keep conversations organized with message threads.

* **Push notifications** - Make sure your users always see their messages.

* **File attachments** - Attach images, videos, or any other type of files.

* **Typing indicators** - Let your users know when others are typing.

* **Reactions** - Users can react to messages with emojis and GIFs.

* **Presence indicators** - Let your users know who's online.

* **Delivery and read receipts** - See when messages get delivered and read.

* **Link preview generation** - Messages with links get rich media previews.

ChatKitty is the first complete chat platform; bringing together everything that's
required to build real-time chat into Web and mobile apps. Getting started with ChatKitty
is easy and you get:

#### Reliability
Your user chat sessions remain stable even in the presence of proxies, load balancers and personal
firewalls. ChatKitty provides auto reconnection support and offline notifications so your users stay
in the loop.

#### Low Latency
With response times below 100ms, ChatKitty makes sure your users have a smooth and immersive chat
experience.

#### Cross-platform support
You can use ChatKitty across every major browser and device platform. ChatKitty also works great
with multi-platform frameworks like React-Native and Ionic.

#### Simple and convenient API

Sample code:

```js
let kitty = ChatKitty.getInstance(CHATKITTY_API_KEY);

useEffect(() => {
  // start real-time chat session
  let result = kitty.startChatSession({
    channel: channel,
    onReceivedMessage: (message) => {
      showMessage(message); // update your UI as new chat events occur
    },
  });

  return result.session.end;
}, []);
```

We've spent a lot of time thinking of the right abstractions and implementing our API to be straightforward
and easy to use - making you more productive.

This repository hosts the code powering docs.chatkitty.com.

We welcome changes that improve our documentation. We are very happy to merge your changes if they 
make things clear and easier to understand.
