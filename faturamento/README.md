# ZPRECOPROD

Função AdvPL que retorna o último preço de compra cadastrado para um produto, consultando a tabela de Itens NF de Entrada (SD1). Foi criada para uso em gatilhos (triggers) no Protheus, por exemplo no campo `C6_PRODUTO` de pedidos de venda.

## Visão geral
- Arquivo: `faturamento/ZPRECOPROD.tlpp`
- Função principal: `ZPRECOPROD(cProd)`
- Objetivo: retornar o último valor do campo `D1_VUNIT` para o produto informado, ordenando por data de digitação (`D1_DTDIGIT`) e obtendo apenas a primeira linha.

## Assinatura
- Parâmetro
  - `cProd` (string) — código do produto a ser consultado.
- Retorno
  - `nPreco` (numeric) — último preço encontrado (0.0 se não existir registro ou em caso de falha).

## Comportamento
- Faz backup da área atual com `FWGetArea()` e a restaura ao final com `FWRestArea()`.
- Monta uma query SQL usando `RetSQLName("SD1")` e `QryArray()` para executar a consulta.
- Ordena por `D1_DTDIGIT DESC` e faz `FETCH FIRST 1 ROW ONLY`, **⚠️Importante** - A sintaxe `FETCH FIRST 1 ROW ONLY` deve ser utilizada em banco de dados Oracle. Consulte a       
    disponibilidade para o seu banco de dados.
- Captura erros via `ErrorBlock()` e, se ocorrer, exibe uma mensagem com `MsgInfo()` sem interromper o fluxo, retornando `0.0` como preço padrão.
- Observação importante: a query usa `cFilAnt` (filial anterior) na cláusula `D1_FILIAL = '...'`. Essa variável precisa existir no escopo chamador; caso contrário, a consulta pode falhar ou retornar resultados inesperados.

## Exemplo de uso
![Cadastro do Gatilho](https://github.com/luizinferreira/advpl-tlpp/blob/7de9d78c6888aaec8f2092504165d053a6ea2765/faturamento/cadastro-gatilho.png)

## Dependências / Requisitos
- Inclui: `Protheus.ch`, `topconn.ch` (cabecalhos do Protheus).
- Funções usadas (dependem do ambiente Protheus):
  - `FWGetArea`, `FWRestArea`, `RetSQLName`, `QryArray`, `ErrorBlock`, `MsgInfo`.

## Observações e recomendações
- Verifique a disponibilidade e valor de `cFilAnt` no contexto onde a função for chamada.
- A função não lança exceções ao usuário final; apenas registra/mostra a mensagem e retorna `0.0` em caso de erro.
- Ajuste a query caso o banco ou dicionário de dados local utilize nomes de campos/tabelas diferentes.

## Localização do código
O código está em: [faturamento/ZPRECOPROD.tlpp](faturamento/ZPRECOPROD.tlpp)