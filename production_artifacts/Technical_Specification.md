# 技術仕様書: GitHub インストール対応

## 概要 (Executive Summary)

現在、本テンプレートのインストーラー（`install.ps1`）および README の導入手順は、社内 Gitea サーバー（`http://192.168.0.90:3000`）のみを対象としています。  
本変更により、**GitHub（`https://github.com/KotaSugiki/AI-Driven-Development-template`）からもワンコマンドでインストール**できるよう対応します。

## 要件 (Requirements)

### 機能要件

1. **GitHub 用インストールコマンドの提供**
   - GitHub の Raw URL を使用した PowerShell ワンライナーを提供する
   - `install.ps1` が GitHub リポジトリの ZIP アーカイブからも `.agents` フォルダを取得・展開できるようにする

2. **インストーラーのマルチソース対応**
   - `install.ps1` を改修し、**ソース（GitHub / Gitea）を自動判定**、または**パラメータで切り替え**できるようにする
   - デフォルトは GitHub（外部利用者向け）とする

3. **README の更新**
   - GitHub 用のインストールコマンドを追記する
   - Gitea 用のインストールコマンドも社内向けとして併記する

### 非機能要件

- 既存の Gitea インストールフローに影響を与えないこと
- 追加の依存関係を導入しないこと（PowerShell 標準機能のみ）
- エラーハンドリングが適切であること

## アーキテクチャと技術スタック (Architecture & Tech Stack)

### 技術スタック

- **スクリプト言語**: PowerShell 5.1+（Windows 標準）
- **パッケージ配布**: GitHub / Gitea の ZIP アーカイブ API

### 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| `install.ps1` | マルチソース対応（GitHub / Gitea パラメータ切り替え） |
| `README.md` | GitHub 用インストール手順の追記 |

### install.ps1 の設計

```powershell
# パラメータで切り替え可能にする
param(
    [ValidateSet("github", "gitea")]
    [string]$Source = "github"  # デフォルトは GitHub
)

# ソースに応じた URL を設定
switch ($Source) {
    "github" {
        $zipUrl = "https://github.com/KotaSugiki/AI-Driven-Development-template/archive/refs/heads/main.zip"
    }
    "gitea" {
        $zipUrl = "http://192.168.0.90:3000/DEV_INTELLIGENT/AI-Driven-Development-template/archive/main.zip"
    }
}
```

### README.md の追記内容

#### GitHub からのインストール（推奨・外部向け）
```powershell
Invoke-Expression (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/KotaSugiki/AI-Driven-Development-template/main/install.ps1")
```

#### Gitea からのインストール（社内向け）
```powershell
Invoke-Expression (Invoke-RestMethod -Uri "http://192.168.0.90:3000/DEV_INTELLIGENT/AI-Driven-Development-template/raw/branch/main/install.ps1") 
```

> **注意**: `Invoke-Expression` 経由で実行する場合、`param()` ブロックは無視されます。  
> そのため、`Invoke-RestMethod` でダウンロードされた時点で適切なデフォルトソースが選択されるよう設計します。  
> - **GitHub の Raw URL** から取得 → デフォルトで GitHub ソースを使用
> - **Gitea の Raw URL** から取得 → 引数なしの場合も GitHub がデフォルト（ただしユーザーが `-Source gitea` を指定可能）

## 状態管理 (State Management)

本変更はステートレスなスクリプト修正のため、状態管理は不要です。  
スクリプトは毎回実行時に ZIP をダウンロード → 展開 → クリーンアップのフローを完結します。

## 検証計画

1. GitHub 用ワンライナーで `.agents` フォルダが正常に展開されることを確認
2. Gitea 用ワンライナーが引き続き動作することを確認
3. `-Source` パラメータでの切り替えが正しく動作することを確認
