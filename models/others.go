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
