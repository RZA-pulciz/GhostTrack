#!/usr/bin/env bash
trace_oracle() {
  banner
  echo "✦ TRACE ORACLE — Osservazione Passiva del Contesto ✦"
  echo "Kernel: $(uname -a)"
  echo "Data:   $(date)"
  echo "Host:   $(hostname)"
  echo "User:   $USER"
}
