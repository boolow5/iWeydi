package controllers

type MainController struct {
	BaseController
}

func (this *MainController) Home() {
	SetupCommonLayout("pages/home.tpl", &this.Controller)
	this.Data["Title"] = "home"
}

func (this *MainController) GetAbout() {
	this.Data["Title"] = "About"
	SetupCommonLayout("pages/about.tpl", &this.Controller)
}
