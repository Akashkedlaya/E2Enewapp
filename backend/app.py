from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/add", methods=["POST"])
def add():
    data = request.json or {}
    a = float(data.get("a", 0))
    b = float(data.get("b", 0))
    return jsonify({"result": a + b})

@app.route("/subtract", methods=["POST"])
def subtract():
    data = request.json or {}
    a = float(data.get("a", 0))
    b = float(data.get("b", 0))
    return jsonify({"result": a - b})

@app.route("/multiply", methods=["POST"])
def multiply():
    data = request.json or {}
    a = float(data.get("a", 0))
    b = float(data.get("b", 0))
    return jsonify({"result": a * b})

@app.route("/divide", methods=["POST"])
def divide():
    data = request.json or {}
    a = float(data.get("a", 0))
    b = float(data.get("b", 1))
    if b == 0:
        return jsonify({"error": "division by zero"}), 400
    return jsonify({"result": a / b})

@app.route("/", methods=["GET"])
def health():
    return jsonify({"status":"ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
