# SQL勉強会 - 初心者向けSQL学習カリキュラム

## コンセプト
- **超マイクロラーニング**: 1回30分で1つのSQL構文を集中トレーニングする。
- **準備を万全に**: 参加者には事前にツールのインストールとデータ配布を完了してもらうことを強く推奨。
- **反復練習**: 短い演習を数多くこなし、体にSQLを覚えさせる。
- **GUI対応**: DuckDBのGUIを使用し、初心者でも視覚的に理解しやすい環境を提供。

## 対象
- 未経験者
- 初心者(SELECT,FROM,WHEREくらいは分かる)

## 本勉強会の目的

- この勉強会では、『SQLの基礎を学び、自力でデータを取得できる』第一歩を踏み出すこと

## 得られること

- 簡単なSQLなら、自力で書いてデータを抽出できるようになる
- 手作業で行っているデータ集計を、より簡単・スピーディに行うヒントが得られる
- AIや他者のSQLが読めるようになり、業務の理解が深まる

## 本勉強会で取り扱わないこと

- `WITH`句や、副問い合わせ等の応用的な構文
- `CREATE`などのDDL文

---

## カリキュラム詳細 (全8回)

### 【第1回】準備と最初のクエリ
- ゴール: DuckDBを起動し、データをn行表示できる。
- 座学 (5-10分):
    - DuckDBのインストールとデータ配置
    - ターミナルでのDuckDB起動方法
    - `SELECT * FROM 'ファイル名' LIMIT 10;` の意味
    - コマンドの終了を意味する `;` (セミコロン)
- 演習 (20-25分):
    1.  （全員で）DuckDBを起動し、サンプルデータのあるフォルダにいることを確認する。
    2.  `sales.csv` の中身を5行だけ表示してみよう。
    3.  `products.csv` の中身を10行表示してみよう。
    4.  `customers.csv` の中身を3行だけ表示してみよう。

### 【第2回】列を選ぶ - `SELECT 列名`
- ゴール: 巨大なデータから、自分が見たい列だけを抜き出せる。
- 座学 (5分):
    - `SELECT 列1, 列2 FROM ...` の構文
    - `AS` を使った列名の変更 `... AS 新しい名前`
- 演習 (25分):
    1.  `sales.csv` から「商品ID(product_id)」と「数量(quantity)」だけを表示しよう。
    2.  `products.csv` から「商品名(product_name)」と「価格(price)」を表示しよう。
    3.  `customers.csv` の「顧客名(customer_name)」を「お名前」という列名で表示しよう。

### 【第3回】行を絞る - `WHERE`
- ゴール: 特定の条件に合うデータだけを絞り込める。
- 座学 (5-10分):
    - `WHERE` 句の基本（数値の比較 `=`, `>`）
    - 文字列の指定（`'テキスト'`）
    - `AND` を使った複数条件の組み合わせ
- 演習 (20-25分):
    1.  `products.csv` から「価格が1000円以上」の商品を探そう。
    2.  `sales.csv` から「顧客IDが `C001` 」の売上データだけを表示しよう。
    3.  `sales.csv` から「商品IDが `P003`」で、かつ「数量が10個以上」のデータを探そう。

### 【第4回】並び替える - `ORDER BY`
- ゴール: 結果を見やすいように昇順・降順で並び替えられる。
- 座学 (5分):
    - `ORDER BY` 句の基本
    - 降順を指定する `DESC`
    - 昇順を指定する `ASC` (省略可能)
- 演習 (25分):
    1.  `products.csv` を「価格(price)が高い順」に並び替えよう。
    2.  `sales.csv` を「売上日時(order_date)が新しい順」に並び替えよう。
    3.  `sales.csv` から「数量が5個以上」のデータを、「数量が多い順」に並び替えて表示しよう (`WHERE`と`ORDER BY`の組み合わせ)。

### 【第5回】全体を集計する - `COUNT`, `SUM`, `AVG`
- ゴール: 表全体の件数や合計、平均値を計算できる。
- 座学 (5分):
    - `COUNT(*)`: 全体の件数を数える
    - `SUM(列名)`: 数値列の合計を計算する
    - `AVG(列名)`: 数値列の平均を計算する
- 演習 (25分):
    1.  `sales.csv` には全部で何件の売上データがあるか数えてみよう。
    2.  `sales.csv` の「数量(quantity)」の合計を計算しよう。
    3.  `products.csv` の全商品の「平均価格」はいくらか計算してみよう。

### 【第6回】グループで集計する - `GROUP BY`
- ゴール: 「〇〇ごと」の合計や件数を計算できるようになる。
- 座学 (5-10分):
    - `GROUP BY 列名` の考え方
    - `GROUP BY` と集計関数はセットで使う
- 演習 (20-25分):
    1.  `sales.csv` で「顧客IDごと」に何回購入したか（=売上件数）を数えよう。
    2.  `sales.csv` で「商品IDごと」に売れた合計数量を計算しよう。
    3.  【応用】売れた合計数量が多い「商品ID」トップ3を調べてみよう（`GROUP BY` と `ORDER BY`, `LIMIT` の組み合わせ）。

### 【第7回】表をくっつける - `INNER JOIN`
- ゴール: IDで管理された2つの表を結合し、意味のある情報として表示できる。
- 座学 (5-10分):
    - なぜJOINが必要か？（売上表と商品マスタの例）
    - `... JOIN ... ON テーブルA.列 = テーブルB.列` の基本構文
- 演習 (20-25分):
    1.  `sales.csv` と `products.csv` を結合し、どの売上がどの「商品名」かを表示しよう。
    2.  `sales.csv` と `customers.csv` を結合し、どの売上がどの「顧客名」によるものかを表示しよう。
    3.  【応用】上記1のクエリに価格も表示させ、「売上単価 x 数量」で売上金額を計算してみよう。

### 【第8回】総合演習と `LEFT JOIN`
- ゴール: これまでの知識を組み合わせ、実践的なデータ抽出に挑戦する。
- 座学 (5-10分):
    - これまでの全構文のクイックレビュー
    - `LEFT JOIN` の紹介（「購入履歴のない顧客」を探す例）
- 演習 (20-25分):
    1.  `LEFT JOIN` を使い、一度も商品を購入していない顧客を探してみよう。
    2.  【最終課題】 `sales`, `products`, `customers` の3つのファイルを全て結合し、「顧客ごと」の「合計購入金額」を計算し、ランキング形式で表示してみよう。

### 【おまけ】これってどうやるの？

- 今勉強会で取り扱わなかった構文やキーワードの紹介

---

## プロジェクト構成

```
sql-study-session/
├── README.md             # このファイル（カリキュラム概要）
├── 0.事前準備.md         # インストールと環境設定ガイド
├── REVIEW.md            # プロジェクトレビュー
├── CLAUDE.md            # Claude Code向け指示書
├── data/                # サンプルデータ
│   ├── customers.csv    # 顧客データ（7件）
│   ├── products.csv     # 商品データ（5件）
│   └── sales.csv        # 売上データ（15件）
├── lessons/             # 各回のレッスン教材
│   ├── lesson01.md      # 第1回：準備と最初のクエリ
│   ├── lesson02.md      # 第2回：列を選ぶ
│   ├── lesson03.md      # 第3回：行を絞る
│   ├── lesson04.md      # 第4回：並び替える
│   ├── lesson05.md      # 第5回：全体を集計する
│   ├── lesson06.md      # 第6回：グループで集計する
│   ├── lesson07.md      # 第7回：表をくっつける
│   └── lesson08.md      # 第8回：総合演習とLEFT JOIN
├── answers/             # 演習問題の模範解答
│   ├── lesson01_answers.md
│   ├── lesson02_answers.md
│   └── ...（各レッスンに対応）
├── start_duckdb_ui.sh   # DuckDB GUI起動スクリプト（Mac/Linux）
└── start_duckdb_ui.cmd  # DuckDB GUI起動スクリプト（Windows）
```

## 事前準備

1. **DuckDBのインストール**: [0.事前準備.md](0.事前準備.md)を参照
2. **リポジトリのクローン**: 
   ```bash
   git clone https://github.com/staticWagomU/sql-study-session.git
   cd sql-study-session
   ```
3. **動作確認**: DuckDBを起動してサンプルクエリを実行

## 学習の進め方

1. **事前準備**: `0.事前準備.md`に従ってDuckDBをインストール
2. **各レッスン**: `lessons/`ディレクトリのファイルを順番に学習
3. **演習問題**: 各レッスンに含まれる追加演習問題に挑戦
4. **答え合わせ**: `answers/`ディレクトリの模範解答で確認

## 特徴

- **GUI版対応**: 各レッスンはDuckDBのGUIインターフェースを使用した説明になっています
- **豊富な演習問題**: 各レッスンに5〜10個の追加演習問題を用意
- **模範解答付き**: すべての演習問題に詳細な解説付き模範解答
- **日本語データ**: 実務により近い日本語のサンプルデータを使用
- **段階的学習**: 基礎から応用まで無理なくステップアップ

## サポート

- **Issues**: 質問や問題がある場合は[GitHubのIssues](https://github.com/staticWagomU/sql-study-session/issues)へ
- **ドキュメント**: 各レッスンファイルの「よくある質問」セクションも参照

## Marpでスライドを表示する

プレゼンテーション用のスライドをMarpサーバーモードで表示できます：

```bash
# Marpサーバーの起動（ホットリロード対応）
npx @marp-team/marp-cli -s .

# 特定のポートを指定する場合
npx @marp-team/marp-cli -s . -p 8080

# スライドファイルを直接指定する場合
npx @marp-team/marp-cli -s slides.md
```

サーバーが起動したら、ブラウザで `http://localhost:8080` にアクセスしてスライドを表示します。
ファイルを編集すると自動的にブラウザがリロードされます。

## 編集履歴

- 2025/07/01 初版
- 2025/07/04 演習問題と模範解答を追加、GUI版に対応
