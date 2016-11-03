package controllers

import (
	"encoding/json"
	"fmt"
	"strconv"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
)

type UserAPIController struct {
	beego.Controller
}

func (this *UserAPIController) Prepare() {
	//this.EnableXSRF = false
}

func (this *UserAPIController) GetOne() {
	id, err := strconv.Atoi(this.Ctx.Input.Param(":id"))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_user_id", "err": err}
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

func (this *UserController) Post() {
	//decode request body to user
	form := map[string]interface{}{}
	err := json.NewDecoder(this.Ctx.Request.Body).Decode(&form)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "submitted_invalid_data"}
		this.ServeJSON()
		return
	}
	// check for empty fields
	if form["email"] == nil || form["password"] == nil {
		this.Data["json"] = map[string]interface{}{"error": "wrong_email_or_password"}
		this.ServeJSON()
		return
	}
	password := string(form["password"].(string))
	email := string(form["email"].(string))

	if len(email) < 5 {
		this.Data["json"] = map[string]interface{}{"error": "short_email"}
		this.ServeJSON()
		return
	}
	if len(password) < 5 {
		this.Data["json"] = map[string]interface{}{"error": "short_password"}
		this.ServeJSON()
		return
	}

	// Check for minimum password
	if len(password) < 5 || len(password) > 16 {
		this.Data["json"] = map[string]interface{}{"error": "password_should_be_5_to_16_chars"}
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

	if form["first_name"] != nil {
		profile.FirstName = string(form["first_name"].(string))
	}
	if form["last_name"] != nil {
		profile.LastName = string(form["last_name"].(string))
	}

	fmt.Println("Profile: ")
	fmt.Println(profile)

	user.Profile = &profile

	// save the new user to database
	exist_user := models.User{}
	exist_user.Email = user.Email
	o := orm.NewOrm()
	if count, err := o.QueryTable(exist_user).Filter("Email", user.Email).Count(); count > 0 {
		this.Data["json"] = map[string]interface{}{"error": "email_already_exists", "err": err}
		this.ServeJSON()
		return
	}
	// START TRANSACTION
	o.Begin()
	id, err := o.Insert(&profile)
	if err != nil {
		//DON'T SAVE PROFILE
		o.Rollback()
		this.Data["json"] = map[string]interface{}{"error": "cannot_save_profile", "err": err, "id": id}
		this.ServeJSON()
		return
	}
	id2, err2 := o.Insert(&user)
	if err2 != nil {
		// DON'S SAVE PROFILE AND USER
		o.Rollback()
		this.Data["json"] = map[string]interface{}{"error": "cannot_save_user", "err2": err2, "id": id2}
		this.ServeJSON()
		return
	}
	//SAVE BOTH
	o.Commit()
	this.Data["json"] = map[string]interface{}{"success": "register_success", "err": err}
	this.ServeJSON()
}

func (this *UserController) Put() {
	sess_user := this.GetSession("current_user")
	//current_user := map[string]interface{}{"id": "2"}
	if sess_user == nil {
		this.Data["json"] = map[string]interface{}{"error": "not_logged_in"}
		this.ServeJSON()
		return
	}
	current_user := sess_user.(map[string]interface{})
	id, err := strconv.Atoi(current_user["id"].(string))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "invalid_user_id"}
		this.ServeJSON()
		return
	}

	form := map[string]interface{}{}
	err = json.NewDecoder(this.Ctx.Request.Body).Decode(&form)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "submitted_invalid_data"}
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
		this.Data["json"] = map[string]interface{}{"error": "password_should_be_5_to_16_chars"}
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
			this.Data["json"] = map[string]interface{}{"warning": "no_changes_to_update", "num": num}
			this.ServeJSON()
			return
		}
		if num, err = o.Update(&user); err == nil {
			this.Data["json"] = map[string]interface{}{"success": "update_success", "num": num}
			this.ServeJSON()
			return
		}
	}
	this.Data["json"] = map[string]interface{}{"error": "cannot_update", "err": err}
	this.ServeJSON()
}
