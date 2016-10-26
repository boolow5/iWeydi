package models

import "time"

type Answer struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text     string          `json:"text" orm:"size(1000)"`
	Author   *User           `json:"author" orm:"rel(fk);on_delete(cascade)"`
	Comments []AnswerComment `json:"comments" orm:"-"`
}

type AnswerComment struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text   string  `json:"text" orm:"size(500)"`
	Author *User   `json:"author" orm:"rel(fk);on_delete(cascade)"`
	Answer *Answer `json:"answer" orm:"rel(fk);on_delete(cascade)"`
}
