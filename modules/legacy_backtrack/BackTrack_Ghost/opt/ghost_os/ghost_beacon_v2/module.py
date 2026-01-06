import json
import time
import os

def heartbeat():
    data = {
        "module": "ghost_beacon_v2",
        "timestamp": time.time(),
        "status": "alive"
    }
    with open("var/heartbeat/ghost_beacon_v2.json", "w") as f:
        json.dump(data, f, indent=4)

def run():
    heartbeat()
    with open("var/logs/ghost_beacon_v2.log", "a") as f:
        f.write(f"[{time.time()}] ghost_beacon_v2 run executed\n")

if __name__ == "__main__":
    run()
