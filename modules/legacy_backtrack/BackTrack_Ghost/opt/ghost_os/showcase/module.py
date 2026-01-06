import json
import time
import os

def heartbeat():
    data = {
        "module": "showcase",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/showcase.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/showcase.log", "a") as f:
        f.write(f"[{time.time()}] showcase run executed\n")

if __name__ == "__main__":
    run()
