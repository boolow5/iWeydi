package controllers

import (
	"github.com/astaxie/beego"
)

type UserAPIController struct {
	beego.Controller
}

func (this *UserAPIController) Get() {
	this.Data["json"] = map[string]interface{}{"user": "No users yet added"}
	this.ServeJSON()
}

func (this *UserAPIController) Post() {
	this.Data["json"] = map[string]interface{}{"success": "Successfully registred new user"}
	this.ServeJSON()
}
