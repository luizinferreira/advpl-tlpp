# 🚀 Guia de Execução do Projeto ADVPL & TLPP

Este projeto contém  **integração com API interna (ViaCep)** e **rotina de importação de arquivos CSV** para o Protheus/TOTVS.  
Siga as instruções abaixo para configurar corretamente o ambiente.

---

## 📝 1. Crie no menu a Função de Usuário TCCOM01 no módulo que desejar e Relacione-a na tabela SA1 (Cadastro de Clientes).

---

## 🌐 2. Consumo da API Interna (ViaCep)

Para utilizar a API interna que realiza a integração com o endpoint **ViaCep**, é necessário:

1. **Habilitar o servidor REST** do Protheus.  
2. Configurar o **`appserver.ini`** conforme o exemplo fornecido neste repositório.
3. Compilar o projeto em ambiente REST e Principal (Homologue antes)

📌 **Passos básicos:**

- Localize o arquivo `appserver.ini` disponibilizado no diretório do projeto.  
- Copie ou adapte as seções REST para o seu ambiente Protheus.  
- Reinicie o AppServer para aplicar as alterações.  

Após isso, a API estará pronta para receber requisições internas e consultar os dados do ViaCep.

---

## 📥 3. Uso da Rotina de Importação (CSV)

Para executar a rotina de importação, siga as etapas abaixo:

1. Prepare um arquivo `.csv` com os dados desejados.  
2. Certifique-se de que o **formato e o cabeçalho** do arquivo estejam **idênticos ao modelo `default.csv`** fornecido neste repositório.  
   - O **separador de campos** deve ser **`;` (ponto e vírgula)**.  
3. Coloque o arquivo CSV no diretório desejado.  
4. Execute a rotina no Protheus para processar os dados.

✅ Caso o arquivo não siga o padrão, a rotina poderá falhar ou importar dados incorretos.

---

## 📝 Requisitos

- Servidor Protheus/TOTVS configurado corretamente  
- ADVPL ou TLPP habilitado no ambiente  
- Acesso ao AppServer para ajustes no `appserver.ini`  
- Arquivo CSV no formato correto (`;` como separador)

---

## 💬 Dúvidas ou Problemas

Caso encontre dificuldades para configurar ou executar as rotinas, verifique:
- Parametrização da chamada da User Function TCCOM01() no Menu do Módulo.
- Logs do AppServer  
- Cabeçalho e estrutura do CSV  
- Configuração REST no `appserver.ini`

