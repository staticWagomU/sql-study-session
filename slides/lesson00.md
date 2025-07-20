---
marp: true
theme: orange-gradient
paginate: true
header: 'SQL勉強会 - 第0回'
---

<!-- _class: lead -->

# SQL勉強会

## 初心者向けSQL学習カリキュラム

---

# コンセプト

- **短いよ** - 1回30分
- **説明は少ないよ** - 座学よりも演習優先

---

# 対象者と目的

## 対象者
- 未経験者
- 初心者（SELECT, FROM, WHERE程度）

## 目的
<div class="check">SQLの基礎を学び、自力でデータを取得できる第一歩を踏み出す</div>

---

# 得られること

1. **簡単なSQLを自力で書ける**

2. **手作業のデータ集計を効率化**

3. **他者のSQLが読めるようになる**

---

# カリキュラム（全8回）

<style scoped>
.columns {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2em;
}
table { 
  font-size: 0.85em; 
  width: 100%;
}
td, th { 
  padding: 0.3em 0.5em; 
}
h2 {
  font-size: 1.2em;
  margin-bottom: 0.5em;
}
</style>

<div class="columns">
<div>

## 前半（1-4回）

| 回 | テーマ | 学習内容 |
|----|--------|----------|
| 1 | 準備と最初のクエリ | LIMIT |
| 2 | 列を選ぶ | SELECT, AS |
| 3 | 行を絞る | WHERE, AND |
| 4 | 並び替える | ORDER BY |

</div>
<div>

## 後半（5-8回）

| 回 | テーマ | 学習内容 |
|----|--------|----------|
| 5 | 全体を集計する | COUNT, SUM, AVG |
| 6 | グループで集計する | GROUP BY |
| 7 | 表をくっつける | INNER JOIN |
| 8 | 総合演習 | LEFT JOIN |

</div>
</div>

---

# 学習の進め方

1. **各レッスン** → `lessons/`フォルダ
2. **演習問題** → 各レッスン内
3. **答え合わせ** → `answers/`フォルダ

---

<!-- _class: lead -->

# それでは始めましょう！

## 第1回：準備と最初のクエリへ
