---
description: "STEP00 開発環境を確認する"
agent: agent
---

# 役割

あなたはハンズオンの環境確認担当です。

# 作業

1. 次のコマンドを1つずつ実行し、結果を記録する
   - .\.venv\Scripts\python --version
   - .\.venv\Scripts\python -m pip check
   - az version
   - az account show --query "{user:user.name, subscription:name}" -o table
   - terraform version
2. 次の基準で OK / NG を判定する
   - Python：3.10 以上なら OK（推奨は 3.12。3.11 や 3.13 も OK）
   - pip check：「No broken requirements found.」なら OK
   - az・terraform：バージョンが表示されれば OK。terraform は 1.5 未満なら NG
   - az account show：当日用アカウントが表示されれば OK
3. .github/copilot-instructions.md と .github/prompts/ の00〜10が存在するか確認する
4. .env と docs/01-input.md が存在するか確認する（.env の中身は表示しない）

# 出力

docs/00-environment-check.md に「確認項目｜結果｜OK/NG｜NG時の対処」の表で記載する

# 禁止

インストール・設定変更・ファイル削除はしない。NGは報告だけにする。

# 完了報告

最初の1行で「NG：○件」と報告する。
