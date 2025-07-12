---
marp: true
theme: orange-gradient
paginate: true
header: 'SQL勉強会 - 第1回'
---

<!-- _class: lead -->

# 第1回：準備と最初のクエリ

---

# 本日のゴール

<div class="check">DuckDBを起動し、データをn行表示できるようになる</div>

---

# 座学パート

## 1. SQLとは？

- データベース(沢山のデータが保管されているところ)と対話するための言語
- 例) こういう情報をこの並び方で5件ちょうだい等...

---

## 2. DuckDBとは？
- 軽量で高速な<span class="accent">SQLを実行するためのツール</span>
- インストールが簡単で、すぐに使い始められる
- CSVファイルをはじめとする多くのファイルを直接読み込んでSQLが実行できる
- ブラウザベースのUIで視覚的に操作できる

---

## 2. DuckDBの起動方法

```bash
# プロジェクトディレクトリに移動
cd sql-study-session

# DuckDBを起動
duckdb -cmd "INSTALL ui;LOAD ui;CALL start_ui();"
```

<div class="tip">
起動に成功すると、ブラウザが自動的に開き、DuckDBのインターフェースが表示されます。
</div>

---

## 3. 画面の構成

![Image](https://github.com/user-attachments/assets/2f3cbaa3-3901-488a-b96a-7325565e0f1b)

---

## 4. 基本的なSQLコマンド

```sql
SELECT * FROM 'ファイル名' LIMIT 10;
```

この構文の意味：
- `SELECT *`：すべての列を選択
- `FROM 'ファイル名'`：どのファイルからデータを読むか
- `LIMIT 10`：最初の10行だけ表示
- `;`（セミコロン）：コマンドの終了を示す（<span class="accent">必須！</span>）

---

## 5. データファイルの構成

今回使うデータ：
- `customers.csv`：顧客データ（7人）
- `products.csv`：商品データ（5商品）
- `sales.csv`：売上データ（15件）

---

# DuckDB GUIの詳しい使い方

![](https://github.com/user-attachments/assets/8f673c7e-579b-4de3-a062-eca6847863f2)

---

## クエリの実行方法

### 実行操作
- **全体実行**：▶ Runボタン または `Ctrl/Cmd + Enter`

---

## 便利な機能とショートカット

### よく使うショートカット
| 操作 | Windows/Linux | Mac |
|------|--------------|-----|
| クエリ実行 | Ctrl + Enter | Cmd + Enter |
| 全選択 | Ctrl + A | Cmd + A |
| コピー | Ctrl + C | Cmd + C |
| 貼り付け | Ctrl + V | Cmd + V |

---

### その他の便利機能

- **自動補完**：テーブル名や列名の候補表示

---

## エラーメッセージの見方

```sql
-- エラー例：ファイルが見つからない
SELECT * FROM 'data/test.csv';
-- IO Error: No files found that match the pattern "data/product.csv"
```

<div class="warning">
エラーが出たら：
<ul>
<li>ファイルパスのスペルミスをチェック</li>
<li>セミコロン（;）の付け忘れを確認</li>
<li>クォート（'）の閉じ忘れを確認</li>
</ul>
</div>

---

# 演習パート

## 演習1：基本的な操作を試してみよう

### 1-1. クエリの入力と実行

クエリエディタに以下を入力して実行（複数行で書いてみましょう）：
```sql
-- 売上データの最初の5件を表示
SELECT * 
FROM 'data/sales.csv' 
LIMIT 5;
```

---

### 1-2. 結果の操作を試す

結果が表示されたら：
1. **列幅の調整**：列の境界をドラッグして見やすく調整
2. **データのコピー**：
   - 任意のセルをクリックして選択
   - `Ctrl/Cmd + C`でコピー
   - メモ帳やExcelに貼り付けてみる
3. **全選択とコピー**：結果全体を選択してコピー

---

## 演習2：エラーメッセージを体験してみよう

### 2-1. わざとエラーを起こしてみる
```sql
-- ファイル名を間違えてみる
SELECT * FROM 'data/product.csv';
```
実行すると何が起きるか確認してみましょう。

### 2-2. 正しいクエリに修正
```sql
SELECT * FROM 'data/products.csv';
```
セミコロンを追加して再実行。5つの商品データが表示されます。

---

## 演習3：便利な機能を活用してみよう

### 3-1. 複数行で見やすく書く
```sql
-- 顧客データから3件だけ取得
SELECT *
FROM 'data/customers.csv' 
LIMIT 3;
```

### 3-2. 結果の活用
1. 結果を確認
2. 画面レイアウトを調整（境界をドラッグ）
3. 必要に応じて結果をコピー＆ペースト

---

# 練習問題

## 1. LIMITを使わずに実行してみよう

```sql
SELECT * FROM 'data/sales.csv';
```
→ 全15件のデータが表示されることを確認

---

## 2. LIMIT 1でどうなるか確認

```sql
SELECT * FROM 'data/products.csv' LIMIT 1;
```
→ 最初の1行だけ表示される

---

## 3. エラーを体験してみよう

```sql
SELECT * FROM 'data/test.csv' LIMIT 5;
```

<div class="warning">
ファイルが存在しないというエラーメッセージが表示される
</div>

---

# 本日のまとめ

今日学んだこと：
- <span class="check">DuckDBの起動方法（`./start_duckdb_ui.sh` または `start_duckdb_ui.cmd`）</span>
- <span class="check">便利なショートカット（Ctrl/Cmd + Enter で実行）</span>
- <span class="check">`SELECT * FROM 'ファイル名' LIMIT n;` の基本構文</span>
- <span class="check">CSVファイルから直接データを読み込む方法</span>

---

## 便利な機能

- **自動補完**：入力中に候補が表示される場合がある
- **エラー表示**：構文エラーが分かりやすく表示される

---

# 次回予告

第2回では、必要な列だけを選んで表示する方法を学びます。
列名も見やすく、どの列を選ぶか視覚的に確認しながら進められます！

---

# 追加演習

## 問題1：異なるLIMIT値での表示

以下のLIMIT値で各ファイルを表示してみましょう：

```sql
-- sales.csvを8行表示
-- あなたの答えをここに書いてください

-- products.csvを2行だけ表示
-- あなたの答えをここに書いてください

-- customers.csvを全件表示（LIMITなし）
-- あなたの答えをここに書いてください
```

---

## 問題2：ファイルパスの理解

以下のクエリを実行し、エラーを確認してください：

```sql
-- 1. パスの区切り文字を間違える
SELECT * FROM 'data\sales.csv' LIMIT 5;

-- 2. ファイル名を間違える
SELECT * FROM 'data/sale.csv' LIMIT 5;

-- 3. 拡張子を忘れる
SELECT * FROM 'data/sales' LIMIT 5;
```

---

## 問題3：複数のクエリを連続実行

以下のクエリを順番に実行し、結果を比較してください：

```sql
-- 最初のクエリ
SELECT * FROM 'data/customers.csv' LIMIT 1;

-- 2番目のクエリ
SELECT * FROM 'data/customers.csv' LIMIT 2;

-- 3番目のクエリ
SELECT * FROM 'data/customers.csv' LIMIT 3;
```

---

## 問題4：データの行数を推測

LIMITを使わずに各ファイルを表示し、それぞれ何行あるか数えてください：
- customers.csv: ＿＿行
- products.csv: ＿＿行
- sales.csv: ＿＿行

---

## 🎯 チャレンジ問題

```sql
-- sales.csvの最後の5行だけを表示するにはどうすればよいでしょうか？
-- ヒント：第4回で学ぶORDER BYを先取りして使ってみましょう
```

---

# FAQ

**Q: ブラウザが開かない**
A: ファイアウォールやセキュリティソフトが原因の可能性があります。表示されるURLを手動でブラウザに入力してください。

**Q: クエリが実行されない**
A: セミコロン（`;`）を忘れていませんか？また、実行ボタンをクリックするか、Ctrl/Cmd + Enterを押してください。

**Q: 文字化けしている**
A: ブラウザの文字エンコーディングがUTF-8になっているか確認してください。
