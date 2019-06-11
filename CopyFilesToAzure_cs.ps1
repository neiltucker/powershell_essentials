### Create Blob and copy files to it from file system
$SubscriptionName = (Get-AzureRMSubscription)[0].Name                            # Replace with the name of your preferred subscription
$CloudDriveMP = (Get-CloudDrive).MountPoint
New-PSDrive -Name "F" -PSProvider "FileSystem" -Root $CloudDriveMP
$WorkFolder = "f:\labfiles.55264a\"  
$TempFolder = "f:\temp\"
Set-Location = $WorkFolder                                         
$Location = "eastus"
$NamePrefix = ("in" + (Get-Date -Format "HHmmss")).ToLower()                              # Replace "in" with your initials
$ResourceGroupName = $NamePrefix + "rg"
$StorageAccountName = $NamePrefix.tolower() + "sa"                     # Must be lower case
$FileShareName = "labfiles"

### Login to Azure
# Connect-AzureRMAccount
$Subscription = Get-AzureRMSubscription -SubscriptionName $SubscriptionName | Select-AzureRmSubscription

### Create Resource Group, Storage Account & Azure Share
$ResourceGroup = New-AzureRMResourceGroup -Name $ResourceGroupName  -Location $Location
$StorageAccount = New-AzureRMStorageAccount -ResourceGroupName $resourceGroupName -Name $StorageAccountName -Location $location -Type Standard_RAGRS
$StorageAccountKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -Name $StorageAccountName)[0].Value
$StorageAccountContext = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey 
$AS = New-AzureStorageShare $FileShareName -Context $StorageAccountContext
 
### Copy local file to Azure Share and verify
New-AzureStorageDirectory -Share $AS -Path txtfiles
Get-ChildItem $WorkFolder"*.txt" -Recurse | Set-AzureStorageFileContent -Share $AS -Path /txtfiles -Force
Get-AzureStorageFile -Sharename $FileShareName -Context $StorageAccountContext
 
### Copy Azure Share file to local directory and verify
Get-AzureStorageFileContent -Share $AS -Path password.txt -Destination $TempFolder -Force
Get-ChildItem $TempFolder 

### Copy to Azure using Mapped Network Drive
$AzureStorageAccountName = "Azure\" + $StorageAccountName
$SecureKey = $StorageAccountKey | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AzureStorageAccountName,$SecureKey
$RootURL = "\\" + $StorageAccountName + ".file.core.windows.net\" + $FileShareName
New-PSDrive -Name S -PSProvider FileSystem -Root $RootURL -Credential $Credential
Copy-Item $WorkFolder -Recurse -Destination S:\ -Verbose -Force

### Remove Resource Group and all objects associated with it
# Remove-AzureRMResourceGroup -Name $resourceGroupName -Force
