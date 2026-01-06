import json
import time
import os

def heartbeat():
    data = {
        "module": "ritual_recorder",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/ritual_recorder.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/ritual_recorder.log", "a") as f:
        f.write(f"[{time.time()}] ritual_recorder run executed\n")

if __name__ == "__main__":
    run()
