# 第8回：総合演習と LEFT JOIN - 模範解答

## 問題1：LEFT JOINの基本

### 1. 全顧客の一覧（購入履歴の有無に関わらず）
```sql
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(s.order_date) AS 購入回数
FROM 'data/customers.csv' AS c
LEFT JOIN 'data/sales.csv' AS s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY c.customer_id;
```

### 2. 全商品の売上状況（売れていない商品も含む）
```sql
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    COALESCE(SUM(s.quantity), 0) AS 総売上数量
FROM 'data/products.csv' AS p
LEFT JOIN 'data/sales.csv' AS s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.price
ORDER BY p.product_id;
```

### 3. 顧客ごとの総購入金額（購入なしは0円として）
```sql
SELECT 
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(s.quantity * p.price), 0) AS 総購入金額
FROM 'data/customers.csv' AS c
LEFT JOIN 'data/sales.csv' AS s ON c.customer_id = s.customer_id
LEFT JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY 総購入金額 DESC;
```

## 問題2：データ品質チェック

### 1. sales.csvに存在するが、customers.csvに存在しない顧客ID
```sql
-- 方法1: LEFT JOINを使用
SELECT DISTINCT s.customer_id
FROM 'data/sales.csv' AS s
LEFT JOIN 'data/customers.csv' AS c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
-- 結果: C005が存在する

-- 方法2: NOT INを使用
SELECT DISTINCT customer_id
FROM 'data/sales.csv'
WHERE customer_id NOT IN (SELECT customer_id FROM 'data/customers.csv');
```

### 2. 一度も売れていない商品のリスト
```sql
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.category
FROM 'data/products.csv' AS p
LEFT JOIN 'data/sales.csv' AS s ON p.product_id = s.product_id
WHERE s.product_id IS NULL
ORDER BY p.product_id;
-- 結果: 全商品が売れているため0件
```

## 問題3：総合分析クエリ

### 1. 顧客セグメンテーション
```sql
SELECT 
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(s.quantity * p.price), 0) AS 購入金額,
    CASE 
        WHEN COALESCE(SUM(s.quantity * p.price), 0) >= 100000 THEN 'VIP顧客'
        WHEN COALESCE(SUM(s.quantity * p.price), 0) > 0 THEN '通常顧客'
        ELSE '休眠顧客'
    END AS 顧客区分
FROM 'data/customers.csv' AS c
LEFT JOIN 'data/sales.csv' AS s ON c.customer_id = s.customer_id
LEFT JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
ORDER BY 購入金額 DESC;
```

### 2. 商品推奨リスト（まだ買っていない商品）
```sql
-- 特定顧客（C001）がまだ買っていない商品
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.category
FROM 'data/products.csv' AS p
WHERE p.product_id NOT IN (
    SELECT DISTINCT product_id 
    FROM 'data/sales.csv' 
    WHERE customer_id = 'C001'
)
ORDER BY p.price DESC;
```

## 問題4：レポート作成

### 顧客価値分析レポート
```sql
WITH customer_stats AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.registration_date AS 登録日,
        COUNT(s.order_date) AS 総購入回数,
        COALESCE(SUM(s.quantity * p.price), 0) AS 総購入金額,
        MAX(s.order_date) AS 最終購入日
    FROM 'data/customers.csv' AS c
    LEFT JOIN 'data/sales.csv' AS s ON c.customer_id = s.customer_id
    LEFT JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name, c.registration_date
),
customer_favorite AS (
    SELECT 
        c.customer_id,
        p.category,
        ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY SUM(s.quantity) DESC) as rn
    FROM 'data/customers.csv' AS c
    LEFT JOIN 'data/sales.csv' AS s ON c.customer_id = s.customer_id
    LEFT JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
    WHERE s.customer_id IS NOT NULL
    GROUP BY c.customer_id, p.category
)
SELECT 
    cs.*,
    cf.category AS お気に入りカテゴリ,
    CASE 
        WHEN cs.総購入金額 >= 100000 THEN 'VIP'
        WHEN cs.総購入金額 > 0 THEN '通常'
        ELSE '休眠'
    END AS 顧客ランク
FROM customer_stats cs
LEFT JOIN customer_favorite cf ON cs.customer_id = cf.customer_id AND cf.rn = 1
ORDER BY cs.総購入金額 DESC;
```

## チャレンジ問題：RFM分析

```sql
WITH rfm_data AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        -- R: 最終購入からの日数（最新日を2024-01-29と仮定）
        JULIANDAY('2024-01-29') - JULIANDAY(MAX(s.order_date)) AS recency,
        -- F: 購入頻度
        COUNT(s.order_date) AS frequency,
        -- M: 購入金額
        COALESCE(SUM(s.quantity * p.price), 0) AS monetary
    FROM 'data/customers.csv' AS c
    LEFT JOIN 'data/sales.csv' AS s ON c.customer_id = s.customer_id
    LEFT JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT 
    customer_id,
    customer_name,
    recency,
    frequency,
    monetary,
    -- スコアリング（簡易版）
    CASE 
        WHEN recency <= 5 THEN 3
        WHEN recency <= 10 THEN 2
        ELSE 1
    END AS R_score,
    CASE 
        WHEN frequency >= 3 THEN 3
        WHEN frequency >= 2 THEN 2
        ELSE 1
    END AS F_score,
    CASE 
        WHEN monetary >= 100000 THEN 3
        WHEN monetary >= 50000 THEN 2
        ELSE 1
    END AS M_score
FROM rfm_data
WHERE frequency > 0  -- 購入履歴のある顧客のみ
ORDER BY monetary DESC;
```

## 実践問題：ダッシュボード用クエリ集

### 1. KPIサマリー
```sql
WITH kpi_data AS (
    SELECT 
        COUNT(DISTINCT CASE WHEN s.customer_id IS NOT NULL THEN c.customer_id END) AS アクティブ顧客数,
        COALESCE(SUM(s.quantity * p.price), 0) AS 総売上金額,
        COALESCE(AVG(s.quantity * p.price), 0) AS 平均購入単価
    FROM 'data/customers.csv' AS c
    LEFT JOIN 'data/sales.csv' AS s ON c.customer_id = s.customer_id
    LEFT JOIN 'data/products.csv' AS p ON s.product_id = p.product_id
),
top_products AS (
    SELECT 
        p.product_name,
        SUM(s.quantity) as total_qty
    FROM 'data/sales.csv' s
    INNER JOIN 'data/products.csv' p ON s.product_id = p.product_id
    GROUP BY p.product_id, p.product_name
    ORDER BY total_qty DESC
    LIMIT 3
)
SELECT 
    k.*,
    (SELECT STRING_AGG(product_name || '(' || total_qty || '個)', ', ') FROM top_products) AS 売れ筋商品TOP3
FROM kpi_data k;
```

### 2. 期間比較分析
```sql
SELECT 
    '前半(1/15-1/22)' AS 期間,
    COUNT(*) AS 取引件数,
    SUM(s.quantity) AS 販売数量,
    SUM(s.quantity * p.price) AS 売上金額
FROM 'data/sales.csv' s
INNER JOIN 'data/products.csv' p ON s.product_id = p.product_id
WHERE s.order_date BETWEEN '2024-01-15' AND '2024-01-22'
UNION ALL
SELECT 
    '後半(1/23-1/29)' AS 期間,
    COUNT(*) AS 取引件数,
    SUM(s.quantity) AS 販売数量,
    SUM(s.quantity * p.price) AS 売上金額
FROM 'data/sales.csv' s
INNER JOIN 'data/products.csv' p ON s.product_id = p.product_id
WHERE s.order_date BETWEEN '2024-01-23' AND '2024-01-29';
```

### 3. カテゴリ別パフォーマンス
```sql
SELECT 
    p.category,
    COUNT(DISTINCT s.customer_id) AS 購入顧客数,
    SUM(s.quantity) AS 販売数量,
    SUM(s.quantity * p.price) AS 売上金額,
    AVG(p.price) AS 平均単価
FROM 'data/products.csv' p
LEFT JOIN 'data/sales.csv' s ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY 売上金額 DESC;
```

## デバッグ練習：複雑なクエリ

### 修正前（エラー）
```sql
SELECT 
    c.customer_name,
    p.product_name,
    SUM(s.quantity),
    SUM(s.quantity * p.price)
FROM 'data/customers.csv' c
LEFT JOIN 'data/sales.csv' s
LEFT JOIN 'data/products.csv' p
GROUP BY c.customer_name;
```

### 修正後
```sql
SELECT 
    c.customer_name,
    p.product_name,
    SUM(s.quantity) AS 合計数量,
    SUM(s.quantity * p.price) AS 合計金額
FROM 'data/customers.csv' c
LEFT JOIN 'data/sales.csv' s ON c.customer_id = s.customer_id
LEFT JOIN 'data/products.csv' p ON s.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name, p.product_id, p.product_name
ORDER BY c.customer_name, p.product_name;
```

## 応用：ウィンドウ関数の代替

### 1. 各顧客の購入履歴に「何回目の購入か」を付ける
```sql
SELECT 
    s1.customer_id,
    s1.order_date,
    s1.product_id,
    s1.quantity,
    (SELECT COUNT(*) 
     FROM 'data/sales.csv' s2 
     WHERE s2.customer_id = s1.customer_id 
       AND s2.order_date <= s1.order_date) AS 購入回数
FROM 'data/sales.csv' s1
ORDER BY s1.customer_id, s1.order_date;
```

### 2. 日別売上の累計
```sql
SELECT 
    s1.order_date,
    SUM(s1.quantity * p1.price) AS 日別売上,
    (SELECT SUM(s2.quantity * p2.price)
     FROM 'data/sales.csv' s2
     INNER JOIN 'data/products.csv' p2 ON s2.product_id = p2.product_id
     WHERE s2.order_date <= s1.order_date) AS 累計売上
FROM 'data/sales.csv' s1
INNER JOIN 'data/products.csv' p1 ON s1.product_id = p1.product_id
GROUP BY s1.order_date
ORDER BY s1.order_date;
```

## 総合演習：ECサイト分析

### 1. コホート分析
```sql
-- 登録月別の顧客の購買行動
SELECT 
    SUBSTR(c.registration_date, 1, 7) AS 登録月,
    COUNT(DISTINCT c.customer_id) AS 顧客数,
    COUNT(DISTINCT CASE WHEN s.customer_id IS NOT NULL THEN c.customer_id END) AS 購入顧客数,
    COALESCE(SUM(s.quantity * p.price), 0) AS 売上金額
FROM 'data/customers.csv' c
LEFT JOIN 'data/sales.csv' s ON c.customer_id = s.customer_id
LEFT JOIN 'data/products.csv' p ON s.product_id = p.product_id
GROUP BY SUBSTR(c.registration_date, 1, 7)
ORDER BY 登録月;
```

### 2. バスケット分析
```sql
-- よく一緒に買われる商品の組み合わせ（同日購入）
SELECT 
    p1.product_name AS 商品1,
    p2.product_name AS 商品2,
    COUNT(*) AS 組み合わせ回数
FROM 'data/sales.csv' s1
INNER JOIN 'data/sales.csv' s2 
    ON s1.customer_id = s2.customer_id 
    AND s1.order_date = s2.order_date
    AND s1.product_id < s2.product_id
INNER JOIN 'data/products.csv' p1 ON s1.product_id = p1.product_id
INNER JOIN 'data/products.csv' p2 ON s2.product_id = p2.product_id
GROUP BY p1.product_name, p2.product_name
ORDER BY 組み合わせ回数 DESC;
```

## 最終課題：月次売上レポート

```sql
-- 統合レポート
WITH customer_summary AS (
    -- 1. 全顧客の当月売上サマリー
    SELECT 
        c.customer_id,
        c.customer_name,
        c.registration_date,
        COALESCE(COUNT(s.order_date), 0) AS 購入回数,
        COALESCE(SUM(s.quantity), 0) AS 購入数量,
        COALESCE(SUM(s.quantity * p.price), 0) AS 購入金額
    FROM 'data/customers.csv' c
    LEFT JOIN 'data/sales.csv' s ON c.customer_id = s.customer_id
    LEFT JOIN 'data/products.csv' p ON s.product_id = p.product_id
    GROUP BY c.customer_id, c.customer_name, c.registration_date
),
new_customer_contribution AS (
    -- 2. 新規顧客の売上貢献度
    SELECT 
        '新規顧客' AS 顧客タイプ,
        COUNT(DISTINCT c.customer_id) AS 顧客数,
        COALESCE(SUM(s.quantity * p.price), 0) AS 売上金額
    FROM 'data/customers.csv' c
    LEFT JOIN 'data/sales.csv' s ON c.customer_id = s.customer_id
    LEFT JOIN 'data/products.csv' p ON s.product_id = p.product_id
    WHERE SUBSTR(c.registration_date, 1, 7) = '2024-01'  -- 当月登録と仮定
),
category_composition AS (
    -- 3. カテゴリ別売上構成比
    SELECT 
        p.category,
        SUM(s.quantity * p.price) AS カテゴリ売上,
        ROUND(SUM(s.quantity * p.price) * 100.0 / 
              (SELECT SUM(s2.quantity * p2.price) 
               FROM 'data/sales.csv' s2 
               INNER JOIN 'data/products.csv' p2 ON s2.product_id = p2.product_id), 2) AS 構成比
    FROM 'data/sales.csv' s
    INNER JOIN 'data/products.csv' p ON s.product_id = p.product_id
    GROUP BY p.category
)
-- 最終出力
SELECT '=== 月次売上レポート ===' AS レポート;
SELECT * FROM customer_summary ORDER BY 購入金額 DESC;
SELECT * FROM new_customer_contribution;
SELECT * FROM category_composition ORDER BY カテゴリ売上 DESC;
```

**学習のポイント**：
1. LEFT JOINは左側の全データを保持（右側にない場合はNULL）
2. COALESCE関数でNULLを別の値に変換
3. WITH句（CTE）で複雑なクエリを整理
4. CASE文で条件分岐
5. サブクエリやウィンドウ関数の代替手法