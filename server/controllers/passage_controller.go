package controllers

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/oyukiyoshi/hs/apperrors"
	"github.com/oyukiyoshi/hs/controllers/services"
	"github.com/oyukiyoshi/hs/models"
)

type PassageController struct {
	service services.PassageServicer
}

type PassageModuleController struct {
	serviceP services.PassageServicer
	serviceM services.ModuleServicer
}

func NewPassageController(s services.PassageServicer) *PassageController {
	return &PassageController{service: s}
}

func NewPassageModuleController(sp services.PassageServicer, sm services.ModuleServicer) *PassageModuleController {
	return &PassageModuleController{serviceP: sp, serviceM: sm}
}

func (c *PassageController) GetSentenceHandler(w http.ResponseWriter, req *http.Request) {
	sentenceID, err := strconv.Atoi(chi.URLParam(req, "sentenceID"))
	if err != nil {
		err = apperrors.BadParam.Wrap(err, "pathparam must be number")
		apperrors.ErrorHandler(w, req, err)
		return
	}

	sentenceList, err := c.service.GetSentenceService(sentenceID)
	if err != nil {
		apperrors.ErrorHandler(w, req, err)
		return
	}
	json.NewEncoder(w).Encode(sentenceList)
}
func (c *PassageModuleController) PostSentenceHandler(w http.ResponseWriter, req *http.Request) {
	var reqSentence models.Passage
	if err := json.NewDecoder(req.Body).Decode(&reqSentence); err != nil {
		http.Error(w, "fail to decode json\n", http.StatusBadRequest)
	}
	err := c.serviceP.PostPassageService(reqSentence)
	if err != nil {
		http.Error(w, "fail internal exec\n", http.StatusInternalServerError)
		return
	}
	err = c.serviceM.ConvertDB2mdService(reqSentence.SentenceID)
	if err != nil {
		http.Error(w, "fail internal exec\n", http.StatusInternalServerError)
		return
	}
}
