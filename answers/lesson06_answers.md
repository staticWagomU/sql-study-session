# 第6回：グループで集計する - GROUP BY - 模範解答

## 問題1：基本的なGROUP BY

### 1. 商品IDごとの販売回数
```sql
SELECT 
    product_id,
    COUNT(*) AS 販売回数
FROM 'data/sales.csv'
GROUP BY product_id
ORDER BY product_id;
```

### 2. 日付ごとの売上件数と合計数量
```sql
SELECT 
    order_date,
    COUNT(*) AS 売上件数,
    SUM(quantity) AS 合計数量
FROM 'data/sales.csv'
GROUP BY order_date
ORDER BY order_date;
```

### 3. カテゴリごとの商品数と最高価格
```sql
SELECT 
    category,
    COUNT(*) AS 商品数,
    MAX(price) AS 最高価格
FROM 'data/products.csv'
GROUP BY category;
```

## 問題2：複数の集計関数

### 顧客ごとの購買行動分析
```sql
SELECT 
    customer_id,
    COUNT(*) AS 購入回数,
    SUM(quantity) AS 総購入数,
    AVG(quantity) AS 平均購入数,
    MAX(quantity) AS 最大購入数,
    MIN(quantity) AS 最小購入数
FROM 'data/sales.csv'
GROUP BY customer_id
ORDER BY customer_id;
```

## 問題3：HAVING句の活用

### 1. 2回以上売れた商品のリスト
```sql
SELECT product_id, COUNT(*) as 販売回数
FROM 'data/sales.csv'
GROUP BY product_id
HAVING COUNT(*) >= 2
ORDER BY 販売回数 DESC;
```

### 2. 合計購入数が15個以上の顧客
```sql
SELECT 
    customer_id,
    SUM(quantity) as 総購入数
FROM 'data/sales.csv'
GROUP BY customer_id
HAVING SUM(quantity) >= 15
ORDER BY 総購入数 DESC;
```

### 3. 平均価格が3万円以上のカテゴリ
```sql
SELECT 
    category,
    AVG(price) as 平均価格
FROM 'data/products.csv'
GROUP BY category
HAVING AVG(price) >= 30000;
```

## 問題4：実務シナリオ

### 1. ABC分析（売れ筋商品の特定）
```sql
-- 商品ごとの売上数量を集計し、上位20%を特定
SELECT 
    product_id,
    SUM(quantity) as 総売上数量,
    ROUND(SUM(quantity) * 100.0 / (SELECT SUM(quantity) FROM 'data/sales.csv'), 2) as 売上比率
FROM 'data/sales.csv'
GROUP BY product_id
ORDER BY 総売上数量 DESC
LIMIT (SELECT CEIL(COUNT(DISTINCT product_id) * 0.2) FROM 'data/sales.csv');
```

### 2. 顧客セグメント分析
```sql
SELECT 
    CASE 
        WHEN SUM(quantity) * 10000 < 50000 THEN 'ライト'
        WHEN SUM(quantity) * 10000 < 200000 THEN 'ミドル'
        ELSE 'ヘビー'
    END AS 顧客層,
    COUNT(*) AS 顧客数
FROM 'data/sales.csv'
GROUP BY 
    CASE 
        WHEN SUM(quantity) * 10000 < 50000 THEN 'ライト'
        WHEN SUM(quantity) * 10000 < 200000 THEN 'ミドル'
        ELSE 'ヘビー'
    END;
```

## チャレンジ問題

### 複数列でのGROUP BY
```sql
-- 顧客×商品の組み合わせごとの購入パターン分析
SELECT 
    customer_id,
    product_id,
    COUNT(*) as 購入回数,
    SUM(quantity) as 合計購入数
FROM 'data/sales.csv'
GROUP BY customer_id, product_id
ORDER BY customer_id, product_id;
```

## 実践問題：月次レポート作成

### 1. 日別売上サマリー
```sql
SELECT 
    order_date,
    COUNT(*) AS 取引件数,
    COUNT(DISTINCT customer_id) AS ユニーク顧客数,
    SUM(quantity) AS 総販売数量
FROM 'data/sales.csv'
GROUP BY order_date
ORDER BY order_date;
```

### 2. 商品別パフォーマンス
```sql
SELECT 
    product_id,
    COUNT(*) AS 販売回数,
    SUM(quantity) AS 総販売数量,
    COUNT(DISTINCT customer_id) AS 購入顧客数
FROM 'data/sales.csv'
GROUP BY product_id
ORDER BY 総販売数量 DESC;
```

## デバッグ練習

### エラー1：GROUP BYに含まれない列
```sql
-- 修正前（エラー）
SELECT customer_id, product_id, COUNT(*)
FROM 'data/sales.csv'
GROUP BY customer_id;

-- 修正後
SELECT customer_id, product_id, COUNT(*)
FROM 'data/sales.csv'
GROUP BY customer_id, product_id;
```

### エラー2：集計関数なしのGROUP BY
```sql
-- 修正前（意味がない）
SELECT customer_id
FROM 'data/sales.csv'
GROUP BY customer_id;

-- 修正後（集計を追加）
SELECT customer_id, COUNT(*) as 購入回数
FROM 'data/sales.csv'
GROUP BY customer_id;
```

### エラー3：HAVINGとWHEREの混同
```sql
-- 修正前（エラー：句の順序が違う）
SELECT customer_id, COUNT(*) as cnt
FROM 'data/sales.csv'
HAVING customer_id = 'C001'
GROUP BY customer_id;

-- 修正後
SELECT customer_id, COUNT(*) as cnt
FROM 'data/sales.csv'
WHERE customer_id = 'C001'
GROUP BY customer_id;
```

## 応用：GROUP BYの組み合わせ

### 1. サブクエリを使った分析
```sql
-- 平均購入数量を上回る顧客のリスト
WITH avg_purchase AS (
    SELECT AVG(quantity) as avg_qty FROM 'data/sales.csv'
)
SELECT customer_id, AVG(quantity) as 顧客平均
FROM 'data/sales.csv'
GROUP BY customer_id
HAVING AVG(quantity) > (SELECT avg_qty FROM avg_purchase)
ORDER BY 顧客平均 DESC;
```

### 2. 複雑な集計（顧客ごとの最頻値商品）
```sql
-- 各顧客が最も多く購入した商品
WITH customer_product_counts AS (
    SELECT 
        customer_id,
        product_id,
        SUM(quantity) as total_qty,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY SUM(quantity) DESC) as rn
    FROM 'data/sales.csv'
    GROUP BY customer_id, product_id
)
SELECT customer_id, product_id, total_qty
FROM customer_product_counts
WHERE rn = 1;
```

## 総合演習：売上分析ダッシュボード

### 1. 顧客別売上ランキングTOP3
```sql
SELECT 
    customer_id,
    SUM(quantity) as 総購入数
FROM 'data/sales.csv'
GROUP BY customer_id
ORDER BY 総購入数 DESC
LIMIT 3;
```

### 2. 商品別売上ランキングTOP3
```sql
SELECT 
    product_id,
    SUM(quantity) as 総販売数
FROM 'data/sales.csv'
GROUP BY product_id
ORDER BY 総販売数 DESC
LIMIT 3;
```

### 3. 日別売上推移
```sql
SELECT 
    order_date,
    COUNT(*) as 件数,
    SUM(quantity) as 数量
FROM 'data/sales.csv'
GROUP BY order_date
ORDER BY order_date;
```

## 上級問題：クロス集計

### 顧客×日付のクロス集計表
```sql
SELECT 
    customer_id,
    SUM(CASE WHEN order_date = '2024-01-15' THEN quantity ELSE 0 END) AS "1月15日",
    SUM(CASE WHEN order_date = '2024-01-16' THEN quantity ELSE 0 END) AS "1月16日",
    SUM(CASE WHEN order_date = '2024-01-17' THEN quantity ELSE 0 END) AS "1月17日",
    SUM(CASE WHEN order_date = '2024-01-18' THEN quantity ELSE 0 END) AS "1月18日",
    SUM(CASE WHEN order_date = '2024-01-19' THEN quantity ELSE 0 END) AS "1月19日",
    SUM(CASE WHEN order_date = '2024-01-20' THEN quantity ELSE 0 END) AS "1月20日"
FROM 'data/sales.csv'
GROUP BY customer_id
ORDER BY customer_id;
```

**学習のポイント**：
1. GROUP BYで指定した列は、SELECTでも使える
2. 集計関数（COUNT、SUM、AVG等）はグループごとに計算される
3. HAVINGは集計後の結果に対する条件（WHEREは集計前）
4. 複数列でのGROUP BYも可能
5. CASE文を使うと条件付き集計ができる