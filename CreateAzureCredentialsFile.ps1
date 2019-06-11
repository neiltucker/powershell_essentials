# Login to Azure and create Azure Credentials File
$Cred_File = 'azure_credentials.json'
az login
az ad sp create-for-rbac --sdk-auth > $Cred_File

# Set Authentication Variable
$Cred_File_Location = (Get-ChildItem $Cred_File).FullName
[Environment]::SetEnvironmentVariable('AZURE_AUTH_LOCATION', $Cred_File_Location, "Machine")

<#
### Azure Authentication using Authentication File in Python 
# These modules are used for authenticating to Azure, using resources and managing storage.  
# Install them if they are not already on the system: pip install --upgrade --user azure-common azure-mgmt azure-storage
import datetime, os, ftplib, xml.etree.ElementTree as ET
from azure.common.client_factory import get_client_from_cli_profile, get_client_from_auth_file
from azure.mgmt.resource import ResourceManagementClient
from azure.mgmt.storage import StorageManagementClient
from azure.storage.common import CloudStorageAccount
from azure.storage.file import FileService
from azure.storage.blob import PublicAccess
from azure.mgmt.web import WebSiteManagementClient
from azure.mgmt.web.models import AppServicePlan, SkuDescription, Site, SiteAuthSettings

# Configure Clients for Managing Resources (using Client Profile)
resource_client = get_client_from_cli_profile(ResourceManagementClient)
storage_client = get_client_from_cli_profile(StorageManagementClient)
web_client = get_client_from_cli_profile(WebSiteManagementClient)

# Configure Clients for Managing Resources (using Authentication File)
resource_client = get_client_from_auth_file(ResourceManagementClient)
storage_client = get_client_from_auth_file(StorageManagementClient)
web_client = get_client_from_auth_file(WebSiteManagementClient)

# Configure Variables
nameprefix = 'np' + (datetime.datetime.now()).strftime('%H%M%S')
resourcegroupname = nameprefix + 'rg'
storageaccountname = nameprefix + 'sa'
serverfarmname = nameprefix + 'sf'
websitename = nameprefix + 'web'
location = 'eastus'
sharename = '55264a'
profilefilename = websitename+'.xml'

# create a test file to be uploaded to your blob and file share
os.system('echo "<h1> This is my first Azure web-site. </h1>" > index.html')
filename = 'index.html'

# Create the Resource Group and Storage Account.  Use Azure Portal to examine their properties before deleting them.
resource_group_params = {'location':location}
resource_client.resource_groups.create_or_update(resourcegroupname, resource_group_params)
storageaccount = storage_client.storage_accounts.create(resourcegroupname, storageaccountname, {'location':location,'kind':'storage','sku':{'name':'standard_ragrs'}})
storageaccount.wait()

#>