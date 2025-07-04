# 第5回：全体を集計する - COUNT, SUM, AVG（GUI版）

## 本日のゴール
✅ 表全体の件数や合計、平均値を計算できるようになる

---

## 📚 座学（5分）

### 1. 集計関数とは？
複数の行をまとめて1つの値を計算する関数。
- **COUNT**：件数を数える
- **SUM**：合計を計算する
- **AVG**：平均を計算する
- その他：MAX（最大）、MIN（最小）

### 2. 基本構文
```sql
-- 件数を数える
SELECT COUNT(*) FROM 'data/sales.csv';

-- 合計を計算
SELECT SUM(quantity) FROM 'data/sales.csv';

-- 平均を計算
SELECT AVG(price) FROM 'data/products.csv';
```

### 3. ポイント
- `COUNT(*)`：全行数を数える（NULLも含む）
- `COUNT(列名)`：その列でNULL以外の値を数える
- SUMやAVGは数値列にのみ使用可能
- 結果は1行だけ返ってくる

### 4. GUIでの集計の利点
- 計算結果がすぐに確認できる
- 複数の集計を同時に実行して比較できる
- エラーがあればすぐに分かる

---

## 💻 演習（25分）

### 演習1：sales.csvの売上データは全部で何件？

```sql
SELECT COUNT(*) FROM 'data/sales.csv';
```

結果：15件

💡 **応用**：特定条件の件数を数える
```sql
-- C001さんの購入回数は？
SELECT COUNT(*) FROM 'data/sales.csv'
WHERE customer_id = 'C001';
```

### 演習2：売上数量の合計を計算

```sql
SELECT SUM(quantity) FROM 'data/sales.csv';
```

結果を確認：
- 全部で何個売れた？
- 1件あたり平均何個？（合計÷件数）

### 演習3：商品の平均価格を計算

```sql
SELECT AVG(price) FROM 'data/products.csv';
```

💡 **さらに詳しく**：
```sql
-- 最高価格、最低価格、平均価格を一度に
SELECT 
    MAX(price) AS 最高価格,
    MIN(price) AS 最低価格,
    AVG(price) AS 平均価格
FROM 'data/products.csv';
```

---

## 🎯 応用練習

### 1. 複数の集計を同時に実行
```sql
SELECT 
    COUNT(*) AS 売上件数,
    SUM(quantity) AS 総販売数,
    AVG(quantity) AS 平均販売数,
    MAX(quantity) AS 最大販売数,
    MIN(quantity) AS 最小販売数
FROM 'data/sales.csv';
```

### 2. 条件付き集計
```sql
-- 10個以上の大量購入の統計
SELECT 
    COUNT(*) AS 大量購入回数,
    SUM(quantity) AS 大量購入総数,
    AVG(quantity) AS 大量購入平均
FROM 'data/sales.csv'
WHERE quantity >= 10;
```

### 3. 計算式と組み合わせ
```sql
-- 仮想的な売上金額の計算（商品価格を10,000円と仮定）
SELECT 
    SUM(quantity) AS 総販売数,
    SUM(quantity) * 10000 AS 推定売上金額
FROM 'data/sales.csv';
```

---

## 🔍 実践的な使い方

### ケース1：在庫管理
```sql
-- 商品マスタの統計情報
SELECT 
    COUNT(*) AS 商品数,
    AVG(price) AS 平均価格,
    SUM(price) AS 全商品合計価格
FROM 'data/products.csv'
WHERE category = '電子機器';
```

### ケース2：売上分析
```sql
-- 期間を絞った売上分析
SELECT 
    COUNT(*) AS 取引回数,
    SUM(quantity) AS 総販売数
FROM 'data/sales.csv'
WHERE order_date >= '2024-01-20';
```

### ケース3：顧客分析
```sql
-- アクティブ顧客数（購入履歴のある顧客）
SELECT COUNT(DISTINCT customer_id) AS アクティブ顧客数
FROM 'data/sales.csv';
```

---

## 🌟 GUIでの効果的な分析

### 段階的な分析アプローチ

1. **まず全体を把握**
```sql
SELECT COUNT(*) AS 全データ数 FROM 'data/sales.csv';
```

2. **条件を加えて絞り込み**
```sql
SELECT COUNT(*) AS 特定顧客数 
FROM 'data/sales.csv' 
WHERE customer_id = 'C001';
```

3. **割合を計算**
```sql
-- C001さんの購入割合
SELECT 
    COUNT(CASE WHEN customer_id = 'C001' THEN 1 END) AS C001の購入回数,
    COUNT(*) AS 全購入回数,
    ROUND(COUNT(CASE WHEN customer_id = 'C001' THEN 1 END) * 100.0 / COUNT(*), 2) AS 購入割合
FROM 'data/sales.csv';
```

---

## 📊 集計関数の使い分け

| 関数 | 用途 | 例 |
|------|------|-----|
| COUNT(*) | 全行数を数える | 売上件数、顧客数 |
| COUNT(列) | NULL以外を数える | 有効データ数 |
| SUM | 合計値 | 売上総額、在庫総数 |
| AVG | 平均値 | 平均単価、平均購入数 |
| MAX | 最大値 | 最高価格、最大購入数 |
| MIN | 最小値 | 最低価格、最小購入数 |

---

## 💡 注意点とTips

### NULL値の扱い
```sql
-- COUNT(*)はNULLも数える
-- COUNT(列名)はNULLを除外
-- SUM、AVGもNULLを除外して計算
```

### 0件の場合
```sql
-- 該当データが0件の場合
SELECT COUNT(*) FROM 'data/sales.csv' 
WHERE customer_id = 'C999';  -- 存在しない顧客
-- 結果：0

SELECT SUM(quantity) FROM 'data/sales.csv' 
WHERE customer_id = 'C999';
-- 結果：NULL（0ではない！）
```

---

## 📝 まとめ

今日学んだこと：
- ✅ `COUNT(*)`で件数を数える
- ✅ `SUM(列名)`で合計を計算
- ✅ `AVG(列名)`で平均を計算
- ✅ MAX、MINで最大・最小値も取得可能
- ✅ 複数の集計を同時に実行できる

### よく使うパターン
```sql
-- 基本的な統計情報
SELECT 
    COUNT(*) AS 件数,
    SUM(数値列) AS 合計,
    AVG(数値列) AS 平均,
    MAX(数値列) AS 最大,
    MIN(数値列) AS 最小
FROM テーブル;

-- 条件付き集計
SELECT 集計関数
FROM テーブル
WHERE 条件;
```

---

## 🚀 次回予告
第6回では、GROUP BYを使って「顧客ごと」「商品ごと」といったグループ単位での集計を学びます。
より実践的な分析ができるようになります！

---

## ❓ よくある質問

**Q: COUNT(1)とCOUNT(*)の違いは？**
A: 実質的に同じです。COUNT(*)の方が一般的。

**Q: 小数点以下を丸めたい**
A: ROUND関数を使います。`ROUND(AVG(price), 2)`で小数点以下2桁。

**Q: 文字列は集計できる？**
A: COUNTは可能ですが、SUMやAVGは数値列のみです。