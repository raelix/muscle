var promise = require('bluebird');
var utils = require('./utils');

var options = {
  // Initialization Options
  promiseLib: promise
};

var pgp = require('pg-promise')(options);
var connectionString = 'postgres://postgres@db:5432/muscle'; // startrek is an example database name
var db = pgp(connectionString);

// console.log(utils.generateToken());

////////////////////////
// User Query Functions
////////////////////////


function getUser(req, res, next) {
_get_user(req.params.token, res, next);
}

function login(req, res, next) {
   var generated_token = utils.generateToken();
    db.one('select * from login($1, $2)', [req.body.username, generated_token])
      .then(function () {
        _get_user(generated_token, res, next);
    })
    .catch(function (err) {
      return next(err);
    });
}


function loginWithFacebook(req, res, next) {
    db.one('select token from get_token_by_facebook_id($1)', [req.body.facebook_id])
      .then(function (data) {
       _get_user(data.token, res, next);
    })
    .catch(function (err) {
       var generated_token = utils.generateToken();
       req.body['token'] = generated_token;
      _insert_or_update(req.body, res, next);
    });
}


function link(req, res, next) {
    _insert_or_update(req.body, res, next);
}

function _insert_or_update(dataObject, res, next){
  console.log(dataObject.username+ " " +  dataObject.gender+ " " +  dataObject.nationality+ " " + dataObject.facebook_id + " " + dataObject.token);
     db.one('SELECT * FROM insert_or_update_user($1, $2, $3, $4, $5)'
     ,[dataObject.username, dataObject.gender, dataObject.nationality, dataObject.facebook_id, dataObject.token])
     .then(function(data){
        _get_user(dataObject.token, res, next);
     })
     .catch(function (err) {
         return next(err);
     });
}

function _get_user(token, res, next){
     db.one('SELECT * FROM users WHERE token = $1', [token])
     .then(function(data){
       res.status(200).json(data);
     })
     .catch(function (err){
         return next(err);
     });
}


////////////////////////
// Score Query Functions
////////////////////////

function getScores(req, res, next) {
    db.any('select * from scores',[])
      .then(function (data) {
        res.status(200).json(data);
    })
    .catch(function (err) {
      return next(err);
    });
}

function addScore(req, res, next) {
    db.any('select * from insert_score(${token}, ${score}, ${mode_id})', req.body)
      .then(function (data) {
        res.status(200).json(data);
    })
    .catch(function (err) {
      return next(err);
    });
}


function getMaxScores(req, res, next) {
  if(!req.body.hasOwnProperty('max_results'))
  req.body['max_results'] = 5;
  if(!req.body.hasOwnProperty('mode_id'))
    req.body['mode_id'] = 1;
  db.any('select * from get_max_scores(${filter_on_nationality}::boolean, ${token}::varchar, ${filter_type}::integer, ${max_results}::integer, ${mode_id}::integer)', req.body)
      .then(function (data) {
        res.status(200).json(data);
    })
    .catch(function (err) {
      return next(err);
    });
}

/////////////
// Exports
/////////////

module.exports = {
    getUser: getUser,
    login: login,
    loginWithFacebook: loginWithFacebook,
    link: link,
    getScores: getScores,
    addScore: addScore,
    getMaxScores: getMaxScores
};
