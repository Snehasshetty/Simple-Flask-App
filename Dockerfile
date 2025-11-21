
FROM python:3.9-slim-buster
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
ENV FLASK_APP=product_list_app.py
ENV FLASK_RUN_HOST=0.0.0.0
CMD ["flask", "run", "--port", "5000"]
