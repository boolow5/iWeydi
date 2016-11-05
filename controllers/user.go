package controllers

import (
	"encoding/json"
	"fmt"
	"strings"

	"golang.org/x/crypto/bcrypt"

	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
)

type UserController struct {
	BaseController
}

func (this *UserController) GetProfile() {
	this.Data["Title"] = "profile"
	SetupCommonLayout("pages/user/profile.tpl", &this.Controller)

	current_user := this.GetSession("current_user")
	if current_user != nil {
		this.Data["UserInfo"] = current_user.(map[string]interface{})
	}
}
func (this *UserController) Register() {
	if IsAuthenticated(&this.Controller) {
		this.Redirect("/", 302)
	}
	this.Data["Title"] = "register"
	SetupCommonLayout("pages/user/register1.tpl", &this.Controller)
}

func (this *UserController) PostUser() {
	if IsAuthenticated(&this.Controller) {
		this.Redirect("/", 302)
	}

	//decode request body to user
	fmt.Println("Registering new user")
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

	sess_user := map[string]interface{}{}
	sess_user["id"] = user.Id
	sess_user["email"] = user.Email

	full_name := user.Profile.FirstName + " " + user.Profile.LastName
	if len(full_name) > 1 {
		sess_user["full_name"] = user.Profile.FirstName + " " + user.Profile.LastName
	} else if len(email) > 0 {
		username := strings.Split(user.Email, "@")
		if len(username) > 0 {
			sess_user["full_name"] = username[0]
		} else {
			sess_user["full_name"] = "Your name"
		}
	}

	this.SetSession("current_user", sess_user)

	this.Data["json"] = map[string]interface{}{"success": "register_success", "err": err}
	this.ServeJSON()
}

func (this *UserController) Login() {
	if IsAuthenticated(&this.Controller) {
		this.Redirect("/", 302)
	}
	this.Data["Title"] = "login"
	SetupCommonLayout("pages/user/login.tpl", &this.Controller)
}

func (this *UserController) GetLogout() {
	this.Redirect("/", 302)
}

func (this *UserController) PostLogin() {
	if IsAuthenticated(&this.Controller) {
		this.Redirect("/", 302)
	}
	form := map[string]interface{}{}
	err := json.NewDecoder(this.Ctx.Request.Body).Decode(&form)
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "submitted_invalid_data"}
		this.ServeJSON()
		return
	}
	if form["email"] == nil {
		this.Data["json"] = map[string]interface{}{"error": "email_required"}
		this.ServeJSON()
		return
	}
	if form["password"] == nil {
		this.Data["json"] = map[string]interface{}{"error": "password_required"}
		this.ServeJSON()
		return
	}

	email := form["email"].(string)
	password := form["password"].(string)

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

	o := orm.NewOrm()
	user := models.User{Email: email}
	o.QueryTable("weydi_auth_user").Filter("Email__exact", email).RelatedSel().One(&user)
	if user.Id == 0 {
		this.Data["json"] = map[string]interface{}{"error": "wrong_email_or_password"}
		this.ServeJSON()
		return
	}
	//o.QueryTable("weydi_user_profile").Filter("Id", user.Profile.Id).One(user.Profile)

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password))
	if err != nil {
		this.Data["json"] = map[string]interface{}{"error": "wrong_email_or_password"}
		this.ServeJSON()
		return
	}
	user.Password = "hidden_for_security"

	sess_user := map[string]interface{}{}
	sess_user["id"] = user.Id
	sess_user["email"] = user.Email

	full_name := user.Profile.FirstName + " " + user.Profile.LastName
	if len(full_name) > 1 {
		sess_user["full_name"] = user.Profile.FirstName + " " + user.Profile.LastName
	} else if len(email) > 0 {
		username := strings.Split(user.Email, "@")
		if len(username) > 0 {
			sess_user["full_name"] = username[0]
		} else {
			sess_user["full_name"] = "Your name"
		}
	}

	this.SetSession("current_user", sess_user)

	this.Data["json"] = map[string]interface{}{"success": "login_success", "err": err}
	this.ServeJSON()
	return
}

func (this *UserController) Logout() {
	this.DelSession("current_user")
	this.DelSession("full_name")
	this.Redirect("/", 302)
}
