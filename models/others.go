package models

import (
	"fmt"
	"time"
)

type Language struct {
	Id   int    `json:"id" orm:"auto"`
	Name string `json:"name" orm:"size(100);unique"`
	Code string `json:"code" orm:"size(10)";unique`
}

type Topic struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Name          string `json:"name" orm:"size(100);unique"`
	FollowerCount int    `json:"followers"`
	Parent        *Topic `json:"parent_topic" orm:"rel(fk);on_delete(cascade)"`

	Followers []Follower `json:"followers_ids" orm:"-"`
}

func (t *Topic) TableName() string {
	return "topic"
}

func (t *Topic) String() string {
	return t.Name
}

type Feed struct {
	Id int `json:"id" orm:"auto"`

	User   *User   `json:"user" orm:"rel(fk);on_delete(cascade)"`
	Answer *Answer `json:"answer" orm:"rel(fk);on_delete(cascade)"`
}

func (f *Feed) TableName() string {
	return "user_feed"
}

type Follower struct {
	Id int `json:"id" orm:"auto"`

	Followee *User  `json:"followee" orm:"null;rel(fk);on_delete(cascade)"`
	User     *User  `json:"user" orm:"null;rel(fk);on_delete(cascade)"`
	Topic    *Topic `json:"topic" orm:"null;rel(fk);on_delete(cascade)"`
}

func (f *Follower) TableName() string {
	return "item_follower"
}

type Knows struct {
	Id int `json:"id" orm:"auto"`

	User     *User     `json:"user" orm:"null;rel(fk);on_delete(cascade)"`
	Topic    *Topic    `json:"knows" orm:"null;rel(fk);on_delete(cascade)"`
	Language *Language `json:"language" orm:"null;rel(fk);on_delete(cascade)"`
}

func (k *Knows) TableName() string {
	return "user_knows"
}

func (k *Knows) String() string {
	return fmt.Sprintf("%s knows %s", k.User.String(), k.Topic.String())
}

type Like struct {
	Id      int  `json:"id" orm:"auto"`
	Postive bool `json:"positive" orm:"positive;default(true)"`

	User            *User            `json:"user" orm:"null;rel(fk);on_delete(cascade)"`
	Question        *Question        `json:"question" orm:"null;rel(fk);on_delete(cascade)"`
	Answer          *Answer          `json:"answer" orm:"null;rel(fk);on_delete(cascade)"`
	QuestionComment *QuestionComment `json:"question_comment" orm:"null;rel(fk);on_delete(cascade)"`
	AnswerComment   *AnswerComment   `json:"answer_comment" orm:"null;rel(fk);on_delete(cascade)"`
}

func (l *Like) TableName() string {
	return "user_likes"
}
