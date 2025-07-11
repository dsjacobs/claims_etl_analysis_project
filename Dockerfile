FROM python:3.10

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

CMD ["flask", "run", "--host=0.0.0.0"]
