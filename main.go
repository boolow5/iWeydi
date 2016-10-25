package main

import (
	"github.com/astaxie/beego"
	"github.com/boolow5/iWeydi/g"
	_ "github.com/boolow5/iWeydi/routers"
)

func main() {
	g.InitEnv()
	beego.Run()
}
