FROM python:3.11

WORKDIR /code

RUN pip install flit
COPY . /code/
RUN flit install

CMD [ "uvicorn", "src.guzzle_api.api:app", "--host", "0.0.0.0", "--port", "7070"]
