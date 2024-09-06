#include "restful.ch"
#include "fwmvcdef.ch"
#INCLUDE "TOTVS.CH"
#include "tbiconn.ch"
#include "topconn.ch"

#define QRY_PARAM_KEY 1
#define QRY_PARAM_VALUE 2

#define MAP_PROP 1
#define MAP_FIELD 2
#define MAP_TYPE 3
#define MAP_INTERNAL_FIELD 4

#define QRY_VAL_TYPE 1
#define QRY_VAL_VALUE 2

//-------------------------------------------------------------------
/*/{Protheus.doc} perfis
    Classe para aplicar a atualização dos perfis das locais app minha_portaria
@type   class

@author  Alberto.goncalves
@since   20.06.2024
/*/
//-------------------------------------------------------------------
wsrestful Ffmpapi01 description "Trata a atualização dos perfis que usam o appMinhaPortaria"
	wsdata cCode         	as character optional
	wsdata cApiFilter 		as character optional
	wsdata cZFilial 		as character optional
	wsdata cDescription 	as character optional


	// versões 2 - utilizam modelo nos processos de gravação
	wsmethod POST V2XROOT description "Cria um perfil para o appMinhaPortaria usando modelo MVC" wssyntax "/ffmpapi01/cad01" path "/ffmpapi01/cad01"

	wsmethod GET V2XID description "Recupera Cad01 pelo Codigo ou Descrição" wssyntax "/ffmpapi01/cad01/{cCode}" path "/ffmpapi01/cad01/{cCode}"
	wsmethod PUT V2xID description "Faz a atualização de um perfil usando modelo MVC" wssyntax "/ffmpapi01/cad01/{cCode}" path "/ffmpapi01/cad01/{cCode}"
	wsmethod DELETE V2X description "Faz a exclusão de um perfil usando modelo MVC" wssyntax "/ffmpapi01/cad01/{cCode}" path "/ffmpapi01/cad01/{cCode}"


end wsrestful

//-------------------------------------------------------------------
/*/{Protheus.doc} GET V2ID
    Recupera Cad01 pelo Codigo ou Descrição
@type    method

@author  Alberto Gonçalves
@since   09.05.2024
/*/
//-------------------------------------------------------------------

wsmethod GET V2XID pathparam cCode, cApiFilter, cZFilial, cDescription wsservice Ffmpapi01
// http://192.168.3.101:2005/rest/ffmpapi01/cad01/TESTE 01?cDescription=TESTE 01&cGroupCode=XXXX&cZFilial=XXXX&cApiFilter=N
	local lProcessed as logical
	local jResponse  as object
	local jItens as object

	Local cQuery := ''
	Local aAlias := GetNextAlias()
	Local IND := 1
	Local nlen := 0
	Local aArray  := []


	lProcessed := .T.
	self:SetContentType("application/json")

	jResponse := JsonObject():New()

	// Id não ser vazio e existir como item na tabela
	lProcessed := !(Alltrim(self:cCode) == "")

	jResponse['Cad01'] := {}

	if lProcessed

		// String SQL Pedidos
		cQuery := " select * "
		cQuery += " from " + RetSqlName("ZZ1") + " as ZZ1"
		cQuery += " where ZZ1.D_E_L_E_T_ = '' "
		if self:cApiFilter == "S"
			cQuery += " AND ( ZZ1_CODE like '%"+ self:cCode +"%' OR ZZ1_NAME like '%"+ self:cDescription +"%') "
			cQuery += " AND ZZ1_FILIAL = '"+ self:cZFilial +" '"
		endif


		cQuery := ChangeQuery(cQuery)
		DbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery), "aAlias", .F., .T. )
		aAlias->(dbGoTop())
		nlen := 0
		Count To nlen
		aArray := aAlias->(DBSTRUCT())

		aAlias->(dbGoTop())
		While aAlias->(!Eof())

			jItens := JsonObject():New()

			While (len(aArray) >= IND)
				jItens[""+ alltrim(aArray[IND][1]) +""] := aAlias->&(aArray[IND][1])
				IND++
			ENDDO

			IND := 1
			aAlias->(dbSkip())
			aAdd(jResponse['Cad01'], jItens)

		enddo

		aAlias->(Dbclosearea())

		self:SetResponse(jResponse:ToJson())
	else
		jResponse["error"] := "id_invalido"
		jResponse["description"] := i18n("Perfil não encontrado utilizando o #[id] informado", {self:cCode})

		self:SetResponse(jResponse:ToJson())
		SetRestFault(404, jResponse:ToJson(), , 404)
		lProcessed := .F.
	endif

return lProcessed

//-------------------------------------------------------------------
/*/{Protheus.doc} POST V2ROOT
    Cria um perfil para o appMinhaPortaria usando MVC
@type   method

@author  Alberto Gonçalves
@since   08.04.2024
/*/
//-------------------------------------------------------------------
wsmethod POST V2XROOT wsservice Ffmpapi01
	local lProcessed as logical
	local lVldPost as logical
	local jBody      as object
	local jResponse  as object
	local jOkPost 	 as object
	local jErrorPost as object
	local listItens as object
	local oModel     as object
	Local oHeader	 as object
	local aError     as array
	local index := 1
	local aHeader as String
	local aModel as string

	aHeader := "ZZ1_FIELDS"
	aModel := "MVCZZ1"

	lVldPost := .T.
	lProcessed := .T.
	self:SetContentType("application/json")

	jBody := JsonObject():New()
	jBody:FromJson(self:GetContent())

	listItens := JsonObject():New()
	listItens := jBody:GetJSonObject("Cad01")

	jResponse := JsonObject():New()
	jResponse['jOkPost'] := {}
	jResponse['jErrorPost'] := {}

	jOkPost := JsonObject():New()
	jErrorPost := JsonObject():New()
	
	
	if 	(listItens[1]["ZZ1_FILIAL"] == Nil .Or. listItens[1]["ZZ1_CODE"] == Nil .Or. listItens[1]["ZZ1_NAME"] == Nil );

		jResponse["error"] := "body_invalido"
		jResponse["description"] := "Forneca as propriedades: ZZ1_FILIAL,ZZ1_CODE,ZZ1_NAME no body: ";

		self:SetResponse(jResponse:ToJson())
		SetRestFault(400, jResponse:ToJson(), , 400)
		lProcessed := .F.
	else

		for index := 1 to Len(listItens)
			//Aviso ERRO DE CHAVE CLASSE NECESSARIO INFORMAR CAMPO SX2_UNICO
			oModel := FwLoadModel("MVCZZ1")
			oModel:SetOperation(MODEL_OPERATION_INSERT)
			lProcessed := oModel:Activate()
			oHeader := oModel:GetModel("ZZ1_FIELDS")

			//Busca o próximo pedido de compra
			cProximo := NextNumero("ZZ1", 1, "ZZ1_CODE", .T.)

			lProcessed := lProcessed .And. oHeader:SetValue("ZZ1_FILIAL" , listItens[index]["ZZ1_FILIAL" ])
			lProcessed := lProcessed .And. oHeader:SetValue("ZZ1_CODE"   , cProximo)
			lProcessed := lProcessed .And. oHeader:SetValue("ZZ1_NAME" , listItens[index]["ZZ1_NAME" ])

			lProcessed := lProcessed .And. oModel:VldData() .And. oModel:CommitData()



			if lProcessed
				jOkPost := JsonObject():New()

				jOkPost["ZZ1_FILIAL"] := oHeader:GetValue("ZZ1_FILIAL")
				jOkPost["ZZ1_CODE"  ] := oHeader:GetValue("ZZ1_CODE"  )
				jOkPost["ZZ1_NAME"] := oHeader:GetValue("ZZ1_NAME")
				// jResponse["inserted_at"] := SB1->S_T_A_M_P_
				// jResponse["updated_at"] := SB1->I_N_S_D_T_


				aAdd(jResponse['jOkPost'], jOkPost)
			else
				lVldPost := .F.
				jErrorPost := JsonObject():New()

				jErrorPost["ZZ1_FILIAL"] := oHeader:GetValue("ZZ1_FILIAL")
				jErrorPost["ZZ1_CODE"  ] := oHeader:GetValue("ZZ1_CODE"  )
				jErrorPost["ZZ1_NAME"] := oHeader:GetValue("ZZ1_NAME")

				aAdd(jResponse['jErrorPost'], jErrorPost)

			endif

			oModel:DeActivate()

		next

		if lVldPost
			self:SetResponse(jResponse:ToJson())
		else
			aError := oModel:GetErrorMessage()
			jResponse["error"] := "creation_failed"
			jResponse["description"] := "aError[MODEL_MSGERR_MESSAGE]"
			self:setStatus(400)
			self:SetResponse(jResponse:ToJson())
			// SetRestFault(400, jResponse:ToJson(), , 400)
		endif

	endif

return lVldPost

//-------------------------------------------------------------------
/*/{Protheus.doc} PUT V2ID
    Faz a atualização de um perfil usando MVC
@type    method

@author  Alberto.goncalves
@since   04.12.2020
/*/
//-------------------------------------------------------------------
wsmethod PUT V2XID pathparam cCode wsservice Ffmpapi01
	local lProcessed as logical
	local jResponse  as object
	local oModel     as object
	local oHeader    as object
	local aError     as array

	local aHeader as String
	local aModel as string

	aHeader := "ZZ1_FIELDS"
	aModel := "MVCZZ1"

	lProcessed := .T.
	self:SetContentType("application/json")

	DbSelectArea("ZZ1")
	DbSetOrder(1) // SB1_FILIAL+SB1_COD

	jResponse := JsonObject():New()

	// Id não ser vazio e existir como item na tabela
	lProcessed := (!(Alltrim(self:cCode) == "") .And. ZZ1->(DbSeek(xFilial("ZZ1")+self:cCode)))

	if lProcessed

		jBody := JsonObject():New()
		jBody:FromJson(self:GetContent())

		if (jBody["ZZ1_CODE"] == Nil)
			jResponse["error"] := "body_invalido"
			jResponse["description"] := "Forneça a propriedade ZZ1_CODE no body"

			self:SetResponse(jResponse:ToJson())
			SetRestFault(400, jResponse:ToJson(), , 400)
			lProcessed := .F.
		else
			oModel := FwLoadModel(aModel)

			oModel:SetOperation(MODEL_OPERATION_UPDATE)

			lProcessed := oModel:Activate()
			oHeader := oModel:GetModel(aHeader)

				lProcessed := lProcessed .And. oHeader:SetValue("ZZ1_FILIAL" , jBody["ZZ1_FILIAL" ])
				lProcessed := lProcessed .And. oHeader:SetValue("ZZ1_CODE"   , jBody["ZZ1_CODE"   ])
				lProcessed := lProcessed .And. oHeader:SetValue("ZZ1_NAME"   , jBody["ZZ1_NAME"   ])
				

			lProcessed := lProcessed .And. oModel:VldData() .And. oModel:CommitData()
			if lProcessed

				jResponse["ZZ1_FILIAL"] := oHeader:GetValue("ZZ1_FILIAL")
				jResponse["ZZ1_CODE"  ] := oHeader:GetValue("ZZ1_CODE")
				jResponse["ZZ1_NAME"  ] := oHeader:GetValue("ZZ1_NAME")		
				// jResponse["inserted_at"] := SB1->S_T_A_M_P_
				// jResponse["updated_at"] := SB1->I_N_S_D_T_

				self:SetResponse(jResponse:ToJson())
			else
				aError := oModel:GetErrorMessage()
				jResponse["error"] := "creation_failed"
				jResponse["description"] := aError[MODEL_MSGERR_MESSAGE]
				self:SetResponse(jResponse:ToJson())
				SetRestFault(400, jResponse:ToJson(), , 400)
			endif

			oModel:DeActivate()
		endif
	else
		jResponse["error"] := "code_invalido"
		jResponse["description"] := i18n("Armazem não encontrado utilizando o #[code] informado", {self:cCode})

		self:SetResponse(jResponse:ToJson())
		SetRestFault(404, jResponse:ToJson(), , 404)
		lProcessed := .F.
	endif

	ZZ1->(Dbclosearea())

return lProcessed

//-------------------------------------------------------------------
/*/{Protheus.doc} DELETE V2
    Faz a exclusão de um perfil usando MVC
@type    method

@author  Alberto.goncalves
@since   04.12.2020
/*/
//-------------------------------------------------------------------
wsmethod DELETE V2X pathparam cCode wsservice Ffmpapi01
	local lProcessed as logical
	local lDelete    as logical
	local jResponse  as object
	local oModel     as object
	local aError     as array
	local aHeader as String
	local aModel as string
	aHeader := "ZZ1_FIELDS"
	aModel := "MVCZZ1"

	lProcessed := .T.
	self:SetContentType("application/json")

	DbSelectArea(aAalias)
	DbSetOrder(1) // SB1_FILIAL+SB1_USRID

	jResponse := JsonObject():New()

	// Id não ser vazio e existir como item na tabela
	lProcessed := !(Alltrim(self:cCode) == "")
	if lProcessed

		lDelete := SB1->(DbSeek(xFilial(aAalias)+self:cCode))
		if lDelete
			oModel := FwLoadModel(aModel)

			oModel:SetOperation(MODEL_OPERATION_DELETE)
			lProcessed := oModel:Activate()

			// Se não encontrar o registro, não faz nada e retorna verdadeiro
			lProcessed := lProcessed .And. oModel:VldData() .And. oModel:CommitData()

			oModel:DeActivate()
		endif

		if lProcessed
			self:SetResponse("{}")
		else
			aError := oModel:GetErrorMessage()
			jResponse["error"] := "deletion_failed"
			jResponse["description"] := aError[MODEL_MSGERR_MESSAGE]
			self:SetResponse(jResponse:ToJson())
			SetRestFault(400, jResponse:ToJson(), , 400)
		endif
	else
		jResponse["error"] := "id_invalido"
		jResponse["description"] := i18n("Perfil não encontrado utilizando o #[id] informado", {self:cCode})

		self:SetResponse(jResponse:ToJson())
		SetRestFault(404, jResponse:ToJson(), , 404)
		lProcessed := .F.
	endif

return lProcessed
