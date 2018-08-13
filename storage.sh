#!/bin/bash

StorageAccountName="robsampledata"
ResourceGroupName="RobSampleDataRG"
Location="eastus"
ContainerName="files"
TableName="data"

### Create Storage Account ###
az group create -n $ResourceGroupName -l $Location
az storage account create -n $StorageAccountName -g $ResourceGroupName -l $Location --sku "Standard_LRS" --tags "Cost Center"="Marketing"

### Get Storage Account Key ###
az storage account keys list -g $ResourceGroupName -n $StorageAccountName

# Set these environment variables so we don't need to specify them in each command
export AZURE_STORAGE_ACCOUNT=$StorageAccountName
#TODO: pull in json library to parse storage account key so it doesn't need to be manually set
export AZURE_STORAGE_ACCESS_KEY="{StorageAccountKey}"


### Blob Example ###
az storage container create -n $ContainerName
az storage blob upload -f ./azure.png -n azure.png -c $ContainerName

mkdir download
az storage blob download -f ./download/azure.png -n azure.png -c $ContainerName

### Table Example ###

az storage table create -n $TableName

az storage entity insert -t $TableName -e PartitionKey="Cloud Providers" RowKey="Azure" ServiceOfferingQuality="Best"
az storage entity insert -t $TableName -e PartitionKey="Cloud Providers" RowKey="AWS" ServiceOfferingQuality="Better"
az storage entity insert -t $TableName -e PartitionKey="Cloud Providers" RowKey="Google" ServiceOfferingQuality="Good"

az storage entity query -t $TableName
