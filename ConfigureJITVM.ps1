### Configure Just In Time access for class VM
### Configure Variables
Set-StrictMode -Version 2.0
$SubscriptionName = "Azure Subscription"                                               # Replace with the name of your Azure Subscription
$WorkFolder = "c:\labfiles.55264a\"
[Environment]::SetEnvironmentVariable("WORKFOLDER", $WorkFolder)
Set-Location $WorkFolder
$MaxTimeVM = 2                                          # Maximum time to allow access to VM (Default is 3 hours)
$ResourceGroupNameVM = ("azad55247rg").ToLower()        # Resource Group used by the VM

### Install Azure-Security-Center Module
If (Get-PackageProvider -Name NuGet) {Write-Output "NuGet PackageProvider already installed."} Else {Install-PackageProvider -Name NuGet -Force}
If (Get-Module -ListAvailable -Name PowerShellGet) {Write-Output "PowerShellGet module already installed"} Else {Find-Module PowerShellGet -IncludeDependencies | Install-Module -Force}
If (Get-Module -ListAvailable -Name Azure-Security-Center) {Write-Output "Azure-Security-Center module already installed"} Else {Find-Module Azure-Security-Center -IncludeDependencies | Install-Module -Force}

### Login to Azure
<#
# You may use the automated login credentials of AzureAdmin1@<domain> if they were configured at the beginning of the class
$Sub = Import-CliXML $WorkFolder"Subscription.xml"
$AzureAdminName = "AzureAdmin1"                         # Existing Global Administrator Account.  Its a goood idea to create at least one additional Administrator account.
$SecurePassword = Write-Output "Password:123" | ConvertTo-SecureString -AsPlainText -Force
$AzureAdminUPN = $AzureAdminName + "@" + $Sub.Tenant.Directory
$AzureAdminURL = "https://" + $Sub.Tenant.Directory + "/" + $AzureAdminName
$AZCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AzureAdminName, $SecurePassword
$ADCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AzureAdminUPN, $SecurePassword
Connect-AzureRMAccount -TenantID $Sub.Subscription.TenantID -ServicePrincipal -Credential $AZCredentials
$Subscription = Get-AzureRMSubscription -SubscriptionName $SubscriptionName | Set-AzureRMContext
$AzureAD = Connect-AzureAD -TenantID $Sub.Tenant.ID -Credential $ADCredentials
$Domain = (Get-AzureADDomain)[0]
#>
Connect-AzureRMAccount
$Subscription = Get-AzureRMSubscription -SubscriptionName $SubscriptionName | Set-AzureRMContext

### Specify Resource Group of VMs
$ResourceGroup = Get-AzureRMResourceGroup | Where-Object {$_.ResourceGroupName -match $ResourceGroupNameVM}
$ResourceGroupName = $ResourceGroup.ResourceGroupName
$Location = $ResourceGroup.Location

### Configure VMs to use a JIT Policy
$VMs = (Get-AzureRMVM -ResourceGroupName $ResourceGroupName).Name
ForEach ($VM in $VMs) {
Set-ASCJITAccessPolicy -ResourceGroupName $ResourceGroupName -MaxRequestHour 2 -Port 22,3389 -Protocol TCP -VM $VM
}
