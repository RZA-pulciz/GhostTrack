import json
import time
import os

class RitualEngine:
    def __init__(self):
        self.rules = []
        self.load_rules()

    def load_rules(self):
        rules_path = "ghost_os/ritual_engine/rules.json"
        if os.path.exists(rules_path):
            with open(rules_path) as f:
                self.rules = json.load(f)
        else:
            self.rules = []

    def save_rules(self):
        with open("ghost_os/ritual_engine/rules.json", "w") as f:
            json.dump(self.rules, f, indent=4)

    def add_rule(self, rule):
        self.rules.append(rule)
        self.save_rules()

    def evaluate(self, event):
        triggered = []
        for rule in self.rules:
            if rule["condition"] in event["event"]:
                triggered.append(rule["action"])
        return triggered

    def execute(self, action):
        print(f"[RITUAL_ENGINE] Eseguo rituale: {action}")
        # Placeholder: qui aggiungeremo azioni reali
        time.sleep(1)

engine = RitualEngine()

def process_event(event):
    actions = engine.evaluate(event)
    for action in actions:
        engine.execute(action)
