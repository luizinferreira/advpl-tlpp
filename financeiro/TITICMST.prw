#include 'Protheus.ch'
#include 'TopConn.ch'

/*/{Protheus.doc} nomeFunction
(long_description)
@type user function
@author user
@since 10/10/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function TITICMST()

Local cOrigem := PARAMIXB[1]
Local cTipoImp := PARAMIXB[2]
Local lDifal := PARAMIXB[3]

    SE2->E2_NUM     := SE2->(Soma1(E2_NUM,Len(E2_NUM)))
    SE2->E2_VENCTO  := DataValida(dDataBase+7,.T.)
    SE2->E2_VENCREA := DataValida(dDataBase+7,.T.)
    SE2->E2_FORNECE := '004527'
    SE2->E2_LOJA    := '01'
    SE2->E2_NOMFOR  := 'SECRETARIA DE FAZEND'


Return {SE2->E2_NUM,SE2->E2_VENCTO,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NOMFOR}
