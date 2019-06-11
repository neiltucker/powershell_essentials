#  These are the commands for Exercise 1 in Appendix B

Get-Command
Get-Help | More
Get-Help Get-WmiObject -Detail | More
Get-Help *about*
Get-Help About_Scripts | More
CD ~; Cls; Dir
Get-Alias CD; Get-Alias Cls; Get-Alias Dir
Get-WmiObject Win32_NetworkAdapterConfiguration
Get-WmiObject -Query "Select * From Win32_NetworkAdapterConfiguration"
Get-WmiObject -Query "Select * From Win32_NetworkAdapterConfiguration Where DNSDomain='Contoso.com'"
Get-WmiObject -Query "Select * From Win32_NetworkAdapterConfiguration" | Format-Table IPAddress,MacAddress 
Get-WmiObject Win32_ComputerSystem | Format-Table Name,Domain,TotalPhysicalMemory
Get-WmiObject Win32_ComputerSystem | Format-Table Name,Domain,TotalPhysicalMemory
Set-Location HKLM:\Software; Dir; Set-Location C:
New-Item –Path c:\temp\tmp –type directory
New-Item –Path c:\temp\tmp\test.txt –type file
Set-Alias Copy-Con Set-Content
Copy-Con test.txt “This is a test”
Type test.txt
