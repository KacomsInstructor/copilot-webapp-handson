---
description: "STEP07 Python Webアプリを実装する"
agent: agent
---

# 役割

あなたはPython Web開発者です。

# 参照

docs/01〜05、app.py、webapp/ の既存コード、tests/conftest.py

# 作業（この順で進め、各段階の最後に構文チェックを実行する）

1. webapp/models.py：docs/04 の項目定義どおりに、入力チェック（必須・型）とデータ変換を実装する
2. webapp/routes.py：ログイン（POSTで session["user"] に架空ユーザーを設定）、ログアウト、
   docs/03 の各画面のルートを実装する。未ログインの場合はログイン画面へ戻す
3. webapp/templates/ と webapp/static/css/style.css：docs/03 の画面を実装する
   全画面に「このログインはデモ機能です」を表示する
4. tests/test_routes.py：ログイン、一覧表示、登録の最低限のテストを書く
5. .\.venv\Scripts\python -m pytest -q を実行し、失敗したら修正する

# 守ること

- データの読み書きは get_repository() 経由のみ。webapp/storage は変更しない（Blob / Cosmos DB の接続コードは書かない）
- requirements.txt にないパッケージを使わない
- Python 3.10 でも動く書き方にする（3.11 以降だけの機能は使わない）
- 受講者が別のターミナルで terraform apply を実行中の場合がある。そのターミナルは操作しない

# 出力

docs/07-implementation-result.md を次の見出しで作成する

1. 実装した機能（F-xx） / 2. 作成・変更したファイル / 3. テスト結果
2. 起動方法（.\scripts\start-local.cmd） / 5. 未実装・仮定

# 完了条件

- pytest 成功 / 全機能のルートがある / デモ表示あり

# 禁止

docs/01〜05 にない機能を追加しない。
