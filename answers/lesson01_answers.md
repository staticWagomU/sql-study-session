# 第1回：準備と最初のクエリ - 模範解答

## 問題1：異なるLIMIT値での表示

### 1. sales.csvを8行表示
```sql
SELECT * FROM 'data/sales.csv' LIMIT 8;
```

### 2. products.csvを2行だけ表示
```sql
SELECT * FROM 'data/products.csv' LIMIT 2;
```

### 3. customers.csvを全件表示（LIMITなし）
```sql
SELECT * FROM 'data/customers.csv';
```
- 結果：7行全てが表示される

## 問題2：ファイルパスの理解

### 1. パスの区切り文字を間違える
```sql
SELECT * FROM 'data\sales.csv' LIMIT 5;
```
- エラー：ファイルが見つからない
- 理由：Unix/Mac/Linuxでは`/`を使用（Windowsでも`/`が推奨）

### 2. ファイル名を間違える
```sql
SELECT * FROM 'data/sale.csv' LIMIT 5;
```
- エラー：ファイルが存在しない
- 正しくは`sales.csv`（複数形）

### 3. 拡張子を忘れる
```sql
SELECT * FROM 'data/sales' LIMIT 5;
```
- エラー：ファイルが見つからない
- `.csv`拡張子が必要

## 問題3：複数のクエリを連続実行

```sql
-- 最初のクエリ
SELECT * FROM 'data/customers.csv' LIMIT 1;
-- 結果：C001の田中太郎さんのデータ

-- 2番目のクエリ
SELECT * FROM 'data/customers.csv' LIMIT 2;
-- 結果：C001とC002の2件

-- 3番目のクエリ
SELECT * FROM 'data/customers.csv' LIMIT 3;
-- 結果：C001、C002、C003の3件
```

**ポイント**：LIMITは常に先頭からn件を取得

## 問題4：データの行数を推測

実際に確認：
```sql
SELECT COUNT(*) FROM 'data/customers.csv';  -- 7行
SELECT COUNT(*) FROM 'data/products.csv';   -- 5行
SELECT COUNT(*) FROM 'data/sales.csv';      -- 15行
```

## チャレンジ問題

### sales.csvの最後の5行だけを表示
```sql
-- 方法1：ORDER BYを使用（第4回の先取り）
SELECT * FROM 'data/sales.csv' 
ORDER BY order_date DESC 
LIMIT 5;
```

**解説**：
- `ORDER BY order_date DESC`で日付の新しい順に並び替え
- その後`LIMIT 5`で上位5件（＝最新5件）を取得
- 完全に「最後の5行」を取得するには、行番号での並び替えが必要（DuckDBでは少し複雑）

### 別解（より高度）
```sql
-- ROWIDを使った方法（システム内部の行番号）
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER () as rn 
    FROM 'data/sales.csv'
) 
WHERE rn > (SELECT COUNT(*) - 5 FROM 'data/sales.csv');
```

**学習のポイント**：
1. LIMITは常に「最初からn件」を取得
2. ファイルパスは正確に記述する必要がある
3. セミコロン（`;`）を忘れずに
4. エラーメッセージをよく読むことが大切