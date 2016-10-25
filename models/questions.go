package models

import "time"

type Question struct {
	ID        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text        string `json:"text" orm:"size(300)"`
	Description string `json:"description" orm:"size(600)"`
	Author      *User  `json:"author" orm:"rel(fk)"`

	LikedBy []*User `json:"who_liked" orm:"rel(m2m)`
	HatedBy []*User `json:"who_hated" orm:"rel(m2m)`
}

type QuestionComment struct {
	ID        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text     string    `json:"text" orm:"size(500)"`
	Author   *User     `json:"author" orm:"rel(fk)"`
	Question *Question `json:"question" orm:"rel(fk)"`

	LikedBy []*User `json:"who_liked" orm:"rel(m2m)`
	HatedBy []*User `json:"who_hated" orm:"rel(m2m)`
}
