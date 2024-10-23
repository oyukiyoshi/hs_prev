package repositories

import (
	"database/sql"
	"time"

	"github.com/oyukiyoshi/hs/models"
)

func SelectPassage(db *sql.DB, sentenceID int) ([]models.Passage, error) {
	const sqlStr = `
		select * from passage where sentence_id = $1 order by line_no asc;
	`
	rows, err := db.Query(sqlStr, sentenceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	passageArray := make([]models.Passage, 0)
	for rows.Next() {
		var passage models.Passage
		rows.Scan(&passage.SentenceID, &passage.LineNo, &passage.TagID, &passage.TextType, &passage.PassageContent)
		passageArray = append(passageArray, passage)
	}

	return passageArray, nil
}

func UpdatePassage(db *sql.DB, passage models.Passage) error {
	tx, err := db.Begin()
	if err != nil {
		return err
	}

	const sqlPassage = `
		update passage set tag_id = $1 where sentence_id = $2 and line_no = $3;
	`
	_, err = tx.Exec(sqlPassage, passage.TagID, passage.SentenceID, passage.LineNo)
	if err != nil {
		tx.Rollback()
		return err
	}

	const sqlSentence = `
		update sentence set changed_at = $1 where sentence_id = $2;
	`
	_, err = tx.Exec(sqlSentence, time.Now(), passage.SentenceID)
	if err != nil {
		tx.Rollback()
		return err
	}

	if err = tx.Commit(); err != nil {
		return err
	}

	return nil
}
