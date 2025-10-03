#Include "TOTVS.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} zGetCep
	@type user function
	@author Luiz Eduardo
	@since 01/10/2025
	@param oBrowse
		Recebe o oBrowse como parametro para identificar em qual Cliente está posicionado no momento da chamada
/*/

User Function zGetCep(oBrowse)

	Local aArea        		:= FWGetArea()
	Local cCep      			:= ""
	Local aHeader  			 	:= {}
	Local oRestClient   	:= FWRest():New("http://127.0.0.1:8500/cepapi")
	Local cResult					:= ""
	Local oResult
	Local aDados					:= {}
	Local cCodCli 		 		:= SA1->A1_COD
	Local cLojaCli 				:= SA1->A1_LOJA
	Local cNomeCli				:= SA1->A1_NOME

	Private lMsErroAuto := .F.

	cCep := FWInputBox("Digite o CEP Desejado",cCep)

	If Empty(cCep)
		MsgStop("Nenhum Cep informado!","Atenção")
	endif

	Conout("CEP recebido com sucesso")

	aAdd(aHeader,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
	aAdd(aHeader,'Content-Type: application/json; charset=utf-8')

	oRestClient:setPath('/cep?search='+cCep)
	If oRestClient:Get(aHeader)

		cResult := oRestClient:cResult
		oResult := JsonObject():New()

		oResult:FromJson(cResult)

		Conout("Abrindo o Cadastro do Cliente: " + cCodCli + " - " + cLojaCli)

		// Verifica se veio erro da API
		If Upper(AllTrim(oResult:GetJsonObject('erro'))) == "TRUE"
			MsgStop("O CEP informado no cadastro de cliente não consta na base de dados da consulta publica","Atenção")
		Else

			DbSelectArea('SA1')

			SA1->(DbSetOrder(1))


			If SA1->(DbSeek(xFilial("SA1") + cCodCli + cLojaCli))
				aDados := {{"A1_COD", cCodCli			, 	Nil},;
					{"A1_LOJA", cLojaCli						,		Nil},;
					{"A1_END", oResult:GetJsonObject('logradouro'), Nil},;
					{"A1_BAIRRO", oResult:GetJsonObject('bairro'),Nil},;
					{"A1_MUN", oResult:GetJsonObject('localidade'),Nil},;
					{"A1_EST", oResult:GetJsonObject('uf'),Nil},;
					{"A1_CEP",		cCep		,		Nil};
					}

				CONOUT("Iniciando a alteracao")

				MSExecAuto({|a,b| CRMA980(a,b)},aDados,4)

				If lMsErroAuto
					MsgStop("Falha na atualização de endereço do cliente: " + cNomeCli + CRLF + CRLF + " Por favor aguarde alguns instantes e tente novamente","Atenção")
					Conout("Erro na alteracao do cliente: " + cNomeCli)
				Else
					Conout("Cliente alterado com sucesso!")
					FWAlertSuccess("As informações de endereço do cliente: " + cNomeCli + " foram atualizadas com sucesso", "Sucesso")
				EndIf

				ConOut("Fim: " + Time())
			Else
				MsgInfo("Cliente não encontrado!")
			EndIf
			SA1->(DbCloseArea())
		endif
	Else

		cLastError := oRestClient:GetLastError()
		cErrorDetail := oRestClient:GetResult()
		Alert(cErrorDetail)
	Endif

	FWRestArea(aArea)
Return

