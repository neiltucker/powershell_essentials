### Create Blob and copy files to it from file system
$SubscriptionName = "Azure Pass"                                         # This variable should be assigned your "Subscription Name"
$workFolder = "c:\labfiles.55264a\"                                           
$TempFolder = "c:\temp\"
$Location = "eastus"
$NamePrefix = ("aa" + (Get-Date -Format "HHmmss")).ToLower()             # Replace "aa" with your initials
$TimeZone = "Eastern Standard Time"
$ResourceGroupName = $NamePrefix + "rg"
$StorageAccountName = $NamePrefix.tolower() + "sa"                     # Must be lower case
$FileShareName = "labfiles"

### Login to Azure
Connect-AzureRmAccount
$Subscription = Get-AzureRMSubscription -SubscriptionName $SubscriptionName | Select-AzureRMSubscription

### Create Resource Group, Storage Account & Azure Share
New-AzureRmResourceGroup -Name $ResourceGroupName  -Location $Location
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $StorageAccountName -Location $location -Type Standard_RAGRS
$StorageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $StorageAccountName)[0].Value
$StorageAccountContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey 
 
### Copy local file to Azure Share and verify
$Share = New-AzureStorageShare $FileShareName -Context $StorageAccountContext
$Directory = New-AzureStorageDirectory -Share $Share -Path txtfiles
Get-ChildItem $WorkFolder"*.txt" -Recurse | Set-AzureStorageFileContent -Share $Share -Path /txtfiles -Force
Get-AzureStorageFile -Directory $Directory
 
### Copy Azure Share file to local directory and verify
Get-AzureStorageFileContent -Share $Share -Path password.txt -Destination $TempFolder -Force
Get-ChildItem $TempFolder 

### Remove Resource Group and all objects associated with it
# Remove-AzureRMResourceGroup -Name $resourceGroupName -Force
