## GET /timeline


- This endpoint is sensitive to the value of the **UserId** HTTP header.

#### Response:

- Status code 200
- Headers: []

- Supported content types are:

    - `application/json`

- Timeline for 20th Dec 2015

```javascript
{"till":"2015-12-20T02:00:00Z","content":[{"fromDate":"2015-12-12T10:00:00Z","allDay":false,"location":"Meeting Room C","participants":[1,2,3,4,5,6,7],"toDate":"2015-12-12T11:00:00Z","id":2,"title":"Jour fixe","description":"","creatorId":1},{"subPostCount":2,"text":"Hi there!","created":"2015-12-08T19:00:00Z","subPosts":[{"subPostCount":0,"text":"Welcome to this group.","created":"2015-12-08T19:02:00Z","subPosts":[],"groupId":1,"id":2,"updated":null,"creatorId":2,"parentPostId":1},{"subPostCount":0,"text":"Thanks!","created":"2015-12-08T19:03:52Z","subPosts":[],"groupId":1,"id":3,"updated":null,"creatorId":1,"parentPostId":1}],"groupId":1,"id":1,"updated":null,"creatorId":1,"parentPostId":null}]}
```

- Timeline for 25th Dec 2015

```javascript
{"till":"2015-12-25T12:00:00Z","content":[{"fromDate":"2015-12-23T17:00:00Z","allDay":false,"location":"Main building","participants":[2,3,6],"toDate":"2015-12-24T06:00:00Z","id":1,"title":"Xmas party","description":"Friends and family welcome","creatorId":1},{"fromDate":"2015-12-12T10:00:00Z","allDay":false,"location":"Meeting Room C","participants":[1,2,3,4,5,6,7],"toDate":"2015-12-12T11:00:00Z","id":2,"title":"Jour fixe","description":"","creatorId":1},{"subPostCount":2,"text":"Hi there!","created":"2015-12-08T19:00:00Z","subPosts":[{"subPostCount":0,"text":"Welcome to this group.","created":"2015-12-08T19:02:00Z","subPosts":[],"groupId":1,"id":2,"updated":null,"creatorId":2,"parentPostId":1},{"subPostCount":0,"text":"Thanks!","created":"2015-12-08T19:03:52Z","subPosts":[],"groupId":1,"id":3,"updated":null,"creatorId":1,"parentPostId":1}],"groupId":1,"id":1,"updated":null,"creatorId":1,"parentPostId":null}]}
```

## GET /timeline/group/:groupid

#### Captures:

- *groupid*: (integer) id of group; content of timeline will be limited to content of this group


- This endpoint is sensitive to the value of the **UserId** HTTP header.

#### Response:

- Status code 200
- Headers: []

- Supported content types are:

    - `application/json`

- Timeline for 20th Dec 2015

```javascript
{"till":"2015-12-20T02:00:00Z","content":[{"fromDate":"2015-12-12T10:00:00Z","allDay":false,"location":"Meeting Room C","participants":[1,2,3,4,5,6,7],"toDate":"2015-12-12T11:00:00Z","id":2,"title":"Jour fixe","description":"","creatorId":1},{"subPostCount":2,"text":"Hi there!","created":"2015-12-08T19:00:00Z","subPosts":[{"subPostCount":0,"text":"Welcome to this group.","created":"2015-12-08T19:02:00Z","subPosts":[],"groupId":1,"id":2,"updated":null,"creatorId":2,"parentPostId":1},{"subPostCount":0,"text":"Thanks!","created":"2015-12-08T19:03:52Z","subPosts":[],"groupId":1,"id":3,"updated":null,"creatorId":1,"parentPostId":1}],"groupId":1,"id":1,"updated":null,"creatorId":1,"parentPostId":null}]}
```

- Timeline for 25th Dec 2015

```javascript
{"till":"2015-12-25T12:00:00Z","content":[{"fromDate":"2015-12-23T17:00:00Z","allDay":false,"location":"Main building","participants":[2,3,6],"toDate":"2015-12-24T06:00:00Z","id":1,"title":"Xmas party","description":"Friends and family welcome","creatorId":1},{"fromDate":"2015-12-12T10:00:00Z","allDay":false,"location":"Meeting Room C","participants":[1,2,3,4,5,6,7],"toDate":"2015-12-12T11:00:00Z","id":2,"title":"Jour fixe","description":"","creatorId":1},{"subPostCount":2,"text":"Hi there!","created":"2015-12-08T19:00:00Z","subPosts":[{"subPostCount":0,"text":"Welcome to this group.","created":"2015-12-08T19:02:00Z","subPosts":[],"groupId":1,"id":2,"updated":null,"creatorId":2,"parentPostId":1},{"subPostCount":0,"text":"Thanks!","created":"2015-12-08T19:03:52Z","subPosts":[],"groupId":1,"id":3,"updated":null,"creatorId":1,"parentPostId":1}],"groupId":1,"id":1,"updated":null,"creatorId":1,"parentPostId":null}]}
```

