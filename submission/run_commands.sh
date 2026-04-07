#!/bin/bash
# Script de exemplo para reproduzir o pipeline (substitua as keys)
set -e

# 1) Instalar dependências (uma vez)
pip install -e .

# 2) Gerar respostas (exemplos) -- substitua chaves e modelos conforme disponível
python3 -m gen_api_answer --run-id group4_victor_gemini --model gemini-3-pro-preview --api-base "https://generativelanguage.googleapis.com/v1beta/openai/" --api-key "$GOOGLE_API_KEY" --parallel 10
python3 -m gen_api_answer --run-id group4_victor_gpt52 --model gpt-5.2 --api-key "$OPENAI_API_KEY" --parallel 10
python3 -m gen_api_answer --run-id group4_victor_sabia4 --model sabia-4-2026-01-06 --api-base "https://chat.maritaca.ai/api" --api-key "$MARITACA_API_KEY" --parallel 10

# 3) Gerar julgamentos (juiz: gpt-5.2, estruturado)
python3 -m gen_judgment --judge-model gpt-5.2 --model-list group4_victor_gemini group4_victor_gpt52 group4_victor_sabia4 --api-key "$OPENAI_API_KEY" --parallel 10 --structured

# 4) Mostrar resultados
python show_result.py --bench-name oab_bench --judge-model gpt-5.2
