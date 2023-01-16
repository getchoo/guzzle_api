# guzzle-api

fun little service powered by [fastAPI](https://github.com/tiangolo/fastapi)

right now it only serves pics of teawie

## how to host

this is meant for my [website](https://guzzle.gay/), but it can be hosted anywhere with one edit in `src/guzzle_api/bot.py` :)

on L7, change the `URL` constant to whatever domain you plan to host this on
```python
URL = "https://<yourdomainhere>
```

and to start running a docker (or podman) container:
```bash
docker build -t guzzle_api .
docker run -d --name api <your_desired_port>:80 guzzle_api
```
