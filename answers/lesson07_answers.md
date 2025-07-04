# 第7回：表をくっつける - INNER JOIN - 模範解答

## 問題1：基本的なJOIN

### 1. salesとcustomersを結合し、顧客名付きの売上一覧を表示
```sql
SELECT 
    s.*,
    c.customer_name
FROM 'data/sales.csv' AS s
INNER JOIN 'data/customers.csv' AS c
ON s.customer_id = c.customer_id
ORDER BY s.order_date;
```

### 2. salesとproductsを結合し、商品名と価格付きの売上一覧を表示
```sql
SELECT 
    s.*,
    p.product_name,
    p.price
FROM 'data/sales.csv' AS s
INNER JOIN 'data/products.csv' AS p
ON s.product_id = p.product_id
ORDER BY s.order_date;
```

### 3. productsとsalesを結合し、売れた商品の情報だけを表示
```sql
SELECT DISTINCT
    p.*
FROM 'data/products.csv' AS p
INNER JOIN 'data/sales.csv' AS s
ON p.product_id = s.product_id
ORDER BY p.product_id;
```

## 問題2：JOINした結果の加工

### salesとproductsを結合して、売上明細を作成
```sql
SELECT 
    s.order_date AS 売上日,
    p.product_name AS 商品名,
    p.price AS 単価,
    s.quantity AS 数量,
    p.price * s.quantity AS 小計
FROM 'data/sales.csv' AS s
INNER JOIN 'data/products.csv' AS p 
ON s.product_id = p.product_id
ORDER BY s.order_date;
```

## 問題3：3つのテーブルを結合

### sales、customers、productsを全て結合
```sql
SELECT 
    c.customer_name AS 顧客名,
    p.product_name AS 商品名,
    p.category AS カテゴリ,
    s.quantity AS 数量,
    p.price * s.quantity AS 金額
FROM 'data/sales.csv' AS s
INNER JOIN 'data/customers.csv' AS c ON s.customer_id = c.customer_id
INNER JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
ORDER BY s.order_date;
```

## 問題4：条件付きJOIN

### 1. 電子機器カテゴリの売上だけを、顧客名付きで表示
```sql
SELECT 
    s.order_date,
    c.customer_name,
    p.product_name,
    s.quantity
FROM 'data/sales.csv' AS s
INNER JOIN 'data/customers.csv' AS c ON s.customer_id = c.customer_id
INNER JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
WHERE p.category = '電子機器'
ORDER BY s.order_date;
```

### 2. 特定期間（1月20日以降）の売上を、商品名・顧客名付きで表示
```sql
SELECT 
    s.order_date,
    c.customer_name,
    p.product_name,
    s.quantity,
    p.price * s.quantity AS 売上金額
FROM 'data/sales.csv' AS s
INNER JOIN 'data/customers.csv' AS c ON s.customer_id = c.customer_id
INNER JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
WHERE s.order_date >= '2024-01-20'
ORDER BY s.order_date;
```

### 3. 高額商品（3万円以上）の購入履歴を、顧客情報付きで表示
```sql
SELECT 
    s.order_date,
    c.customer_name,
    c.email,
    p.product_name,
    p.price,
    s.quantity
FROM 'data/sales.csv' AS s
INNER JOIN 'data/customers.csv' AS c ON s.customer_id = c.customer_id
INNER JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
WHERE p.price >= 30000
ORDER BY s.order_date;
```

## チャレンジ問題

### どの顧客がどのカテゴリの商品をいくつ買ったか
```sql
SELECT 
    c.customer_name AS 顧客名,
    p.category AS カテゴリ,
    SUM(s.quantity) AS 購入数量
FROM 'data/sales.csv' AS s
INNER JOIN 'data/customers.csv' AS c ON s.customer_id = c.customer_id
INNER JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name, p.category
ORDER BY c.customer_name, p.category;
```

## 実践問題：売上レポート

### 1. 日別売上明細（顧客名、商品名、金額付き）
```sql
SELECT 
    s.order_date AS 売上日,
    c.customer_name AS 顧客名,
    p.product_name AS 商品名,
    s.quantity AS 数量,
    p.price AS 単価,
    p.price * s.quantity AS 金額
FROM 'data/sales.csv' AS s
INNER JOIN 'data/customers.csv' AS c ON s.customer_id = c.customer_id
INNER JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
ORDER BY s.order_date, c.customer_name;
```

### 2. 顧客別購入商品リスト（重複なし）
```sql
SELECT DISTINCT
    c.customer_name AS 顧客名,
    p.product_name AS 購入商品
FROM 'data/sales.csv' AS s
INNER JOIN 'data/customers.csv' AS c ON s.customer_id = c.customer_id
INNER JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
ORDER BY c.customer_name, p.product_name;
```

### 3. カテゴリ別売上集計（顧客数、総数量、総金額）
```sql
SELECT 
    p.category AS カテゴリ,
    COUNT(DISTINCT s.customer_id) AS 購入顧客数,
    SUM(s.quantity) AS 総販売数量,
    SUM(p.price * s.quantity) AS 総売上金額
FROM 'data/sales.csv' AS s
INNER JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY 総売上金額 DESC;
```

## デバッグ練習

### エラー1：テーブル別名の使い忘れ
```sql
-- 修正前（エラー：曖昧な列名）
SELECT customer_name, product_name
FROM 'data/sales.csv' AS s
INNER JOIN 'data/customers.csv' AS c ON customer_id = customer_id;

-- 修正後
SELECT c.customer_name, p.product_name
FROM 'data/sales.csv' AS s
INNER JOIN 'data/customers.csv' AS c ON s.customer_id = c.customer_id
INNER JOIN 'data/products.csv' AS p ON s.product_id = p.product_id;
```

### エラー2：結合条件の間違い
```sql
-- 修正前（エラー：間違った結合）
SELECT * FROM 'data/sales.csv' s
INNER JOIN 'data/products.csv' p ON s.customer_id = p.product_id;

-- 修正後
SELECT * FROM 'data/sales.csv' s
INNER JOIN 'data/products.csv' p ON s.product_id = p.product_id;
```

### エラー3：存在しない列の参照
```sql
-- 修正前（エラー：列名が違う）
SELECT s.sale_id, c.name, p.item_name
FROM 'data/sales.csv' s
INNER JOIN 'data/customers.csv' c ON s.customer_id = c.customer_id
INNER JOIN 'data/products.csv' p ON s.product_id = p.product_id;

-- 修正後
SELECT s.customer_id, c.customer_name, p.product_name
FROM 'data/sales.csv' s
INNER JOIN 'data/customers.csv' c ON s.customer_id = c.customer_id
INNER JOIN 'data/products.csv' p ON s.product_id = p.product_id;
```

## 応用：JOINの活用

### 1. 自己結合（C001が買った商品を、他に誰が買ったか）
```sql
SELECT DISTINCT s2.customer_id, c.customer_name
FROM 'data/sales.csv' s1
INNER JOIN 'data/sales.csv' s2 ON s1.product_id = s2.product_id
INNER JOIN 'data/customers.csv' c ON s2.customer_id = c.customer_id
WHERE s1.customer_id = 'C001' AND s2.customer_id != 'C001'
ORDER BY s2.customer_id;
```

### 2. 顧客ごとの「お気に入りカテゴリ」
```sql
WITH customer_category_purchases AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        p.category,
        SUM(s.quantity) as total_qty,
        ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY SUM(s.quantity) DESC) as rn
    FROM 'data/sales.csv' s
    INNER JOIN 'data/customers.csv' c ON s.customer_id = c.customer_id
    INNER JOIN 'data/products.csv' p ON s.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name, p.category
)
SELECT customer_name, category AS お気に入りカテゴリ, total_qty AS 購入数
FROM customer_category_purchases
WHERE rn = 1;
```

## 総合演習：360度顧客ビュー（C001）

```sql
-- C001の完全な購買履歴
SELECT 
    s.order_date AS 購入日,
    p.product_name AS 商品名,
    p.category AS カテゴリ,
    p.price AS 単価,
    s.quantity AS 数量,
    p.price * s.quantity AS 小計
FROM 'data/sales.csv' s
INNER JOIN 'data/products.csv' p ON s.product_id = p.product_id
WHERE s.customer_id = 'C001'
ORDER BY s.order_date;

-- C001の統計情報
SELECT 
    COUNT(*) AS 購入回数,
    SUM(p.price * s.quantity) AS 総購入金額,
    AVG(p.price * s.quantity) AS 平均購入金額
FROM 'data/sales.csv' s
INNER JOIN 'data/products.csv' p ON s.product_id = p.product_id
WHERE s.customer_id = 'C001';
```

## 上級問題：クロスセル分析

### P001を買った顧客が、他に何を買っているか
```sql
SELECT 
    p2.product_name AS 関連商品,
    COUNT(DISTINCT s2.customer_id) AS 購入人数
FROM 'data/sales.csv' s1
INNER JOIN 'data/sales.csv' s2 
    ON s1.customer_id = s2.customer_id 
    AND s2.product_id != 'P001'
INNER JOIN 'data/products.csv' p2 
    ON s2.product_id = p2.product_id
WHERE s1.product_id = 'P001'
GROUP BY p2.product_id, p2.product_name
ORDER BY 購入人数 DESC;
```

**学習のポイント**：
1. INNER JOINは両方のテーブルに存在するデータのみ結合
2. ONで結合条件を指定（通常は主キーと外部キー）
3. テーブル別名（AS）を使って記述を簡潔に
4. 複数テーブルの結合も可能（順番に結合）
5. JOINした後もWHERE、GROUP BY、ORDER BYが使える