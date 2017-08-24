
strVarName = WScript.Arguments(0)
strVarValue = Wscript.Arguments(1)

Set objVarClass = GetObject( "winmgmts://./root/cimv2:Win32_Environment" )
Set objVar      = objVarClass.SpawnInstance_
objVar.Name          = strVarName
objVar.VariableValue = strVarValue
objVar.UserName      = "<SYSTEM>"
objVar.Put_
WScript.Echo "Created environment variable " & strVarName
Set objVar      = Nothing
Set objVarClass = Nothing
