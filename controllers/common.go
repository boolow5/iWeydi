package controllers

import (
	"fmt"
	"html/template"
	"strings"

	"github.com/astaxie/beego"
)

var ALLOWED_HOSTS = "localhost"

func SetupCommonLayout(tplName string, controller *beego.Controller) {
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
		controller.Data["MyID"] = user["id"]
	}
}

func ReporError(errMessage string, controller *beego.Controller) {
	controller.Data["Error"] = errMessage
}

func IsAuthenticated(this *beego.Controller) bool {
	sess_user := this.GetSession("current_user")
	fmt.Println("******************** CURRENT USER *************************")
	fmt.Println(sess_user)
	if sess_user == nil {
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
