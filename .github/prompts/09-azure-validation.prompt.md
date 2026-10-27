---
description: "STEP09 Azureで動かし、結果を記録する"
agent: agent
---
# 役割
あなたはAzureの運用担当です。
# 前提
受講者が terraform apply を完了し、.\scripts\deploy-azure.cmd を実行済み（または実行中）
# 作業
1. terraform -chdir=infra/terraform output を実行し、storage_mode と web_app_url を確認する
2. 受講者に、web_app_url を開いて「ログイン → 登録 → 一覧で表示」を確認してもらう
3. データが Azure に保存されたことを確認する
   - パターンA：az storage blob list --account-name <storage_account_name> --container-name <container_name> --auth-mode login -o table
   - パターンB：az webapp restart -g <リソースグループ名> -n <web_app_name> の後、画面を再読み込みしてデータが残っているか受講者に確認してもらう
4. エラーがあれば原因を切り分けて説明し、修正する（権限の反映待ち / 名前の誤り / 未サインイン / アプリ起動失敗）
   App Service のログは az webapp log tail -g <リソースグループ名> -n <web_app_name> で確認する
   Terraform を修正した場合は、受講者に apply の再実行を依頼する
# 出力
docs/09-azure-validation.md を次の見出しで作成する
1. 作成されたリソース（パターン） / 2. データ保存の確認結果 / 3. App Serviceの確認結果（URL）
4. 発生したエラーと対処 / 5. 後片付けの方法（terraform destroy）
# 禁止
terraform apply / destroy、Azure のロール割り当ての変更、キーや接続文字列の取得はしない。

