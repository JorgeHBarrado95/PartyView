#!/bin/bash

# Activar entorno virtual si existe
if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate
fi

# Ejecutar el script
python3 /home/jorge/Escritorio/TFG/PartyView/dev-scripts/GestionSalas/main.py
