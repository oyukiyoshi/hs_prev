package services

import "github.com/oyukiyoshi/hs/models"

// sentence 関連を引き受けるサービス
type SentenceServicer interface {
	GetSentenceListService() ([]models.Sentence, error)
	PostSentenceService(sentence models.Sentence, passages []models.Passage) (models.Sentence, error)
	DeleteSentenceService(sentenceID int) error
	GetSentenceFileService(sentenceID int) (string, error)
}

// passage 関連を引き受けるサービス
type PassageServicer interface {
	GetSentenceService(sentenceID int) ([]models.Passage, error)
	PostPassageService(passage models.Passage) error
}

// tag 関連を引き受けるサービス
type TagServicer interface {
	GetTagService() ([]models.Tag, error)
	PostTagService(tag models.Tag) error
	DeleteTagService(tagID int) error
}

// その他のサービス
type ModuleServicer interface {
	ConvertDB2mdService(sentenceID int) error
}
