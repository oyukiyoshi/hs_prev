package controllers

import (
	"encoding/json"
	"io"
	"net/http"
	"os"
	"regexp"
	"strconv"
	"strings"

	"github.com/go-chi/chi/v5"
	"github.com/oyukiyoshi/hs/apperrors"
	"github.com/oyukiyoshi/hs/controllers/services"
	"github.com/oyukiyoshi/hs/models"
)

type SentenceController struct {
	service services.SentenceServicer
}

type SentenceModuleController struct {
	serviceS services.SentenceServicer
	serviceM services.ModuleServicer
}

func NewSentenceController(s services.SentenceServicer) *SentenceController {
	return &SentenceController{service: s}
}

func NewSentenceModuleController(ss services.SentenceServicer, sm services.ModuleServicer) *SentenceModuleController {
	return &SentenceModuleController{serviceS: ss, serviceM: sm}
}

func (c *SentenceController) GetSentenceListHandler(w http.ResponseWriter, req *http.Request) {
	sentenceList, err := c.service.GetSentenceListService()
	if err != nil {
		apperrors.ErrorHandler(w, req, err)
		return
	}
	json.NewEncoder(w).Encode(sentenceList)
}
func (c *SentenceModuleController) PostSentenceHandler(w http.ResponseWriter, req *http.Request) {
	file, fileHeader, err := req.FormFile("file")
	if err != nil {
		http.Error(w, "fail to get file", http.StatusBadRequest)
		return
	}
	defer file.Close()

	fileName := fileHeader.Filename

	tmpFile, err := os.Create("./md/tmp.md")
	if err != nil {
		http.Error(w, "fail to create file", http.StatusInternalServerError)
		return
	}

	_, err = io.Copy(tmpFile, file)
	if err != nil {
		http.Error(w, "fail to copy file", http.StatusInternalServerError)
		return
	}

	data, err := os.ReadFile("./md/tmp.md")
	if err != nil {
		http.Error(w, "fail to read file", http.StatusInternalServerError)
	}

	result := ParseText(string(data))
	reqSentence, reqPassages := FormatFileContent(fileName, result)

	sentence, err := c.serviceS.PostSentenceService(reqSentence, reqPassages)
	if err != nil {
		http.Error(w, "fail internal exec\n", http.StatusInternalServerError)
		return
	}

	err = c.serviceM.ConvertDB2mdService(sentence.SentenceID)
	if err != nil {
		http.Error(w, "fail internal exec\n", http.StatusInternalServerError)
		return
	}

	json.NewEncoder(w).Encode(sentence)
}

func (c *SentenceController) DeleteSentenceHandler(w http.ResponseWriter, req *http.Request) {
	sentenceID, err := strconv.Atoi(chi.URLParam(req, "sentenceID"))
	if err != nil {
		err = apperrors.BadParam.Wrap(err, "pathparam must be number")
		apperrors.ErrorHandler(w, req, err)
		return
	}

	err = c.service.DeleteSentenceService(sentenceID)
	if err != nil {
		http.Error(w, "fail internal exec\n", http.StatusInternalServerError)
		return
	}
}

func (c *SentenceController) GetSentenceFileHandler(w http.ResponseWriter, req *http.Request) {
	sentenceID, err := strconv.Atoi(chi.URLParam(req, "sentenceID"))
	if err != nil {
		err = apperrors.BadParam.Wrap(err, "pathparam must be number")
		apperrors.ErrorHandler(w, req, err)
		return
	}

	sentenceName, err := c.service.GetSentenceFileService(sentenceID)
	if err != nil {
		http.Error(w, "fail internal exec\n", http.StatusInternalServerError)
		return
	}

	re := regexp.MustCompile(`\s+`)
	reSentenceName := re.ReplaceAllString(sentenceName, "_")

	mdFile, err := os.Open("./md/" + reSentenceName + ".md")
	if err != nil {
		http.Error(w, "fail to find file", http.StatusNotFound)
		return
	}
	defer mdFile.Close()

	fileInfo, err := mdFile.Stat()
	if err != nil {
		http.Error(w, "fail to get file information", http.StatusInternalServerError)
		return
	}

	http.ServeContent(w, req, fileInfo.Name(), fileInfo.ModTime(), mdFile)
}

func ParseText(input string) [][]string {
	var result [][]string

	pattern := regexp.MustCompile(`(\$[^$]+\$|[^\r\n$]+)`)
	matches := pattern.FindAllString(input, -1)

	for _, match := range matches {
		if match[0] == '$' && match[len(match)-1] == '$' {
			result = append(result, []string{"tex", match[1 : len(match)-1]})
		} else {
			result = append(result, []string{"text", match})
		}
	}

	return result
}

func FormatFileContent(sentenceName string, prePassages [][]string) (models.Sentence, []models.Passage) {
	var sentence models.Sentence
	passageArray := make([]models.Passage, 0)

	sentence.SentenceName = strings.Split(sentenceName, ".")[0]
	for i := 0; i < len(prePassages); i++ {
		var passage models.Passage
		passage.LineNo = i + 1
		passage.TagID = 1
		passage.TextType = prePassages[i][0]
		passage.PassageContent = prePassages[i][1]
		passageArray = append(passageArray, passage)
	}

	return sentence, passageArray
}
