FROM python:3.11

WORKDIR /app

COPY . /app

RUN pip install flask

EXPOSE 5050

CMD ["python", "sample_app.py"]
