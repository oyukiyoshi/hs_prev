package api

import (
	"database/sql"

	"github.com/go-chi/chi/v5"
	"github.com/oyukiyoshi/hs/api/middlewares"
	"github.com/oyukiyoshi/hs/controllers"
	"github.com/oyukiyoshi/hs/services"
)

func NewRouter(db *sql.DB) *chi.Mux {
	ser := services.NewMyAppService(db)
	sCon := controllers.NewSentenceController(ser)
	smCon := controllers.NewSentenceModuleController(ser, ser)
	pCon := controllers.NewPassageController(ser)
	tCon := controllers.NewTagController(ser)

	r := chi.NewRouter()
	r.Use(middlewares.LoggingMiddleware)
	r.Use(middlewares.CORSMiddleware)

	// list handlers
	r.Get("/list", sCon.GetSentenceListHandler)
	r.Post("/list", smCon.PostSentenceHandler)
	r.Delete("/list", sCon.DeleteSentenceHandler)
	r.Get("/list/download/{sentenceID:[0-9]+}", sCon.GetSentenceFileHandler)

	// sentence handlers
	r.Get("/sentence/{sentenceID:[0-9]+}", pCon.GetSentenceHandler)
	r.Post("/sentence", pCon.PostSentenceHandler)

	// tag handlers
	r.Get("/tag", tCon.GetTagHandler)
	r.Post("/tag", tCon.PostTagHandler)
	r.Delete("/tag", tCon.DeleteTagHandler)
	// r.Post("/tag/create", tCon.CreateTagHandler)

	return r
}
