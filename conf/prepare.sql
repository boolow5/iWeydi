/*  The following SQL code is run the first time to configre the database to behave as intended
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
-- --drop table `weydi_auth_user`
--     DROP TABLE IF EXISTS "weydi_auth_user"
--
-- --drop table `weydi_user_profile`
--     DROP TABLE IF EXISTS "weydi_user_profile"
--
-- --drop table `weydi_question`
--     DROP TABLE IF EXISTS "weydi_question"
--
-- --drop table `weydi_answer`
--     DROP TABLE IF EXISTS "weydi_answer"
--
-- --drop table `weydi_topic`
--     DROP TABLE IF EXISTS "weydi_topic"
--
-- --drop table `weydi_item_follower`
--     DROP TABLE IF EXISTS "weydi_item_follower"
--
-- --drop table `weydi_user_likes`
--     DROP TABLE IF EXISTS "weydi_user_likes"
--
-- --drop table `weydi_comment_parent`
--     DROP TABLE IF EXISTS "weydi_comment_parent"
--
-- --drop table `weydi_user_comment`
--     DROP TABLE IF EXISTS "weydi_user_comment"
--
-- --drop table `weydi_language`
--     DROP TABLE IF EXISTS "weydi_language"
--
-- --drop table `weydi_activity_type`
--     DROP TABLE IF EXISTS "weydi_activity_type"
--
-- --drop table `weydi_user_activity`
--     DROP TABLE IF EXISTS "weydi_user_activity"
--
-- --create table `weydi_auth_user`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.User`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_auth_user" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "created_at" timestamp with time zone NOT NULL,
--         "updated_at" timestamp with time zone NOT NULL,
--         "email" varchar(255) NOT NULL DEFAULT ''  UNIQUE,
--         "password" varchar(255) NOT NULL DEFAULT '' ,
--         "profile_id" integer NOT NULL UNIQUE
--     );
--
-- --create table `weydi_user_profile`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.Profile`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_user_profile" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "created_at" timestamp with time zone NOT NULL,
--         "updated_at" timestamp with time zone NOT NULL,
--         "first_name" varchar(255),
--         "last_name" varchar(255),
--         "avatar_url" varchar(255),
--         "likes" integer NOT NULL DEFAULT 0 ,
--         "answer_count" integer NOT NULL DEFAULT 0 ,
--         "question_count" integer NOT NULL DEFAULT 0
--     );
--
-- --create table `weydi_question`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.Question`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_question" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "created_at" timestamp with time zone NOT NULL,
--         "updated_at" timestamp with time zone NOT NULL,
--         "text" varchar(300) NOT NULL DEFAULT ''  UNIQUE,
--         "text_id" varchar(310) NOT NULL DEFAULT ''  UNIQUE,
--         "description" varchar(600),
--         "author_id" integer NOT NULL,
--         "language_id" integer,
--         "love_count" integer NOT NULL DEFAULT 0 ,
--         "hate_count" integer NOT NULL DEFAULT 0 ,
--         "comment_count" integer NOT NULL DEFAULT 0
--     );
--
-- --create table `weydi_answer`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.Answer`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_answer" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "created_at" timestamp with time zone NOT NULL,
--         "updated_at" timestamp with time zone NOT NULL,
--         "text" varchar(1000) NOT NULL DEFAULT '' ,
--         "author_id" integer NOT NULL,
--         "question_id" integer NOT NULL,
--         "love_count" integer NOT NULL DEFAULT 0 ,
--         "hate_count" integer NOT NULL DEFAULT 0 ,
--         "comment_count" integer NOT NULL DEFAULT 0
--     );
--
-- --create table `weydi_topic`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.Topic`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_topic" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "created_at" timestamp with time zone NOT NULL,
--         "updated_at" timestamp with time zone NOT NULL,
--         "name" varchar(100) NOT NULL DEFAULT ''  UNIQUE,
--         "follower_count" integer NOT NULL DEFAULT 0 ,
--         "parent_id" integer NOT NULL
--     );
--
-- --create table `weydi_item_follower`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.Follower`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_item_follower" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "followee_id" integer,
--         "user_id" integer,
--         "topic_id" integer
--     );
--
-- --create table `weydi_user_likes`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.Like`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_user_likes" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "postive" bool NOT NULL DEFAULT true ,
--         "user_id" integer,
--         "question_id" integer,
--         "answer_id" integer,
--         "comment_id" integer
--     );
--
-- --create table `weydi_comment_parent`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.CommentParent`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_comment_parent" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "name" varchar(20) NOT NULL DEFAULT ''
--     );
--
-- --create table `weydi_user_comment`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.Comment`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_user_comment" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "created_at" timestamp with time zone NOT NULL,
--         "updated_at" timestamp with time zone NOT NULL,
--         "text" varchar(500) NOT NULL DEFAULT '' ,
--         "author_id" integer NOT NULL,
--         "answer_id" integer NOT NULL,
--         "question_id" integer NOT NULL,
--         "parent_type_id" integer NOT NULL,
--         "love_count" integer NOT NULL DEFAULT 0 ,
--         "hate_count" integer NOT NULL DEFAULT 0 ,
--         "comment_count" integer NOT NULL DEFAULT 0
--     );
--
-- --create table `weydi_language`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.Language`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_language" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "name" varchar(100) NOT NULL DEFAULT ''  UNIQUE,
--         "code" varchar(10) NOT NULL DEFAULT ''
--     );
--
-- --create table `weydi_activity_type`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.ActivityType`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_activity_type" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "created_at" timestamp with time zone NOT NULL,
--         "updated_at" timestamp with time zone NOT NULL,
--         "name" varchar(100) NOT NULL DEFAULT ''  UNIQUE
--     );
--
-- --create table `weydi_user_activity`
--     -- --------------------------------------------------
--     --  Table Structure for `github.com/boolow5/iWeydi/models.Activity`
--     -- --------------------------------------------------
--     CREATE TABLE IF NOT EXISTS "weydi_user_activity" (
--         "id" serial NOT NULL PRIMARY KEY,
--         "created_at" timestamp with time zone NOT NULL,
--         "updated_at" timestamp with time zone NOT NULL,
--         "doer_id" integer NOT NULL,
--         "type_id" integer NOT NULL,
--         "item_id" integer NOT NULL DEFAULT 0
--     );


/********************* views **********************/
CREATE OR REPLACE VIEW user_view AS
	SELECT U.id, U.email, U.created_at, P.first_name, P.last_name, P.avatar_url, P.likes, P.answer_count, question_count FROM weydi_auth_user U
		LEFT JOIN weydi_user_profile P ON U.profile_id = P.id

CREATE OR REPLACE VIEW answer_view AS
	SELECT 	A.id AS q_id, Q.created_at AS q_created_at, Q.text AS q_text, Q.text_id AS q_text_id, Q.description AS q_description,
		Q.author_id AS q_author_id, Q.language_id AS q_language_id, Q.love_count AS q_love_count, Q.hate_count AS q_hate_count,
		Q.comment_count AS q_comment_count, A.id AS a_answer_id, A.created_at AS a_created_at, A.text AS a_text,
		A.author_id AS a_author_id, A.love_count AS a_love_count, A.hate_count AS a_hate_count, A.comment_count AS a_comment_count
	FROM weydi_question Q
		LEFT JOIN weydi_answer A ON Q.id = A.question_id



/*                               2. Function Declarations                                 */
/******************************************************************************************/




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
CREATE TRIGGER activity_log_trigger
AFTER INSERT ON weydi_answer
FOR EACH ROW
EXECUTE PROCEDURE tg_log_answer_activities();
-----------------------------------------------------------------------------------------------

-- TRIGGER FUNCTION FOR ACTIVITY LOG LIKES COUNT UPDATE
CREATE OR REPLACE FUNCTION tg_update_likes() RETURNS trigger AS $likes_trigger$
BEGIN
	IF NEW.question_id IS NOT NULL THEN
		UPDATE weydi_question SET love_count = (SELECT (SELECT COUNT(id) FROM weydi_user_likes WHERE question_id = NEW.id AND postive = true) AS bigint)
		WHERE id = NEW.question_id;
	ELSIF NEW.answer_id IS NOT NULL THEN
		UPDATE weydi_answer SET love_count = (SELECT (SELECT COUNT(id) FROM weydi_user_likes WHERE answer_id = NEW.id AND postive = true) AS bigint)
		WHERE id = NEW.question_id;

	ELSIF NEW.question_comment_id IS NOT NULL THEN
		UPDATE weydi_question_comment SET love_count = (SELECT (SELECT COUNT(id) FROM weydi_user_likes WHERE question_comment_id = NEW.id AND postive = true) AS bigint)
		WHERE id = NEW.question_comment_id;
	ELSIF NEW.answer_comment_id IS NOT NULL THEN
		UPDATE weydi_answer_comment SET love_count = (SELECT (SELECT COUNT(id) FROM weydi_user_likes WHERE answer_comment_id = NEW.id AND postive = true) AS bigint)
		WHERE id = NEW.question_comment_id;
	END IF;
	RETURN NEW;
END;
$likes_trigger$ LANGUAGE plpgsql;
-- TRIGGER FOR ACTIVITY LOG LIKES COUNT UPDATE
CREATE TRIGGER activity_log_trigger
AFTER INSERT ON weydi_user_likes
FOR EACH ROW
EXECUTE PROCEDURE tg_update_likes();
-----------------------------------------------------------------------------------------------------------------



-- #######################################\
-- -- ###################################### INSERT LIKE FUNCTION
-- ######################################/
CREATE OR REPLACE FUNCTION insert_like(positive boolean, user_id integer, question integer, answer integer, OUT rows bigint, OUT inserted_new boolean) AS $like_trigger$
DECLARE
	available_rows bigint;
	item_id bigint;
BEGIN
	IF $2 IS NULL THEN
		RAISE NOTICE 'user_id is null';
	ELSIF question IS NOT NULL THEN
		SELECT id INTO item_id FROM weydi_user_likes L
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
	ELSIF answer IS NOT NULL THEN
		SELECT id INTO item_id FROM weydi_user_likes
		WHERE answer_id = $4 AND L.user_id = $2
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
	ELSE
		RAISE NOTICE 'Nothing to like, because all are null';
	END IF;
END;
$like_trigger$ LANGUAGE plpgsql;


/*                               2. Data                                                  */
/******************************************************************************************/
-- -- insert two users Mahdi and Muno
-- INSERT INTO weydi_auth_user(created_at, updated_at, email, password, profile_id)
-- 										VALUES(now(),now(),'boolow5@gmail.com', '$2a$10$BYlqx4UDfbthgx1B34sshOSkdg6KmanA2yixtbI/2xsdotK0/sS8K')
--
-- INSERT INTO weydi_auth_user(created_at, updated_at, email, password, profile_id)
-- 									VALUES(now(),now(),'lajecleey5@gmail.com', '$2a$10$XWsXQnCjR/2ZFes7CrTWUecupBBe3Z0bxJ.Fu7qBaEcMB57tfVg1a')
