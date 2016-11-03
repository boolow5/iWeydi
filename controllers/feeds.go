package controllers

import (
	"fmt"

	"github.com/astaxie/beego/orm"
)

type FeedController struct {
	BaseController
}

func (this *FeedController) GetFeed() {
	SetupCommonLayout("pages/feeds/feeds.tpl", &this.Controller)
	o := orm.NewOrm()

	fmt.Println("CREATING FEED ARRAY -------------------------------------------------------------------")
	feeds := []orm.Params{}
	o.Raw("SELECT * FROM feeds_view").Values(&feeds)

	this.Data["Feed"] = feeds
	this.Data["Title"] = "feeds"
}
func (this *FeedController) GetOneFeed() {
	SetupCommonLayout("pages/feeds/question.tpl", &this.Controller)
	/*
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

		question := models.Feed{}
		answers := []models.Answer{}
		o.QueryTable("weydi_question").Filter("id", question_id).One(&question)
		o.QueryTable("weydi_answer").Filter("question_id__exact", question.Id)

		this.Data["Feed"] = question
		this.Data["Answers"] = answers
		this.Data["Title"] = question.Text
	*/
}
func (this *FeedController) AddFeed() {
	this.Data["Title"] = "add_feed"
	SetupCommonLayout("pages/feeds/add.tpl", &this.Controller)
}
