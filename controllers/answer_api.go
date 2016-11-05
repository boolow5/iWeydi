package controllers

import (
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
)

type AnswerAPIController struct {
	beego.Controller
}

func (this *AnswerAPIController) PostAnswer() {
	fmt.Println("PostAnswer:")
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
	question_id, err := strconv.Atoi(this.Ctx.Input.Param(":question_id"))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_question_id"}
		this.ServeJSON()
		return
	}

	//decode request body to answer
	form := map[string]interface{}{}
	err = json.NewDecoder(this.Ctx.Request.Body).Decode(&form)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "submitted_invalid_data", "err": err.Error()}
		this.ServeJSON()
		return
	}
	// check for empty fields
	if form["text"] == nil {
		this.Data["json"] = map[string]interface{}{"error": "answer_text_required"}
		this.ServeJSON()
		return
	}
	answer_text := string(form["text"].(string))

	// Check for minimum password
	if len(answer_text) < 5 || len(answer_text) > 1000 {
		this.Data["json"] = map[string]interface{}{"error": "answer_should_be_5_to_1000", "length": len(answer_text)}
		this.ServeJSON()
		return
	}
	//use data to initialize new answer
	user := models.User{Id: user_id}
	answer := models.Answer{Author: &user, Text: answer_text, Question: &models.Question{Id: question_id}}

	o := orm.NewOrm()

	o.Begin()
	answer_id, err := o.Insert(&answer)
	if err != nil {
		//DON'T SAVE ANYTHING
		o.Rollback()
		this.Data["json"] = map[string]interface{}{"error": "cannot_save_answer", "err": err, "id": answer_id}
		this.ServeJSON()
		return
	}
	o.Commit()
	this.Data["json"] = map[string]interface{}{"success": "add_answer_success", "err": err}
	this.ServeJSON()
}

func (this *AnswerAPIController) PutAnswer() {
	sess_user := this.GetSession("current_user")
	answer_id, err := strconv.Atoi(this.Ctx.Input.Param(":id"))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_answer_id", "reason": err}
		this.ServeJSON()
		return
	}
	//current_user := map[string]interface{}{"id": "2"}
	if sess_user == nil {
		this.Data["json"] = map[string]interface{}{"error": "not_logged_in"}
		this.ServeJSON()
		return
	}
	current_user := sess_user.(map[string]interface{})
	_, err = strconv.Atoi(current_user["id"].(string))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_user_id", "reason": err}
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
	answer_text := ""
	if form["text"] != nil {
		answer_text = string(form["text"].(string))
	}

	// Check for minimum password
	if len(answer_text) > 0 && (len(answer_text) < 5 || len(answer_text) > 1000) {
		this.Data["json"] = map[string]interface{}{"error": "answer_should_be_5_to_1000"}
		this.ServeJSON()
		return
	}

	o := orm.NewOrm()
	answer := models.Answer{Id: answer_id, Text: answer_text}

	_, err = o.Update(&answer)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "answer_update_fail", "reason": err}
		this.ServeJSON()
		return
	}

	this.Data["json"] = map[string]interface{}{"success": "answer_update_success"}
	this.ServeJSON()
}
