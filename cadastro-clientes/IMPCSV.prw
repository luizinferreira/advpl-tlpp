#Include "Totvs.ch"


/*/{Protheus.doc} IMPCSV
Importa arquivo .csv Cadastro de Clientes e dispara MsgInfo em caso de duplicidade do código do cliente
)
@type user function
@author Luiz Eduardo
@since 02/10/2025
@version version
@param
@return 

/*/
User Function IMPCSV()
	Local aArea   := FWGetArea()
	Local cDir := GetTempPath()
	Local cArq := ""
	Local cTitulo := "Selecione arquivo .csv para importação"
	Local lSalvar := .F.
	Local cArqSel  := ""

	If !IsBlind()
		cArqSel := tFileDialog(;
			cArq,;
			cTitulo,;
			,;
			cDir,;
			lSalvar,;
			;
			)

		If !Empty(cArqSel) .And. File(cArqSel)
			Processa({|| csvArq(cArqSel) }, "Importando arquivo...")
		EndIf
	EndIf

	FWRestArea(aArea)

Return


/*/{Protheus.doc} csvArq
)
  @type  Static Function
  @author Luiz Eduardo
  @since 02/10/2025
  @version version
  @param cArqSel
  @return 
/*/
Static Function csvArq(cArqSel)
	Local nTotLinhas := 0
	Local cLinAtu    := ""
	Local nLinhaAtu  := 0
	Local aLinha     := {}
	Local oArquivo
	Local cPastaErro := '\x_logs\'
	Local cNomeErro  := ''
	Local cTextoErro := ''
	Local cLog       := ''
	Local lIgnor01   := FWAlertYesNo('Deseja ignorar a linha 1 do arquivo?', 'Ignorar?')

	//variaveis para MSExecAuto CRMA980
	Private aDados         := {}
	Private lMSHelpAuto    := .T.
	Private lAutoErrNoFile := .T.
	Private lMsErroAuto    := .F.

	//Separador de campos do arquivo .csv
	Private cSeparador := ';'

	DbSelectArea('SA1')
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())

	oArquivo := FWFileReader():New(cArqSel)

	if (oArquivo:Open())

		If ! (oArquivo:Eof())

			aLinhas := oArquivo:GetAllLines()

			nTotLinhas := Len(aLinhas)

			ProcRegua(nTotLinhas)

			oArquivo:Close()

			oArquivo := FWFileReader():New(cArqSel)

			oArquivo:Open()

			conout("Iniciando importação...")

			Begin Transaction

				While( oArquivo:HasLine())

					nLinhaAtu++

					cLinAtu := oArquivo:GetLine()

					aLinha := Separa(cLinAtu, cSeparador)

					If lIgnor01 .And. nLinhaAtu == 1
						Loop
					elseif Len(aLinha) > 0

						SA1->(DbSetOrder(1))

						If SA1->(DbSeek(xFilial("SA1") + AllTrim(aLinha[1]) + AllTrim(aLinha[2])))

							MsgInfo("Código de Cliente já existe para "+ CRLF+ CRLF + AllTrim(aLinha[4])+ CRLF + CRLF+ CRLF + "Tentando incluir próximo...")

						else
							aDados := {}

							aAdd(aDados, {"A1_COD",         AllTrim(aLinha[1]), Nil})
							aAdd(aDados, {"A1_LOJA",        AllTrim(aLinha[2]), Nil})
							aAdd(aDados, {"A1_NOME",        AllTrim(aLinha[3]), Nil})
							aAdd(aDados, {"A1_NREDUZ",      AllTrim(aLinha[4]), Nil})
							aAdd(aDados, {"A1_TIPO",        AllTrim(aLinha[5]), Nil})
							aAdd(aDados, {"A1_CEP",         AllTrim(aLinha[6]), Nil})
							aAdd(aDados, {"A1_END",         AllTrim(aLinha[7]), Nil})
							aAdd(aDados, {"A1_COMPLEM",     AllTrim(aLinha[8]), Nil})
							aAdd(aDados, {"A1_BAIRRO",      AllTrim(aLinha[9]), Nil})
							aAdd(aDados, {"A1_MUN",         AllTrim(aLinha[10]), Nil})
							aAdd(aDados, {"A1_EST",         AllTrim(aLinha[11]), Nil})

							MSExecAuto({|a,b| CRMA980(a,b)},aDados,3)

							lMsErroAuto := .F.
							if lMsErroAuto
								cNomeErro := "erro_impo_cli_" + dToS(Date())+ "_" + StrTran(Time(), ':', '-') + ".txt"

								if !ExistDir(cPastaErro)
									MakeDir(cPastaErro)
								endif

								MemoWrite(cPastaErro + cNomeErro, cTextoErro)
								cLog+= "Falha ao incluir registro linha [" + cValToChar(nLinhaAtu) + "] arquivo de log em " + cPastaErro + cNomeErro + CRLF

							Else

								cLog+= "Sucesso no Execauto na linha " + cValToChar(nLinhaAtu) + ";" + CRLF


							endif
						Endif


					endif

				EndDo

			End Transaction
		Else
			MsgStop('Arquivo vazio!', 'Atenção')
		endif
		MsgInfo("Processo de Importação Finalizado com Sucesso...")
		oArquivo:Close()

		conout("Importação de Arquivo .csv Finalizada com Sucesso !")

	Else

		MsgStop('Erro ao abrir o arquivo!', 'Atenção')
	endif


Return
