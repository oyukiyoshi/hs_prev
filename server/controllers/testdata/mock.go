package testdata

import "github.com/oyukiyoshi/hs/models"

type serviceMock struct{}

func NewServiceMock() *serviceMock {
	return &serviceMock{}
}

// sentence
func (s *serviceMock) GetSentenceListService() ([]models.Sentence, error) {
	return sentenceTestData, nil
}
func (s *serviceMock) PostSentenceService(sentence models.Sentence) (models.Sentence, error) {
	return sentenceTestData[0], nil
}
func (s *serviceMock) DeleteSentence(sentenceID int) (models.Sentence, error) {
	return sentenceTestData[1], nil
}

// passage
func (s *serviceMock) GetPassageService() ([]models.Passage, error) {
	return passageTestData, nil
}
func (s *serviceMock) PostPassageService(sentence models.Passage) (models.Passage, error) {
	return passageTestData[0], nil
}

// tag
func (s *serviceMock) GetTagService() ([]models.Tag, error) {
	return tagTestData, nil
}
func (s *serviceMock) PostTagService(tag models.Tag) (models.Tag, error) {
	return tagTestData[0], nil
}
func (s *serviceMock) DeleteTagService(tag models.Tag) (models.Tag, error) {
	return tagTestData[1], nil
}
