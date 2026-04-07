INSTRUÇÕES PARA ADICIONAR UM ARQUIVO DE RESPOSTAS GEMINI

1) Estrutura esperada
- O arquivo deve ser um JSONL (uma linha JSON por questão).
- Cada linha deve ter pelo menos os campos: question_id (string), answer_id (string), model_id (string), choices (lista com objetos contendo index e turns), tstamp (timestamp). Exemplo de linha:
  {"question_id":"107","answer_id":"example-uuid-0001","model_id":"group4_victor_gemini","choices":[{"index":0,"turns":["Resposta do modelo para o turno 1 (texto)"]}],"tstamp":1700000000}

2) Como nomear e colocar o arquivo
- Renomeie seu arquivo para: data/oab_bench/model_answer/group4_victor_gemini.jsonl
- Faça commit e push para o repositório.

3) Verificação rápida local (opcional)
- Linha de comando para validar o formato (Linux/macOS):
  head -n 1 data/oab_bench/model_answer/group4_victor_gemini.jsonl | python -m json.tool
  # se for válido, o JSON será pretty-printed; caso contrário dará erro.

4) Converter se seu arquivo estiver em outro formato
- Se seu arquivo só contém respostas em texto (uma resposta por linha), use este script Python local para converter (exemplo):

  import json, time, uuid
  infile = 'meu_gemini_respostas.txt'
  outfile = 'data/oab_bench/model_answer/group4_victor_gemini.jsonl'
  qids = list(range(107, 119))  # ajustar conforme as questões usadas
  with open(infile) as fin, open(outfile, 'w', encoding='utf-8') as fout:
      for i, line in enumerate(fin):
          qid = str(qids[i]) if i < len(qids) else str(1000+i)
          obj = {
              'question_id': qid,
              'answer_id': str(uuid.uuid4()),
              'model_id': 'group4_victor_gemini',
              'choices': [{'index':0, 'turns':[line.strip()]}],
              'tstamp': int(time.time())
          }
          fout.write(json.dumps(obj, ensure_ascii=False) + '\n')

- Ajuste qids conforme as questões (107–118 para as abertas e 1102–1230 para as de múltipla escolha, conforme sua instrução).

5) Depois de adicionar o arquivo
- Rode o gerador de julgamentos (exemplo):
  python3 -m gen_judgment --judge-model gpt-5.2 --model-list group4_victor_gemini --api-key "SUA_OPENAI_KEY" --parallel 10 --structured
- Em seguida, rode:
  python show_result.py --bench-name oab_bench --judge-model gpt-5.2

6) Se preferir que eu faça a conversão/validação
- Cole aqui UMA LINHA do seu arquivo Gemini (uma linha JSON) ou anexe o conteúdo; eu valido e, se preciso, converto e eu mesmo adiciono ao repositório.

-- Fim das instruções --
