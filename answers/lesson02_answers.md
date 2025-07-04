# 第2回：列を選ぶ - SELECT 列名 - 模範解答

## 問題1：必要な情報だけを抽出

### 1. customers.csvから顧客IDとメールアドレスだけを表示
```sql
SELECT customer_id, email FROM 'data/customers.csv';
```

### 2. products.csvから商品名だけを表示（列名は変更しない）
```sql
SELECT product_name FROM 'data/products.csv';
```

### 3. sales.csvから注文日と数量だけを表示
```sql
SELECT order_date, quantity FROM 'data/sales.csv';
```

## 問題2：意味のある列名に変更

### 顧客一覧を日本語で分かりやすく表示
```sql
SELECT 
    customer_id AS 顧客番号,
    customer_name AS お客様名,
    address AS ご住所
FROM 'data/customers.csv';
```

### 商品マスタを見やすく表示
```sql
SELECT 
    product_name AS 商品名,
    price AS 販売価格,
    category AS 商品分類
FROM 'data/products.csv';
```

## 問題3：列の順番を工夫

### 1. メール送信用リスト（メール、名前、IDの順）
```sql
SELECT 
    email AS メールアドレス,
    customer_name AS 氏名,
    customer_id AS 顧客ID
FROM 'data/customers.csv';
```

### 2. 価格表（価格、商品名、カテゴリの順）
```sql
SELECT 
    price AS 価格,
    product_name AS 商品名,
    category AS カテゴリ
FROM 'data/products.csv';
```

## 問題4：よくある間違いを修正

### エラー1：カンマ忘れ
```sql
-- 修正前
SELECT customer_id customer_name FROM 'data/customers.csv';

-- 修正後
SELECT customer_id, customer_name FROM 'data/customers.csv';
```

### エラー2：存在しない列名
```sql
-- 修正前
SELECT id, name FROM 'data/customers.csv';

-- 修正後
SELECT customer_id, customer_name FROM 'data/customers.csv';
```

### エラー3：ASの位置が間違い
```sql
-- 修正前
SELECT customer_name お名前 AS FROM 'data/customers.csv';

-- 修正後
SELECT customer_name AS お名前 FROM 'data/customers.csv';
```

## チャレンジ問題

### sales.csvから以下の形式でレポートを作成
```sql
SELECT 
    order_date AS 購入日,
    customer_id AS 顧客コード,
    product_id AS 商品コード,
    quantity AS 購入数量
FROM 'data/sales.csv';
```

**さらに見やすく**：
```sql
SELECT 
    order_date AS "購入日",
    customer_id AS "顧客",
    product_id AS "商品",
    quantity AS "数量"
FROM 'data/sales.csv'
ORDER BY order_date;  -- 日付順に並べる（第4回の内容）
```

## 実践問題：請求書フォーマット

### sales.csvから請求書に必要な情報を抽出
```sql
SELECT 
    order_date AS 取引日,
    customer_id AS 得意先コード,
    product_id AS 商品コード,
    quantity AS 数量
FROM 'data/sales.csv';
```

**より実践的な請求書フォーマット**：
```sql
-- 将来的にはJOINを使って名称も表示
SELECT 
    order_date AS 請求日,
    customer_id AS 請求先,
    product_id AS 品番,
    quantity AS 数量,
    quantity * 10000 AS 金額  -- 仮の単価で計算
FROM 'data/sales.csv';
```

**学習のポイント**：
1. 列名はカンマ（`,`）で区切る
2. ASを使って日本語の列名にできる
3. 列の順番は自由に変更可能
4. SELECT文では計算式も使える
5. 存在しない列名を指定するとエラーになる