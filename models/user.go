package models

import "time"

type Profile struct {
	ID        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	FirstName     string   `json:"first_name"`
	LastName      string   `json:"last_name"`
	User          *User    `json:"user" orm:"reverse(One)"`
	AvatarUrl     string   `json:"profile_picture"`
	Followers     []*User  `json:"followers"`
	Following     []*User  `json:"following"`
	Knows         []*Topic `json:"topics_you_know"`
	Likes         []*Topic `Json:"topics_you_like"`
	AnswerCount   int      `json:"answer_count"`
	QuestionCount int      `json:"question_count"`
	PersonalFeed  []*Feed  `json:"-"`
}

type User struct {
	ID        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Email    string   `json:"email" `
	Password string   `json:"password"`
	Profile  *Profile `json:"profile" orm:"rel(One)"`
}
