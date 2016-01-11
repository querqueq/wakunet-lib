## GET /timeline


- This endpoint is sensitive to the value of the **UserId** HTTP header.

#### GET Parameters:

- from
     - **Values**: *2015-12-12, 2013-01-08, ...*
     - **Description**: Return a timeline starting from :from. If not set timeline will contain all past content

- till
     - **Values**: *2015-12-12, 2013-01-08, ...*
     - **Description**: Return a timeline starting till :till. If not set current time is used

- group
     - **Values**: *1, 4, 12, ...*
     - **Description**: Return a timeline for given group. If not set all available content for sender will be in timeline


#### Response:

- Status code 200
- Headers: []

- Supported content types are:

    - `application/json`

- Timeline for 20th Dec 2015

```javascript
{"contents":[{"ratings":{"dislikes":0,"userId":2,"likes":0,"userRating":null,"contentKey":{"contentId":2,"contentType":"event"}},"content":{"fromDate":"2015-12-12T10:00:00Z","allDay":false,"location":"Meeting Room C","participants":[1,2,3,4,5,6,7],"toDate":"2015-12-12T11:00:00Z","id":2,"title":"Jour fixe","type":"PlainEvent","contentKey":{"contentId":1,"contentType":"event"},"description":"","creatorId":1},"happened":"2015-12-12T10:00:00Z"},{"ratings":{"dislikes":0,"userId":2,"likes":0,"userRating":null,"contentKey":{"contentId":1,"contentType":"post"}},"content":{"subPostCount":2,"text":"Hi there!","created":"2015-12-08T19:00:00Z","subPosts":[{"subPostCount":0,"text":"Welcome to this group.","created":"2015-12-08T19:02:00Z","subPosts":[],"groupId":1,"id":2,"updated":null,"type":"fullPost","contentKey":{"contentId":0,"contentType":"post"},"creatorId":2,"parentPostId":1},{"subPostCount":0,"text":"Thanks!","created":"2015-12-08T19:03:52Z","subPosts":[],"groupId":1,"id":3,"updated":null,"type":"fullPost","contentKey":{"contentId":0,"contentType":"post"},"creatorId":1,"parentPostId":1}],"groupId":1,"id":1,"updated":null,"type":"fullPost","contentKey":{"contentId":0,"contentType":"post"},"creatorId":1,"parentPostId":null},"happened":"2015-12-08T19:00:00Z"}],"till":"2015-12-20T02:00:00Z"}
```

- Timeline for 25th Dec 2015

```javascript
{"contents":[{"ratings":{"dislikes":0,"userId":2,"likes":0,"userRating":null,"contentKey":{"contentId":1,"contentType":"event"}},"content":{"fromDate":"2015-12-23T17:00:00Z","allDay":false,"location":"Main building","participants":[2,3,6],"toDate":"2015-12-24T06:00:00Z","id":1,"title":"Xmas party","type":"PlainEvent","contentKey":{"contentId":1,"contentType":"event"},"description":"Friends and family welcome","creatorId":1},"happened":"2015-12-23T17:00:00Z"},{"ratings":{"dislikes":0,"userId":2,"likes":0,"userRating":null,"contentKey":{"contentId":2,"contentType":"event"}},"content":{"fromDate":"2015-12-12T10:00:00Z","allDay":false,"location":"Meeting Room C","participants":[1,2,3,4,5,6,7],"toDate":"2015-12-12T11:00:00Z","id":2,"title":"Jour fixe","type":"PlainEvent","contentKey":{"contentId":1,"contentType":"event"},"description":"","creatorId":1},"happened":"2015-12-12T10:00:00Z"},{"ratings":{"dislikes":0,"userId":2,"likes":0,"userRating":null,"contentKey":{"contentId":1,"contentType":"post"}},"content":{"subPostCount":2,"text":"Hi there!","created":"2015-12-08T19:00:00Z","subPosts":[{"subPostCount":0,"text":"Welcome to this group.","created":"2015-12-08T19:02:00Z","subPosts":[],"groupId":1,"id":2,"updated":null,"type":"fullPost","contentKey":{"contentId":0,"contentType":"post"},"creatorId":2,"parentPostId":1},{"subPostCount":0,"text":"Thanks!","created":"2015-12-08T19:03:52Z","subPosts":[],"groupId":1,"id":3,"updated":null,"type":"fullPost","contentKey":{"contentId":0,"contentType":"post"},"creatorId":1,"parentPostId":1}],"groupId":1,"id":1,"updated":null,"type":"fullPost","contentKey":{"contentId":0,"contentType":"post"},"creatorId":1,"parentPostId":null},"happened":"2015-12-08T19:00:00Z"}],"till":"2015-12-25T12:00:00Z"}
```

