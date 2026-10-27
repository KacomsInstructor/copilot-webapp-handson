"""テスト共通設定（講師が用意。変更しないでください）。
 
テストは常に local モード・一時フォルダーで実行され、.env や Azure には影響しません。
"""
import pytest
 
from webapp import create_app
 
 
@pytest.fixture
def app(tmp_path, monkeypatch):
    monkeypatch.setenv("STORAGE_MODE", "local")
    monkeypatch.setenv("SECRET_KEY", "test-secret-key")
    monkeypatch.setenv("LOCAL_DATA_PATH", str(tmp_path / "items.json"))
    monkeypatch.setenv("SAMPLE_DATA_PATH", "")
    app = create_app()
    app.config.update(TESTING=True)
    yield app
 
 
@pytest.fixture
def client(app):
    return app.test_client()
 
 
@pytest.fixture
def logged_in_client(client):
    client.post("/login")
    return client
 
 
@pytest.fixture
def repo(app):
    with app.app_context():
        from webapp.storage import get_repository
        yield get_repository()

