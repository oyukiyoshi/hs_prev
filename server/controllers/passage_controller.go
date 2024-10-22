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

func NewPassageController(s services.PassageServicer) *PassageController {
	return &PassageController{service: s}
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
func (c *PassageController) PostSentenceHandler(w http.ResponseWriter, req *http.Request) {
	var reqSentence models.Passage
	if err := json.NewDecoder(req.Body).Decode(&reqSentence); err != nil {
		http.Error(w, "fail to decode json\n", http.StatusBadRequest)
	}
	err := c.service.PostPassageService(reqSentence)
	if err != nil {
		http.Error(w, "fail internal exec\n", http.StatusInternalServerError)
		return
	}
}
