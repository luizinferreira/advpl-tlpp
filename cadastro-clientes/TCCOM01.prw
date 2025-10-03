#Include "Totvs.ch"
#Include "FWMVCDef.ch"


/*/{Protheus.doc} TCCOM01
Cria tela de Cadastro de Clientes no padrão MVC
	@type user function
	@author Luiz Eduardo
	@since 01/10/2025
/*/
User Function TCCOM01()
	Local oBrowse 	:= FWMBrowse():New()

	oBrowse:AddStatusColumns( { || BrwStatus() },{ || BrwLegend() } )
	oBrowse:SetAlias("SA1")
	oBrowse:SetDescription("Cadastro de Clientes")
	oBrowse:Activate()
Return



/*/{Protheus.doc} ModelDef
	@type  Static Function
	@return oModel
/*/
Static Function ModelDef()
	Local oStruSA1 := FWFormStruct(1,'SA1')
	Local oModel

	oModel := MPFormModel():New("SA1MODEL")
	oModel:AddFields('SA1MASTER', /*cOwner*/, oStruSA1)
	oModel:SetDescription("Modelo de dados Clientes")
	oModel:GetModel('SA1MASTER'):SetDescription( "Dados de Clientes")
Return oModel


/*/{Protheus.doc} ViewDef
	@type  Static Function
	@return oView
/*/
Static Function ViewDef()
	Local oModel := FWLoadModel('TCCOM01')
	Local oStruSA1 := FWFormStruct(2,'SA1')
	Local oView
	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_SA1", oStruSA1, "SA1MASTER")
	oView:CreateHorizontalBox("TELA" , 100 )
	oView:SetOwnerView("VIEW_SA1", "TELA")

Return oView

/*/{Protheus.doc} MenuDef
	@type  Static Function
	@return aRotina
/*/
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE "Visualizar" 			ACTION "VIEWDEF.TCCOM01" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Atu. WebServ" 	ACTION "u_zGetCep()" OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE "Atu. CSV" 				ACTION "u_IMPCSV()" OPERATION 10 ACCESS 0

Return aRotina

//------------------------ Habilita Legendas ----------------------------------

Static Function BrwStatus()
	If Empty(SA1->A1_CEP)
		Return "BR_VERMELHO"
	ElseIf Empty(SA1->A1_BAIRRO) .OR. Empty(SA1->A1_EST) .OR. Empty(SA1->A1_MUN) .OR. Empty(SA1->A1_END) .OR. Empty(SA1->A1_COMPLEM)
		Return "BR_AMARELO"
	Else
		Return "BR_VERDE"
	EndIf
Return


Static Function BrwLegend()
	Local oLegend := FWLegend():New()

	oLegend:Add("", "BR_VERDE"   , "Cadastro Completo" )
	oLegend:Add("", "BR_AMARELO" , "CEP Presente - Ausencia de Outros Dados" )
	oLegend:Add("", "BR_VERMELHO", "CEP Ausente" )

	oLegend:Activate()
	oLegend:View()
	oLegend:DeActivate()

Return
