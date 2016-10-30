package controllers

import (
	"strconv"
	"strings"

	"github.com/astaxie/beego"
	"github.com/beego/i18n"
)

type MiscAPIController struct {
	beego.Controller
}

func (this *MiscAPIController) Prepare() {
	this.EnableXSRF = false
}

func (this *MiscAPIController) GetTranslation() {
	word := this.Ctx.Input.Param(":word")
	raw_args := strings.Split(this.Ctx.Input.Param(":args"), ",")
	var args []interface{}
	for i := 0; i < len(raw_args); i++ {
		n, err := strconv.Atoi(raw_args[i])
		if err == nil {
			args = append(args, n)
		} else {
			args = append(args, raw_args[i])
		}
	}
	lang := this.Ctx.GetCookie("lang")

	meaning := ""

	if args[0] == -1 {
		meaning = i18n.Tr(lang, word, nil)
	} else {
		meaning = i18n.Tr(lang, word, args)
	}

	this.Data["json"] = map[string]interface{}{"meaning": meaning}
	this.ServeJSON()
}
