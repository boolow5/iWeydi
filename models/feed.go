package models

import "time"

type Feed struct {
	ActivityId       int       `json:"activity_id"`
	CreatedAt        time.Time `json:"created_at"`
	UserId           int       `json:"user_id"`
	UserFullName     string    `json:"user_full_name"`
	ActivityTypeName string    `json:"activity_type_name"`

	Question *Question `json:"question"`
	Answer   *Answer   `json:"answer"`
}

func ViewName() string {
	return "ACTIVITY_VIEW"
}
func (f *Feed) Columns() []string {
	return []string{"activity_id", "created_at", "user_id", "user_full_name", "activity_type_name", "question_id", "answer_id"}
}

type Notification struct {
	Id        int       `json:"id" orm:"auto"`
	CreatedAt time.Time `json:"created_at" orm:"auto_now_add;type(datetime)"`
	UpdatedAt time.Time `json:"updated_at" orm:"auto_now;type(datetime)"`

	Activity *Activity `json:"Activity" orm:"rel(fk);on_delete(cascade)"`
	Receiver *User     `json:"receiver" orm:"rel(fk);on_delete(cascade)"`
	Seen     bool      `json:"seen" orm:"default(false)"`
}

func (n *Notification) TableName() string {
	return "user_notifications"
}
