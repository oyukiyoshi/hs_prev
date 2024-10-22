package services

import (
	"github.com/oyukiyoshi/hs/apperrors"
	"github.com/oyukiyoshi/hs/models"
	"github.com/oyukiyoshi/hs/repositories"
)

func (s *MyAppService) GetSentenceListService() ([]models.Sentence, error) {
	sentenceList, err := repositories.SelectSentence(s.db)
	if err != nil {
		err = apperrors.GetDataFailed.Wrap(err, "fail to get data")
		return nil, err
	}

	if len(sentenceList) == 0 {
		err := apperrors.NAData.Wrap(err, "no data")
		return nil, err
	}

	return sentenceList, nil
}

func (s *MyAppService) PostSentenceService(sentence models.Sentence, passages []models.Passage) (models.Sentence, error) {
	sentenceList, err := repositories.InsertSentence(s.db, sentence, passages)
	if err != nil {
		return models.Sentence{}, err
	}
	return sentenceList, nil
}

func (s *MyAppService) DeleteSentenceService(sentenceID int) error {
	err := repositories.DeleteSentence(s.db, sentenceID)
	if err != nil {
		return err
	}
	return nil
}

func (s *MyAppService) GetSentenceFileService(sentenceID int) (string, error) {
	sentenceName, err := repositories.SpecificSelectSentence(s.db, sentenceID)
	if err != nil {
		return "", err
	}
	return sentenceName, nil
}
