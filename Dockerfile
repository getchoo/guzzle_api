FROM python:3.11

WORKDIR /code
ARG FLIT_ROOT_INSTALL=1

RUN pip install flit
COPY . /code/
RUN flit install

CMD [ "uvicorn", "src.guzzle_api.api:app", "--host", "0.0.0.0", "--port", "7070"]
