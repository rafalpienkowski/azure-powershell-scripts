# This repository contains handy Azure PowerShell extensions.


I'm going to add new scripts which in my opinion would be useful for a .Net dev.

Available scripts:
- RemoveResources.ps1

This script removes all resources by given type in the given Resource Group in the selected Azure Subscription. This script require Azure Subscription and rights to remove resources from given Resource Group.

Parameters:
- resourceGroupName - Resource group name
- resourceTypes - List of resource group types. Default types: "Microsoft.Web/sites" and "Microsoft.Sql/servers"

Usage:
```
  RemoveResources.ps1 [Resource Group Name] [Optional: Resource type]
```

Example:

```
  RemoveResources.ps1 "my-resource-group"
```

or 

```
    RemoveResources.ps1 "my-resource-group" "Microsoft.Cache/Redis","Microsoft.Sql/servers/databases"
```

#

Feel free to copy, use and modify those scripts. I'm also open to all your suggestions.