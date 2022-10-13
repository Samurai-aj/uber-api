FROM python:latest

RUN mkdir -p home/uber-app

COPY ./app/app  /home/uber-app

WORKDIR /home/uber-app

RUN pip install -r requirements.txt

EXPOSE 5000

ENTRYPOINT [ "python", "app.py"]
