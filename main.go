package main

import (
	"fmt"
	"html/template"
	"net/http"
	"strings"

	"github.com/astaxie/beego"
	"github.com/beego/i18n"
	"github.com/boolow5/iWeydi/controllers"
	"github.com/boolow5/iWeydi/g"
	_ "github.com/boolow5/iWeydi/routers"
	"github.com/slene/blackfriday"
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

	beego.AddFuncMap("markdown", func(args ...interface{}) template.HTML {
		s := blackfriday.MarkdownCommon([]byte(fmt.Sprintf("%s", args...)))
		return template.HTML(s)
	})

	beego.AddFuncMap("shorten_makrdown", func(markdown string, desired_length int) string /*template.HTML*/ {
		var str string
		if len(markdown) > desired_length {
			str = markdown[:desired_length]
			str = strings.TrimSpace(str)
			str += "..."
		} else {
			str = markdown
		}

		str = strings.Replace(str, "*", "", -1)
		str = strings.Replace(str, "#", "", -1)
		str = strings.Replace(str, "\n", "", -1)

		//s := blackfriday.MarkdownCommon([]byte(fmt.Sprintf("%s", str)))
		//return template.HTML(s)
		return str
	})

	beego.Run()
}

// ERROR HANDLERS
func NotFoundHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("404 - NOT FOUND"))
}

func InternalErrorHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("500 - INTERNAL ERROR"))
}
