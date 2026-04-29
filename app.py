"""
Module for calling the main flask application.
The application will be only supported with Flask and Gunicorn.
"""

from flask import Flask, json
from flasgger import Swagger
from prometheus_flask_exporter import PrometheusMetrics
from router.attendance import route as create_record
from router.cache import cache
from utils.json_encoder import DataclassJSONEncoder
from client.redis.redis_conn import get_caching_data

app = Flask(__name__)

# Swagger
swagger = Swagger(app)

# Metrics
metrics = PrometheusMetrics(app)
metrics.info("attendance_api", "Attendance API metrics", version="0.1.0")

# Cache init
cache.init_app(app, get_caching_data())

# JSON config (safe for Flask 2.3+)
app.config['JSON_SORT_KEYS'] = False

try:
    app.json_encoder = DataclassJSONEncoder
except Exception:
    pass  # fallback for newer Flask

# Routes
app.register_blueprint(create_record, url_prefix="/api/v1")


# 🔥 IMPORTANT: Health route (for Jenkins health check)
@app.route("/")
def home():
    return {"status": "UP"}
