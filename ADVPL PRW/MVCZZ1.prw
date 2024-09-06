#include "protheus.ch"
#include "fwmvcdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} ZMBA010
    Browse simples para exibir os dados da tabela 
	@type    function

@author  Alberto.goncalves
@since   20.06.2024
/*/
//-------------------------------------------------------------------
user function MVCZZ1()
    // u_m010Stamp()
    AxCadastro("ZZ1")
return

static function ModelDef()
    local oModel   as object
    local oStr  as object

    oStr := FWFormStruct(1, "ZZ1")
    oModel := MpFormModel():New("ZZ1MODEL")

    oModel:AddFields("ZZ1_FIELDS", , oStr)
    oModel:SetDescription("Log de Eventos")
    oModel:GetModel("ZZ1_FIELDS"):SetDescription("Log Eventos")

return oModel
