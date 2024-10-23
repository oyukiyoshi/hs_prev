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

type TagController struct {
	service services.TagServicer
}

func NewTagController(s services.TagServicer) *TagController {
	return &TagController{service: s}
}

func (c *TagController) GetTagHandler(w http.ResponseWriter, req *http.Request) {
	tagList, err := c.service.GetTagService()
	if err != nil {
		apperrors.ErrorHandler(w, req, err)
		return
	}
	json.NewEncoder(w).Encode(tagList)
}
func (c *TagController) CreateTagHandler(w http.ResponseWriter, req *http.Request) {
	var reqTag models.Tag
	if err := json.NewDecoder(req.Body).Decode(&reqTag); err != nil {
		http.Error(w, "fail to decode json\n", http.StatusBadRequest)
	}
	err := c.service.CreateTagService(reqTag)
	if err != nil {
		http.Error(w, "fail internal exec\n", http.StatusInternalServerError)
		return
	}
}
func (c *TagController) PostTagHandler(w http.ResponseWriter, req *http.Request) {
	var reqTag models.Tag
	if err := json.NewDecoder(req.Body).Decode(&reqTag); err != nil {
		http.Error(w, "fail to decode json\n", http.StatusBadRequest)
	}
	err := c.service.PostTagService(reqTag)
	if err != nil {
		http.Error(w, "fail internal exec\n", http.StatusInternalServerError)
		return
	}
}
func (c *TagController) DeleteTagHandler(w http.ResponseWriter, req *http.Request) {
	tagID, err := strconv.Atoi(chi.URLParam(req, "tagID"))
	if err != nil {
		err = apperrors.BadParam.Wrap(err, "pathparam must be number")
		apperrors.ErrorHandler(w, req, err)
		return
	}

	err = c.service.DeleteTagService(tagID)
	if err != nil {
		http.Error(w, "fail internal exec\n", http.StatusInternalServerError)
		return
	}
}
