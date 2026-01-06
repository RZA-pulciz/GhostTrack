import json
import time
import os

def heartbeat():
    data = {
        "module": "archive",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/archive.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/archive.log", "a") as f:
        f.write(f"[{time.time()}] archive run executed\n")

if __name__ == "__main__":
    run()
