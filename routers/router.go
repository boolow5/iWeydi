package routers

import (
	"github.com/boolow5/iWeydi/controllers"
	"github.com/astaxie/beego"
)

func init() {
    beego.Router("/", &controllers.MainController{})
}
