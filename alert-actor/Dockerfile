FROM python:3.9.12-slim

COPY alert-actor.py .

RUN python -m pip install flask

# Dynamic interaction with the model
EXPOSE 8080

CMD ["python", "alert-actor.py"]
