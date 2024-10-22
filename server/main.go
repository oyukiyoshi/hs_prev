package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	_ "github.com/lib/pq"
	"github.com/oyukiyoshi/hs/api"
)

var (
	dbUser     = "postgres"
	dbPassword = "password"
	dbDatabase = "postgres"
	dbConn     = fmt.Sprintf("host=127.0.0.1 port=5432 user=%s password=%s dbname=%s sslmode=disable", dbUser, dbPassword, dbDatabase)
)

func main() {
	db, err := sql.Open("postgres", dbConn)
	if err != nil {
		log.Println("fail to connect DB")
		return
	}

	r := api.NewRouter(db)

	log.Fatal(http.ListenAndServe(":3000", r))
}
