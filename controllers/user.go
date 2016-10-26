package controllers

import (
	"encoding/json"
	"strconv"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
)

type UserAPIController struct {
	beego.Controller
}

func (this *UserAPIController) GetOne() {
	id, err := strconv.Atoi(this.Ctx.Input.Param(":id"))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "Invalid user ID format", "err": err}
		this.ServeJSON()
		return
	}
	o := orm.NewOrm()
	user := models.User{Id: id}
	err = o.Read(&user)
	profile := models.Profile{Id: id}
	err = o.Read(&profile)
	user.Profile = &profile
	this.Data["json"] = map[string]interface{}{"user": user, "err": err}
	this.ServeJSON()
}

func (this *UserAPIController) Get() {
	o := orm.NewOrm()
	var user models.User
	var users []models.User
	num, err := o.QueryTable(user).All(&users)
	this.Data["json"] = map[string]interface{}{"users": users, "num": num, "err": err}
	this.ServeJSON()
}

func (this *UserAPIController) Post() {
	//decode request body to user
	form := map[string]interface{}{}
	err := json.NewDecoder(this.Ctx.Request.Body).Decode(&form)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "Submitted an invalid data"}
		this.ServeJSON()
		return
	}
	// check for empty fields
	if form["email"] == nil || form["password"] == nil {
		this.Data["json"] = map[string]interface{}{"error": "Both Email and Password are required"}
		this.ServeJSON()
		return
	}
	password := string(form["password"].(string))
	email := string(form["email"].(string))
	// Check for minimum password
	if len(password) < 5 || len(password) > 16 {
		this.Data["json"] = map[string]interface{}{"error": "Password should be 5 - 16 characters"}
		this.ServeJSON()
		return
	}
	//use data to initialize new user
	user := models.User{
		Email:    email,
		Password: password,
	}
	user.HashPassword()
	profile := models.Profile{}
	user.Profile = &profile

	// save the new user to database
	exist_user := models.User{}
	exist_user.Email = user.Email
	o := orm.NewOrm()
	if count, err := o.QueryTable(exist_user).Filter("Email", user.Email).Count(); count > 0 {
		this.Data["json"] = map[string]interface{}{"error": "User with this email already exists", "err": err}
		this.ServeJSON()
		return
	}
	// START TRANSACTION
	o.Begin()
	id, err := o.Insert(&profile)
	if err != nil {
		//DON'T SAVE PROFILE
		o.Rollback()
		this.Data["json"] = map[string]interface{}{"error": "Cannot save profile", "err": err, "id": id}
		this.ServeJSON()
		return
	}
	id2, err2 := o.Insert(&user)
	if err2 != nil {
		// DON'S SAVE PROFILE AND USER
		o.Rollback()
		this.Data["json"] = map[string]interface{}{"error": "Cannot save user", "err2": err2, "id": id2}
		this.ServeJSON()
		return
	}
	//SAVE BOTH
	o.Commit()
	this.Data["json"] = map[string]interface{}{"success": "Successfully registred new user", "err": err}
	this.ServeJSON()
}

func (this *UserAPIController) Put() {
	sess_user := this.GetSession("current_user")
	//current_user := map[string]interface{}{"id": "2"}
	if sess_user == nil {
		this.Data["json"] = map[string]interface{}{"error": "You are not logged in"}
		this.ServeJSON()
		return
	}
	current_user := sess_user.(map[string]interface{})
	id, err := strconv.Atoi(current_user["id"].(string))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "Invalid user ID"}
		this.ServeJSON()
		return
	}

	form := map[string]interface{}{}
	err = json.NewDecoder(this.Ctx.Request.Body).Decode(&form)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "Submitted an invalid data"}
		this.ServeJSON()
		return
	}
	email := ""
	password := ""
	if form["password"] != nil {
		password = string(form["password"].(string))
	}
	if form["email"] != nil {
		email = string(form["email"].(string))
	}
	// Check for minimum password
	if len(password) > 0 && (len(password) < 5 || len(password) > 16) {
		this.Data["json"] = map[string]interface{}{"error": "Password should be 5 - 16 characters"}
		this.ServeJSON()
		return
	}
	// get old user data
	user := models.User{Id: id}
	o := orm.NewOrm()
	var num int64
	password_changed, email_changed := false, false
	if o.Read(&user) == nil {
		if len(password) > 4 && len(password) < 17 {
			user.Password = password
			user.HashPassword()
			password_changed = true
		}
		if user.Email != email {
			user.Email = email
			email_changed = true
		}
		if email_changed == false && password_changed == false {
			this.Data["json"] = map[string]interface{}{"warning": "There was no any changes to save", "num": num}
			this.ServeJSON()
			return
		}
		if num, err = o.Update(&user); err == nil {
			this.Data["json"] = map[string]interface{}{"success": "Successfully updated user", "num": num}
			this.ServeJSON()
			return
		}
	}
	this.Data["json"] = map[string]interface{}{"error": "Could not update user", "err": err}
	this.ServeJSON()
}
