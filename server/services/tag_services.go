package services

import (
	"github.com/oyukiyoshi/hs/apperrors"
	"github.com/oyukiyoshi/hs/models"
	"github.com/oyukiyoshi/hs/repositories"
)

func (s *MyAppService) GetTagService() ([]models.Tag, error) {
	tagList, err := repositories.SelectTag(s.db)
	if err != nil {
		err = apperrors.GetDataFailed.Wrap(err, "fail to get data")
		return nil, err
	}

	if len(tagList) == 0 {
		err := apperrors.NAData.Wrap(err, "no data")
		return nil, err
	}

	return tagList, nil
}

func (s *MyAppService) PostTagService(tag models.Tag) error {
	err := repositories.UpdateTag(s.db, tag)
	if err != nil {
		return err
	}
	return nil
}

func (s *MyAppService) DeleteTagService(tagID int) error {
	err := repositories.DeleteTag(s.db, tagID)
	if err != nil {
		return err
	}
	return nil
}
