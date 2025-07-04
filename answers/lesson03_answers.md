# 第3回：行を絞る - WHERE - 模範解答

## 問題1：様々な比較演算子

### 1. products.csvから価格がちょうど29999円の商品
```sql
SELECT * FROM 'data/products.csv' 
WHERE price = 29999;
```
- 結果：P005 ゲーミングチェア

### 2. sales.csvから数量が5個未満のデータ
```sql
SELECT * FROM 'data/sales.csv' 
WHERE quantity < 5;
```

### 3. customers.csvから2023年8月1日以降に登録した顧客
```sql
SELECT * FROM 'data/customers.csv' 
WHERE registration_date >= '2023-08-01';
```
- 結果：C003（鈴木一郎）以降の顧客

## 問題2：複合条件の練習

### 1. 電子機器カテゴリで、かつ価格が10000円以上の商品
```sql
SELECT * FROM 'data/products.csv'
WHERE category = '電子機器' AND price >= 10000;
```

### 2. 顧客IDがC001またはC002の売上データ
```sql
SELECT * FROM 'data/sales.csv'
WHERE customer_id = 'C001' OR customer_id = 'C002';
```

### 3. 2024年1月20日以降で、かつ数量が5個以上、かつ商品IDがP001の売上
```sql
SELECT * FROM 'data/sales.csv'
WHERE order_date >= '2024-01-20' 
  AND quantity >= 5 
  AND product_id = 'P001';
```

## 問題3：実務シナリオ

### 1. 在庫確認：1万円未満の低価格商品リスト
```sql
SELECT * FROM 'data/products.csv'
WHERE price < 10000;
```
- 結果：P002 ワイヤレスマウス（2,999円）

### 2. VIP顧客抽出：10個以上購入したことがある取引
```sql
SELECT * FROM 'data/sales.csv'
WHERE quantity >= 10;
```

### 3. 期間限定分析：1月25日から1月29日の売上
```sql
SELECT * FROM 'data/sales.csv'
WHERE order_date >= '2024-01-25' 
  AND order_date <= '2024-01-29';
```

## 問題4：エラーを見つけて修正

### エラー1：文字列のクォート忘れ
```sql
-- 修正前
SELECT * FROM 'data/sales.csv' WHERE customer_id = C001;

-- 修正後
SELECT * FROM 'data/sales.csv' WHERE customer_id = 'C001';
```

### エラー2：比較演算子の間違い
```sql
-- 修正前
SELECT * FROM 'data/products.csv' WHERE price => 10000;

-- 修正後
SELECT * FROM 'data/products.csv' WHERE price >= 10000;
```

### エラー3：AND/ORの優先順位
```sql
-- 修正前（意図と異なる動作）
SELECT * FROM 'data/sales.csv' 
WHERE customer_id = 'C001' OR customer_id = 'C002' AND quantity > 10;

-- 修正後（括弧で明確に）
SELECT * FROM 'data/sales.csv' 
WHERE (customer_id = 'C001' OR customer_id = 'C002') AND quantity > 10;
```

## チャレンジ問題

### 「購入していない商品」を見つけるヒント
```sql
-- 特定の商品が売れているかチェック
SELECT DISTINCT product_id 
FROM 'data/sales.csv'
WHERE product_id = 'P005';
-- 結果がある = 売れている

-- 全ての売れた商品のリスト
SELECT DISTINCT product_id 
FROM 'data/sales.csv'
ORDER BY product_id;
-- P001〜P005が全て売れていることが分かる
```

## 実践問題：販売戦略分析

### 1. 高額商品（3万円以上）の購入履歴
```sql
-- まず高額商品を確認
SELECT * FROM 'data/products.csv' WHERE price >= 30000;
-- P001, P004, P005

-- これらの商品の購入履歴
SELECT * FROM 'data/sales.csv'
WHERE product_id IN ('P001', 'P004', 'P005');
```

### 2. 少量購入（3個以下）の顧客を特定
```sql
SELECT DISTINCT customer_id 
FROM 'data/sales.csv'
WHERE quantity <= 3;
```

### 3. 特定期間（1月15日〜1月20日）の特定顧客（C001）の活動
```sql
SELECT * FROM 'data/sales.csv'
WHERE customer_id = 'C001'
  AND order_date >= '2024-01-15'
  AND order_date <= '2024-01-20';
```

## デバッグ練習

### なぜ結果が0件か？
```sql
SELECT * FROM 'data/products.csv' 
WHERE price > 100000;
-- 理由：最高価格が89,999円なので、10万円を超える商品は存在しない

SELECT * FROM 'data/sales.csv' 
WHERE order_date = '2024/01/15';
-- 理由：日付フォーマットが違う。正しくは '2024-01-15'
```

**学習のポイント**：
1. 文字列は必ずシングルクォート（'）で囲む
2. 日付もシングルクォートで囲み、YYYY-MM-DD形式を使用
3. AND/ORを組み合わせる時は括弧で優先順位を明確に
4. 比較演算子は正しく使い分ける（=, !=, >, >=, <, <=）
5. エラーメッセージや0件の結果には必ず理由がある