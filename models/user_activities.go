package models

import "time"

type CommentParent struct {
	Id   int    `json:"id" orm:"auto"`
	Name string `json:"name" orm:"size(20)"`
}

func (cp *CommentParent) TableName() string {
	return "comment_parent"
}

func (cp *CommentParent) String() string {
	return cp.Name
}

type Comment struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Text       string         `json:"text" orm:"size(500)"`
	Author     *User          `json:"author" orm:"rel(fk);on_delete(cascade)"`
	Answer     *Answer        `json:"answer" orm:"rel(fk);on_delete(cascade)"`
	Question   *Question      `json:"question" orm:"rel(fk);on_delete(cascade)"`
	ParentType *CommentParent `json:"comment_parent" orm:"rel(fk);on_delete(cascade)"`

	Children []Comment `json:"children" orm:"-"`

	LoveCount    int `json:"love_count" orm:"default(0)"`
	HateCount    int `json:"hate_count" orm:"default(0)"`
	CommentCount int `json:"comment_count" orm:"default(0)"`
}

func (c *Comment) TableName() string {
	return "user_comment"
}

func (c *Comment) String() string {
	return c.Text
}

type Like struct {
	Id      int  `json:"id" orm:"auto"`
	Postive bool `json:"positive" orm:"positive;default(true)"`

	User     *User     `json:"user" orm:"null;rel(fk);on_delete(cascade)"`
	Question *Question `json:"question" orm:"null;rel(fk);on_delete(cascade)"`
	Answer   *Answer   `json:"answer" orm:"null;rel(fk);on_delete(cascade)"`
	Comment  *Comment  `json:"question_comment" orm:"null;rel(fk);on_delete(cascade)"`
}

func (l *Like) TableName() string {
	return "user_likes"
}

type ActivityType struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Name string `json:"name" orm:"size(100);unique"`
}

func (at *ActivityType) TableName() string {
	return "activity_type"
}

type Activity struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Doer   *User         `json:"doer" orm:"rel(fk);on_delete(cascade)"`
	Type   *ActivityType `json:"type" orm:"rel(fk);on_delete(cascade)"`
	Item   interface{}   `json:"item" orm:"-"`
	ItemId int           `json:"item_id" orm:"item_id"`
}

func (a *Activity) TableName() string {
	return "user_activity"
}
