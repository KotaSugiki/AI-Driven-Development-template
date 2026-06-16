# 技術仕様書: GitHub インストール対応

## 概要 (Executive Summary)

本テンプレートのインストーラー（`install.ps1`）およびREADMEの導入手順を、**GitHub（`https://github.com/KotaSugiki/AI-Driven-Development-template`）からワンコマンドでインストール**できるよう対応しました。

## 要件 (Requirements)

### 機能要件

1. **GitHub 用インストールコマンドの提供**
   - GitHub の Raw URL を使用した PowerShell ワンライナーを提供する
   - `install.ps1` が GitHub リポジトリの ZIP アーカイブから `.agents` フォルダを取得・展開できるようにする

2. **README の更新**
   - GitHub 用のインストールコマンドを記載する

### 非機能要件

- 追加の依存関係を導入しないこと（PowerShell 標準機能のみ）
- エラーハンドリングが適切であること

## アーキテクチャと技術スタック (Architecture & Tech Stack)

### 技術スタック

- **スクリプト言語**: PowerShell 5.1+（Windows 標準）
- **パッケージ配布**: GitHub の ZIP アーカイブ API

### 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| `install.ps1` | GitHub からの ZIP ダウンロード・展開 |
| `README.md` | GitHub 用インストール手順の記載 |

### install.ps1 の設計

```powershell
$zipUrl = "https://github.com/KotaSugiki/AI-Driven-Development-template/archive/refs/heads/main.zip"
```

### README.md のインストールコマンド

```powershell
Invoke-Expression (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/KotaSugiki/AI-Driven-Development-template/main/install.ps1")
```

## 状態管理 (State Management)

本変更はステートレスなスクリプト修正のため、状態管理は不要です。
スクリプトは毎回実行時に ZIP をダウンロード → 展開 → クリーンアップのフローを完結します。

## 検証計画

1. GitHub 用ワンライナーで `.agents` フォルダが正常に展開されることを確認
2. `-Source` パラメータでの切り替えが正しく動作することを確認
