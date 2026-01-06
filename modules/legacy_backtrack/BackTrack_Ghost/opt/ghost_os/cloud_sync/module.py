import json
import time
import os

def heartbeat():
    data = {
        "module": "cloud_sync",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/cloud_sync.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/cloud_sync.log", "a") as f:
        f.write(f"[{time.time()}] cloud_sync run executed\n")

if __name__ == "__main__":
    run()
