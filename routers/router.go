package routers

import (
	"github.com/astaxie/beego"
	"github.com/boolow5/iWeydi/controllers"
)

func init() {
	beego.Router("/", &controllers.MainController{})

	beego.Router("/api/user", &controllers.UserAPIController{}, "get:Get;post:Post")
}
