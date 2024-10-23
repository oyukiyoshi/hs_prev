package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"
	"github.com/oyukiyoshi/hs/api"
)

func main() {
	err := godotenv.Load(fmt.Sprintf(".env.%s", os.Getenv("GO_ENV")))
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	dbConn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", os.Getenv("HOST"), os.Getenv("PORT"), os.Getenv("USER"), os.Getenv("PASSWORD"), os.Getenv("DATABASE"))

	db, err := sql.Open("postgres", dbConn)
	if err != nil {
		log.Println("fail to connect DB")
		return
	}

	r := api.NewRouter(db)

	log.Fatal(http.ListenAndServe(":3000", r))
}
