package controllers

import (
	"fmt"
	"strconv"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
)

type ReactionAPIController struct {
	beego.Controller
}

func (this *ReactionAPIController) PostAnswerReaction() {
	fmt.Println("PostReaction:")
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
	// 1. get answer id
	answer_id, err := strconv.Atoi(this.Ctx.Input.Param(":answer_id"))
	if answer_id < 1 || err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_answer_id"}
		this.ServeJSON()
		return
	}
	// 3. set Like properties
	answer_reaction := models.Like{}
	postive, err := strconv.ParseBool(this.Ctx.Input.Query("postive"))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "unknown_reaction_type"}
		this.ServeJSON()
		return
	}
	answer_reaction.Postive = postive
	answer_reaction.User = &models.User{Id: user_id}
	answer_reaction.Answer = &models.Answer{Id: answer_id}

	// 2. insert like with ordirany orm
	o := orm.NewOrm()
	//row_count, err := o.Insert(&answer_reaction)
	_, err = o.Raw("SELECT insert_like( ?, ? , NULL, ?)", postive, user_id, answer_id).Exec()

	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "couldnt_save_reaction", "reason": err.Error()}
		this.ServeJSON()
		return
	}
	// 3. get sum of likes hates and send it as json
	hate_love := []orm.Params{}
	o.Raw("SELECT (SELECT COUNT(id) FROM weydi_user_likes WHERE postive = true AND answer_id = ?) AS love_count, (SELECT COUNT(id) FROM weydi_user_likes WHERE postive = false AND answer_id = ?) AS hate_count;", answer_id, answer_id).Values(&hate_love)
	this.Data["json"] = map[string]interface{}{"reactions": hate_love}
	this.ServeJSON()
}
