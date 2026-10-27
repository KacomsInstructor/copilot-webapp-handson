"""Flaskアプリの生成（講師が用意。変更しないでください）。"""
from dotenv import load_dotenv
from flask import Flask
 
from .config import Config
from .storage import create_repository
 
 
def create_app() -> Flask:
    # .env を読み込む（App Service では使わず、アプリ設定の環境変数が使われる）
    load_dotenv()
    config = Config()
    config.validate()
 
    app = Flask(__name__)
    app.config["SECRET_KEY"] = config.SECRET_KEY
    app.config["STORAGE_MODE"] = config.STORAGE_MODE
    app.config["SESSION_COOKIE_HTTPONLY"] = True
    app.config["SESSION_COOKIE_SAMESITE"] = "Lax"
    app.extensions["repository"] = create_repository(config)
 
    from .routes import bp
    app.register_blueprint(bp)
 
    @app.context_processor
    def inject_common():
        return {"storage_mode": config.STORAGE_MODE}
 
    return app
