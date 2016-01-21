## GET /stickies


- This endpoint is sensitive to the value of the **UserId** HTTP header.

#### GET Parameters:

- contents
     - **Values**: *1:post, 3:event, 5:post*
     - **Description**: List of content keys, e.g. ratings?contents[]=1:post&contents[]=3:event&contents[]=5:post
     - This parameter is a **list**. All GET parameters with the name contents[] will forward their values in a list to the handler.


#### Response:

- Status code 200
- Headers: []

- Supported content types are:

    - `application/json`

- Response body as below.

```javascript
[{"contentId":13,"contentType":"post"},{"contentId":4,"contentType":"event"},{"contentId":1,"contentType":"post"}]
```

## DELETE /stickies/:contentType/:contentId

#### Captures:

- *contentType*: (string) super type of rated content
- *contentId*: (long) id if rated content


- This endpoint is sensitive to the value of the **UserId** HTTP header.

#### Response:

- Status code 200
- Headers: []

- Supported content types are:

    - `application/json`

- No response body

## POST /stickies/:contentType/:contentId

#### Captures:

- *contentType*: (string) super type of rated content
- *contentId*: (long) id if rated content


- This endpoint is sensitive to the value of the **UserId** HTTP header.

#### Response:

- Status code 201
- Headers: []

- Supported content types are:

    - `application/json`

- No response body

