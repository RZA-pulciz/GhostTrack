import json
import time
import os

def heartbeat():
    data = {
        "module": "link",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/link.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/link.log", "a") as f:
        f.write(f"[{time.time()}] link run executed\n")

if __name__ == "__main__":
    run()
