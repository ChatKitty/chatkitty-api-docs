# Files

Files like pictures, videos, documents, etc. can be uploaded to ChatKitty. 
If you prefer hosting your own files, you can also create external file references pointing to 
your file servers.

## Properties
Name | Type | Description 
--------- | ----------- | -----------
type | Enum | The type of this file. __Possible values__ are [HOSTED](#file-uploads) and [EXTERNAL](#external-files)
url | String | URL pointing to this file's content
name | String | The name of this file
contentType | String | MIME type of this file
size | Long | 64 bit integer size of this file in bytes

## File Uploads
> The HTTP request for a file upload looks like this:

```http
POST / HTTP/1.1
Host: https://api.chatkitty.com/v1/applications/1/channels/2/messages
Content-Type: multipart/form-data; boundary=Your_Boundary_String

Your_Unique_Boundary_String
Content-Disposition: form-data; name="file"; filename="./file-path/file_name.png"
Content-Type: image/png

(file data)
New_Boundary_String
Content-Disposition: form-data; name="extraProperty"

extraPropertyValue
Your_Unique_Boundary_String
```
To upload a file to ChatKitty, make a [multipart form data](https://tools.ietf.org/html/rfc2388) `POST` request to a file upload endpoint:

- Your HTTP request content type header must be set to `multipart/form-data`.
- The content-disposition header for the part containing the file content must have 
a "name" parameter with the value `file`.
- The form data must be the content of the file.

### Additional file upload properties
- Additional properties specific to the file upload endpoint can be sent using 
additional content parts
- The content-disposition header for the part containing the property must have 
a "name" parameter with the property name.
- The form data must be the value of the property.

## External Files
If you'd rather host your own files, you can create an external file reference.  

To create an external file reference, set the external file's parameters on the file property 
of an endpoint expecting an external file reference:

### External File Parameters
Parameter | Type | Description 
--------- | ----------- | -----------
url | String | External URL pointing to this file's content
name | String | The name of this file
contentType | String | MIME type of this file
size | Long | 64 bit integer size of this file in bytes