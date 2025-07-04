# 第4回：並び替える - ORDER BY - 模範解答

## 問題1：基本的な並び替え

### 1. customers.csvを顧客名のあいうえお順（昇順）で表示
```sql
SELECT * FROM 'data/customers.csv'
ORDER BY customer_name;
-- または明示的にASCを指定
SELECT * FROM 'data/customers.csv'
ORDER BY customer_name ASC;
```

### 2. products.csvを価格の安い順で表示
```sql
SELECT * FROM 'data/products.csv'
ORDER BY price;
-- または
SELECT * FROM 'data/products.csv'
ORDER BY price ASC;
```

### 3. sales.csvを数量の多い順で表示（上位5件のみ）
```sql
SELECT * FROM 'data/sales.csv'
ORDER BY quantity DESC
LIMIT 5;
```

## 問題2：複数列での並び替え

### 1. sales.csvを顧客ID順、その中で日付の新しい順
```sql
SELECT * FROM 'data/sales.csv'
ORDER BY customer_id, order_date DESC;
```

### 2. products.csvをカテゴリ順、その中で価格の高い順
```sql
SELECT * FROM 'data/products.csv'
ORDER BY category, price DESC;
```

## 問題3：条件と組み合わせた並び替え

### 1. 電子機器カテゴリの商品を価格の高い順で表示
```sql
SELECT * FROM 'data/products.csv'
WHERE category = '電子機器'
ORDER BY price DESC;
```

### 2. C001の購入履歴を日付の古い順で表示
```sql
SELECT * FROM 'data/sales.csv'
WHERE customer_id = 'C001'
ORDER BY order_date;
-- またはASCを明示
ORDER BY order_date ASC;
```

### 3. 5個以上の購入を、購入日の新しい順で上位3件表示
```sql
SELECT * FROM 'data/sales.csv'
WHERE quantity >= 5
ORDER BY order_date DESC
LIMIT 3;
```

## 問題4：実務シナリオ

### 1. 売れ筋商品ランキング（数量の多い商品TOP3）
```sql
SELECT product_id, SUM(quantity) as total
FROM 'data/sales.csv'
GROUP BY product_id
ORDER BY total DESC
LIMIT 3;
```

### 2. 最近の取引履歴（直近5件）
```sql
SELECT * FROM 'data/sales.csv'
ORDER BY order_date DESC
LIMIT 5;
```

### 3. 高額商品カタログ（3万円以上を高い順に）
```sql
SELECT * FROM 'data/products.csv'
WHERE price >= 30000
ORDER BY price DESC;
```

## チャレンジ問題

### 各顧客の最初の購入を見つける
```sql
-- 方法1: 各顧客の最古の購入日を表示
SELECT customer_id, MIN(order_date) as first_purchase
FROM 'data/sales.csv'
GROUP BY customer_id
ORDER BY customer_id;

-- 方法2: 詳細情報も含めて表示（サブクエリ使用）
SELECT s.* 
FROM 'data/sales.csv' s
INNER JOIN (
    SELECT customer_id, MIN(order_date) as first_date
    FROM 'data/sales.csv'
    GROUP BY customer_id
) first_purchases
ON s.customer_id = first_purchases.customer_id 
AND s.order_date = first_purchases.first_date
ORDER BY s.customer_id;
```

## 実践問題：レポート作成

### 1. 今月の売上を新しい順で表示（全項目）
```sql
SELECT * FROM 'data/sales.csv'
ORDER BY order_date DESC;
```

### 2. 購入数量が多い順に顧客IDを表示（重複あり）
```sql
SELECT customer_id, quantity
FROM 'data/sales.csv'
ORDER BY quantity DESC;
```

### 3. 商品IDごとの売上を日付順に表示
```sql
SELECT * FROM 'data/sales.csv'
ORDER BY product_id, order_date;
```

## デバッグ練習

### エラー1：ORDER BYの位置
```sql
-- 修正前（エラー）
SELECT * FROM 'data/products.csv'
ORDER BY price DESC
WHERE category = '電子機器';

-- 修正後
SELECT * FROM 'data/products.csv'
WHERE category = '電子機器'
ORDER BY price DESC;
```

### エラー2：存在しない列での並び替え
```sql
-- 修正前（エラー）
SELECT product_name, price
FROM 'data/products.csv'
ORDER BY product_id;

-- 修正後（方法1：product_idも選択）
SELECT product_id, product_name, price
FROM 'data/products.csv'
ORDER BY product_id;

-- 修正後（方法2：選択している列で並び替え）
SELECT product_name, price
FROM 'data/products.csv'
ORDER BY product_name;
```

### エラー3：DESCの位置
```sql
-- 修正前（エラー）
SELECT * FROM 'data/sales.csv'
ORDER BY DESC quantity;

-- 修正後
SELECT * FROM 'data/sales.csv'
ORDER BY quantity DESC;
```

## 応用：並び替えの活用

### 1. 列番号での並び替え
```sql
SELECT customer_id, product_id, quantity
FROM 'data/sales.csv'
ORDER BY 3 DESC;
-- 3番目の列（quantity）で降順
```

### 2. 計算結果での並び替え
```sql
SELECT *, quantity * 10000 as amount
FROM 'data/sales.csv'
ORDER BY amount DESC;
```

**学習のポイント**：
1. ORDER BYは必ずWHERE句の後に書く
2. LIMITがある場合は、ORDER BY → LIMITの順
3. DESCは降順（大→小）、ASCは昇順（小→大）
4. 複数列で並び替える場合は、左から順に優先される
5. 列番号でも並び替え可能だが、列名の方が分かりやすい