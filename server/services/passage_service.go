package services

import (
	"github.com/oyukiyoshi/hs/apperrors"
	"github.com/oyukiyoshi/hs/models"
	"github.com/oyukiyoshi/hs/repositories"
)

func (s *MyAppService) GetSentenceService(sentenceID int) ([]models.Passage, error) {
	passageList, err := repositories.SelectPassage(s.db, sentenceID)
	if err != nil {
		err = apperrors.GetDataFailed.Wrap(err, "fail to get data")
		return nil, err
	}

	if len(passageList) == 0 {
		err := apperrors.NAData.Wrap(err, "no data")
		return nil, err
	}

	return passageList, nil
}

func (s *MyAppService) PostPassageService(passage models.Passage) error {
	err := repositories.UpdatePassage(s.db, passage)
	if err != nil {
		return err
	}
	return nil
}
