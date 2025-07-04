# 第3回：行を絞る - WHERE（GUI版）

## 本日のゴール
✅ 特定の条件に合うデータだけを絞り込めるようになる

---

## 📚 座学（5-10分）

### 1. WHERE句の役割
膨大なデータから必要な情報だけを取り出す「フィルター」の役割。
例：1万件の売上データから「今日の売上」だけを見たい

### 2. WHERE句の基本構文
```sql
SELECT 列名 FROM 'ファイル名' WHERE 条件;
```

### 3. 条件の書き方
```sql
-- 数値の比較
WHERE price > 1000      -- 1000より大きい
WHERE price >= 1000     -- 1000以上
WHERE price = 1000      -- 1000と等しい
WHERE price < 1000      -- 1000より小さい
WHERE price <= 1000     -- 1000以下

-- 文字列の比較
WHERE customer_id = 'C001'    -- 完全一致（''で囲む）
WHERE category = '電子機器'    -- 日本語もOK

-- 複数条件
WHERE price > 1000 AND category = '電子機器'  -- 両方満たす
WHERE price > 50000 OR category = '家具'      -- どちらか満たす
```

### 4. GUIでWHERE句を使うメリット
- 条件を変えながら結果をすぐに確認できる
- 件数が表示されるので、絞り込みの効果が分かる
- エラーがあればすぐに気づける

---

## 💻 演習（20-25分）

### 演習1：価格が1000円以上の商品を探そう

1. クエリ入力エリアに入力：
```sql
SELECT * FROM 'data/products.csv' 
WHERE price >= 1000;
```

2. 実行して結果を確認
   - 何件表示されたか？
   - どの商品が条件を満たしたか？

💡 **確認ポイント**：価格が2999円のワイヤレスマウスも含まれている

### 演習2：顧客IDが「C001」の売上データだけを表示

```sql
SELECT * FROM 'data/sales.csv' 
WHERE customer_id = 'C001';
```

⚠️ **注意**：文字列は必ずシングルクォート（`'`）で囲む！

結果を見て確認：
- C001の田中太郎さんの購入履歴だけが表示される
- 何回購入しているか数えてみよう

### 演習3：商品IDが「P003」で、かつ数量が10個以上のデータ

```sql
SELECT * FROM 'data/sales.csv' 
WHERE product_id = 'P003' AND quantity >= 10;
```

結果の解釈：
- メカニカルキーボード（P003）を10個以上買った記録
- 該当するデータは何件？

---

## 🎯 応用練習

### 1. OR条件を使ってみよう
```sql
-- 電子機器または価格が30000円以上の商品
SELECT product_name, price, category
FROM 'data/products.csv'
WHERE category = '電子機器' OR price >= 30000;
```

### 2. 条件を組み合わせよう
```sql
-- 2024年1月20日以降の、数量5個以上の売上
SELECT * FROM 'data/sales.csv'
WHERE order_date >= '2024-01-20' 
  AND quantity >= 5;
```

### 3. 否定条件を使ってみよう
```sql
-- C001以外の顧客の購入履歴
SELECT * FROM 'data/sales.csv'
WHERE customer_id != 'C001';
```

---

## 🔍 実践的な使い方

### ケース1：在庫確認
```sql
-- 高額商品（3万円以上）のリスト
SELECT 
    product_id AS 商品コード,
    product_name AS 商品名,
    price AS 価格
FROM 'data/products.csv'
WHERE price >= 30000;
```

### ケース2：顧客分析
```sql
-- 特定顧客の大量購入（10個以上）履歴
SELECT 
    customer_id AS 顧客ID,
    product_id AS 商品ID,
    quantity AS 購入数,
    order_date AS 購入日
FROM 'data/sales.csv'
WHERE quantity >= 10;
```

---

## 🌟 GUIでの効率的なデバッグ

### よくあるエラーと対処法

1. **文字列のクォート忘れ**
```sql
-- ❌ エラーになる
WHERE customer_id = C001

-- ✅ 正しい
WHERE customer_id = 'C001'
```

2. **比較演算子の間違い**
```sql
-- ❌ 代入演算子（SQLでは使えない）
WHERE price := 1000

-- ✅ 比較演算子
WHERE price = 1000
```

3. **ANDとORの優先順位**
```sql
-- 括弧を使って明確に
WHERE (price > 10000 OR category = '家具') 
  AND quantity > 5
```

---

## 📊 条件による絞り込みの確認

GUIなら結果の件数がすぐ分かるので、以下を試してみましょう：

```sql
-- 全データ
SELECT COUNT(*) FROM 'data/sales.csv';
-- 結果：15件

-- C001の購入履歴
SELECT COUNT(*) FROM 'data/sales.csv' 
WHERE customer_id = 'C001';
-- 結果：？件

-- 10個以上の大量購入
SELECT COUNT(*) FROM 'data/sales.csv' 
WHERE quantity >= 10;
-- 結果：？件
```

---

## 📝 まとめ

今日学んだこと：
- ✅ `WHERE`句で条件に合うデータだけを抽出
- ✅ 数値の比較（`>`, `>=`, `=`, `<`, `<=`）
- ✅ 文字列の比較（シングルクォートで囲む）
- ✅ `AND`で複数条件をすべて満たす
- ✅ `OR`でいずれかの条件を満たす

### よく使うパターン
```sql
-- 数値の範囲指定
WHERE price >= 1000 AND price <= 5000

-- 特定の値のリスト（第4回以降で学ぶIN句の代わり）
WHERE customer_id = 'C001' 
   OR customer_id = 'C002' 
   OR customer_id = 'C003'

-- 日付の範囲
WHERE order_date >= '2024-01-15' 
  AND order_date <= '2024-01-20'
```

---

## 🚀 次回予告
第4回では、ORDER BY句を使ってデータを並び替える方法を学びます。
価格の高い順、日付の新しい順など、見たい順番でデータを表示できるようになります！

---

## ❓ よくある質問

**Q: 日付の比較はどうすればいい？**
A: 文字列として比較できます。`WHERE order_date >= '2024-01-20'`のように。

**Q: NULLのデータを探すには？**
A: `WHERE 列名 IS NULL`を使います（`= NULL`ではないので注意）。

**Q: 大文字小文字は区別される？**
A: 文字列の値は区別されます。'C001'と'c001'は別物です。