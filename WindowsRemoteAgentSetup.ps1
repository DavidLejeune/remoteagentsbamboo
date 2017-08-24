
#Write-Host "Path : $($PSScriptRoot)"



# ////////////////////////////////////////////////////////
# FUNCTIONS
# ////////////////////////////////////////////////////////
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}


function Show-Header()
{
  #making this script sexy
    Clear
    Write-Host '      ____              __        ' -ForegroundColor Yellow
    Write-Host '     / __ \   ____ _   / /      ___ ' -ForegroundColor Yellow
    Write-Host '    / / / /  / __ `/  / /      / _ \' -ForegroundColor Yellow
    Write-Host '   / /_/ /  / /_/ /  / /___   /  __/' -ForegroundColor Yellow
    Write-Host '  /_____/   \__,_/  /_____/   \___/ ' -ForegroundColor Yellow
    Write-Host ''
    Write-Host '    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+' -ForegroundColor Blue
    Write-Host '    |P|o|w|e|r|s|h|e|l|l| |C|L|I|' -ForegroundColor Blue
    Write-Host '    +-+-+-+-+-+-+-+-+-+-+ +-+-+-+' -ForegroundColor Blue
    Write-Host ''
    Write-Host '  >> Author : David Lejeune' -ForegroundColor Red
    Write-Host "  >> Created : 24/082017" -ForegroundColor Red
    Write-Host ''
    Write-Host ' #####################################'  -ForegroundColor DarkGreen
    Write-Host ' #     REMOTE AGENT SETUP WINDOWS    #' -ForegroundColor DarkGreen
    Write-Host ' #####################################' -ForegroundColor DarkGreen
    Write-Host ''
}


# /////////////////////////////////////////////////////////
# SETUP SCRIPT
# /////////////////////////////////////////////////////////

$Host.UI.RawUI.BackgroundColor = ($bckgrnd = 'black')
$Host.UI.RawUI.ForegroundColor = 'White'
$Host.PrivateData.ErrorForegroundColor = 'Red'
$Host.PrivateData.ErrorBackgroundColor = $bckgrnd
$Host.PrivateData.WarningForegroundColor = 'Magenta'
$Host.PrivateData.WarningBackgroundColor = $bckgrnd
$Host.PrivateData.DebugForegroundColor = 'Yellow'
$Host.PrivateData.DebugBackgroundColor = $bckgrnd
$Host.PrivateData.VerboseForegroundColor = 'Green'
$Host.PrivateData.VerboseBackgroundColor = $bckgrnd
$Host.PrivateData.ProgressForegroundColor = 'Cyan'
$Host.PrivateData.ProgressBackgroundColor = $bckgrnd



Show-Header
write-host "*******" -ForegroundColor Blue;
write-host "* ANT *" -ForegroundColor Blue;
write-host "*******" -ForegroundColor Blue;

$AntFolder = "$($env:USERPROFILE)\Ant"



$strEnvVariable="ANT_HOME"
write-host "Testing the following env variable : $($strEnvVariable) " -ForegroundColor DarkGreen;
If (Test-Path env:$strEnvVariable)
{
  write-host "Env Variable $($strEnvVariable) exists"
}
Else
{
  write-host "Env Variable $($strEnvVariable) does NOT exist" -ForegroundColor Red;

  $url = "http://apache.cu.be//ant/binaries/apache-ant-1.10.1-bin.zip"
  write-host "Downloading from url $($url)" -ForegroundColor Magenta;
  Start-Sleep -m 100
  $output = "$($env:USERPROFILE)\Ant.zip"
  $start_time = Get-Date
  Invoke-WebRequest -Uri $url -OutFile $output
  Write-host "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Magenta;

  Write-Host "Extracting the zip file" -ForegroundColor DarkGray;
  $start_time = Get-Date
  Remove-Item $AntFolder -Recurse -ErrorAction Ignore
  Unzip $output $AntFolder
  $ApacheFolder=(Get-ChildItem $AntFolder | Select-Object FullName)
  $ApacheFolder=($ApacheFolder -replace "@{FullName=", "")
  $ApacheFolder=($ApacheFolder -replace "}", "")
  Write-Host "Extracted to folder : $($ApacheFolder)" -ForegroundColor DarkGray;
  Write-host "Removing the zip file" -ForegroundColor DarkGray;
  Remove-Item $output -ErrorAction Ignore
  Write-host "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor DarkGray;

  write-host "Creating the Env Variable $($strEnvVariable) "
  cscript //nologo "$($PSScriptRoot)\CreateEnvVariable.vbs" $strEnvVariable $ApacheFolder
  #If (Test-Path env:$strEnvVariable)
  #{
  #  write-host "Env Variable $($strEnvVariable) exists"
  #}
  #Else
  #{
  #  write-host "Env Variable $($strEnvVariable) does NOT exist" -ForegroundColor Red;
  #}
}
Write-Host "-------------------------------------------------------------------------------------------"




















write-host "**********" -ForegroundColor Blue;
write-host "* PYTHON *" -ForegroundColor Blue;
write-host "**********" -ForegroundColor Blue;


$strEnvVariable="PYTHON_HOME"
write-host "Testing the following env variable : $($strEnvVariable) " -ForegroundColor DarkGreen;
If (Test-Path env:$strEnvVariable)
{
  write-host "Env Variable $($strEnvVariable) exists"
}
Else
{
  write-host "Env Variable $($strEnvVariable) does NOT exist" -ForegroundColor Red;

  $url = "https://www.python.org/ftp/python/2.7.13/python-2.7.13.amd64.msi"
  write-host "Downloading from url $($url)" -ForegroundColor Magenta;
  Start-Sleep -m 100
  $output = "$($env:USERPROFILE)\Python.msi"
  $start_time = Get-Date
  Invoke-WebRequest -Uri $url -OutFile $output
  Write-host "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Magenta;
  Start-Process $output
  $Result = Read-Host -Prompt 'Did you succesfully complete the Python Installation wizard?  (y/n) ';
  switch ($Result.ToUpper())
    {
        "Y"
          {
            Write-host "Removing the downloaded file" -ForegroundColor DarkGray;
            Remove-Item $output -ErrorAction Ignore

            write-host "Creating the Env Variable $($strEnvVariable) "
            $PythonPath = "C:\Python27"
            cscript //nologo "$($PSScriptRoot)\CreateEnvVariable.vbs" $strEnvVariable $PythonPath

            write-host "Adding Env Variable $($strEnvVariable) to PATH "
            $env:Path += ";%PYTHON_HOME%\;%PYTHON_HOME%\Scripts\ "
            Write-Host "Showing all Path variables : " -ForegroundColor Yellow;
            Write-Host $env:path.split(";") -ForegroundColor Yellow;
          }
        "N"
          {
              Write-Host "Aborting the Python part of this setup " -ForegroundColor Red;
              Write-Host "Note : not all build plans for bamboo may work correctly " -ForegroundColor Red;

              Write-host "Removing the downloaded file" -ForegroundColor DarkGray;
              Remove-Item $output -ErrorAction Ignore


          }
    }
}
Write-Host "-------------------------------------------------------------------------------------------"
