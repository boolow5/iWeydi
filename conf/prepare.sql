/*
  The following SQL code is run the first time to configre the database to behave as intended
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
