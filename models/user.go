package models

import (
	"fmt"
	"time"

	bolow "github.com/boolow5/bolow/crypto"
)

type Profile struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	FirstName string `json:"first_name" orm:"null"`
	LastName  string `json:"last_name" orm:"null"`
	User      *User  `json:"user" orm:"reverse(one)"`
	AvatarUrl string `json:"profile_picture" orm:"null"`

	Likes         int         `Json:"topics_you_like" orm:"default(0)"`
	AnswerCount   int         `json:"answer_count" orm:"default(0)"`
	QuestionCount int         `json:"question_count" orm:"default(0)"`
	Languages     []*Language `json:"languages" orm:"-"`
	PersonalFeed  []*Feed     `json:"feed_list" orm:"-"`
}

func (p *Profile) TableName() string {
	return "user_profile"
}

func (p *Profile) FullName() string {
	return fmt.Sprintf("%s %s", p.FirstName, p.LastName)
}
func (p *Profile) String() string {
	return p.FullName()
}

type User struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Email    string   `json:"email" orm:"unique"`
	Password string   `json:"password"`
	Profile  *Profile `json:"profile" orm:"rel(one);on_delete(cascade)"`
}

func (u *User) TableName() string {
	return "auth_user"
}
func (u *User) String() string {
	return u.Profile.String()
}
func (u *User) HashPassword() (err error) {
	u.Password, err = bolow.HashPassword(u.Password)
	if err != nil {
		return err
	}
	return nil
}
