// Response.cpp : Implementation of CResponse
#include "stdafx.h"
#include "MyASP.h"
#include "Response.h"

/////////////////////////////////////////////////////////////////////////////
// CResponse

STDMETHODIMP CResponse::Write(BSTR bstrText)
{
	m_responseBuffer.AppendBSTR(bstrText);

//	Use this MessageBox to see what's going on step by step
//	MessageBoxW(0, bstrText, 0, 0);

	return S_OK;
}

STDMETHODIMP CResponse::get_ResponseBuffer(BSTR *pVal)
{
	// There's no equivalent method/property in the ASP object model.
	// In ASP you cannot access the buffer being sent to the browser

	m_responseBuffer.CopyTo(pVal);

	// Clear the buffer, like you're using Flush()
	m_responseBuffer.Detach(); 
	return S_OK;
}

STDMETHODIMP CResponse::Clear()
{
	// Re-enable processing
	m_bCanContinue = true;

	m_responseBuffer.Detach(); 
	m_responseBuffer.Empty(); 
	return S_OK;
}

STDMETHODIMP CResponse::End()
{
	m_bCanContinue = false;
	return S_OK;
}

STDMETHODIMP CResponse::get_CanContinue(BOOL *pVal)
{
	// Since the browser manages the Response.End we need a way
	// to make it know we've called it

	*pVal = m_bCanContinue;
	return S_OK;
}
