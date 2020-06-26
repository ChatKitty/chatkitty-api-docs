---
title: Platform API Documentation

language_tabs:
  - java

toc_footers:
  - <a href='https://www.chatkitty.com'>&copy; ChatKitty 2020. All rights reserved</a>

search: true
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

Get a `ChatKitty` instance by passing your application's API key to the `ChatKitty.getInstance()` method as a parameter.

**Begin a user session with a user name**
