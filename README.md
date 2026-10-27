# GitHub Copilot で業務課題を Python Web アプリにする（ハンズオン用テンプレート）

業務課題から、要件定義・設計（Markdown）・Python Web アプリ・Azure 構成（Terraform）までを、
GitHub Copilot に用意されたプロンプトを順番に実行して作り、Azure に展開します。
データの保存先（Blob Storage か Cosmos DB）は、課題に合わせて Copilot が選びます。

> このアプリのログインはデモ機能です。本人確認やアクセス制御は行いません。
> 実在の個人情報・顧客情報・社外秘は入力しないでください。

## 必要なもの

| もの                                           | バージョン                              | 確認コマンド                          |
| ---------------------------------------------- | --------------------------------------- | ------------------------------------- |
| Visual Studio Code ＋ GitHub Copilot Chat 拡張 | 最新版に更新                            | −                                     |
| Python                                         | 3.10 以上（推奨 3.12。3.11・3.13 も可） | `python --version` または `py --list` |
| Azure CLI                                      | 新しい版（古い場合は `az upgrade`）     | `az version`                          |
| Terraform CLI                                  | 1.5 以上                                | `terraform version`                   |

Azure 上（App Service）では Python 3.12 で動きます。PC のバージョンと違っていて問題ありません。

## はじめに（1回だけ）

1. このフォルダーを `C:\handson\copilot-webapp-handson` に置き、VS Code で「フォルダーを開く」
2. ターミナルで実行（インストール済みの Python 3.10 以上を自動で選びます）

```powershell
.\scripts\setup-local.cmd
```

## 進め方

1. `docs/01-input.md` に業務課題を書く
2. Copilot Chat を開き（Ctrl+Alt+I）、モードを **Agent** にする
3. STEP ごとに「＋（新しいチャット）」を押し、`/` から番号のプロンプトを選んで送信する

| STEP | チャットで実行                                    | 作られるもの                                                   |
| ---- | ------------------------------------------------- | -------------------------------------------------------------- |
| 00   | `/00-environment-check`                           | docs/00-environment-check.md                                   |
| 01   | `/01-business-problem`                            | docs/01-business-problem.md                                    |
| 02   | `/02-requirements`                                | docs/02-requirements.md                                        |
| 03   | `/03-screen-design`                               | docs/03-screen-design.md                                       |
| 04   | `/04-data-design`                                 | docs/04-data-design.md、data/sample-items.json                 |
| 05   | `/05-architecture`                                | docs/05-architecture.md（保存先パターンの選択）                |
| 06   | init-tfvars → `/06-infrastructure` → 自分で apply | infra/terraform/main.tf・outputs.tf、docs/06-infrastructure.md |
| 07   | `/07-implementation`                              | webapp/、tests/、docs/07-implementation-result.md              |
| 08   | `start-local` で起動 → `/08-local-validation`     | docs/08-local-validation.md                                    |
| 09   | `deploy-azure` → `/09-azure-validation`           | docs/09-azure-validation.md                                    |
| 10   | `/10-handover`                                    | docs/10-handover-guide.md、docs/11-demo-summary.md             |

## よく使うコマンド

```powershell
# アプリを起動（http://127.0.0.1:5000）
.\scripts\start-local.cmd
.\scripts\start-local.cmd -Port 5001        # 5000番が使用中のとき

# テスト
.\.venv\Scripts\python -m pytest -q

# Azure（STEP06・09）
az login
.\scripts\init-tfvars.cmd -ResourceGroup <リソースグループ名>
terraform -chdir=infra/terraform plan
terraform -chdir=infra/terraform apply      # 自分で入力し、yes で実行
.\scripts\deploy-azure.cmd                  # App Service に公開
.\scripts\use-azure-storage.cmd             # （任意）ローカルのアプリを Azure の保存先につなぐ
.\scripts\use-azure-storage.cmd -Local      # ローカル保存に戻す

# 終了時（秘密情報と環境依存ファイルを削除）
.\scripts\prepare-handover.cmd
```

## データの保存先

| STORAGE_MODE（.env） | 保存先                                               |
| -------------------- | ---------------------------------------------------- |
| local                | data/items.json（ローカル確認用）                    |
| blob                 | パターンA：Azure Blob Storage の items.json          |
| cosmos               | パターンB：Azure Cosmos DB for NoSQL（サーバーレス） |

どちらも、キーは使わず Microsoft Entra ID で接続します。

## 自社の Azure で構築するとき

1. 管理者（リソースグループの所有者）が実行：`.\scripts\admin-prepare.cmd -ResourceGroup <名前> -ParticipantUpn <あなたのUPN>`
2. 本人が実行：`az login` → `init-tfvars` → `plan` → `apply` → `deploy-azure`

## 後片付け

```powershell
terraform -chdir=infra/terraform destroy
```
