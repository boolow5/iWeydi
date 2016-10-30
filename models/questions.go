package models

import "time"

type Question struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text        string `json:"text" orm:"unique;size(300)"`
	Description string `json:"description" orm:"null;size(600)"`
	Author      *User  `json:"author" orm:"rel(fk);on_delete(cascade)"`

	Language *Language `json:"language" orm:"rel(fk);on_delete(set_null);null"`

	Comments []*QuestionComment `json:"comments" orm:"-"`
}

func (q *Question) TableName() string {
	return "question"
}
func (q *Question) String() string {
	return q.Text
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
