package models

type Topic struct {
	Name      string `json:"name" orm:"size(100)"`
	Followers int    `json:"followers"`
	Parent    *Topic `json:"parent_topic"`
}

type Feed struct {
	Item map[string]interface{}
}
