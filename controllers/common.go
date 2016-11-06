package controllers

import (
	"fmt"
	"html/template"
	"strconv"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

var ALLOWED_HOSTS = "localhost"
var MY_USER_ID = 0

func SetupCommonLayout(tplName string, controller *beego.Controller) {
	fmt.Println("SetupCommonLayout")
	controller.Layout = "layouts/base.tpl"
	controller.TplName = tplName
	controller.LayoutSections = make(map[string]string)
	//controller.LayoutSections["HtmlHead"] = "partials/html_head.tpl"
	//controller.LayoutSections["Scripts"] = "partials/scripts.tpl"
	//controller.LayoutSections["Sidebar"] = "partials/sidebar.tpl"
	controller.LayoutSections["NavPills"] = "partials/nav-pills.tpl"
	controller.Data["LoggedIn"] = IsAuthenticated(controller)
	controller.Data["NotLoggedIn"] = !IsAuthenticated(controller)

	controller.Data["xsrf_token"] = controller.XSRFToken()
	controller.XSRFExpire = 7200
	controller.Data["xsrfdata"] = template.HTML(controller.XSRFFormHTML())

	current_user := controller.GetSession("current_user")
	if current_user != nil {
		user := current_user.(map[string]interface{})
		controller.Data["FullName"] = user["full_name"]
		id, _ := strconv.Atoi(string(user["id"].(int)))
		controller.Data["MyID"] = id
		fmt.Println("-----id", id)
		MY_USER_ID = id
	}
}

func GetIDFromSession(mp map[string]interface{}) int {
	id := 0
	if mp != nil {
		id, _ = mp["id"].(int)
	}
	return id
}

func GetUsersYouFollow(controller *beego.Controller, my_id int) (users_ids []int) {
	o := orm.NewOrm()
	// select followee_id  from weydi_item_follower where user_id = 1;
	// i, err := o.QueryTable("weydi_item_follower").Filter("user__id__exact", my_id).All(&users_ids, "followee_id")
	ids := []orm.Params{}
	o.Raw("SELECT followee_id FROM weydi_item_follower WHERE user_id = ?", my_id).Values(&ids, "followee_id")
	fmt.Println("ids:\n", ids)
	for _, v := range ids {
		value, err := strconv.Atoi(v["followee_id"].(string))
		if err == nil && value > 0 {
			users_ids = append(users_ids, (value))
		}
	}
	return users_ids
}

func ReporError(errMessage string, controller *beego.Controller) {
	controller.Data["Error"] = errMessage
}

func IsAuthenticated(this *beego.Controller) bool {
	current_user := this.GetSession("current_user")
	if current_user == nil {
		return false
	}

	return true
}

func IsAllowedHost(current_host string) bool {
	allowed_hosts := strings.Split(ALLOWED_HOSTS, ";")
	for _, host := range allowed_hosts {
		if current_host == host {
			return true
		}
	}
	return false
}
