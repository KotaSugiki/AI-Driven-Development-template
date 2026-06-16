# AI駆動開発テンプレート インストーラースクリプト
# 既存のプロジェクトに .agents フォルダを展開します。
#
# 使い方:
#   GitHub から直接実行:
#     Invoke-Expression (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/KotaSugiki/AI-Driven-Development-template/main/install.ps1")
#
#   ローカルで実行:
#     .\install.ps1

$zipUrl = "https://github.com/KotaSugiki/AI-Driven-Development-template/archive/refs/heads/main.zip"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " AI駆動開発テンプレート インストーラー" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 一時ファイル名を定義
$tempZip = "ai-template-temp.zip"
$tempDir = "ai-template-temp"

try {
    # ステップ 1: ZIP アーカイブのダウンロード
    Write-Host "[1/3] テンプレートを GitHub からダウンロードしています..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
    Write-Host "  ✅ ダウンロード完了" -ForegroundColor Green

    # ステップ 2: アーカイブの展開
    Write-Host "[2/3] アーカイブを展開しています..." -ForegroundColor Cyan
    Expand-Archive -Path $tempZip -DestinationPath $tempDir -Force

    # 展開されたフォルダ（リポジトリ名のフォルダ）を検出
    $extractedDir = Get-ChildItem -Path $tempDir -Directory | Select-Object -First 1

    if (-not $extractedDir) {
        throw "アーカイブの展開に失敗しました。ディレクトリが見つかりません。"
    }

    # .agents フォルダの存在確認と配置
    $srcAgents = Join-Path $extractedDir.FullName ".agents"
    if (-not (Test-Path $srcAgents)) {
        throw ".agents フォルダがアーカイブ内に見つかりませんでした。"
    }

    # ステップ 3: .agents フォルダの配置
    Write-Host "[3/3] 既存プロジェクトに .agents フォルダを配置しています..." -ForegroundColor Cyan

    # 既存の .agents フォルダがある場合は警告
    if (Test-Path ".agents") {
        Write-Host "  ⚠️  既存の .agents フォルダを上書きします" -ForegroundColor Yellow
    }

    Copy-Item -Path $srcAgents -Destination "." -Recurse -Force
    Write-Host "  ✅ 配置完了" -ForegroundColor Green

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host " 🎉 AI駆動開発のセットアップが完了しました！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "次のステップ:" -ForegroundColor White
    Write-Host "  1. Antigravity や対応AIツールで /startcycle コマンドを実行" -ForegroundColor White
    Write-Host "  2. アイデアを入力して開発サイクルを開始" -ForegroundColor White
    Write-Host ""

} catch {
    Write-Host ""
    Write-Error "❌ インストール中にエラーが発生しました: $_"
    Write-Host ""
    Write-Host "トラブルシューティング:" -ForegroundColor Yellow
    Write-Host "  - インターネット接続を確認してください" -ForegroundColor Yellow
    Write-Host "  - GitHub のリポジトリにアクセスできるか確認してください" -ForegroundColor Yellow
    Write-Host "  - PowerShell を管理者権限で実行してみてください" -ForegroundColor Yellow
} finally {
    # 一時ファイルとフォルダのクリーンアップ
    Write-Host "一時ファイルをクリーンアップしています..." -ForegroundColor Gray
    if (Test-Path $tempZip) { Remove-Item -Path $tempZip -Force -ErrorAction SilentlyContinue }
    if (Test-Path $tempDir) { Remove-Item -Path $tempDir -Recurse -Force -ErrorAction SilentlyContinue }
}
