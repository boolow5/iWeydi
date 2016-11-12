package routers

import (
	"github.com/astaxie/beego"
	"github.com/boolow5/iWeydi/controllers"
)

func init() {
	// GENERAL
	// NORMAL
	beego.Router("/", &controllers.MainController{}, "*:Home")
	beego.Router("/about", &controllers.MainController{}, "get:GetAbout")

	// USER AND AUTHS
	// API
	beego.Router("/api/user", &controllers.UserAPIController{}, "get:Get;post:Post")
	beego.Router("/api/user/:id", &controllers.UserAPIController{}, "get:GetOne;put:Put")
	//beego.Router("/api/user/login", &controllers.UserAPIController{}, "post:Login")
	//beego.Router("/api/user/logout", &controllers.UserAPIController{}, "get:Logout")
	// NORMAL
	beego.Router("/user/profile", &controllers.UserController{}, "get:GetProfile")
	beego.Router("/user/register", &controllers.UserController{}, "get:Register;post:PostUser")
	beego.Router("/user/login", &controllers.UserController{}, "get:Login;post:PostLogin")
	beego.Router("/user/logout", &controllers.UserController{}, "*:Logout")

	// QUESTION
	// API
	beego.Router("/question/:id", &controllers.QuestionController{}, "get:GetOneQuestion")

	// NORMAL
	beego.Router("/questions", &controllers.QuestionController{}, "get:GetQuestions")
	beego.Router("/question", &controllers.QuestionController{}, "get:AddQuestion")

	// ANSWERS
	// API
	beego.Router("/api/answer/:question_id", &controllers.AnswerAPIController{}, "post:PostAnswer")
	beego.Router("/api/answer/:answer_id", &controllers.AnswerAPIController{}, "put:PutAnswer")
	// NORMAL
	beego.Router("/answer/:id", &controllers.AnswerController{}, "get:GetAnswer")

	// COMMENT
	// API
	beego.Router("/api/comment", &controllers.CommentAPIController{}, "post:PostComment;put:PutComment")
	// NORMAL
	beego.Router("/comment", &controllers.CommentController{}, "get:CommentForm")
	beego.Router("/comments/:parent_type/:parent_id", &controllers.CommentController{}, "get:GetComments")

	// LIKES
	// API
	beego.Router("/api/reaction/:item_id/:postive/:item_type", &controllers.ReactionAPIController{}, "post:PostAnswerReaction")

	// FOLLOW
	// API

	// MISC
	beego.Router("/translate/:word/:args", &controllers.MiscAPIController{}, "*:GetTranslation")

	beego.Router("/api/question", &controllers.QuestionAPIController{}, "post:Post")
}
