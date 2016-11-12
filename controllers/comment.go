package controllers

import (
	"html/template"
	"strconv"

	"github.com/astaxie/beego/orm"
)

type CommentController struct {
	BaseController
}

func (this *CommentController) CommentForm() {
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "pages/comments/add.tpl"
}
func (this *CommentController) GetComments() {
	this.TplName = "pages/comments/comments.tpl"

	parent_type, err := strconv.Atoi(this.Ctx.Input.Param(":parent_type")) // 1. question 2. answer 3. comment
	if err != nil {
		this.Data["error"] = err.Error()
		return
	}
	parent_id, err := strconv.Atoi(this.Ctx.Input.Param(":parent_id"))
	if err != nil {
		this.Data["error"] = err.Error()
		return
	}
	if parent_type > 3 || parent_type < 1 {
		this.Data["error"] = "unknown_comment_parent_type"
		return
	}
	if parent_id < 1 {
		this.Data["error"] = "comment_parent_id_should_be_greater_than_zero"
	}

	comments := []orm.Params{}
	o := orm.NewOrm()
	var rs orm.RawSeter
	if parent_type == 1 {
		rs = o.Raw("SELECT * FROM question_comments_view WHERE parent_id = ?", parent_id)
	} else if parent_type == 2 {
		rs = o.Raw("SELECT * FROM answer_comments_view WHERE parent_id = ?", parent_id)
	} else if parent_type == 3 {
		rs = o.Raw("SELECT * FROM comment_comments_view WHERE parent_id = ?", parent_id)
	}
	rs.Values(&comments, "id", "text", "author_name", "author_id", "parent_id", "love_count", "hate_count", "comment_count")
	this.Data["Comments"] = comments
}
