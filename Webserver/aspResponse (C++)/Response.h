// Response.h : Declaration of the CResponse

#ifndef __RESPONSE_H_
#define __RESPONSE_H_

#include "resource.h"       // main symbols

/////////////////////////////////////////////////////////////////////////////
// CResponse
class ATL_NO_VTABLE CResponse : 
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<CResponse, &CLSID_Response>,
	public IDispatchImpl<IResponse, &IID_IResponse, &LIBID_MYASPLib>
{
public:
	CResponse()
	{
		m_responseBuffer.Empty();
		m_bCanContinue = true;
	}

DECLARE_REGISTRY_RESOURCEID(IDR_RESPONSE)

DECLARE_PROTECT_FINAL_CONSTRUCT()

BEGIN_COM_MAP(CResponse)
	COM_INTERFACE_ENTRY(IResponse)
	COM_INTERFACE_ENTRY(IDispatch)
END_COM_MAP()

// IResponse
public:
	STDMETHOD(get_CanContinue)(/*[out, retval]*/ BOOL *pVal);
	STDMETHOD(End)();
	STDMETHOD(Clear)();
	STDMETHOD(get_ResponseBuffer)(/*[out, retval]*/ BSTR *pVal);
	STDMETHOD(Write)(/*[in]*/ BSTR bstrText);
private:
	CComBSTR m_responseBuffer;
	BOOL m_bCanContinue;
};

#endif //__RESPONSE_H_
