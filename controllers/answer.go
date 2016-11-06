package controllers

import (
	"strconv"

	"github.com/astaxie/beego/orm"
	"github.com/beego/i18n"

	"github.com/boolow5/iWeydi/models"
)

type AnswerController struct {
	BaseController
}

func (this *AnswerController) GetAnswer() {
	lang := this.Data["Lang"].(string)
	answer_id, err := strconv.Atoi(this.Ctx.Input.Param(":id"))
	if err != nil {
		this.Ctx.Abort(404, i18n.Tr(lang, "answer_not_found"))
	}
	answer := models.Answer{Id: answer_id}
	o := orm.NewOrm()
	err = o.QueryTable(&answer).Filter("id", answer_id).One(&answer)
	if err != nil {
		this.Ctx.Abort(404, i18n.Tr(lang, "answer_not_found"))
	}
	o.QueryTable(answer.Question).One(answer.Question)
	profile := models.Profile{}
	err = o.QueryTable("weydi_user_profile").Filter("id", answer.Author.Id).One(&profile)

	answer.Author.Profile = &profile
	this.Data["Answer"] = answer
	this.Data["Question"] = answer.Question
	this.Data["Title"] = i18n.Tr(lang, "answer") + ": " + answer.Question.Text
	SetupCommonLayout("pages/answers/answer.tpl", &this.Controller)
}
