#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*/{Protheus.doc} FA040INC()
@type user function
@author Luiz Eduardo
@since 03/02/2024
@Description = Verifica se ja existe um titulo lançado para o cliente com os mesmos dados digitados.
/*/

User Function FA040INC()
    Local aArea     := SE1->(GetArea())
    Local lRet      := .T.
    Local cQuery    := ""
    Local nTotalReg := 0
    Local cMensagem := "Foi encontrado um titulo já lançado para este Cliente que coincide com os mesmos dados digitados. Deseja Continuar?"
    

    cQuery := " SELECT "
    cQuery += " E1_NUM AS NUMERO, "
    cQuery += " E1_PREFIXO AS PREFIXO, "
    cQuery += " E1_CLIENTE AS CODCLIENTE, "
    cQuery += " E1_LOJA AS LOJA, "
    cQuery += " E1_NOMCLI AS NOME, "
    cQuery += " E1_VALOR AS VALOR "
    cQuery += " FROM " + RetSQLName("SE1")+" SE1 "
    cQuery += " WHERE E1_CLIENTE = '"+ M->E1_CLIENTE+ " ' AND "
    cQuery += " E1_LOJA = '"+ M->E1_LOJA+ " ' AND "
    cQuery += " E1_VALOR = '"+ cValToChar(M->E1_VALOR)+ " ' AND"
    cQuery += " E1_EMISSAO >= '"+ DTOS(M->E1_EMISSAO)+ " ' - '7' AND "
    cQuery += " E1_EMISSAO <= '"+ DTOS(M->E1_EMISSAO)+ " ' AND "
    cQuery += " E1_ORIGEM <> 'FINI055' AND "
    cQuery += " D_E_L_E_T_ = ' ' "

    TCQuery cQuery New Alias "xE1TEMP"
    DbSelectArea("xE1TEMP")
    
    Count to nTotalReg
    
    xE1TEMP->(DbGoTop())
     
        IF(nTotalReg > 0)
            IF FwAlertNoYes(cMensagem,"Duplicidade Encontrada")
                lRet := .T.
            ELSE
                lRet := .F.
            ENDIF
        ENDIF
    
    xE1TEMP->(DbCloseArea())
    RestArea(aArea)

Return lRet
