Grupo: 4
Aluno: Victor
Professor: Glauco

Resumo da entrega:
- Modelos avaliados neste run:
  * group4_victor_gemini (Gemini)
  * group4_victor_gpt52 (GPT-5.2)
  * group4_victor_sabia4 (Sabiá-4)

Arquivos principais no repositório:
- data/oab_bench/model_answer/*.jsonl  -> respostas geradas por cada modelo (cada linha é uma resposta por questão)
- data/oab_bench/model_judgment/*.jsonl -> julgamentos do juiz (notas por questão)

Como reproduzir (passo-a-passo):
1) Instalar dependências:
   pip install -e .
2) Gerar respostas (exemplo Gemini):
   python3 -m gen_api_answer --run-id group4_victor_gemini --model gemini-3-pro-preview --api-base "https://generativelanguage.googleapis.com/v1beta/openai/" --api-key "SUA_GOOGLE_KEY" --parallel 10
3) Gerar julgamentos:
   python3 -m gen_judgment --judge-model gpt-5.2 --model-list group4_victor_gemini group4_victor_gpt52 group4_victor_sabia4 --api-key "SUA_OPENAI_KEY" --parallel 10 --structured
4) Exibir resultados:
   python show_result.py --bench-name oab_bench --judge-model gpt-5.2

Observações:
- Se já possuir um arquivo gerado (por ex. Gemini), coloque-o em data/oab_bench/model_answer/{{run_id}}.jsonl.
- Para qualquer dúvida ou se quiser que eu converta o arquivo do Gemini para o formato esperado, me envie uma linha de exemplo.

Link para este repositório: https://github.com/luanvsky/oab-bench
