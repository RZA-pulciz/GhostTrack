#!/usr/bin/env python3
import os, sys, json
from datetime import datetime
ROOT=os.path.abspath(os.path.join(os.path.dirname(__file__),"..",".."))
LOG=os.path.join(ROOT,"var","logs")
os.makedirs(LOG,exist_ok=True)
entry={"ts":datetime.utcnow().isoformat()+"Z","channel":sys.argv[1],"msg":" ".join(sys.argv[2:])}
with open(os.path.join(LOG,f"{sys.argv[1]}.log"),"a") as f: f.write(json.dumps(entry)+"\n")
print(entry)
