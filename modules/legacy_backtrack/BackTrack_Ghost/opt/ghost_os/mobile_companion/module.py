import json
import time
import os

def heartbeat():
    data = {
        "module": "mobile_companion",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/mobile_companion.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/mobile_companion.log", "a") as f:
        f.write(f"[{time.time()}] mobile_companion run executed\n")

if __name__ == "__main__":
    run()
