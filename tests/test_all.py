from fastapi.testclient import TestClient

from guzzle_api.api import app

client = TestClient(app)

resp = client.get("/get_random_teawie").text
print(f"random:\n {resp}")

resp = client.get("/list_teawies?limit=6").text
print(f"list:\n {resp}")

tests = {"/list_teawies"}
