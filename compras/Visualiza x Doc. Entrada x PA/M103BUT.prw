#Include 'Protheus.ch'
/*/{Protheus.doc} MA103BUT
PE para adicionar novos botões no EnchoiceBAR
do Documento de Entrada.
@type     function
@author     
@since       21/11/2024
/*/
User Function MA103BUT()
	Local aButtons := {}


	Aadd(aButtons, {'Visualizar Pedido', {||u_ZVPEDPA()}, 'Visualizar Pedido'})


Return (aButtons)
