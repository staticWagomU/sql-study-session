# 第6回：グループで集計する - GROUP BY（GUI版）

## 本日のゴール
✅ 「〇〇ごと」の合計や件数を計算できるようになる

---

## 📚 座学（5-10分）

### 1. GROUP BYとは？
データをグループに分けて、各グループごとに集計する機能。
- 「顧客ごとの購入回数」
- 「商品ごとの売上数量」
- 「日付ごとの売上件数」

### 2. 基本構文
```sql
SELECT 
    グループ化する列,
    集計関数
FROM テーブル
GROUP BY グループ化する列;
```

### 3. 重要なルール
- SELECTに書く列は、GROUP BYに含まれるか、集計関数である必要がある
- GROUP BYと集計関数（COUNT、SUM、AVGなど）はセットで使う
- 複数の列でグループ化も可能

### 4. イメージで理解
```
元データ：
customer_id | quantity
C001        | 5
C001        | 10
C002        | 2
C002        | 1

GROUP BY customer_id の結果：
customer_id | SUM(quantity)
C001        | 15
C002        | 3
```

---

## 💻 演習（20-25分）

### 演習1：顧客IDごとの購入回数を数える

```sql
SELECT 
    customer_id,
    COUNT(*) AS 購入回数
FROM 'data/sales.csv'
GROUP BY customer_id;
```

結果を確認：
- 誰が一番多く購入している？
- 各顧客の購入パターンが見える

💡 **並び替えを追加**：
```sql
SELECT 
    customer_id,
    COUNT(*) AS 購入回数
FROM 'data/sales.csv'
GROUP BY customer_id
ORDER BY 購入回数 DESC;
```

### 演習2：商品IDごとの売上数量合計

```sql
SELECT 
    product_id,
    SUM(quantity) AS 総売上数量
FROM 'data/sales.csv'
GROUP BY product_id;
```

どの商品が一番売れている？

### 演習3：【応用】売上数量TOP3の商品

```sql
SELECT 
    product_id AS 商品ID,
    SUM(quantity) AS 総売上数量
FROM 'data/sales.csv'
GROUP BY product_id
ORDER BY 総売上数量 DESC
LIMIT 3;
```

これは複合技！
1. GROUP BYで商品ごとに集計
2. ORDER BYで多い順に並び替え
3. LIMITで上位3つだけ表示

---

## 🎯 応用練習

### 1. 複数の集計を同時に
```sql
SELECT 
    customer_id AS 顧客ID,
    COUNT(*) AS 購入回数,
    SUM(quantity) AS 総購入数,
    AVG(quantity) AS 平均購入数
FROM 'data/sales.csv'
GROUP BY customer_id;
```

### 2. 条件付きGROUP BY
```sql
-- 5個以上購入したことがある顧客の統計
SELECT 
    customer_id,
    COUNT(*) AS 大量購入回数,
    SUM(quantity) AS 総購入数
FROM 'data/sales.csv'
WHERE quantity >= 5
GROUP BY customer_id;
```

### 3. 日付でグループ化
```sql
-- 日付ごとの売上統計
SELECT 
    order_date AS 売上日,
    COUNT(*) AS 取引件数,
    SUM(quantity) AS 販売数量
FROM 'data/sales.csv'
GROUP BY order_date
ORDER BY order_date;
```

---

## 🔍 実践的な使い方

### ケース1：顧客分析レポート
```sql
-- 優良顧客の特定（購入回数3回以上）
SELECT 
    customer_id AS 顧客ID,
    COUNT(*) AS 購入回数,
    SUM(quantity) AS 総購入数
FROM 'data/sales.csv'
GROUP BY customer_id
HAVING COUNT(*) >= 3
ORDER BY 総購入数 DESC;
```

💡 **HAVING句**：GROUP BY後の結果に対する条件（WHERE句はGROUP BY前）

### ケース2：商品カテゴリ分析
```sql
-- カテゴリごとの商品統計
SELECT 
    category AS カテゴリ,
    COUNT(*) AS 商品数,
    AVG(price) AS 平均価格,
    MAX(price) AS 最高価格
FROM 'data/products.csv'
GROUP BY category;
```

---

## 🌟 GUIでGROUP BYを理解する

### ステップバイステップで確認

1. **まず元データを確認**
```sql
SELECT customer_id, quantity 
FROM 'data/sales.csv'
ORDER BY customer_id;
```

2. **GROUP BYで集計**
```sql
SELECT 
    customer_id,
    SUM(quantity) AS 合計
FROM 'data/sales.csv'
GROUP BY customer_id;
```

→ GUIなら元データと集計結果を並べて比較できる！

### よくあるエラーと対処法

❌ **エラーになる例**：
```sql
-- product_idがGROUP BYにない！
SELECT 
    customer_id,
    product_id,  -- これがエラーの原因
    COUNT(*)
FROM 'data/sales.csv'
GROUP BY customer_id;
```

✅ **正しい例**：
```sql
SELECT 
    customer_id,
    COUNT(*) AS 購入回数
FROM 'data/sales.csv'
GROUP BY customer_id;
```

---

## 📊 GROUP BYの活用パターン

### 1. ランキング作成
```sql
-- 売れ筋商品ランキング
SELECT 
    product_id,
    SUM(quantity) AS 売上数
FROM 'data/sales.csv'
GROUP BY product_id
ORDER BY 売上数 DESC;
```

### 2. 期間集計
```sql
-- 月ごとの集計（仮想的な例）
SELECT 
    SUBSTR(order_date, 1, 7) AS 年月,
    COUNT(*) AS 件数
FROM 'data/sales.csv'
GROUP BY SUBSTR(order_date, 1, 7);
```

### 3. 複数列でのグループ化
```sql
-- 顧客×商品の組み合わせ
SELECT 
    customer_id,
    product_id,
    SUM(quantity) AS 購入数
FROM 'data/sales.csv'
GROUP BY customer_id, product_id;
```

---

## 📝 まとめ

今日学んだこと：
- ✅ `GROUP BY`でデータをグループ化
- ✅ グループごとに集計関数を適用
- ✅ 複数の集計を同時に実行可能
- ✅ ORDER BY、LIMITと組み合わせてランキング作成
- ✅ HAVING句でグループ化後の条件指定

### よく使うパターン
```sql
-- 基本形
SELECT 
    グループ列,
    COUNT(*),
    SUM(数値列),
    AVG(数値列)
FROM テーブル
GROUP BY グループ列;

-- ランキング
SELECT 
    グループ列,
    集計関数 AS 集計値
FROM テーブル
GROUP BY グループ列
ORDER BY 集計値 DESC
LIMIT 10;
```

---

## 🚀 次回予告
第7回では、INNER JOINを使って複数のテーブルを結合する方法を学びます。
IDだけでなく、商品名や顧客名を表示できるようになります！

---

## ❓ よくある質問

**Q: WHEREとHAVINGの違いは？**
A: WHERE = GROUP BY前の絞り込み、HAVING = GROUP BY後の絞り込み

**Q: GROUP BYの列は必ずSELECTに書く？**
A: 書かなくても動きますが、結果が分かりにくくなるので書くことを推奨。

**Q: 集計結果が0の場合も表示したい**
A: LEFT JOINなどを使う必要があります（第8回で学習）。