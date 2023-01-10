import importlib.resources
import random
from math import ceil
from pathlib import Path

from guzzle_api.teawie import imgs

NUM_TEAWIES = 30


def list_teawies(limit: int) -> list[Path]:
	files = importlib.resources.files(imgs)

	res = []
	for i, file in enumerate(files.iterdir()):
		if i >= limit:
			break
		res.append(file)

	return res


def random_teawie() -> Path:
	limit = ceil(NUM_TEAWIES / 2)
	return random.choice(list_teawies(limit))
