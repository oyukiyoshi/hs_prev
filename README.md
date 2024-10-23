# HS

## 準備
### DB のテーブル作成
1. ./hs/server に移動する
2. psql を起動する
3. 下記コマンドを実行する
```
# \i ./sql/bulk.sh
```
### server 起動
4. ./hs/server に移動する
5. 下記コマンドを実行する
```
> go run main.go
```
### client 起動
6. ./hs/client に移動する
7. 下記コマンドを実行する
```
> flutter run -d chrome
```

## 使い方

<img src="./img/1.png" alt="figure 1" width="700px"><br>
画面右のボタンを押下するとファイル選択ポップアップが現れます。  
任意のテキストファイルを選択し、「開く」ボタンを押下します。  
<img src="./img/2.png" alt="figure 1" width="700px"><br>
整形済みの文章が表示されます。  
<img src="./img/3.png" alt="figure 1" width="700px"><br>
テキストの背景色を変える場合は、変更したい文を選択し、  
<img src="./img/4.png" alt="figure 1" width="700px"><br>
画面右側のタグボタンのいずれかを押下します。  
<img src="./img/5.png" alt="figure 1" width="700px"><br>
「Sentences」タブでは文章の登録、  
<img src="./img/6.png" alt="figure 1" width="700px"><br>
ダウンロード(Markdown 形式)、  
<img src="./img/7.png" alt="figure 1" width="700px"><br>
削除が行えます。  
<img src="./img/8.png" alt="figure 1" width="700px"><br>
<img src="./img/9.png" alt="figure 1" width="700px"><br>
「Tgas」タブではタグ名の変更が行えます。