#  PowerShell Essentials: Exercise 1

Get-Command
gcm
Get-Help | More
Get-Help Get-CimInstance -Detail | More
Get-Help *about*
Get-Help About_Scripts | More
New-Item –Path c:\labfiles –type directory -erroraction SilentlyContinue
Get-Alias CD; Get-Alias Cls; Get-Alias Dir
cd C:\Labfiles
Set-Location C:\Labfiles
cls
Clear-Host
dir
Get-ChildItem
Set-Location C:\Labfiles; Clear-Host; Get-ChildItem
Get-CimInstance Win32_NetworkAdapterConfiguration
Get-CimInstance -Query "Select * From Win32_NetworkAdapterConfiguration"
Get-CimInstance -Query "Select * From Win32_NetworkAdapterConfiguration Where DNSDomain='Contoso.com'"
Get-CimInstance -Query "Select * From Win32_NetworkAdapterConfiguration" | Format-Table IPAddress,MacAddress 
Get-CimInstance Win32_ComputerSystem | Format-Table Name,Domain,TotalPhysicalMemory
Set-Location HKLM:\Software; Get-ChildItem; 
Set-Location C:
New-Item –Path c:\temp\tmp –type directory
New-Item –Path c:\temp\tmp\test1.txt –type file
Set-Content tes1t.txt “This is a test.”
Add-Content test1.txt "This is another test."
Get-Content test1.txt
Set-Alias Add-Content Copy-Con
Copy-Con test2.txt "This is a test."
Copy-Con test2.txt "This is another test."
Get-Content test2.txt
