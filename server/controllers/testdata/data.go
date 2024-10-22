package testdata

import (
	"time"

	"github.com/oyukiyoshi/hs/models"
)

var sentenceTestData = []models.Sentence{
	models.Sentence{
		SentenceID:   1,
		SentenceName: "進撃の巨人",
		ChangedAt:    time.Now(),
	},
	models.Sentence{
		SentenceID:   2,
		SentenceName: "暗殺教室",
		ChangedAt:    time.Now(),
	},
}

var passageTestData = []models.Passage{
	models.Passage{
		SentenceID:     1,
		LineNo:         1,
		TagID:          0,
		TextType:       "text",
		PassageContent: "巨人がすべてを支配する世界。",
	},
	models.Passage{
		SentenceID:     1,
		LineNo:         2,
		TagID:          0,
		TextType:       "text",
		PassageContent: "巨人の餌と化した人類は、巨大な壁を築き、壁外への自由と引き換えに侵略を防いでいた。",
	},
}

var tagTestData = []models.Tag{
	models.Tag{
		TagID:    0,
		TagNmae:  "none",
		TagColor: "ffffff",
	},
	models.Tag{
		TagID:    1,
		TagNmae:  "魅力的",
		TagColor: "ff0000",
	},
}
