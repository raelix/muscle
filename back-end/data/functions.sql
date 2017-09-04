max_results\c muscle;

DROP FUNCTION get_token_by_facebook_id(VARCHAR);
CREATE OR REPLACE FUNCTION get_token_by_facebook_id(facebook_id_in VARCHAR)
RETURNS TABLE (
  token VARCHAR) AS
$BODY$
declare
  procedure_name VARCHAR(50) := 'get_token_by_facebook_id';
begin
return query
  SELECT usr.token FROM users usr WHERE usr.facebook_id = facebook_id_in;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP FUNCTION login(VARCHAR, VARCHAR);
CREATE OR REPLACE FUNCTION login(username_in VARCHAR, token_in VARCHAR)
  RETURNS integer AS
$BODY$
declare
  procedure_name VARCHAR(20) := 'add_user';
  updated_rows integer := 0;
begin
  INSERT INTO users(username, token) VALUES(username_in, token_in);
  GET DIAGNOSTICS updated_rows = ROW_COUNT;
  return updated_rows;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP FUNCTION insert_or_update_user(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR);
CREATE OR REPLACE FUNCTION insert_or_update_user(
    in username_in    VARCHAR
  , in gender_in      VARCHAR
  , in nationality_in VARCHAR
  , in facebook_id_in VARCHAR
  , in token_in       VARCHAR)
  RETURNS integer AS
$BODY$
  declare
    procedure_name varchar(40) := 'login_with_facebook';
    updated_rows integer := 0;
    begin
      begin
          UPDATE users
          SET username = username_in,
              gender = gender_in,
              nationality = nationality_in,
              facebook_id = facebook_id_in
              where token = token_in;

          GET DIAGNOSTICS updated_rows = ROW_COUNT;

          if updated_rows = 0 then

            INSERT INTO users
                  (username, gender, nationality, facebook_id, token)
            VALUES(username_in, gender_in, nationality_in, facebook_id_in, token_in);

              GET DIAGNOSTICS updated_rows = ROW_COUNT;
          end if;
      end;
        return updated_rows;
    end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

----------
--- SCORES
----------


DROP FUNCTION insert_score(VARCHAR, INTEGER, INTEGER);
CREATE OR REPLACE FUNCTION insert_score(
    in token_in          VARCHAR
  , in score_in          INTEGER
  , in mode_id_in        INTEGER)
  RETURNS integer AS
$BODY$
  declare
    procedure_name varchar(40) := 'insert_score';
    updated_rows integer := 0;
    user_id_in integer := -1;
    begin
      SELECT usr.id FROM users usr where usr.token = token_in	INTO user_id_in;
      begin
      IF (user_id_in <> -1) THEN
      INSERT INTO scores(score, user_id, mode_id)
      VALUES(score_in, user_id_in, mode_id_in);
      updated_rows = 1;
      END IF;
    end;
    return updated_rows;
  end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


drop function get_max_scores(boolean, varchar, integer, integer, integer);

CREATE OR REPLACE FUNCTION get_max_scores(
  in filter_on_nationality boolean,
  in token_in              varchar,
  in filter_type           integer,
  in max_results		   integer default 5,
  in mode_id_in		       integer default 1)

  RETURNS TABLE (
    positions   integer,
    max_score   integer,
    username    varchar,
    nationality varchar,
    user_id     integer,
    ts          timestamp
    ) AS
  $BODY$
  declare
    procedure_name VARCHAR(50) := 'get_max_scores';
--  counter integer;
  begin
--	select count(*) from users uk where uk.token = token_in into counter;
	begin
return query
  with filter_user as (
  select usr.id, usr.username, usr.nationality
    from users usr
    where usr.token = token_in
    limit 1
  ),
  best_five as(
  select row_number() OVER (ORDER BY max(score) desc) as positions, max(score) as max_score, sc.user_id, max(sc.ts) as ts
    from scores sc
      join users ux on ux.id = sc.user_id
      join filter_user fu on (fu.nationality = ux.nationality or filter_on_nationality = false)
    where
      (filter_type = 0)
    or
      (filter_type = 1 and sc.ts >= date_trunc('month', CURRENT_DATE) AND sc.ts < date_trunc('month', CURRENT_DATE) + interval '1 month')
    or
      (filter_type = 2 and sc.ts >= date_trunc('day', CURRENT_DATE) AND sc.ts < date_trunc('day', CURRENT_DATE) + interval '1 day')
    and sc.mode_id = mode_id_in
    group by sc.user_id
    order by max_score desc
  )
  select bf.positions::integer as positions, bf.max_score, uk.username, uk.nationality, bf.user_id as user_id, bf.ts as ts
    from best_five bf
      join users uk on uk.id = bf.user_id
      join filter_user fu on (bf.user_id = fu.id) or bf.positions < max_results
  ;
  END;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
