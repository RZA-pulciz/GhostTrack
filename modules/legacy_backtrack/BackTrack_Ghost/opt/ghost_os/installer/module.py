import json
import time
import os

def heartbeat():
    data = {
        "module": "installer",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/installer.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/installer.log", "a") as f:
        f.write(f"[{time.time()}] installer run executed\n")

if __name__ == "__main__":
    run()
