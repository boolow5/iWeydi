package models

import (
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego/orm"
)

type Question struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text        string `json:"text" orm:"unique;size(300)"`
	TextId      string `json:"text_id" orm:"unique;size(310)"`
	Description string `json:"description" orm:"null;size(600)"`
	Author      *User  `json:"author" orm:"rel(fk);on_delete(cascade)"`

	Language *Language `json:"language" orm:"rel(fk);on_delete(set_null);null"`

	Comments []*QuestionComment `json:"comments" orm:"-"`
	LikedBy  []User             `json:"i_liked_this" orm:"-"`
	HatedBy  []User             `json:"i_liked_this" orm:"-"`
}

func (q *Question) TableName() string {
	return "question"
}
func (q *Question) String() string {
	return q.Text
}
func (q *Question) SetText(text string) {
	q.Text = text
	q.TextId = strings.Replace(q.Text, " ", "-", -1)
}
func (q *Question) LoveCount(id int) (count int64) {
	fmt.Println("LoveCount: id = ", id)
	user_ids := []orm.Params{}

	o := orm.NewOrm()
	like := Like{}
	count, _ = o.QueryTable(like).Filter("question_id__exact", q.Id).Filter("postive", true).Count()

	_, err := o.Raw("SELECT user_id FROM weydi_user_likes WHERE question_id = ? AND postive = ?;", q.Id, true).Values(&user_ids)
	if err != nil {
		//q.LikedBy = ids
	}
	users := []User{}
	for _, val := range user_ids {
		id, err := strconv.Atoi(val["user_id"].(string))
		if id > 0 && err == nil {
			users = append(users, User{Id: id})
		}
	}

	q.LikedBy = users

	fmt.Println("LikedBy")
	fmt.Println(q.LikedBy)

	return
}

func (q *Question) HateCount(id int) (count int64) {
	fmt.Println("HateCount: id = ", id)
	user_ids := []orm.Params{}

	o := orm.NewOrm()
	like := Like{}
	var err error
	count, err = o.QueryTable(like).Filter("question_id__exact", q.Id).Filter("postive", false).Count()
	if err != nil {
		fmt.Println("HateCount Error:")
		fmt.Println(err)
	}

	_, err = o.Raw("SELECT user_id FROM weydi_user_likes WHERE question_id = ? AND postive = ?;", q.Id, true).Values(&user_ids)
	if err != nil {
		//q.LikedBy = &[]int(user_ids)
	}

	users := []User{}
	for _, val := range user_ids {
		id, err := strconv.Atoi(val["user_id"].(string))
		if id > 0 && err == nil {
			users = append(users, User{Id: id})
		}
	}

	q.HatedBy = users

	fmt.Println("HatedBy")
	fmt.Println(q.LikedBy)

	return
}

func (q *Question) CommentCount() (count int64) {
	question_comment := QuestionComment{}
	o := orm.NewOrm()
	count, _ = o.QueryTable(question_comment).Filter("question_id__exact", q.Id).Count()
	fmt.Println("CommentCount:", count)
	return
}

type QuestionComment struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text     string    `json:"text" orm:"size(500)"`
	Author   *User     `json:"author" orm:"rel(fk);on_delete(cascade)"`
	Question *Question `json:"question" orm:"rel(fk);on_delete(cascade)"`
}

func (qc *QuestionComment) TableName() string {
	return "question_comment"
}

func (qc *QuestionComment) String() string {
	return qc.Text
}
