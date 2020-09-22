
MyASPps.dll: dlldata.obj MyASP_p.obj MyASP_i.obj
	link /dll /out:MyASPps.dll /def:MyASPps.def /entry:DllMain dlldata.obj MyASP_p.obj MyASP_i.obj \
		kernel32.lib rpcndr.lib rpcns4.lib rpcrt4.lib oleaut32.lib uuid.lib \

.c.obj:
	cl /c /Ox /DWIN32 /D_WIN32_WINNT=0x0400 /DREGISTER_PROXY_DLL \
		$<

clean:
	@del MyASPps.dll
	@del MyASPps.lib
	@del MyASPps.exp
	@del dlldata.obj
	@del MyASP_p.obj
	@del MyASP_i.obj
