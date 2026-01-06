#!/usr/bin/env bash
set -e

echo "[BOOTSTRAP] Creo struttura Ghost_OS..."

mkdir -p core/{ghost_boot,integrity,anon_bus,notify,packaging,security,logging,profile}
mkdir -p rituals ops missions/templates docs var/logs var/state

touch MANIFESTO.md README.md .env.example
touch docs/{doctrine.md,rituals.md,modules_map.md}

touch rituals/{init_ritual.sh,closure_ritual.sh,purge_ritual.sh}

touch core/ghost_boot/ghost_boot.sh
touch core/integrity/verify_and_heal.sh
touch core/anon_bus/anon_bus.sh
touch core/notify/notify_startup.sh
touch core/packaging/package_snapshot.sh
touch core/security/validate_node_receive.sh
touch core/logging/eco_log.py
touch core/profile/profile_resolver.sh

touch ops/{deploy_termux.sh,ghost_status.sh,ghost_summary.sh,ghost_tmux.sh,dashboard_cli.py,dashboard_api.py}

touch missions/{run_mission.sh,network_hygiene.sh,flipper_sync.sh}
touch missions/templates/mission_template.sh

echo "[BOOTSTRAP] Struttura creata. Ora puoi riempire i file."
