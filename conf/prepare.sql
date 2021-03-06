﻿/*  The following SQL code is run the first time to configre the database to behave as intended
  It contains:
    1. Table Declarations
    2. Function Declarations
    3. Trigger Declarations
    4. Some data to test the database
  Table Declarations may change during the development so, we are not going to put it here until
  we are sure the development cycle is over.
*/

/*                              1. Table Declarations.                                    */
/******************************************************************************************/
--ALTER TABLE IF EXISTS weydi_user_likes ADD COLUMN reaction_level INTEGER NOT NULL DEFAULT 0;




/********************* views **********************/
DROP VIEW IF EXISTS user_view;
CREATE OR REPLACE VIEW user_view AS
	SELECT U.id, U.email, U.created_at, P.first_name, P.last_name, P.avatar_url, P.likes, P.answer_count, question_count FROM weydi_auth_user U
		LEFT JOIN weydi_user_profile P ON U.profile_id = P.id;

GRANT ALL PRIVILEGES ON TABLE user_view TO mahdi;

DROP VIEW IF EXISTS answer_view;
CREATE OR REPLACE VIEW answer_view AS
	SELECT 	A.id AS q_id, Q.created_at AS q_created_at, Q.text AS q_text, Q.text_id AS q_text_id, Q.description AS q_description,
		Q.author_id AS q_author_id, Q.language_id AS q_language_id, Q.love_count AS q_love_count, Q.hate_count AS q_hate_count,
		Q.comment_count AS q_comment_count, A.id AS a_answer_id, A.created_at AS a_created_at, A.text AS a_text,
		A.author_id AS a_author_id, A.love_count AS a_love_count, A.hate_count AS a_hate_count, A.comment_count AS a_comment_count
	FROM weydi_question Q
		LEFT JOIN weydi_answer A ON Q.id = A.question_id;

GRANT ALL PRIVILEGES ON TABLE answer_view TO mahdi;

/************************* Replaced with the below view *********************************************/
/*DROP VIEW IF EXISTS answer_activity_view;
CREATE OR REPLACE VIEW answer_activity_view AS
	SELECT AN.*, Q.id AS q_id, Q.text AS question_text, U.id AS user_id, concat(P.first_name, ' ', P.last_name) AS Doer  FROM weydi_user_activity A
		INNER JOIN weydi_activity_type T ON A.type_id = T.id
		INNER JOIN weydi_answer AN ON A.item_id = AN.id AND A.type_id = 2
		INNER JOIN weydi_question Q ON AN.question_id = Q.id
		INNER JOIN weydi_auth_user U ON AN.author_id = U.id
		INNER JOIN weydi_user_profile P ON P.id = U.profile_id;
*/
		
DROP VIEW IF EXISTS answer_activity_view;
CREATE OR REPLACE VIEW answer_activity_view AS 
	SELECT AN.id, to_char(AN.created_at, 'dd-mm-yyyy HH12:MIam') AS created_at, 
		to_char(AN.updated_at, 'dd-mm-yyyy HH12:MIam') AS updated_at, AN.text, P.avatar_url,
		AN.love_count, AN.hate_count, AN.comment_count, AN.question_id AS q_id,
		Q.text AS question_text, U.id AS user_id, concat(P.first_name, ' ', P.last_name) AS Doer  
	FROM weydi_user_activity A
		INNER JOIN weydi_activity_type T ON A.type_id = T.id
		INNER JOIN weydi_answer AN ON A.item_id = AN.id AND A.type_id = 2
		INNER JOIN weydi_question Q ON AN.question_id = Q.id
		INNER JOIN weydi_auth_user U ON AN.author_id = U.id
		INNER JOIN weydi_user_profile P ON P.id = U.profile_id;

GRANT ALL PRIVILEGES ON TABLE answer_activity_view TO mahdi;

/*__________________ COMMENTS ______________*/
-- ################## QUESTION COMMENTS #################################################
DROP VIEW IF EXISTS question_comments_view;
CREATE VIEW question_comments_view AS
	SELECT 	C.id, to_char(C.created_at, 'dd-mm-yyyy HH12:MIam') AS created_at, 
		to_char(C.updated_at, 'dd-mm-yyyy HH12:MIam') AS updated_at, C.text,
		U.id AS author_id, concat(P.first_name, ' ', P.last_name) AS author_name,
		C.question_id AS parent_id, P.avatar_url AS author_avatar_url
	FROM weydi_user_comment C
		LEFT JOIN weydi_auth_user U ON C.author_id = U.id
		LEFT JOIN weydi_user_profile P ON U.profile_id = P.id;
GRANT ALL PRIVILEGES ON TABLE question_comments_view TO mahdi;

-- ################### ANSWER COMMENTS ##################################################
DROP VIEW IF EXISTS answer_comments_view;
CREATE VIEW answer_comments_view AS
	SELECT 	C.id, to_char(C.created_at, 'dd-mm-yyyy HH12:MIam') AS created_at, 
		to_char(C.updated_at, 'dd-mm-yyyy HH12:MIam') AS updated_at, C.text,
		U.id AS author_id, concat(P.first_name, ' ', P.last_name) AS author_name,
		C.answer_id AS parent_id, P.avatar_url AS author_avatar_url
	FROM weydi_user_comment C
		LEFT JOIN weydi_auth_user U ON C.author_id = U.id
		LEFT JOIN weydi_user_profile P ON U.profile_id = P.id;
GRANT ALL PRIVILEGES ON TABLE answer_comments_view TO mahdi;

-- ################### COMMENT COMMENTS #################################################
DROP VIEW IF EXISTS comment_comments_view;
CREATE VIEW comment_comments_view AS
	SELECT 	C.id, to_char(C.created_at, 'dd-mm-yyyy HH12:MIam') AS created_at, 
		to_char(C.updated_at, 'dd-mm-yyyy HH12:MIam') AS updated_at, C.text,
		U.id AS author_id, concat(P.first_name, ' ', P.last_name) AS author_name,
		C.comment_id AS parent_id, P.avatar_url AS author_avatar_url
	FROM weydi_user_comment C
		LEFT JOIN weydi_auth_user U ON C.author_id = U.id
		LEFT JOIN weydi_user_profile P ON U.profile_id = P.id;
GRANT ALL PRIVILEGES ON TABLE comment_comments_view TO mahdi;

/*                               2. Function Declarations                                 */
/******************************************************************************************/
-- ||###############################################################################||
-- ||	this function is used to update counter field in the question/answer table  ||
-- ||	it will be envoked when new like is inserted or updated.		    ||
-- ||###############################################################################||
CREATE OR REPLACE FUNCTION update_answer_likes(answer_id integer) RETURNS void AS $$
BEGIN 
	UPDATE weydi_answer
	SET 	love_count = (SELECT COUNT(*) FROM weydi_user_likes L WHERE L.postive = true AND L.answer_id = $1),
		hate_count = (SELECT COUNT(*) FROM weydi_user_likes L WHERE L.postive = false AND L.answer_id = $1)
	WHERE id = $1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_question_likes(question_id integer) RETURNS void AS $$
BEGIN 
	UPDATE weydi_question
	SET 	love_count = (SELECT COUNT(*) FROM weydi_user_likes L WHERE L.postive = true AND L.question_id = $1),
		hate_count = (SELECT COUNT(*) FROM weydi_user_likes L WHERE L.postive = false AND L.question_id = $1)
	WHERE id = $1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_comment_likes(answer_id integer) RETURNS void AS $$
BEGIN 
	UPDATE weydi_user_comment
	SET 	love_count = (SELECT COUNT(*) FROM weydi_user_likes L WHERE L.postive = true AND L.comment_id = $1),
		hate_count = (SELECT COUNT(*) FROM weydi_user_likes L WHERE L.postive = false AND L.comment_id = $1)
	WHERE id = $1;
END;
$$ LANGUAGE plpgsql;

/*CREATE OR REPLACE FUNCTION answer_likes_counter_update(answer_id integer, question_id integer, comment_id integer) RETURNS void AS $likes_counter$
BEGIN
	IF $1 IS NOT NULL THEN
		UPDATE weydi_answer
		SET 	love_count = (SELECT COUNT(id) FROM weydi_user_likes L WHERE postive = true AND L.answer_id = $1), 
			hate_count = (SELECT COUNT(id) FROM weydi_user_likes L WHERE postive = true AND L.answer_id = $1)
		WHERE id = $1;
	ELSIF $2 IS NOT NULL THEN
		UPDATE weydi_question
		SET 	love_count = (SELECT COUNT(id) FROM weydi_user_likes L WHERE postive = true AND L.question_id = $1), 
			hate_count = (SELECT COUNT(id) FROM weydi_user_likes L WHERE postive = true AND L.question_id = $1)
		WHERE id = $1;
	ELSIF $3 IS NOT NULL THEN 
		UPDATE weydi_user_comment
		SET 	love_count = (SELECT COUNT(id) FROM weydi_user_likes L WHERE postive = true AND L.comment_id = $1), 
			hate_count = (SELECT COUNT(id) FROM weydi_user_likes L WHERE postive = true AND L.comment_id = $1)
		WHERE id = $1;
	END IF;
END;
$likes_counter$ LANGUAGE plpgsql;
*/

CREATE OR REPLACE FUNCTION update_question_comment_counter(question_id integer) RETURNS VOID AS $$
BEGIN
	UPDATE weydi_question
	SET comment_count = (SELECT COUNT(*) FROM weydi_user_comment UC WHERE UC.question_id = $1)
	WHERE id = $1;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_answer_comment_counter(answer_id integer) RETURNS VOID AS $$
BEGIN
	UPDATE weydi_answer
	SET comment_count = (SELECT COUNT(*) FROM weydi_user_comment UC WHERE UC.answer_id = $1)
	WHERE id = $1;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_comment_comment_counter(comment_id integer) RETURNS VOID AS $$
BEGIN
	UPDATE weydi_user_comment
	SET comment_count = (SELECT COUNT(*) FROM weydi_user_comment UC WHERE UC.comment_id = $1)
	WHERE id = $1;
END; $$ LANGUAGE plpgsql;



/*                               2. Trigger Declarations                                 */
/******************************************************************************************/
-- QUESTION INSERT TRIGGER FUNCTION
CREATE OR REPLACE FUNCTION tg_log_question_activities()
RETURNS trigger AS $question_trigger$
BEGIN
	INSERT INTO weydi_user_activity(created_at, updated_at, doer_id, type_id, item_id)
		VALUES(NEW.created_at, NEW.updated_at, NEW.author_id, 1, NEW.id);
	RETURN NEW;
END;
$question_trigger$ LANGUAGE plpgsql;

-- TRIGGER FOR ACTIVITY LOG
DROP TRIGGER IF EXISTS activity_log_trigger ON weydi_question;
CREATE TRIGGER activity_log_trigger
AFTER INSERT ON weydi_question
FOR EACH ROW
EXECUTE PROCEDURE tg_log_question_activities();
-----------------------------------------------------------------------------------------------

-- ANSWER INSERT TRIGGER FUNCTION
CREATE OR REPLACE FUNCTION tg_log_answer_activities()
RETURNS trigger AS $answer_trigger$
BEGIN
	INSERT INTO weydi_user_activity(created_at, updated_at, doer_id, type_id, item_id)
		VALUES(NEW.created_at, NEW.updated_at, NEW.author_id, 2, NEW.id);
	RETURN NEW;
END;
$answer_trigger$ LANGUAGE plpgsql;
-- TRIGGER FOR ACTIVITY LOG
DROP TRIGGER IF EXISTS activity_log_trigger ON weydi_answer;
CREATE TRIGGER activity_log_trigger
AFTER INSERT ON weydi_answer
FOR EACH ROW
EXECUTE PROCEDURE tg_log_answer_activities();
-----------------------------------------------------------------------------------------------
--------   REPLACED WITH INDIVIDUAL FUNCTIONS BECAUSE OF AN UNKNOWN BUG, I COULN'T FIX --------
-------- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ------
-----------------------------------------------------------------------------------------------
-- TRIGGER FUNCTION FOR ACTIVITY LOG LIKES COUNT UPDATE
/*
CREATE OR REPLACE FUNCTION tg_update_likes() RETURNS trigger AS $likes_trigger$
BEGIN
	IF NEW.question_id IS NOT NULL THEN
		UPDATE weydi_question 
		SET love_count = (SELECT COUNT(id) FROM weydi_user_likes WHERE question_id = NEW.id AND postive = true),
			hate_count = (SELECT COUNT(id) FROM weydi_user_likes WHERE question_id = NEW.id AND postive = false)
		WHERE id = NEW.question_id;
	ELSIF NEW.answer_id IS NOT NULL THEN
		UPDATE weydi_answer SET love_count = (SELECT COUNT(id) FROM weydi_user_likes WHERE answer_id = NEW.id AND postive = true),
			hate_count = (SELECT COUNT(id) FROM weydi_user_likes WHERE answer_id = NEW.id AND postive = false)
		WHERE id = NEW.answer_id;

	ELSIF NEW.question_comment_id IS NOT NULL THEN
		UPDATE weydi_question_comment SET love_count = (SELECT COUNT(id) FROM weydi_user_likes WHERE question_comment_id = NEW.id AND postive = true),
			hate_count = (SELECT COUNT(id) FROM weydi_user_likes WHERE question_comment_id = NEW.id AND postive = false)
		WHERE id = NEW.question_comment_id;
	ELSIF NEW.answer_comment_id IS NOT NULL THEN
		UPDATE weydi_answer_comment SET love_count = (SELECT COUNT(id) FROM weydi_user_likes WHERE answer_comment_id = NEW.id AND postive = true),
			hate_count = (SELECT COUNT(id) FROM weydi_user_likes WHERE answer_comment_id = NEW.id AND postive = false)
		WHERE id = NEW.question_comment_id;
	END IF;
	RETURN NEW;
END;
$likes_trigger$ LANGUAGE plpgsql;
-- TRIGGER FOR ACTIVITY LOG LIKES COUNT UPDATE
DROP TRIGGER IF EXISTS activity_log_trigger ON weydi_user_likes;
CREATE TRIGGER activity_log_trigger
AFTER INSERT OR UPDATE ON weydi_user_likes
FOR EACH ROW
EXECUTE PROCEDURE tg_update_likes();*/
-----------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION convert_to_integer(v_input text)
RETURNS INTEGER AS $$
DECLARE v_int_value INTEGER DEFAULT NULL;
BEGIN
    BEGIN
        v_int_value := v_input::INTEGER;
    EXCEPTION WHEN OTHERS THEN
        RAISE NOTICE 'Invalid integer value: "%".  Returning NULL.', v_input;
        RETURN NULL;
    END;
RETURN v_int_value;
END;
$$ LANGUAGE plpgsql;


-- #######################################\
-- -- ###################################### INSERT LIKE FUNCTIONS
-- ######################################/
CREATE OR REPLACE FUNCTION insert_question_like(positive boolean, user_id integer, question integer, OUT inserted_new boolean) AS $$
DECLARE 
	likes_item_id bigint;
BEGIN	
	IF $2 IS NULL THEN
		RAISE NOTICE 'user_id is null';
	ELSIF $3 IS NOT NULL THEN
		SELECT L.id INTO likes_item_id FROM weydi_user_likes L WHERE L.question_id = $3 AND L.user_id = $2;
		RAISE NOTICE 'item_id = %', likes_item_id;
		IF likes_item_id IS NOT NULL THEN
			UPDATE weydi_user_likes L SET postive = $1 WHERE L.question_id = $3 AND L.user_id = $2;
			inserted_new := false;
		ELSE
			INSERT INTO weydi_user_likes(postive, user_id, question_id) VALUES($1, $2, $3);
			inserted_new := true;
		END IF;
	END IF;
	PERFORM update_question_likes(question);
	
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_answer_like(positive boolean, user_id integer, answer integer, OUT inserted_new boolean) AS $$
DECLARE 
	likes_item_id bigint;
BEGIN	
	IF $2 IS NULL THEN
		RAISE NOTICE 'user_id is null';
	ELSIF $3 IS NOT NULL THEN
		SELECT L.id INTO likes_item_id FROM weydi_user_likes L WHERE L.answer_id = $3 AND L.user_id = $2;
		RAISE NOTICE 'item_id = %', likes_item_id;
		IF likes_item_id IS NOT NULL THEN
			UPDATE weydi_user_likes L SET postive = $1 WHERE L.answer_id = $3 AND L.user_id = $2;
			inserted_new := false;
		ELSE
			INSERT INTO weydi_user_likes(postive, user_id, answer_id) VALUES($1, $2, $3);
			inserted_new := true;
		END IF;
	END IF;
	PERFORM update_answer_likes(answer);
END; $$ LANGUAGE plpgsql;

--
CREATE OR REPLACE FUNCTION insert_comment_like(positive boolean, user_id integer, comment integer, OUT inserted_new boolean) AS $$
DECLARE 
	likes_item_id bigint;
BEGIN	
	IF $2 IS NULL THEN
		RAISE NOTICE 'user_id is null';
	ELSIF $3 IS NOT NULL THEN
		SELECT L.id INTO likes_item_id FROM weydi_user_likes L WHERE L.comment_id = $3 AND L.user_id = $2;
		RAISE NOTICE 'item_id = %', likes_item_id;
		IF likes_item_id IS NOT NULL THEN
			UPDATE weydi_user_likes L SET postive = $1 WHERE L.comment_id = $3 AND L.user_id = $2;
			inserted_new := false;
		ELSE
			INSERT INTO weydi_user_likes(postive, user_id, comment_id) VALUES($1, $2, $3);
			inserted_new := true;
		END IF;
	END IF;
	PERFORM update_comment_likes(answer);
END; $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_like(positive boolean, user_id integer, question integer, answer integer, comment integer, OUT rows bigint, OUT inserted_new boolean) AS $like_trigger$
DECLARE
	available_rows bigint;
	item_id bigint;
BEGIN
	IF $2 IS NULL THEN	-- user_id is not null
		RAISE NOTICE 'user_id is null';
	ELSIF question IS NOT NULL THEN
		SELECT L.id INTO item_id FROM weydi_user_likes L
		WHERE (L.question_id = $3 AND L.user_id = $2)
		LIMIT 1;
		RAISE NOTICE 'Question_like id %', item_id;
		IF item_id > 0 THEN
			RAISE NOTICE 'Updating question_like';
			UPDATE weydi_user_likes SET postive = $1
			WHERE id = item_id; --question_id = $3 AND postive != $1 AND user_id = $2;
			rows := item_id;
			inserted_new := false;
		ELSE
			RAISE NOTICE 'Inserting new question_like';
			INSERT INTO weydi_user_likes(user_id, postive, question_id)
				VALUES($2, $1, $3);
			rows := 1;
			inserted_new := true;
		END IF;
		--PERFORM answer_likes_counter_update(NULL, question, NULL);
		
		PERFORM update_question_likes(question);

	ELSIF answer IS NOT NULL THEN
		SELECT L.id INTO item_id FROM weydi_user_likes L
		WHERE L.answer_id = $4 AND L.user_id = $2
		LIMIT 1;
		--RAISE NOTICE 'Answer_like id %s' item_id;
		RAISE NOTICE 'Answer_like id, % ', item_id;
		IF item_id > 0 THEN
			RAISE NOTICE 'Updating question_like';
			UPDATE weydi_user_likes SET postive = $1
			WHERE id = item_id; --answer_id = $4 AND postive != $1;
			rows := item_id;
			inserted_new := false;
		ELSE
			RAISE NOTICE 'Inserting new answer_like';
			INSERT INTO weydi_user_likes(answer_id, user_id, postive)
				VALUES($4, $2, $1);
			rows := 1;
			inserted_new := true;
		END IF;
		--PERFORM answer_likes_counter_update(answer, NULL, NULL);
		PERFORM update_answer_likes(answer);
		

	-- COMMENT ADDED LATER
	ELSIF comment IS NOT NULL THEN
		SELECT L.id INTO item_id FROM weydi_user_likes L
		WHERE L.comment_id = $4 AND L.user_id = $2
		LIMIT 1;
		--RAISE NOTICE 'Answer_like id %s' item_id;
		RAISE NOTICE 'Comment_like id, % ', item_id;
		IF item_id > 0 THEN
			RAISE NOTICE 'Updating comment_like';
			UPDATE weydi_user_likes SET postive = $1
			WHERE id = item_id; --answer_id = $4 AND postive != $1;
			rows := item_id;
			inserted_new := false;
		ELSE
			RAISE NOTICE 'Inserting new comment_like';
			INSERT INTO weydi_user_likes(comment_id, user_id, postive)
				VALUES($5, $2, $1);
			rows := 1;
			inserted_new := true;
		END IF;
		--PERFORM answer_likes_counter_update(NULL, NULL, comment);
		PERFORM update_comment_likes(comment);
	
	ELSE
		RAISE NOTICE 'Nothing to like, because all are null';
	END IF;
END;
$like_trigger$ LANGUAGE plpgsql;


/*                               2. Data                                                  */
/******************************************************************************************/

-- -- ADD ACTIVITY TYPES / LANGUAGES / 
INSERT INTO weydi_activity_type(created_at, updated_at, name)
	VALUES	(now(), now(), 'question_asked'),
		(now(), now(), 'answer_question'),
		(now(), now(), 'comment_on'),
		(now(), now(), 'reacted_to_question'),
		(now(), now(), 'reacted_to_answer'),
		(now(), now(), 'followed_question'),
		(now(), now(), 'followed_topic');

INSERT INTO weydi_language(name, code) VALUES('English', 'en-US'), ('Somali', 'so-SO'), ('العربية', 'ar-SA');