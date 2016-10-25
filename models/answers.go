package models

import "time"

type Answer struct {
	ID        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text   string `json:"text" orm:"size(1000)"`
	Author *User

	LikedBy []*User `json:"who_liked" orm:"rel(m2m)`
	HatedBy []*User `json:"who_hated" orm:"rel(m2m)`
}

type AnswerComment struct {
	ID        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text   string `json:"text" orm:"size(500)"`
	Author *User
	Answer *Answer

	LikedBy []*User `json:"who_liked" orm:"rel(m2m)`
	HatedBy []*User `json:"who_hated" orm:"rel(m2m)`
}
