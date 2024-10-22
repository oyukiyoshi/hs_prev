package repositories

import (
	"database/sql"
	"time"

	"github.com/oyukiyoshi/hs/models"
)

func SelectSentence(db *sql.DB) ([]models.Sentence, error) {
	const sqlStr = `
		select * from sentence order by changed_at desc;
	`
	rows, err := db.Query(sqlStr)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	sentenceArray := make([]models.Sentence, 0)
	for rows.Next() {
		var sentence models.Sentence
		rows.Scan(&sentence.SentenceID, &sentence.SentenceName, &sentence.ChangedAt)
		sentenceArray = append(sentenceArray, sentence)
	}

	return sentenceArray, nil
}

func InsertSentence(db *sql.DB, sentence models.Sentence, passage []models.Passage) (models.Sentence, error) {
	tx, err := db.Begin()
	if err != nil {
		return models.Sentence{}, err
	}

	const sqlSentence = `
		insert into sentence (sentence_name, changed_at) values ($1, $2) returning sentence_id;
	`
	var newSentenceID int
	var newSentence models.Sentence
	newSentence.SentenceName = sentence.SentenceName
	err = tx.QueryRow(sqlSentence, sentence.SentenceName, time.Now()).Scan(&newSentenceID)
	if err == sql.ErrNoRows {
		tx.Rollback()
		return models.Sentence{}, err
	}
	newSentence.SentenceID = newSentenceID

	for i := 0; i < len(passage); i++ {
		const sqlPassage = `
			insert into passage (sentence_id, line_no, tag_id, text_type, passage_content) values ($1, $2, $3, $4, $5);
		`
		_, err := tx.Exec(sqlPassage, newSentenceID, passage[i].LineNo, passage[i].TagID, passage[i].TextType, passage[i].PassageContent)
		if err != nil {
			tx.Rollback()
			return models.Sentence{}, err
		}
	}

	if err = tx.Commit(); err != nil {
		return models.Sentence{}, err
	}

	return newSentence, nil
}

func DeleteSentence(db *sql.DB, sentenceID int) error {
	tx, err := db.Begin()
	if err != nil {
		return err
	}

	const sqlPassage = `
		delete from passage where sentence_id = $1;
	`
	_, err = tx.Exec(sqlPassage, sentenceID)
	if err != nil {
		tx.Rollback()
		return err
	}

	const sqlSentence = `
		delete from sentence where sentence_id = $1;
	`
	_, err = tx.Exec(sqlSentence, sentenceID)
	if err != nil {
		tx.Rollback()
		return err
	}

	if err = tx.Commit(); err != nil {
		return err
	}

	return nil
}

func SpecificSelectSentence(db *sql.DB, sentenceID int) (string, error) {
	const sqlStr = `
		select sentence_name from sentence where sentence_id = $1;
	`
	var sentenceName string
	row := db.QueryRow(sqlStr, sentenceID)
	if err := row.Err(); err != nil {
		return "", err
	}

	err := row.Scan(&sentenceName)
	if err != nil {
		return "", err
	}

	return sentenceName, nil
}
