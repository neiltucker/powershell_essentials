### Create Blob and copy files to it from file system
### Configure Objects & Variables
Set-StrictMode -Version 2.0
$SubscriptionName = "Azure Pass"                                     # This variable should be assigned your "Subscription Name"
$WorkFolder = "c:\labfiles.55264a\"                                           
$TempFolder = "c:\temp\"
[Environment]::SetEnvironmentVariable("WORKFOLDER", $WorkFolder)
New-Item -ItemType Directory -Path $WorkFolder, $TempFolder -Force -ErrorAction SilentlyContinue
Set-Location $WorkFolder
$Location = "eastus"
$NamePrefix = "aa" + (Get-Date -Format "HHmmss")                         # Replace "aa" with your initials
$ResourceGroupName = $namePrefix + "rg"
$StorageAccountName = $NamePrefix.tolower() + "sa"                     # Must be lower case
$BlobContainerName = "labfiles"

### Login to Azure
Connect-AzureRmAccount
$Subscription = Get-AzureRMSubscription -SubscriptionName $SubscriptionName | Select-AzureRMSubscription

### Create Resource Group, Storage Account & Azure Blob
New-AzureRmResourceGroup -Name $ResourceGroupName  -Location $Location
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $StorageAccountName -Location $location -Type Standard_RAGRS
$StorageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $StorageAccountName)[0].Value
$StorageAccountContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey 
New-AzureStorageContainer -Name $BlobContainerName -Context $StorageAccountContext 
 
### Copy local files to Azure Blob and verify
### The list of files can be filtered based on the last modified date   (Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-1)})
Get-Childitem $WorkFolder"*.txt" -Recurse | Set-AzureStorageBlobContent -Container $BlobContainerName -Context $StorageAccountContext -Force
Get-AzureStorageBlob -Container $BlobContainerName -Context $StorageAccountContext | Format-Table Name,Length
 
### Copy Azure Blob files to local directory and verify
Get-AzureStorageBlob -Container $BlobContainerName -Context $StorageAccountContext | Get-AzureStorageBlobContent -Destination $TempFolder
Get-ChildItem $TempFolder"*.txt" 

### Remove Resource Group and all objects associated with it
# Remove-AzureRMResourceGroup -Name $resourceGroupName -Force
