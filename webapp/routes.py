"""画面のルーティング（STEP07で Copilot が画面を追加します）。
 
ログイン・ログアウトは実装済みです（デモ用の仮想ログイン。認証機能ではありません）。
データの読み書きは必ず get_repository() を使ってください（保存先が変わってもコードは同じ）。
"""
from functools import wraps
 
from flask import Blueprint, redirect, render_template, session, url_for
 
from .storage import get_repository
 
bp = Blueprint("main", __name__)
 
# 仮想ログインで設定する架空ユーザー
DEMO_USER = {"name": "体験ユーザー", "department": "サンプル部門", "role": "一般利用者"}
 
 
def login_required(view):
    @wraps(view)
    def wrapped(*args, **kwargs):
        if "user" not in session:
            return redirect(url_for("main.login"))
        return view(*args, **kwargs)
    return wrapped
 
 
@bp.get("/login")
def login():
    return render_template("login.html")
 
 
@bp.post("/login")
def login_post():
    session.clear()
    session["user"] = DEMO_USER
    return redirect(url_for("main.index"))
 
 
@bp.post("/logout")
def logout():
    session.clear()
    return redirect(url_for("main.login"))
 
 
@bp.get("/")
@login_required
def index():
    # STEP07 で一覧画面に置き換えます
    items = get_repository().list_items()
    return render_template("index.html", items=items)
