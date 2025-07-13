---
marp: true
theme: orange-gradient
paginate: true
header: 'SQL勉強会 - 第0回'
---

<!-- _class: lead -->

# 第0回：事前準備<br />- Windows以外編 -

SQL勉強会で使用するDuckDBのインストール方法

---

## 手順1：ターミナルを開く

### macOS
1. **Command + Space**を押す
2. `ターミナル`または`terminal`を入力
3. **Enter キー**を押す

### Linux
1. **Ctrl + Alt + T**を押す
2. または、アプリケーションメニューから`Terminal`を選択

![bg right:40% 95%](https://github.com/user-attachments/assets/fd0af0fb-d993-419d-b614-d96321e5eca5)

---

## 手順2：DuckDBをインストール

以下のコマンドを実行：

### macOS（Homebrewを使用）
```bash
brew install duckdb
```

### macOS・Linux（公式インストーラー）
```bash
curl https://install.duckdb.org | sh
```

✅ 成功すると右のような表示になります

![bg right:40% 95%](https://github.com/user-attachments/assets/a3ed2bec-4df0-4ec9-bd5c-fc250ed66231)

---

## 手順3：インストールの確認

1. ターミナルを**一度閉じて再度開く**（公式インストーラーを使用した場合）
2. 以下のコマンドを実行：

```bash
duckdb -version
```

✅ バージョン情報が表示されれば完了！

![bg right:45% 90%](https://github.com/user-attachments/assets/c29e9871-e43a-4fcd-8ea5-223b83660444)

