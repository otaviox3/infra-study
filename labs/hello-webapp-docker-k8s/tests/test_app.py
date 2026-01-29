import sys
from pathlib import Path

# Garante que a pasta raiz do lab esteja no sys.path
ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from app import app


def test_health_endpoint():
    """Garante que /health responde 200 e 'OK'."""
    client = app.test_client()
    resp = client.get("/health")
    assert resp.status_code == 200
    assert resp.data.decode() == "OK"


def test_root_endpoint():
    """Garante que / responde 200 (página inicial da app)."""
    client = app.test_client()
    resp = client.get("/")
    assert resp.status_code == 200
