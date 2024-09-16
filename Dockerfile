FROM python:3.12.6-bookworm

RUN python -m pip install --upgrade pip

COPY requirements.txt requirements.txt

RUN python -m pip install -r requirements.txt

WORKDIR /app