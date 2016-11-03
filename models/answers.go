package models

import "time"

type Answer struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text   string `json:"text" orm:"size(1000)"`
	Author *User  `json:"author" orm:"rel(fk);on_delete(cascade)"`

	Question *Question  `json:"question" orm:"rel(fk);on_delete(cascade)"`
	Comments []*Comment `json:"comments" orm:"-"`

	LoveCount    int `json:"love_count" orm:"default(0)"`
	HateCount    int `json:"hate_count" orm:"default(0)"`
	CommentCount int `json:"comment_count" orm:"default(0)"`
}
