import pytest
from app import app


@pytest.fixture
def client():
    return app.test_client()


def test_home(client):
    response = client.get('/')
    assert response.status_code == 200
    assert response.data == b'Hello, DevOps!'
