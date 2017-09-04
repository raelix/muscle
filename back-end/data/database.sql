
CREATE DATABASE muscle;

\c muscle;

-- Tables definitions

CREATE TABLE IF NOT EXISTS users (
  id SERIAL,
  username VARCHAR NOT NULL,
  nationality VARCHAR,
  gender VARCHAR,
  facebook_id VARCHAR,
  token VARCHAR NOT NULL,
  CONSTRAINT cstr_users PRIMARY KEY (id),
  CONSTRAINT cstr_unique_users_by_token UNIQUE (token),
  CONSTRAINT cstr_unique_users_by_facebook_id UNIQUE (facebook_id)
);

CREATE TABLE IF NOT EXISTS scores (
  id SERIAL,
  score INTEGER NOT NULL,
  ts TIMESTAMP NOT NULL DEFAULT timezone('utc'::text, now()),
  user_id INTEGER NOT NULL,
  mode_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (id),
  FOREIGN KEY (mode_id) REFERENCES modes (id),
  CONSTRAINT cstr_scores PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS modes (
  id SERIAL,
  name VARCHAR NOT NULL,
  duration INTEGER NOT NULL,
  CONSTRAINT cstr_modes PRIMARY KEY (id)
);

-- Dictionary Tables

INSERT INTO modes (id, name, duration)
  VALUES (1, 'power',     10),
         (2, 'reflex',    10),
         (3, 'power',     30);
