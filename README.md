# 英単語しりとり
英単語しりとりゲームアプリです</br>
敵が繰り出してきた英単語にしりとりで返すと敵にダメージを与えることができます．</br>
敵を倒すとゲームクリアです．</br>
App Store：https://apps.apple.com/jp/app/%E8%8B%B1%E5%8D%98%E8%AA%9E%E3%81%97%E3%82%8A%E3%81%A8%E3%82%8A/id1581560378

## 作成した目的
英単語を楽しみながら学習できるようにといった考えから，生まれました．</br>
しりとりで使用した英単語を単語リストに保存して意味を確認することができるようになっています．

## 遊び方
### トップ画面
<img src='https://user-images.githubusercontent.com/84612341/144635344-56f9fa61-b369-41e9-b039-db5a713cffda.png' width='320px'></br>

Playボタンを押すとモード選択画面に遷移します．</br>
下の３つのボタンは左から，BGMのON/OFF，しりとりのルール，ランキング(Comming Soon)となります．
</br>

### プレイ画面
<img src='https://user-images.githubusercontent.com/84612341/144636703-3fdff3b8-db01-4e86-b638-034a50a9c380.gif' width='320px'></br>

しりとりを成功させると敵にダメージを与えることができます．</br>
英単語の文字数によって与えるダメージが変わります．</br>
制限時間以内に敵を倒してゲームクリアを目指しましょう．</br>

### 使用した単語リスト
<img src='https://user-images.githubusercontent.com/84612341/144637402-6a88670b-1975-41d4-bdef-e5cf34b79cd5.png' width='320px'></br>

ゲームで使用した英単語を確認することができます． タップしてお気に入り登録することでお気に入り単語リストに保存されます．</br>
※お気に入り単語リストはアプリ内のSQLiteファイルに保存されます．

### 単語詳細画面
<img src='https://user-images.githubusercontent.com/84612341/144637419-124523dc-d15b-45ec-98c1-9aca848c2934.png' width='320px'>

単語リストからそれぞれの単語をタップすることで日本語の意味を確認できます．</br>
なお，ゲーム内で使用している英単語は[こちら](https://kujirahand.com/web-tools/EJDictFreeDL.php)で無料で公開されているものを使用しています.</br>
辞書データベースはアプリ内に組み込む形で実装しており，英単語と日本語の意味はそこから取得して表示しています．


## 使用技術
* Swift 5.4.2
* UIKit
* SQLite
* Gecco

## 使用した素材
* 音楽: 魔王魂
https://maou.audio/rule/

* イラスト: 後藤孝輔

## 制作者
 
* 作成者 後藤孝輔
* 所属　九州工業大学大学院
* E-mail　kosuke.109gkgkgkg@gmail.com

## 制作期間
約3ヶ月(リリースまで)+α(デザインパターンの変更やUIの更新などアプリの改善を行っています)
 
