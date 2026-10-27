---
description: "STEP04 データを設計する"
agent: agent
---
# 役割
あなたはデータ設計者です。
# 参照
docs/02-requirements.md、docs/03-screen-design.md
# 作業
1. 主要データを1種類だけ定義する（複数に分けない）
2. 共通項目 id（UUID文字列）、created_at、updated_at（ISO 8601）を必ず含める
3. 画面の入力・表示項目と一致させる。項目名は英小文字のスネークケースにする
4. 型は str / int / float / bool / date のいずれかにする
5. 架空のサンプルデータを3件作り、data/sample-items.json を更新する（形式は {"items": [...]}）
# 出力
docs/04-data-design.md を次の見出しで作成する
1. データの概要 / 2. 項目定義（項目名｜表示名｜型｜必須｜例｜使用画面）
3. JSON例（1件分） / 4. 検索・絞り込みに使う項目 / 5. 仮定
# 完了条件
- データ1種類 / 画面項目と一致 / サンプル3件
# 禁止
実在の個人情報・顧客情報を使わない。保存先（Blob / Cosmos DB）はまだ決めない。



