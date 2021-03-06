package g

import (
	"fmt"
	"os"
	//_ "github.com/go-sql-driver/mysql"
	"github.com/astaxie/beego/orm"
	"github.com/boolow5/iWeydi/models"
	_ "github.com/lib/pq"

	"github.com/astaxie/beego/session"
	_ "github.com/astaxie/beego/session/redis"
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

	globalSessions, _ := session.NewManager("redis", `{"cookieName":"gosessionid","gclifetime":3600,"ProviderConfig":"127.0.0.1:6379"}`)
	go globalSessions.GC()

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
	//////////////////////////////// postgres://user:password@host/database?port=port_number \\\\\\\\\\\\\\\\\\\\\\\\\\\\\
	db_source_string := fmt.Sprintf("postgres://%s:%s@%s/%s?port=%s", DATABASE_USER, DATABASE_PASS, DATABASE_HOST_NAME, DATABASE_NAME, DATABASE_PORT)
	//session_db_str := fmt.Sprintf("postgres://%s:%s@%s/%s?sslmode=verify-full", DATABASE_USER, DATABASE_PASS, DATABASE_HOST_NAME, DATABASE_NAME)

	orm.RegisterDataBase("default", "postgres", db_source_string)
	//orm.RegisterDataBase("default", "postgres", "user="+DATABASE_USER+" password="+DATABASE_PASS+" dbname="+DATABASE_NAME+" sslmode=disable")
	if RUN_MODE == "dev" {
		orm.Debug = true
	} else {
		orm.Debug = false
	}

	/*orm.RegisterModel(new(models.User), new(models.Profile), new(models.Question), new(models.Answer),
	new(models.Topic), new(models.Feed), new(models.Follower), new(models.Like))*/
	orm.RegisterModelWithPrefix("weydi_", new(models.User), new(models.Profile), new(models.Conference), new(models.Question),
		new(models.Answer), new(models.Topic), new(models.Follower), new(models.Like),
		new(models.CommentParent), new(models.Comment), new(models.Language), new(models.ActivityType), new(models.Activity))
	//orm.RunCommand()

}
