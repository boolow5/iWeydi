package controllers

import (
	"encoding/json"
	"fmt"
	"strconv"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
)

type QuestionAPIController struct {
	beego.Controller
}

func (this *QuestionAPIController) Search() {
	form := map[string]interface{}{}
	err := json.NewDecoder(this.Ctx.Request.Body).Decode(&form)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "submitted_invalid_data"}
		this.ServeJSON()
		return
	}
	if form["search"] == nil {
		this.Data["json"] = map[string]interface{}{"error": "nothing_to_search"}
		this.ServeJSON()
		return
	}

	items := removeOrdinaryWords(removeInjection(form["search"].(string)))

	if len(items) < 1 {
		this.Data["json"] = map[string]interface{}{"error": "nothing_to_search"}
		this.ServeJSON()
		return
	}

	if len(items[0]) < 2 {
		this.Data["json"] = map[string]interface{}{"error": "nothing_to_search"}
		this.ServeJSON()
		return
	}

	fmt.Println("Items:", items)

	// search questions where text in items
	o := orm.NewOrm()

	query := "SELECT id, text FROM weydi_question WHERE "

	for i, v := range items {
		if i == 0 {
			query += " text LIKE '% " + v + "%'"
		} else {
			query += " OR text LIKE '% " + v + "%'"
		}
	}
	query += " LIMIT 10"
	questions := []orm.Params{}

	o.Raw(query).Values(&questions, "text", "id")

	this.Data["json"] = map[string]interface{}{"questions": questions}
	this.ServeJSON()
}

func removeOrdinaryWords(s string) []string {
	ORDINARY_WORDS := []string{" an ", " is ", " in ", " of ", " at ", " the ", " is ", " am ", " are "}
	for _, v := range ORDINARY_WORDS {
		strings.Replace(s, v, " ", -1)
	}
	words := strings.Split(s, " ")

	return words
}

func (this *QuestionAPIController) Post() {
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

	//decode request body to question
	form := map[string]interface{}{}
	err := json.NewDecoder(this.Ctx.Request.Body).Decode(&form)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "submitted_invalid_data"}
		this.ServeJSON()
		return
	}
	// check for empty fields
	if form["text"] == nil {
		this.Data["json"] = map[string]interface{}{"error": "question_text_required"}
		this.ServeJSON()
		return
	}
	question_text := string(form["text"].(string))
	question_description := ""
	if form["description"] != nil {
		question_description = string(form["description"].(string))
	}

	// Check for minimum password
	if len(question_text) < 5 || len(question_text) > 250 {
		this.Data["json"] = map[string]interface{}{"error": "question_should_be_5_to_250"}
		this.ServeJSON()
		return
	}
	//use data to initialize new question
	user := models.User{Id: user_id}
	question := models.Question{Description: question_description, Author: &user}
	question.SetText(question_text)

	o := orm.NewOrm()
	q_count, err := o.QueryTable(question).Filter("text_id__exact", question.TextId).Count()
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": err.Error()}
		this.ServeJSON()
		return
	}
	if q_count != 0 {
		this.Data["json"] = map[string]interface{}{"error": "got_same_question"}
		this.ServeJSON()
		return
	}

	o.Begin()
	question_id, err := o.Insert(&question)
	if err != nil {
		//DON'T SAVE ANYTHING
		o.Rollback()
		this.Data["json"] = map[string]interface{}{"error": "cannot_save_question", "err": err, "id": question_id}
		this.ServeJSON()
		return
	}
	o.Commit()
	this.Data["json"] = map[string]interface{}{"success": "add_question_success", "err": err}
	this.ServeJSON()
}

func (this *QuestionAPIController) Put() {
	sess_user := this.GetSession("current_user")
	question_id, err := strconv.Atoi(this.Ctx.Input.Param(":id"))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_question_id", "reason": err}
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
	question_text := ""
	if form["text"] != nil {
		question_text = string(form["text"].(string))
	}

	// Check for minimum password
	if len(question_text) > 0 && (len(question_text) < 5 || len(question_text) > 249) {
		this.Data["json"] = map[string]interface{}{"error": "question_should_be_5_to_250"}
		this.ServeJSON()
		return
	}

	o := orm.NewOrm()
	question := models.Question{Id: question_id}
	question.SetText(question_text)

	_, err = o.Update(&question)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "question_update_fail", "reason": err}
		this.ServeJSON()
		return
	}

	this.Data["json"] = map[string]interface{}{"success": "question_update_success"}
	this.ServeJSON()
}
