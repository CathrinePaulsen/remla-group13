FROM python:3.9.12-slim

WORKDIR /root/

RUN apt-get update &&\
    apt-get install -y gcc

COPY requirements.txt .
COPY setup.py .
COPY src src

RUN python -m pip install --upgrade pip &&\
    pip install -r requirements.txt &&\
    pip install -e .[all]

COPY .pylintrc .
COPY tests tests

# Copy necessary files and folders for dvc
COPY .dvc .dvc
COPY dvc.yaml .
COPY dvc.lock .
COPY .git .git
COPY data data
COPY models models

# TODO: Add entrypoint to ML application here
