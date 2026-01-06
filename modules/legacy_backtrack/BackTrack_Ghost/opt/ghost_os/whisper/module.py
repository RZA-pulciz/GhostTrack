import json
import time
import os

def heartbeat():
    data = {
        "module": "whisper",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/whisper.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/whisper.log", "a") as f:
        f.write(f"[{time.time()}] whisper run executed\n")

if __name__ == "__main__":
    run()
