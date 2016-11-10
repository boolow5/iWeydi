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

func (this *ReactionAPIController) Prepare() {
	this.EnableXSRF = false
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
	item_id, err := strconv.Atoi(this.Ctx.Input.Param(":item_id"))
	if item_id < 1 || err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_item_id"}
		this.ServeJSON()
		return
	}
	// 3. set Like properties
	item_reaction := models.Like{}
	postive, err := strconv.ParseBool(this.Ctx.Input.Param(":postive"))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "unknown_reaction_type"}
		this.ServeJSON()
		return
	}
	item_reaction.Postive = postive
	item_reaction.User = &models.User{Id: user_id}

	o := orm.NewOrm()

	// 2. insert like with ordirany orm

	//row_count, err := o.Insert(&item_reaction)
	item_type, err := strconv.Atoi(this.Ctx.Input.Param(":item_type")) // item reaction type: 1. question, 2. answer, 3. comment
	if err != nil || (item_type < 1 || item_type > 3) {
		this.Data["json"] = map[string]interface{}{"error": "unknown_reaction_item_type", "reason": err}
		this.ServeJSON()
		return
	}
	var rawsetter orm.RawSeter
	fmt.Printf("Reaction type: %v \nTarget Item Type: %v\nItem id: %d\n", postive, item_type, item_id)
	if item_type == 1 {
		item_reaction.Question = &models.Question{Id: item_id}
		rawsetter = o.Raw("SELECT insert_question_like( ? , ?, ?)", postive, user_id, item_id)
	} else if item_type == 2 {
		item_reaction.Answer = &models.Answer{Id: item_id}
		rawsetter = o.Raw("SELECT insert_answer_like( ? , ?, ?)", postive, user_id, item_id)
	} else if item_type == 3 {
		item_reaction.Comment = &models.Comment{Id: item_id}
		rawsetter = o.Raw("SELECT insert_comment_like( ? , ?, ?)", postive, user_id, item_id)
	}

	fmt.Println(rawsetter)

	// TODO: check the postgres function to fix answer counter update;
	r_count, err := rawsetter.Exec()
	fmt.Println(err)
	fmt.Println(r_count)

	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "couldnt_save_reaction", "reason": err.Error()}
		this.ServeJSON()
		return
	}
	// 3. get sum of likes hates and send it as json
	var hate_love []orm.Params
	var rs orm.RawSeter
	it := "none"
	if item_type == 1 {
		it = "question"
		rs = o.Raw("SELECT (SELECT COUNT(id) FROM weydi_user_likes WHERE postive = true AND question_id = ?) AS love_count, (SELECT COUNT(id) FROM weydi_user_likes WHERE postive = false AND question_id = ?) AS hate_count;", item_id, item_id)
	}
	if item_type == 2 {
		it = "answer"
		rs = o.Raw("SELECT (SELECT COUNT(id) FROM weydi_user_likes WHERE postive = true AND answer_id = ?) AS love_count, (SELECT COUNT(id) FROM weydi_user_likes WHERE postive = false AND answer_id = ?) AS hate_count;", item_id, item_id)
	}
	if item_type == 3 {
		it = "comment"
		rs = o.Raw("SELECT (SELECT COUNT(id) FROM weydi_user_likes WHERE postive = true AND comment_id = ?) AS love_count, (SELECT COUNT(id) FROM weydi_user_likes WHERE postive = false AND comment_id = ?) AS hate_count;", item_id, item_id)
	}

	rs.Values(&hate_love)

	if len(hate_love) > 0 {
		this.Data["json"] = map[string]interface{}{"reactions": hate_love[0], "your_reaction_type": postive, "item_type": it}
		this.ServeJSON()
		return
	}
	this.Data["json"] = map[string]interface{}{"reactions": hate_love, "your_reaction_type": postive, "item_type": it}
	this.ServeJSON()
}
