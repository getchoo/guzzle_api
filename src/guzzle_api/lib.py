from pathlib import Path


def path_to_json_val(url: str, mount: str, file_path: Path) -> str:
	return f"{url}{mount}/{file_path.name}"
