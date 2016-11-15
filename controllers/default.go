package controllers

import (
	"fmt"

	"github.com/astaxie/beego/orm"
)

type MainController struct {
	BaseController
}

func (this *MainController) Home() {
	SetupCommonLayout("pages/home.tpl", &this.Controller)
	this.Data["Title"] = "home"

	feedItems := []orm.Params{}
	o := orm.NewOrm()
	o.Raw("SELECT * FROM answer_activity_view ORDER BY id DESC").Values(&feedItems, "id", "created_at", "updated_at", "text", "question_text", "user_id", "doer", "q_id", "comment_count", "love_count", "hate_count", "avatar_url")
	fmt.Println("FEEDS COUNT: ", len(feedItems))

	this.Data["Feeds"] = feedItems
}

func (this *MainController) GetAbout() {
	this.Data["Title"] = "About"
	SetupCommonLayout("pages/about.tpl", &this.Controller)
}
