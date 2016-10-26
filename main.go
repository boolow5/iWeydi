package main

import (
	"github.com/astaxie/beego"
	"github.com/boolow5/iWeydi/g"
	_ "github.com/boolow5/iWeydi/routers"
)

func main() {
	g.InitEnv()
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

	beego.Run()
}
