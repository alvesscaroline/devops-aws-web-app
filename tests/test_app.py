import requests

def test_nginx_is_running():
    response = requests.get("http://nginx-test:80")
    assert response.status_code == 200