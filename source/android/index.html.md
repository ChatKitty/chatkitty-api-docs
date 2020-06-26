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

**Begin a user session**  
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
        // Handle session request cancellation
    }

    @Override
    public void onError(ChatKittyException error) {
        // Handle error
    }
});
```

If your application has the **guest user** feature enabled, you can begin a user session by calling the 
`ChatKitty.startSession(CHATKITTY_USERNAME)` method.
