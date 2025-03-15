import requests

def test_nginx_is_running():
    response = requests.get("http://localhost")
    assert response.status_code == 200