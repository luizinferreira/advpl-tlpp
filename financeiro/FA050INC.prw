#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
/*/{Protheus.doc} FA050INC()
@type user function
@author Luiz Eduardo
@since 03/02/2024
@Description = Verifica se ja existe um titulo lançado para o cliente com os mesmos dados digitados.
/*/

User Function FA050INC()
    Local aArea     := SE2->(GetArea())
    Local lRet      := .T.
    Local cQuery    := ""
    Local nTotalReg := 0
    Local cMensagem := "Foi encontrado um titulo já lançado para este cliente que coincide com os mesmos dados digitados. Deseja Continuar?"
    

    cQuery := " SELECT "
    cQuery += " E2_NUM AS NUMERO, "
    cQuery += " E2_PREFIXO AS PREFIXO, "
    cQuery += " E2_FORNECE AS CODCLIENTE, "
    cQuery += " E2_LOJA AS LOJA, "
    cQuery += " E2_NOMFOR AS NOME, "
    cQuery += " E2_VALOR AS VALOR "
    cQuery += " FROM " + RetSQLName("SE2")+" SE2 "
    cQuery += " WHERE E2_FORNECE = '"+ M->E2_FORNECE+ " ' AND "
    cQuery += " E2_LOJA = '"+ M->E2_LOJA+ " ' AND "
    cQuery += " E2_PREFIXO = '"+ M->E2_PREFIXO+ " ' AND "
    cQuery += " E2_ORIGEM <> 'FINA171' AND "
    cQuery += " E2_VALOR = '"+ cValToChar(M->E2_VALOR)+ " ' AND"
    cQuery += " D_E_L_E_T_ = ' ' "

    TCQuery cQuery New Alias "xE2TEMP"
    DbSelectArea("xE2TEMP")
    
    Count to nTotalReg
    xE2TEMP->(DbGoTop())
     
        IF(nTotalReg > 0)
            IF FwAlertNoYes(cMensagem,"Duplicidade Encontrada")
                lRet := .T.
            ELSE
                lRet := .F.
            ENDIF
        ENDIF
    
        xE2TEMP->(DbCloseArea())
        RestArea(aArea)

Return lRet
