from ritual_engine import process_event

event = {
    "timestamp": "now",
    "event": "beacon_anomaly",
    "details": "Segnale sconosciuto rilevato"
}

process_event(event)
