# 第5回：全体を集計する - COUNT, SUM, AVG - 模範解答

## 問題1：基本的な集計関数

### 1. products.csvの最高価格を表示
```sql
SELECT MAX(price) FROM 'data/products.csv';
-- 結果：89999（ノートパソコン）
```

### 2. sales.csvの最小購入数量を表示
```sql
SELECT MIN(quantity) FROM 'data/sales.csv';
-- 結果：1
```

### 3. customers.csvの登録顧客数をカウント
```sql
SELECT COUNT(*) FROM 'data/customers.csv';
-- 結果：7
```

## 問題2：条件付き集計

### 1. 電子機器カテゴリの商品数と平均価格
```sql
SELECT 
    COUNT(*) AS 商品数,
    AVG(price) AS 平均価格
FROM 'data/products.csv'
WHERE category = '電子機器';
```

### 2. 2024年1月25日以降の売上件数と合計数量
```sql
SELECT 
    COUNT(*) AS 売上件数,
    SUM(quantity) AS 合計数量
FROM 'data/sales.csv'
WHERE order_date >= '2024-01-25';
```

### 3. 顧客C002の購入回数と平均購入数量
```sql
SELECT 
    COUNT(*) AS 購入回数,
    AVG(quantity) AS 平均購入数量
FROM 'data/sales.csv'
WHERE customer_id = 'C002';
```

## 問題3：複数の集計を組み合わせ

### products.csvの統計情報を一度に表示
```sql
SELECT 
    COUNT(*) AS 商品総数,
    MAX(price) AS 最高価格,
    MIN(price) AS 最低価格,
    AVG(price) AS 平均価格,
    SUM(price) AS 価格の合計
FROM 'data/products.csv';
```

## 問題4：実務シナリオ

### 1. 日次売上サマリー（2024年1月20日）
```sql
SELECT 
    COUNT(*) AS 取引件数,
    COUNT(DISTINCT product_id) AS 販売商品種類数,
    SUM(quantity) AS 総販売数量
FROM 'data/sales.csv'
WHERE order_date = '2024-01-20';
```

### 2. 在庫価値の計算
```sql
SELECT SUM(price) AS 全商品合計価格
FROM 'data/products.csv';
-- 結果：180,995円（全商品を1つずつの価値）
```

## チャレンジ問題

### 1. 全取引の平均購入数量（小数点以下1桁）
```sql
SELECT ROUND(AVG(quantity), 1) AS 平均購入数量
FROM 'data/sales.csv';
```

### 2. 購入数量が平均以上の取引件数
```sql
-- まず平均を確認
SELECT AVG(quantity) FROM 'data/sales.csv';
-- 結果：約5.73

-- 平均以上の取引をカウント
SELECT COUNT(*) AS 平均以上の取引数
FROM 'data/sales.csv'
WHERE quantity >= (SELECT AVG(quantity) FROM 'data/sales.csv');
```

## 実践問題：売上分析レポート

### 1. 期間売上分析（1月15日〜1月20日）
```sql
SELECT 
    COUNT(*) AS 期間中の総売上件数,
    SUM(quantity) AS 期間中の総販売数量,
    COUNT(*) / 6.0 AS 一日あたりの平均取引件数  -- 6日間
FROM 'data/sales.csv'
WHERE order_date >= '2024-01-15' 
  AND order_date <= '2024-01-20';
```

### 2. 顧客別の購入分析（特定顧客C001）
```sql
SELECT 
    COUNT(*) AS 総購入回数,
    SUM(quantity) AS 総購入数量,
    AVG(quantity) AS 一回あたりの平均購入数量
FROM 'data/sales.csv'
WHERE customer_id = 'C001';
```

## デバッグ練習

### エラー1：集計関数の使い方
```sql
-- 修正前（エラー：GROUP BYが必要）
SELECT customer_id, COUNT(*) 
FROM 'data/sales.csv';

-- 修正後
SELECT customer_id, COUNT(*) 
FROM 'data/sales.csv'
GROUP BY customer_id;
```

### エラー2：文字列にSUMを使用
```sql
-- 修正前（エラー：文字列は集計できない）
SELECT SUM(customer_name) 
FROM 'data/customers.csv';

-- 修正後（件数をカウント）
SELECT COUNT(customer_name) 
FROM 'data/customers.csv';
```

### エラー3：集計関数とWHERE句の組み合わせ
```sql
-- 修正前（エラー：WHERE句で集計関数は使えない）
SELECT COUNT(*) 
FROM 'data/sales.csv' 
WHERE COUNT(*) > 5;

-- 修正後（HAVINGを使用）
SELECT customer_id, COUNT(*) as cnt
FROM 'data/sales.csv'
GROUP BY customer_id
HAVING COUNT(*) > 5;
```

## 応用：NULL値の扱い

### 1. COUNT(*)とCOUNT(列名)の違い
```sql
SELECT 
    COUNT(*) AS 全行数,
    COUNT(customer_id) AS 顧客ID数,
    COUNT(DISTINCT customer_id) AS ユニーク顧客数
FROM 'data/sales.csv';
-- 結果：15, 15, 5（C001〜C005）
```

### 2. NULLを0として扱う
```sql
-- 仮にNULL値があった場合の対処法
SELECT 
    SUM(COALESCE(quantity, 0)) AS 合計数量
FROM 'data/sales.csv';
```

## 総合演習：データヘルスチェック

### sales.csvのヘルスチェック
```sql
SELECT 
    'sales' AS テーブル名,
    COUNT(*) AS レコード数,
    MIN(quantity) AS 最小数量,
    MAX(quantity) AS 最大数量,
    AVG(quantity) AS 平均数量,
    COUNT(CASE WHEN quantity > 20 THEN 1 END) AS 異常値の可能性
FROM 'data/sales.csv';
```

### products.csvのヘルスチェック
```sql
SELECT 
    'products' AS テーブル名,
    COUNT(*) AS レコード数,
    MIN(price) AS 最低価格,
    MAX(price) AS 最高価格,
    AVG(price) AS 平均価格,
    COUNT(CASE WHEN price = 0 THEN 1 END) AS 価格0の商品数
FROM 'data/products.csv';
```

**学習のポイント**：
1. COUNT(*)は全行数、COUNT(列名)はNULL以外の数
2. SUM、AVGは数値列のみに使用可能
3. ROUND関数で小数点以下の桁数を制御
4. 集計関数の結果は1行で返される
5. WHERE句では集計関数を使えない（HAVINGを使う）