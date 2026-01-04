#!/usr/bin/env bash
set -e

echo "[GHOST_README] Rigenerazione README.md rituale..."

cat > README.md << 'EOF'
# 🕯️ Ghost_OS — Ritual Cyber Defense System

> Effimero. Modulare. Auto‑rigenerante.  
> Ogni esecuzione è un rito. Ogni log è un battito.

[![Status](https://img.shields.io/badge/status-active-brightgreen)]()
[![Ethics](https://img.shields.io/badge/ethics-defensive_only-blue)]()
[![Platform](https://img.shields.io/badge/platform-Termux%20%7C%20Linux%20%7C%20WSL-orange)]()
[![Flipper](https://img.shields.io/badge/flipper-Ghost_Beacon-purple)]()

---

## 🧬 Visione

Ghost_OS non è un semplice insieme di script, ma un **sistema operativo rituale** per:

- cyber difesa etica  
- osservazione tecnica  
- logging strutturato  
- automazione disciplinata  
- integrazione con hardware (Flipper Zero)  

Nessun modulo è offensivo.  
Ghost_OS è **uno scudo, non una lama**.

---

## 🗂️ Architettura

```text
Ghost_Ops_Unit/
├── core/        → integrità, heartbeat, bus interno
├── ops/         → automazioni, self‑heal, push, doctor
├── missions/    → moduli operativi contestuali
├── rituals/     → avvio, chiusura, purificazione
├── var/         → stato effimero, logs JSON
├── docs/        → sito GitHub Pages (CRT, glitch, terminal‑like)
├── flipper/
│   └── ghost_beacon/  → app per Flipper Zero
└── ghost_os/
    └── ghost_beacon_receiver.py → ingest report Ghost Beacon
