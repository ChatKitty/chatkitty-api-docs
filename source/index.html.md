---
title: ChatKitty API Documentation

toc_footers:
  - <a href='https://www.chatkitty.com'>&copy; ChatKitty 2020. All rights reserved</a>

---

# Overview

ChatKitty provides a **Platform API**, and client SDKs to directly interact with the different types
of resources representing data in your ChatKitty application. The ChatKitty Platform API is RESTful,
using the HTTP protocol to expose discoverable [HAL](http://stateless.co/hal_specification.html) resources.

The client libraries provide an asynchronous real-time messaging interface to ChatKitty's user-side functionality.
While the client SDKs handle the requests and responses at the client-side, the Platform API provides
an interface for you to manage and control your application server-side.

<aside class="notice">
 The Platform API is not designed for client-side use.
</aside>
