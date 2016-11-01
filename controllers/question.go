package controllers

import (
	"strconv"

	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
)

type QuestionController struct {
	BaseController
}

func (this *QuestionController) GetQuestions() {
	o := orm.NewOrm()
	questions := []models.Question{}
	o.QueryTable("weydi_question").OrderBy("-created_at").All(&questions)
	this.Data["Questions"] = questions
	this.Data["Title"] = "questions"
	SetupCommonLayout("pages/questions/questions.tpl", &this.Controller)

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
