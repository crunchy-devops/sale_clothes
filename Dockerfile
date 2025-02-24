FROM python:3.9-slim

COPY . .
RUN pip install --no-cache-dir -r requirements.txt
WORKDIR /app
CMD ["python", "app.py"]
#CMD ["tail", "-f", "/dev/null"]