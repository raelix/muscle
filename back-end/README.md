# muscle

REST API Example

get /api/users/:token
// { get user object by token
//     "token": "2d23d34d32d32"
// }


post /api/users/login
// { register new user with passed username and create token
//     "username": "raelix"
// }

post /api/users/loginWithFacebook
// { add the user with passed facebook_id and create token or get the existing user with this facebook_id
//     "username": "raelix",
//     "facebook_id": "343j4u2394h32uer32"
// }

post /api/users/link
// { change facebook id by passed token or if token does not exists create new user, for unlink pass facebook_id="" empty
//     "username": "raelix",
//     "token":"2d23d34d32d32"
// }

////////////////////////
// Score Query Functions
////////////////////////

get /api/scores
// return array of objects, only for debug
// {
//     "id": 5, unique id of this score
//     "score": 123,
//     "ts": "2017-08-29T19:43:28.805Z",
//     "user_id": 36,
//     "mode_id": 1
// }

post /api/scores
// post object:
// {
//     "mode_id": 1,
//     "token":"2d23d234d32d32",
//     "score": 2222
// }
// return 0 if token not found 1 otherwise
// [
//     {
//         "insert_score": 0
//     }
// ]

post /api/scores/max
// post object:
// {
//     "filter_on_nationality": false,
//     "token":"2d23d234d32d32",
//     "filter_type":0 if no date filter - 1 filter on current month - 2 filter on current day
//     "max_results":5 default result
//     "mode_id":1  for base mode
// }
// return array list of objects
// {
//        "positions": 5, position in ranking
//        "max_score": 1213,
//        "username": "pippo",
//        "nationality": "QA",
//        "user_id": 2,
//        "ts": "2017-08-30T20:20:42.568Z"
// }
