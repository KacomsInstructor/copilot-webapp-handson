"""App Service / ローカル共通の入口。
 
App Service は、ルートの app.py にある変数 app を自動で検出し、
Gunicorn（gunicorn app:app）で起動します。このファイルは変更しないでください。
"""
from webapp import create_app
 
app = create_app()

