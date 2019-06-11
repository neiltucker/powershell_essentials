### Create Blob and copy files to it from file system
### Configure Objects & Variables
Set-StrictMode -Version 2.0
$SubscriptionName = (Get-AzureRMSubscription)[0].Name                            # Replace with the name of your preferred subscription
$CloudDriveMP = (Get-CloudDrive).MountPoint
New-PSDrive -Name "F" -PSProvider "FileSystem" -Root $CloudDriveMP
$WorkFolder = "f:\labfiles.55264a\"                                           
$TempFolder = "f:\temp\"
New-Item -ItemType Directory -Path $WorkFolder, $TempFolder -Force -ErrorAction SilentlyContinue
[Environment]::SetEnvironmentVariable("WORKFOLDER", $WorkFolder)
Set-Location $WorkFolder
$Location = "EASTUS"
$NamePrefix = ("in" + (Get-Date -Format "HHmmss")).ToLower()                              # Replace "in" with your initials
$ResourceGroupName = $NamePrefix + "rg"
$StorageAccountName = $NamePrefix.ToLower() + "sa"                     # Must be lower case
$BlobContainerName = "labfiles"

### Login to Azure & Select Azure Subscription
# Connect-AzureRMAccount
$Subscription = Get-AzureRMSubscription -SubscriptionName $SubscriptionName | Select-AzureRMSubscription

### Create Resource Group, Storage Account & Azure Blob
New-AzureRmResourceGroup -Name $ResourceGroupName  -Location $Location
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $StorageAccountName -Location $location -Type Standard_RAGRS
$StorageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $StorageAccountName)[0].Value
$StorageAccountContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey 
New-AzureStorageContainer -Name $BlobContainerName -Context $StorageAccountContext 
 
### Copy local files to Azure Blob and verify
### The list of files can be filtered based on the last modified date   (Where-Object {$_.LastWriteTime -GT (Get-Date).AddDays(-1)})
Get-ChildItem $WorkFolder"*.txt" -Recurse | Set-AzureStorageBlobContent -Container $BlobContainerName -Context $StorageAccountContext -Force
Get-AzureStorageBlob -Container $BlobContainerName -Context $StorageAccountContext | Format-Table Name,Length
 
### Copy Azure Blob files to local directory and verify
Get-AzureStorageBlob -Container $BlobContainerName -Context $StorageAccountContext | Get-AzureStorageBlobContent -Destination $TempFolder -Force
Get-ChildItem $TempFolder"*.txt" 

### Mount Azure Blob Drive
# If (Get-Module -ListAvailable -Name AzureBlobStorageProvider) {Write-Host "AzureBlobStorageProvider module already installed" ; Import-Module AzureBlobStorageProvider} Else {Find-Module AzureBlobStorageProvider -IncludeDependencies | Install-Module -Force ; Import-Module -Name AzureBlobStorageProvider}
# $RootParameters = "DefaultEndpointsProtocol=https;AccountName=$StorageAccountName;AccountKey=$StorageAccountKey"
# New-PSDrive -Name P -PSProvider BLOB -Root $RootParameters

### Remove Resource Group and all objects associated with it
# Remove-AzureRMResourceGroup -Name $resourceGroupName -Force
