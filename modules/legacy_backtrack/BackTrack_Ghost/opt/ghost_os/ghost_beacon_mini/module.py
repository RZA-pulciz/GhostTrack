import json
import time
import os

def heartbeat():
    data = {
        "module": "ghost_beacon_mini",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/ghost_beacon_mini.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/ghost_beacon_mini.log", "a") as f:
        f.write(f"[{time.time()}] ghost_beacon_mini run executed\n")

if __name__ == "__main__":
    run()
