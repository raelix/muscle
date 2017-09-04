# Muscle

## REST API Documentation

### /api/users/:token *GET*
#### get user object by token
```javascript
{
    "token": "2d23d34d32d32"
}
```

### /api/users/login *POST*
#### register new user with passed username and create token
```javascript
{
    "username": "raelix"
}
```

### /api/users/loginWithFacebook *POST*
#### add the user with passed facebook_id and create token or get the existing user with this facebook_id
```javascript
{
    "username": "raelix",
    "facebook_id": "343j4u2394h32uer32"
}
```

### /api/users/link *POST*
#### change facebook id by passed token or if token does not exists create new user, for unlink pass facebook_id="" empty
```javascript
{
    "username": "raelix",
    "token":"2d23d34d32d32"
}
```

# get /api/scores
#### return array of objects, only for debug
```javascript
{
    "id": 5, //unique id of this score
    "score": 123,
    "ts": "2017-08-29T19:43:28.805Z",
    "user_id": 36,
    "mode_id": 1
}
```

### /api/scores *POST*
#### post object:
```javascript
{
    "mode_id": 1,
    "token":"2d23d234d32d32",
    "score": 2222
}
```
#### return 0 if token not found 1 otherwise
```javascript
[
    {
        "insert_score": 0
    }
]
```

### /api/scores/max *POST*
#### post object:
```javascript
{
    "filter_on_nationality": false,
    "token":"2d23d234d32d32",
    "filter_type":0, // if no date filter - 1 filter on current month - 2 filter on current day
    "max_results":5, // default result
    "mode_id":1  // base mode
}
```
#### return array list of objects
```javascript
{
       "positions": 5, //position in ranking
       "max_score": 1213,
       "username": "pippo",
       "nationality": "QA",
       "user_id": 2,
       "ts": "2017-08-30T20:20:42.568Z"
}
```
