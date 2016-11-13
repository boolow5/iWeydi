package controllers

import (
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
)

type CommentAPIController struct {
	beego.Controller
}

func (this *CommentAPIController) PostComment() {
	fmt.Println("PostComment:")
	if !IsAuthenticated(&this.Controller) {
		this.Data["json"] = map[string]interface{}{"error": "not_logged_in"}
		this.ServeJSON()
		return
	}

	sess_user := this.GetSession("current_user")

	current_user := sess_user.(map[string]interface{})

	user_id := current_user["id"].(int)
	if user_id < 1 {
		this.Data["json"] = map[string]interface{}{"error": "invalid_user_id"}
		this.ServeJSON()
		return
	}
	parent_id, err := strconv.Atoi(this.Ctx.Input.Param(":parent_id"))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_parent_id"}
		this.ServeJSON()
		return
	}

	parent_type, err := strconv.Atoi(this.Ctx.Input.Param(":parent_type")) // CommentParent: 1. Question 2. Answer 3. Comment
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_parent_type"}
		this.ServeJSON()
		return
	}

	//decode request body to comment
	form := map[string]interface{}{}
	err = json.NewDecoder(this.Ctx.Request.Body).Decode(&form)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "submitted_invalid_data", "err": err.Error()}
		this.ServeJSON()
		return
	}
	// check for empty fields
	if form["text"] == nil {
		this.Data["json"] = map[string]interface{}{"error": "comment_text_required"}
		this.ServeJSON()
		return
	}
	comment_text := string(form["text"].(string))

	// Check for minimum password
	if len(comment_text) < 1 || len(comment_text) > 500 {
		this.Data["json"] = map[string]interface{}{"error": "comment_should_be_less_than_500", "length": len(comment_text)}
		this.ServeJSON()
		return
	}
	//use data to initialize new comment
	user := models.User{Id: user_id}
	// CommentParent: 1. Question 2. Answer 3. Comment
	var comment models.Comment
	if parent_type == 1 {
		comment = models.Comment{Author: &user, Text: comment_text, Question: &models.Question{Id: parent_id}, ParentType: &models.CommentParent{Id: parent_type}}
	} else if parent_type == 2 {
		comment = models.Comment{Author: &user, Text: comment_text, Answer: &models.Answer{Id: parent_id}, ParentType: &models.CommentParent{Id: parent_type}}
	} else if parent_type == 3 {
		comment = models.Comment{Author: &user, Text: comment_text, Comment: &models.Comment{Id: parent_id}, ParentType: &models.CommentParent{Id: parent_type}}
	} else {
		this.Data["json"] = map[string]interface{}{"error": "comment_parent_is_unknown", "comment_parent": parent_type}
		this.ServeJSON()
		return
	}

	o := orm.NewOrm()

	o.Begin()
	comment_id, err := o.Insert(&comment)
	if err != nil {
		//DON'T SAVE ANYTHING
		o.Rollback()
		this.Data["json"] = map[string]interface{}{"error": "cannot_save_comment", "err": err.Error(), "id": comment_id}
		this.ServeJSON()
		return
	}
	o.Commit()

	if parent_type == 1 {
		o.Raw("SELECT update_question_comment_counter(?)", parent_id).Exec()
	} else if parent_type == 2 {
		o.Raw("SELECT update_answer_comment_counter(?)", parent_id).Exec()
	} else if parent_type == 3 {
		o.Raw("SELECT update_comment_comment_counter(?)", parent_id).Exec()
	}
	this.Data["json"] = map[string]interface{}{"success": "add_comment_success", "parent_type": parent_type, "parent_id": parent_id}
	this.ServeJSON()
}

func (this *CommentAPIController) PutComment() {
	if !IsAuthenticated(&this.Controller) {
		this.Data["json"] = map[string]interface{}{"error": "not_logged_in"}
		this.ServeJSON()
		return
	}

	sess_user := this.GetSession("current_user")

	current_user := sess_user.(map[string]interface{})

	user_id := current_user["id"].(int)
	if user_id < 1 {
		this.Data["json"] = map[string]interface{}{"error": "invalid_user_id"}
		this.ServeJSON()
		return
	}

	comment_id, err := strconv.Atoi(this.Ctx.Input.Param(":id"))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_comment_id", "reason": err}
		this.ServeJSON()
		return
	}

	parent_id, err := strconv.Atoi(this.Ctx.Input.Param(":parent_id"))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_parent_id"}
		this.ServeJSON()
		return
	}

	//current_user := map[string]interface{}{"id": "2"}
	if sess_user == nil {
		this.Data["json"] = map[string]interface{}{"error": "not_logged_in"}
		this.ServeJSON()
		return
	}

	parent_type, err := strconv.Atoi(this.Ctx.Input.Param(":parent_type")) // CommentParent: 1. Question 2. Answer 3. Comment
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_parent_type"}
		this.ServeJSON()
		return
	}

	form := map[string]interface{}{}
	err = json.NewDecoder(this.Ctx.Request.Body).Decode(&form)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "submitted_invalid_data", "reason": err}
		this.ServeJSON()
		return
	}
	comment_text := ""
	if form["text"] != nil {
		comment_text = string(form["text"].(string))
	}

	// Check for minimum password
	if len(comment_text) > 0 && (len(comment_text) < 5 || len(comment_text) > 1000) {
		this.Data["json"] = map[string]interface{}{"error": "comment_should_be_5_to_1000"}
		this.ServeJSON()
		return
	}

	user := models.User{Id: user_id}

	o := orm.NewOrm()

	comment := models.Comment{Id: comment_id}
	if parent_type == 1 {
		comment = models.Comment{Author: &user, Text: comment_text}
	} else if parent_type == 2 {
		comment = models.Comment{Author: &user, Text: comment_text}
	} else if parent_type == 3 {
		comment = models.Comment{Author: &user, Text: comment_text}
	} else {
		this.Data["json"] = map[string]interface{}{"error": "comment_parent_is_unknown", "comment_parent": parent_type}
		this.ServeJSON()
		return
	}
	_, err = o.Update(&comment)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "comment_update_fail", "reason": err}
		this.ServeJSON()
		return
	}

	this.Data["json"] = map[string]interface{}{"success": "comment_update_success", "parent_type": parent_type, "parent_id": parent_id}
	this.ServeJSON()
}
