FROM python:3.12.3-bullseye

RUN python -m pip install --upgrade pip

COPY requirements.txt requirements.txt

RUN python -m pip install -r requirements.txt

WORKDIR /app