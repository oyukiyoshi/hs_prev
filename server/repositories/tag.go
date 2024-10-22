package repositories

import (
	"database/sql"

	"github.com/oyukiyoshi/hs/models"
)

func SelectTag(db *sql.DB) ([]models.Tag, error) {
	const sqlStr = `
		select * from tag order by tag_id asc;
	`
	rows, err := db.Query(sqlStr)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	tagArray := make([]models.Tag, 0)
	for rows.Next() {
		var tag models.Tag
		rows.Scan(&tag.TagID, &tag.TagColor, &tag.TagNmae)
		tagArray = append(tagArray, tag)
	}

	return tagArray, nil
}

/* func InsertTag(db *sql.DB, tag models.Tag) (models.Tag, error) {
	const sqlStr = `
		insert into tag (tag_color, tag_name) values ($1, $2) returning tag_id;
	`
	var newTagID int
	var newSentence models.Tag
	newSentence.TagID = tag.TagID
	err := db.QueryRow(sqlStr, tag.TagColor, tag.TagNmae).Scan(&newTagID)
	if err != nil {
		return models.Tag{}, err
	}
	newSentence.TagID = newTagID
	return newSentence, nil
} */

func UpdateTag(db *sql.DB, tag models.Tag) error {
	const sqlStr = `
		update tag set tag_color = $1, tag_name = $2 where tag_id = $3;
	`
	_, err := db.Exec(sqlStr, tag.TagColor, tag.TagNmae, tag.TagID)
	if err != nil {
		return err
	}
	return nil
}

func DeleteTag(db *sql.DB, tagID int) error {
	tx, err := db.Begin()
	if err != nil {
		return err
	}

	const sqlPassage = `
		update passage set tag_id = 1 where tag_id = $1;
	`
	_, err = tx.Exec(sqlPassage, tagID)
	if err != nil {
		tx.Rollback()
		return err
	}

	const sqlTag = `
		delete from tag where tag_id = $1;
	`
	_, err = tx.Exec(sqlTag, tagID)
	if err != nil {
		tx.Rollback()
		return err
	}

	if err = tx.Commit(); err != nil {
		return err
	}

	return nil
}
