# Caderno Temático — OAB Bench (pasta data)

## Contexto e Objetivos
Este caderno temático reúne os dados, prompts e artefatos usados para avaliar modelos de linguagem na resolução de questões estilo OAB. Objetivo: documentar a curadoria de fontes, registrar a engenharia de prompts (com "cicatrizes" — dificuldades e ajustes) e entregar um miniguia de estudo com resumos, glossário e um conjunto de prompts reutilizáveis para revisões futuras e replicação.

Escopo deste diretório:
- Dados das questões e respostas de referência.
- Prompts de avaliação/julgamento.
- Artefatos de execução e instruções para reprodução.

## Curadoria de Fontes (3–5 referências no repositório)
As fontes abaixo foram carregadas neste repositório e serviram de base para a curadoria no NotebookLM e para os testes com modelos:

1. Conjunto de perguntas (questões OAB)  
   https://github.com/luanvsky/oab-bench/blob/69e81d637930ab8f955bf38c076dc3722c84c40a/data/oab_bench/question.jsonl

2. Arquivo com múltiplas respostas/metadata usadas nas inferências  
   https://github.com/luanvsky/oab-bench/blob/69e81d637930ab8f955bf38c076dc3722c84c40a/data/oab_bench/multiple_me.json

3. Prompts de avaliação / judge prompts (variações testadas para avaliação automática)  
   https://github.com/luanvsky/oab-bench/blob/69e81d637930ab8f955bf38c076dc3722c84c40a/data/judge_prompts.jsonl

(Se tiver PDFs ou textos externos que foram importados para o NotebookLM, inclua-os aqui com link ou descreva os arquivos adicionados.)

## Engenharia de Prompts e "Cicatrizes" (registro de tentativa e erro)
Nesta seção documentamos perguntas estratégicas, variações testadas e problemas encontrados.

Exemplos de prompts estratégicos usados (versão reduzida):
- "Responda à questão abaixo simulando a redação jurídica exigida pela prova da OAB. Seja objetivo, cite dispositivos legais quando aplicável e indique a conclusão."
- "Compare a resposta gerada pelo modelo com o gabarito oficial e calcule uma pontuação de similaridade textual (BERTScore). Liste divergências factuais."
- "Extraia, em tópicos, os pontos legais centrais que devem constar na resposta ideal para esta questão."

Variações testadas:
- Ajuste do tom (conciso → detalhado).
- Fornecimento de instruções de formatação (ex.: "responda em tópicos numerados, inclua artigos citados").
- Uso/remoção de contexto adicional (jurisprudência, enunciados).

Cicatrizes — dificuldades e como resolvemos:
- Ambiguidade nas instruções: modelos omitiram citações legais; resolvido reforçando "cite artigos/arts." no prompt.
- Respostas muito prolixas: usar instruções de limite de tokens e pedir "resumo em 5 itens".
- Modelos inventando jurisprudência ("hallucination"): mitigar com prompt que pede "indique quando não encontrar jurisprudência específica" e com filtragem pós-processamento.
- Avaliação automática ruidosa: BERTScore penaliza sinonímias legais; adotamos avaliação híbrida (BERTScore + revisão humana em amostra).

Registro de resultados (exemplo resumido):
- Modelo: Gemini 2.5-flash — média BERTScore (F1): 0.6786 (ver artefatos na pasta `integrantes/` conforme convenção do repositório).

## Miniguia de Estudo (Entrega Final)
Este bloco é a entrega condensada para revisão rápida.

1) Resumos estruturados do assunto
- Objetivo do benchmark: medir aderência de LLMs ao vocabulário e raciocínio jurídico exigidos pela OAB.
- Metodologia: inferência com prompts padronizados → comparação com gabarito oficial → métrica principal: BERTScore (F1) + amostra de revisão humana.
- Principais conclusões: modelos apresentam boa aderência lexical, porém falham em peças práticas que exigem argumentação estruturada e referência a jurisprudência específica.

2) Glossário (principais conceitos)
- Gabarito: resposta oficial usada como referência.
- BERTScore: métrica de similaridade semântica entre textos (usa embeddings).
- Prompt engineering: construção e iteração de instruções para orientar o modelo.
- Hallucination: quando o modelo gera informação factualmente incorreta ou não-verificável.
- Peça prática: questão que exige elaboração de peça jurídica (maior complexidade).

3) Conjunto de prompts reutilizáveis (exemplos em Português)
- Prompt A — Resposta Jurídica Objetiva:
  "Você é um advogado experiente. Responda a questão abaixo de forma objetiva, em no máximo 8 frases, citando os dispositivos legais relevantes (se existirem). Termine com uma conclusão direta."

- Prompt B — Estrutura por Tópicos:
  "Leia a questão e responda em 5 tópicos: (1) pontos fáticos; (2) questões jurídicas; (3) normativa aplicável; (4) argumentação; (5) conclusão. Seja sucinto."

- Prompt C — Verificação de Conformidade com o Gabarito:
  "Compare a resposta X com o gabarito Y e gere: (a) uma nota 0–100 baseada em similaridade semântica; (b) 3 diferenças factuais ou de escopo; (c) recomendações de correção."

- Prompt D — Extração de Citações Legais:
  "Extraia todos os artigos/arts./incisos citáveis na resposta. Se nenhum existir, escreva 'Nenhum dispositivo explícito'."

- Prompt E — Identificação de Hallucination:
  "Verifique se a resposta contém afirmações não suportadas pelo enunciado ou por normas citadas. Liste cada possível invenção e indique 'Suspeita de invenção' e motivo."

- Prompt F — Resumo para Revisão R��pida:
  "Resuma a resposta em até 3 frases-chave que um revisor deve verificar."

Observação: mantenha esses prompts em um arquivo (ex.: `prompts/reusable_prompts.md`) e versionados para reutilização.

## Reprodutibilidade e próximos passos
- Como reproduzir: rodar o script de inferência (ver `script_final_equipe4_victor.py` ou equivalentes) apontando para os arquivos em `data/oab_bench/`. Exportar saídas em CSV e rodar avaliação com o script de avaliação para gerar BERTScores.
- Checklist sugerido para entrega:
  - Pasta organizada por integrante: `integrantes/<nome>/`
  - Scripts e CSVs de output na pasta do integrante.
  - README principal (raiz) com link para este README de dados.
  - Pequena amostra de revisão humana anexada para validar avaliações automáticas.

## Créditos e contato
Repositório: luanvsky/oab-bench  
---

# Gráfico de barras comparativo mostrando o BERTScore F1-score e a pontuação percentual do LLM-Juiz para cada modelo. Isso ajudará a visualizar a relação entre similaridade textual e avaliação de conteúdo.

O gráfico gerado, intitulado 'BERTScore F1-score vs. Pontuação do LLM-Juiz por Modelo', compara o desempenho de cada modelo usando duas métricas:

F1-score do BERTScore: Representa a similaridade semântica das respostas do modelo com o gabarito oficial, variando de 0 a 1.
Pontuação Percentual do LLM-Juiz (0-1): É a nota média percentual que o LLM-Juiz atribuiu a cada modelo, também normalizada para uma escala de 0 a 1 para facilitar a comparação visual.
Este gráfico permite que você veja como a similaridade textual (BERTScore) se alinha com a avaliação de conteúdo (LLM-Juiz) para cada um dos modelos testados. Modelos que têm barras de F1-score e Pontuação do LLM-Juiz de altura similar indicam uma boa concordância entre as duas métricas, enquanto grandes diferenças podem sugerir que o modelo é semanticamente similar, mas não atende aos critérios de avaliação do juiz, ou vice-versa.

<img width="1386" height="790" alt="image" src="https://github.com/user-attachments/assets/ac0c782b-5ef8-4354-a40b-97dde2565387" />

Com base nos cálculos anteriores, os modelos que apresentam a maior discrepância entre o F1-score do BERTScore e a Pontuação Percentual do LLM-Juiz são:

<img width="644" height="279" alt="image" src="https://github.com/user-attachments/assets/723935c7-4487-4ae5-97fd-b6599454f630" />


A tabela mostra os modelos com a maior discrepância entre o F1-score do BERTScore e a pontuação percentual do LLM-Juiz, ordenados do maior para o menor desvio:

GPT-OSS 120B e Groq Compound apresentam os maiores desvios. O GPT-OSS 120B, por exemplo, tem um F1-score de 0.620, mas uma pontuação do LLM-Juiz de 100%. Isso sugere que, embora a similaridade semântica com o gabarito (medida pelo BERTScore) não seja a mais alta, o LLM-Juiz o avaliou como perfeito. Isso pode indicar que o GPT-OSS 120B capturou os pontos-chave exigidos pelo LLM-Juiz, mesmo que a formulação da resposta não fosse linguisticamente muito similar ao gabarito.
Allam 2 7B também mostra uma grande diferença, com um F1-score baixo (0.206) e uma pontuação do LLM-Juiz de 45.7%.
LLaMA 3.1 8B Instant, GPT-OSS 20B e GPT-OSS Safeguard 20B são os modelos com as menores discrepâncias. Isso significa que a avaliação de similaridade semântica (BERTScore) e a avaliação de conteúdo (LLM-Juiz) para esses modelos são mais alinhadas, sugerindo que respostas semanticamente mais próximas aos gabaritos também tendem a receber pontuações de conteúdo mais altas do LLM-Juiz.





