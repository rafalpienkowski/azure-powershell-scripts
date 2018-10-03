 <#
  .SYNOPSIS
   The Script removes all resources from given resource group with given resource types 
  .EXAMPLE
  .\RemoveResources.ps1 "my-resource-group"
  .PARAMETER resourceGroupName
  Resource group name
  .PARAMETER resourceTypes
  List of resource group types. Default types: "Microsoft.Web/sites" and "Microsoft.Sql/servers"
  #>
param(
  [Parameter(Position = 0, Mandatory = $true)]
  [string]
  $resourceGroupName,
  [Parameter(Position = 1, Mandatory = $false)]
  [string[]]
  $resourceTypes = @( "Microsoft.Web/sites" , "Microsoft.Sql/servers" )
)

function Remove-Resource {
    param (
        [string] $resourceType
    )

    $resources = Get-AzureRmResource -ResourceGroupName $resourceGroup.ResourceGroupName -ResourceType $resourceType

    if(!$resources)
    {
        Write-Host $resourceType "No resource with given type." -ForegroundColor Yellow
    }
    else{
        $resources | ForEach-Object { 
            Write-Host ('Processing {0}/{1}' -f $_.resourceType, $_.ResourceName) -ForegroundColor Blue
            $_ | Remove-AzureRmResource -Force
        }
    }
}

# Login
Login-AzureRmAccount

# Get a list of all Azure subscription that the user can access
$allSubs = Get-AzureRmSubscription 

# In case if user belongs to more than one subscription 
if ($allSubs.Count -gt 1)
{
    Write-Host "Avaliable subscriptions" -ForegroundColor Cyan

    $allSubs | Sort-Object SubscriptionName | Format-Table -Property Name, SubscriptionId
    $theSub = Read-Host "Enter the subscriptionId you want to clean"

    Write-Host "You select the following subscription:" $theSub -ForegroundColor Cyan     
}
else {
    $theSub = $allSubs[0].Id
}

# Selecting Subscription
Get-AzureRmSubscription -SubscriptionId $theSub | Select-AzureRmSubscription

# Selecting Resource Group by given name
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourcegroup)
{
    Write-Host "There is no Resource Group called " $resourceGroupName "unser the Subscription " $theSub -ForegroundColor Red
    Exit
}

# Removing resources from subscription
$resourceTypes | ForEach-Object {
    Remove-Resource $_
}

Write-Host "Done" -ForegroundColor Green