#Include "Protheus.ch"
#Include "TopConn.ch"
 
/*/{Protheus.doc} zF1Doc
Função que preenche os zeros a esquerda do documento de uma nota de entrada
@author Atilio
@since 17/12/2017
@version 1.0
@type function
/*/
 
User Function zSE1REC()
    Local aArea    := GetArea()
    Local lRet     := .T.
 
    //Se o titulo digitado for do prefixo SYS do sysrad, ira ignorar
        If !Empty(M->E1_PREFIXO <> "SYS")
            
        //Adiciona o zero a esquerda em titulos que nao sejam do Sysrad
            (M->E1_NUM := STRZERO(Val(M->E1_NUM),9),.T.)
            
        EndIf
    
    RestArea(aArea)
Return lRet
