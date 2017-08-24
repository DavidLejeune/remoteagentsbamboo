


clear






write-host "*******"
write-host "* ANT *"
write-host "*******"
$strEnvVariable="ANT_HOME"
echo "Testing the following env variable : $($strEnvVariable) "
If (Test-Path env:$strEnvVariable)
{
  write-host "Env Variable $($strEnvVariable) exists"
}
Else
{
  write-host "Env Variable $($strEnvVariable) does NOT exist"
}
Write-Host "-------------------------------------------------------------------------------------------"
