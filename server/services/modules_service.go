package services

import (
	"bufio"
	"os"

	"github.com/oyukiyoshi/hs/apperrors"
	"github.com/oyukiyoshi/hs/repositories"
)

func (s *MyAppService) ConvertDB2mdService(sentenceID int) error {

	// タイトル取得
	sentenceName, err := repositories.SpecificSelectSentence(s.db, sentenceID)
	if err != nil {
		return err
	}

	// 各文取得
	passageList, err := repositories.SelectPassage(s.db, sentenceID)
	if err != nil {
		return err
	}

	// タグ取得
	tagList, err := repositories.SelectTag(s.db)
	if err != nil {
		err = apperrors.GetDataFailed.Wrap(err, "fail to get data")
		return err
	}

	if len(tagList) == 0 {
		err := apperrors.NAData.Wrap(err, "no data")
		return err
	}

	// ファイル作成(既に存在すれば内容消去)
	f, err := os.Create("./md/" + sentenceName + ".md")
	if err != nil {
		return err
	}

	defer f.Close()

	writer := bufio.NewWriter(f)
	defer writer.Flush()

	// 本体
	for i := 0; i < len(passageList); i++ {
		var err error
		if passageList[i].TextType == "tex" {
			_, err = writer.WriteString(string("$" + passageList[i].PassageContent + "$\n"))
		} else {
			for j := 0; j < len(tagList); j++ {
				if passageList[i].TagID == tagList[j].TagID {
					_, err = writer.WriteString(string("<!-- " + tagList[j].TagNmae + " --><span style=\"color: #" + tagList[j].TagColor + "\">" + passageList[i].PassageContent + "</span>\n"))
				}
			}
		}
		if err != nil {
			return err
		}
	}

	return nil
}
