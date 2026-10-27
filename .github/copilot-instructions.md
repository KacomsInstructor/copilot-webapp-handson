# このリポジトリのルール（ハンズオン用）

## 目的

業務課題からPython Webアプリを作り、Azureに展開する。工程ごとに、呼び出されたプロンプトの範囲だけ作業する。

## アプリの技術構成（変更禁止）

- Python / Flask / Jinja2 / ローカルCSS（外部CDN・外部APIは使わない）
- Pythonのバージョン：受講者PCは 3.10 以上（推奨 3.12）、App Service は 3.12。3.10 でも動く書き方にする
- エントリポイントはルートの app.py（変数名 app）。アプリ本体は webapp/ パッケージ
- Pythonコマンドは必ず .\.venv\Scripts\python で実行する
- データの読み書きは webapp/storage の get_repository() 経由のみ。webapp/storage は変更しない
- 依存パッケージは requirements.txt にあるものだけ。追加が必要なら理由を示し、受講者に確認する

## データ保存のパターン（STEP05で課題に合わせて1つ選ぶ）

- パターンA（STORAGE_MODE=blob）：Azure Blob Storage に items.json を1つ置く
  向いている課題：少人数で使う／データは1種類で数百件程度／一覧と登録が中心
  注意：複数の人が同時に更新すると、後から保存した内容で上書きされる
- パターンB（STORAGE_MODE=cosmos）：Azure Cosmos DB for NoSQL（サーバーレス）に1件1ドキュメントで保存する
  向いている課題：複数の人が同時に更新する／件数が増える／項目で検索・絞り込みしたい
- どちらを選んでも、ローカルでの確認は STORAGE_MODE=local（data/items.json）で行う
- アプリのコードは保存先に依存しない（get_repository() が保存先を切り替える）

## Azure（Terraform）のルール

- IaCは infra/terraform。versions.tf・providers.tf・variables.tf は変更しない。azurerm は 4.x の書き方を使う
- リソースグループは作成しない（data "azurerm_resource_group" で参照する）
- App Service は既存のユーザー割り当てマネージドID（var.app_identity_name）を使う。新しく作らない
- 実行者の権限は「共同作成者」。azurerm_role_assignment（Azureのロール割り当て）は作らない（権限がなく失敗する）
- Azureへの接続は Microsoft Entra ID（DefaultAzureCredential）。接続文字列・アカウントキーは使わない
- SKUは最小構成（App Service Plan は Linux B1、Cosmos DB はサーバーレス）
- outputs.tf の出力名は /06-infrastructure の指定に従う（スクリプトが使うため）

## ログイン

- 認証機能は実装しない。「体験用ユーザーとしてログイン」ボタンで session["user"] に架空ユーザーを設定するだけ
- 全画面に「このログインはデモ機能です」と表示する
- セッション鍵は環境変数 SECRET_KEY から読む（webapp/**init**.py で設定済み）

## 文書

- 設計書は docs/ に日本語のMarkdownで出力する。ファイル名と見出しはプロンプトの指定に従う
- 不明点は勝手に決めず「仮定」として明記する

## 禁止事項

- 実在の個人情報・顧客情報・社外秘を書かない
- .env と \*.tfstate の中身を表示しない。.env は作成・編集しない（スクリプトが編集する）
- terraform apply / destroy、az role assignment、git push は実行しない（apply は受講者が自分で入力する）
- 指定された工程より先の作業をしない。ファイルを削除する前に確認する

## エラーへの対応

- コマンドが失敗したら、エラーを読んで原因を説明し、修正して再実行する
- 同じ工程で3回修正しても解決しない場合は止めて、状況と考えられる原因を報告する

## 完了報告

作業の最後に「作成・変更したファイル」「仮定」「未完了」「次工程への注意」を箇条書きで報告する。
