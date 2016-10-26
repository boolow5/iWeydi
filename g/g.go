package g

import (
	"fmt"
	"os"
	//_ "github.com/go-sql-driver/mysql"
	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
	_ "github.com/lib/pq"
)

var (
	DATABASE_NAME      string
	DATABASE_HOST_NAME string
	DATABASE_PORT      string
	DATABASE_USER      string
	DATABASE_PASS      string

	RUN_MODE string
)

func InitEnv() {
	//GET DATABASE INFO FROM ENVIRONMENT VARIABLES
	DATABASE_HOST_NAME = os.Getenv("DATABASE_HOST_NAME")
	DATABASE_NAME = os.Getenv("DATABASE_NAME")
	DATABASE_USER = os.Getenv("DATABASE_USER")
	DATABASE_PASS = os.Getenv("DATABASE_PASS")
	DATABASE_PORT = os.Getenv("DATABASE_PORT")

	RUN_MODE = os.Getenv("RUN_MODE")

	//orm.RegisterDriver("mysql", orm.DRMySQL)
	orm.RegisterDriver("postgres", orm.DRPostgres)
	//orm.RegisterDataBase("default", "mysql", dbLink, maxIdleConn, maxOpenConn)

	orm.RegisterDataBase("default", "postgres", fmt.Sprintf("postgres://%s:%s@%s/%s?port=%i&sslmode=disable",
		DATABASE_USER, DATABASE_PASS, DATABASE_HOST_NAME, DATABASE_PORT, DATABASE_NAME))
	//orm.RegisterDataBase("default", "postgres", "user="+DATABASE_USER+" password="+DATABASE_PASS+" dbname="+DATABASE_NAME+" sslmode=disable")

	if RUN_MODE == "dev" {
		orm.Debug = true
	} else {
		orm.Debug = false
	}

	/*orm.RegisterModel(new(models.User), new(models.Profile), new(models.Question), new(models.Answer),
	new(models.Topic), new(models.Feed), new(models.Follower), new(models.Like))*/
	orm.RegisterModelWithPrefix("weydi_", new(models.User), new(models.Profile), new(models.Question),
		new(models.Answer), new(models.Topic), new(models.Feed), new(models.Follower), new(models.Like),
		new(models.QuestionComment), new(models.AnswerComment))
	//orm.RunCommand()
}
