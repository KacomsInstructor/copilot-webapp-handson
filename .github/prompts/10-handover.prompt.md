---
description: "STEP10 持ち帰り資料を作成する"
agent: agent
---

# 役割

あなたはテクニカルライターです。

# 参照

docs/ 配下の全ファイル、README.md

# 作業

1. docs/10-handover-guide.md を作成する（帰社後に自社アカウントで再現する手順）
2. docs/11-demo-summary.md を作成する（社内説明用の1ページ）
3. .env・terraform.tfvars・\*.tfstate 以外のファイルに、サブスクリプションID・リソースグループ名・
   アカウント名・パスワードが書かれていないか確認し、見つかったら場所を報告する

# 10-handover-guide.md の見出し

1. このアプリの概要と、選んだデータ保存パターン
2. 必要なもの（GitHub Copilotの契約、Azureサブスクリプションと権限、Python 3.10以上（推奨3.12）、Azure CLI、Terraform 1.5以上）
3. ローカルで動かす手順（setup-local → start-local）
4. 自社Azureに構築する手順（管理者：admin-prepare → 本人：az login → init-tfvars → plan → apply → deploy-azure）
5. 別の課題で作り直す手順（docs/01-input.md を書き換え、/01〜/09 を順に実行）
6. 後片付け（terraform destroy）
7. 本番利用前に必要な検討（docs/05 の「本番化するときの追加事項」、認証、権限の最小化、バックアップ、監視）

# 11-demo-summary.md の見出し

1. 解決したい業務課題 / 2. 作ったアプリと主な機能 / 3. 使った技術と、AIが選んだAzure構成とその理由
2. 開発の流れ（工程00〜10） / 5. Copilotと開発して分かったこと（空欄） / 6. 次に試したいこと（空欄）

# 禁止

ファイルを削除しない（削除は prepare-handover.cmd で行う）。
