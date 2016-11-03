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
