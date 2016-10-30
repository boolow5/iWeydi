package main

import (
	"github.com/astaxie/beego"
	"github.com/beego/i18n"
	"github.com/boolow5/iWeydi/controllers"
	"github.com/boolow5/iWeydi/g"
	_ "github.com/boolow5/iWeydi/routers"
)

func main() {
	g.InitEnv()
	controllers.InitLocales()
	/*
		// USED ONLY WHEN YOU CHANGE MODELS
		// Database alias.
		name := "default"

		// Drop table and re-create.
		force := true

		// Print log.
		verbose := true

		// Error.
		err := orm.RunSyncdb(name, force, verbose)
		if err != nil {
			fmt.Println(err)
		}
	*/
	beego.ErrorHandler("404", NotFoundHandler)
	beego.ErrorHandler("500", InternalErrorHandler)

	//i18n function for translations
	beego.AddFuncMap("i18n", i18n.Tr)
	beego.AddFuncMap("eq", func(a, b interface{}) bool {
		return a == b
	})

	beego.AddFuncMap("neq", func(a, b interface{}) bool {
		return a != b
	})

	beego.AddFuncMap("len", func(a ...interface{}) int {
		return len(a)
	})

	beego.AddFuncMap("isZeroLen", func(a ...interface{}) bool {
		return len(a) == 0
	})
	beego.AddFuncMap("isNotZeroLen", func(a ...interface{}) bool {
		return len(a) != 0
	})

	beego.Run()
}
