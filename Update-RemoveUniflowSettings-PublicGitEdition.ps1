<#--SYNOPSIS
#Deployment script to cleanup previous Uniflow Smart Client Settings
###############
#----DESCRIPTION
#Delete Uniflow Smart Client files and associated settings
###############
#Filename: Update-UniflowSmartClient Settings
#Version: 5.0 #> 

#bypass execution policy for this process
Set-ExecutionPolicy Bypass -scope Process -Force

#Stop services and processes for Uniflow Smart Client that would otherwise prevent deleting the application
Stop-process -Name momsmartclnt -ErrorAction SilentlyContinue
Stop-Service -Name "MsclPrProxy" -ErrorAction SilentlyContinue

#Delete files associated with the Uniflow Smart Client
remove-item -path "C:\Program Files\uniFLOW SmartClient" -Force -Recurse -ErrorAction SilentlyContinue

#Create variable username to be used in path to delete user specific uniflow files
$CurrentUsername = Get-WMIObject -class Win32_ComputerSystem | Select username
$Username = $CurrentUsername.username
$Username = $Username.Split("\")
$Username = $Username[1]

remove-item -path "C:\Users\$Username\AppData\Roaming\Nt-ware" -Force -Recurse

#create drive that will later provide access to the HKCR registry hive
New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR -ErrorAction SilentlyContinue
New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCU -ErrorAction SilentlyContinue

#Add entry to registry that will configure Uniflow Smart Client to start with the computer
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "Uniflow Smart Client" -Value "C:\Program Files\uniFLOW SmartClient\momsmartclnt.exe"

#Delete registry entries associated with the Uniflow Smart Client
Remove-Item HKLM:\SOFTWARE\WOW6432Node\Nt-ware -Force -Recurse 
Remove-Item HKCU:\SOFTWARE\NT-ware -Force -Recurse 
Remove-Item HKCR:\Installer\Products\EC2D4627EF0E06849AC54EB9254B8177 -Force -Recurse
