"""storage 層の動作確認（講師が用意。変更しないでください）。"""
 
 
def test_add_get_update_delete(repo):
    assert repo.list_items() == []
 
    item = repo.add_item({"title": "テスト", "id": "ignored"})
    assert item["id"] != "ignored"
    assert item["created_at"] and item["updated_at"]
 
    assert repo.get_item(item["id"])["title"] == "テスト"
 
    updated = repo.update_item(item["id"], {"title": "変更後"})
    assert updated["title"] == "変更後"
    assert updated["created_at"] == item["created_at"]
 
    assert repo.delete_item(item["id"]) is True
    assert repo.get_item(item["id"]) is None
    assert repo.delete_item(item["id"]) is False
 
 
def test_login_required_and_demo_login(client):
    res = client.get("/")
    assert res.status_code == 302 and "/login" in res.headers["Location"]
 
    res = client.post("/login", follow_redirects=True)
    assert res.status_code == 200
    assert "デモ機能" in res.get_data(as_text=True)


