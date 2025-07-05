---
marp: true
theme: orange-gradient
paginate: true
header: 'SQL勉強会 - 第1回'
---

<!-- _class: lead -->

# 第1回：準備と最初のクエリ
## GUI版でスタート！

---

# 本日のゴール

<div class="check">DuckDB GUIを起動し、データをn行表示できるようになる</div>

---

# 📚 座学パート

## 1. DuckDBとは？
- 軽量で高速な<span class="accent">SQLデータベースエンジン</span>
- インストールが簡単で、すぐに使い始められる
- CSVファイルを直接読み込んでSQLが実行できる
- **GUI版**：`duckdb -cmd "INSTALL ui;LOAD ui;CALL start_ui();"`で視覚的に操作できる

---

## 2. DuckDB GUIの起動方法

```bash
# プロジェクトディレクトリに移動
cd sql-study-session

# DuckDB GUIを起動
duckdb -cmd "INSTALL ui;LOAD ui;CALL start_ui();"
```

<div class="tip">
起動に成功すると、ブラウザが自動的に開き、DuckDBのGUIインターフェースが表示されます。
</div>

---

## 3. GUI画面の構成

画面は大きく<span class="accent">3つのエリア</span>に分かれています：

- **上部**：クエリ入力エリア（SQLを書く場所）
- **中央**：実行ボタン（▶ Run または Ctrl/Cmd + Enter）
- **下部**：結果表示エリア（実行結果が表形式で表示）

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

私たちが使うデータ：
- `customers.csv`：顧客データ（7人）
- `products.csv`：商品データ（5商品）
- `sales.csv`：売上データ（15件）

---

# 💻 演習パート

## 演習1：DuckDB GUIの起動確認（全員で一緒に）

1. ターミナルで`pwd`コマンドを実行し、`sql-study-session`ディレクトリにいることを確認
2. DuckDB GUIを起動：
   - Mac/Linux: `./start_duckdb_ui.sh`を実行
   - Windows: `start_duckdb_ui.cmd`を実行
3. ブラウザが自動的に開くことを確認
4. GUI画面の各エリアを確認

---

## 演習2：sales.csvの中身を5行だけ表示

1. **クエリ入力エリア**に以下を入力：
```sql
SELECT * FROM 'data/sales.csv' LIMIT 5;
```

2. **実行ボタン**をクリック（または Ctrl/Cmd + Enter）

---

## 結果の確認

```
┌─────────────┬────────────┬──────────┬────────────┐
│ customer_id │ product_id │ quantity │ order_date │
│   varchar   │  varchar   │  int64   │  varchar   │
├─────────────┼────────────┼──────────┼────────────┤
│ C001        │ P001       │        5 │ 2024-01-15 │
│ C002        │ P003       │        2 │ 2024-01-16 │
│ C001        │ P002       │       10 │ 2024-01-17 │
│ C003        │ P001       │        3 │ 2024-01-18 │
│ C002        │ P004       │        1 │ 2024-01-19 │
└─────────────┴────────────┴──────────┴────────────┘
```

---

## 演習3：products.csvの中身を10行表示

1. クエリ入力エリアをクリアして新しいクエリを入力：
```sql
SELECT * FROM 'data/products.csv' LIMIT 10;
```

2. 実行して結果を確認（商品は5つしかないので、5行すべて表示されます）

---

## 演習4：customers.csvの中身を3行だけ表示

```sql
SELECT * FROM 'data/customers.csv' LIMIT 3;
```

<div class="tip">
<strong>GUI操作のコツ</strong>：
<ul>
<li>クエリ入力エリアでは、複数行に分けて書くことも可能</li>
<li>実行履歴は画面に残るので、前のクエリを参考にできる</li>
<li>結果はExcelのような表形式で見やすく表示される</li>
</ul>
</div>

---

# 🎯 練習問題

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

# 📝 本日のまとめ

今日学んだこと：
- <span class="check">DuckDB GUIの起動方法（`./start_duckdb_ui.sh` または `start_duckdb_ui.cmd`）</span>
- <span class="check">GUI画面の3つのエリア（クエリ入力、実行、結果表示）</span>
- <span class="check">`SELECT * FROM 'ファイル名' LIMIT n;` の基本構文</span>
- <span class="check">セミコロン（`;`）の重要性</span>
- <span class="check">CSVファイルから直接データを読み込む方法</span>

---

## GUIの便利な機能

- **自動補完**：入力中に候補が表示される場合がある
- **エラー表示**：構文エラーが分かりやすく表示される
- **結果のエクスポート**：結果をCSVなどで保存可能

---

# 🚀 次回予告

第2回では、必要な列だけを選んで表示する方法を学びます。
GUIだと列名も見やすく、どの列を選ぶか視覚的に確認しながら進められます！

---

# 📋 追加演習

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

GUIで以下のクエリを順番に実行し、結果を比較してください：

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

# ❓ FAQ

**Q: ブラウザが開かない**
A: ファイアウォールやセキュリティソフトが原因の可能性があります。表示されるURLを手動でブラウザに入力してください。

**Q: クエリが実行されない**
A: セミコロン（`;`）を忘れていませんか？また、実行ボタンをクリックするか、Ctrl/Cmd + Enterを押してください。

**Q: 文字化けしている**
A: ブラウザの文字エンコーディングがUTF-8になっているか確認してください。