package models

import "time"

type Sentence struct {
	SentenceID   int       `json:"sentence_id"`
	SentenceName string    `json:"sentence_name"`
	ChangedAt    time.Time `json:"changed_at,omitempty"`
}

type Passage struct {
	SentenceID     int    `json:"sentence_id"`
	LineNo         int    `json:"line_no"`
	TagID          int    `json:"tag_id"`
	TextType       string `json:"text_type"`
	PassageContent string `json:"passage_content"`
}

type Tag struct {
	TagID    int    `json:"tag_id"`
	TagColor string `json:"tag_color"`
	TagNmae  string `json:"tag_name"`
}
