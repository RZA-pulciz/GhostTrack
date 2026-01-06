import json
import sys

def load_report(path="ghost_beacon.json"):
    with open(path) as f:
        data = json.load(f)
    print("[GHOST_OS] Report Ghost Beacon:")
    print(json.dumps(data, indent=4))

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "ghost_beacon.json"
    load_report(path)
