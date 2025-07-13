---
marp: true
theme: orange-gradient
paginate: true
header: 'SQL勉強会 - 第0回'
---

<!-- _class: lead -->

# 第0回：事前準備<br />- Windows編 -

SQL勉強会で使用するDuckDBのインストール方法

---

## 手順1：ターミナルを開く

1. **Windows キー**を押す
2. `wt`、`cmd`、`powershell` のいずれかを入力
3. **Enter キー**を押す

![bg right:40% 90%](https://github.com/user-attachments/assets/04c0930d-9edc-4952-882b-2fd2d0ed0e6d)

---

## 手順2：DuckDBをインストール

以下のコマンドを実行：

```bash
winget install DuckDB.cli
```

✅ 成功すると右のような表示になります

![bg right:50% 95%](https://github.com/user-attachments/assets/4bdbf232-332a-4300-af27-6f99d3a1a043)

---

## 手順3：インストールの確認

1. ウィンドウを**一度閉じて再度開く**
2. 以下のコマンドを実行：

```bash
duckdb -version
```

✅ バージョン情報が表示されれば完了！

![bg right:45% 90%](https://github.com/user-attachments/assets/c8792cef-a14a-45d2-aa81-f736a6038b1e)

