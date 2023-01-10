FROM python:3.9

WORKDIR /code

RUN pip install flit
RUN flit install

CMD [ "uvicorn", "src.guzzle_api.api:app", "--host", "0.0.0.0", "--port", "7070"]
