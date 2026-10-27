"""データの入力チェックと変換（STEP07で Copilot が実装します）。
 
docs/04-data-design.md の項目定義に合わせて実装してください。
id / created_at / updated_at は storage 側で自動付与されるため、ここでは扱いません。
"""
 
 
def validate_item(form: dict) -> tuple[dict, list[str]]:
    """フォームの値を検証し、(保存するデータ, エラーメッセージの一覧) を返す。
 
    STEP07 で実装されるまでは、受け取った値をそのまま返します。
    """
    data = {k: v.strip() if isinstance(v, str) else v for k, v in form.items()}
    return data, []


