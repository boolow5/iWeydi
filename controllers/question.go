package controllers

import (
	"fmt"
	"strconv"

	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
)

type QuestionController struct {
	BaseController
}

func (this *QuestionController) GetQuestions() {
	SetupCommonLayout("pages/questions/questions.tpl", &this.Controller)
	o := orm.NewOrm()
	questions := []models.Question{}
	current_user := this.GetSession("current_user")
	id := 0
	if current_user != nil {
		id = GetIDFromSession(current_user.(map[string]interface{}))
	}
	if id > 0 {
		MY_USER_ID = id
	}
	fmt.Println("MY_USER_ID", MY_USER_ID)
	if MY_USER_ID > 0 {
		users_you_follow := GetUsersYouFollow(&this.Controller, MY_USER_ID)
		fmt.Println("Users You Follow:", users_you_follow)

		if len(users_you_follow) < 1 {
			o.QueryTable("weydi_question").OrderBy("-created_at").All(&questions)
			this.Data["Questions"] = questions
			this.Data["Title"] = "questions"
			return
		}

		o.QueryTable("weydi_question").Filter("author__id__in", users_you_follow).OrderBy("-created_at").All(&questions)
	}

	this.Data["Questions"] = questions
	this.Data["Title"] = "questions"
}
func (this *QuestionController) GetOneQuestion() {
	SetupCommonLayout("pages/questions/question.tpl", &this.Controller)

	id := this.Ctx.Input.Param(":id")
	question_id := 0
	var err error

	if len(id) == 0 {
		ReporError("No question id is empty", &this.Controller)
		return
	}
	question_id, err = strconv.Atoi(id)

	if err != nil {
		ReporError("Wrong question id format", &this.Controller)
		return
	}

	if question_id == 0 {
		ReporError("No question id", &this.Controller)
		return
	}

	o := orm.NewOrm()

	question := models.Question{}
	answers := []models.Answer{}
	o.QueryTable("weydi_question").Filter("id", question_id).One(&question)
	o.QueryTable("weydi_answer").Filter("question_id__exact", question.Id)

	this.Data["Question"] = question
	this.Data["Answers"] = answers
	this.Data["Title"] = question.Text

}
func (this *QuestionController) AddQuestion() {
	this.Data["Title"] = "add_question"
	SetupCommonLayout("pages/questions/add.tpl", &this.Controller)
}
