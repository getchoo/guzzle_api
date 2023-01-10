from fastapi import FastAPI, Query
from fastapi.staticfiles import StaticFiles

from guzzle_api import lib
from guzzle_api.teawie import lib as teawie

URL = "https://guzzle.gay/api"
TEAWIE_STATIC_ENDPOINT = "/static/teawie"

app = FastAPI()

app.mount(TEAWIE_STATIC_ENDPOINT,
          StaticFiles(packages=[("guzzle_api.teawie.imgs", "")]),
          name="teawie_pics")


@app.get("/list_teawies")
async def teawie_list(limit: str | None = Query(default="5", max="2")):
	try:
		limit = int(limit)
	except ValueError:
		return {"error": "invalid limit"}

	res = {}
	for key, value in enumerate(teawie.list_teawies(limit)):
		res[key] = lib.path_to_json_val(URL, TEAWIE_STATIC_ENDPOINT, value)

	return res


@app.get("/get_random_teawie")
async def get_random_teawie():
	tea = teawie.random_teawie()
	value = lib.path_to_json_val(URL, TEAWIE_STATIC_ENDPOINT, tea)
	return {"url": f"{value}"}
