from flask import Flask, request, jsonify, send_file
import subprocess, os

app = Flask(__name__)


API_KEY = "API-KEY"

def run(cmd):
    return subprocess.check_output(cmd.split()).decode()

def auth():
    key = request.headers.get("x-api-key")
    if key != API_KEY:
        return False
    return True



@app.get("/battery")
def battery():
    if not auth():
        return "Unauthorized", 401
    return run("termux-battery-status")

@app.get("/notif")
def notif():
    if not auth():
        return "Unauthorized", 401
    return run("termux-notification-list")

@app.post("/vibrate")
def vibrate():
    if not auth():
        return "Unauthorized", 401
    ms = request.json.get("duration", 500)
    return run(f"termux-vibrate -d {ms}")

@app.post("/send")
def send():
    if not auth():
        return "Unauthorized", 401
    filepath = request.json.get("path")
    if not filepath or not os.path.exists(filepath):
        return "File not found", 404
    return send_file(filepath, as_attachment=True)

@app.post("/receive")
def receive():
    if not auth():
        return "Unauthorized", 401
    f = request.files['file']
    f.save(f"/sdcard/{f.filename}")
    return "OK"



app.run(host="0.0.0.0", port=6969)
