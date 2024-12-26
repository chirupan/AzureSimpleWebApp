
$Location="Germany West Central"
$ResourceGroupName="my-webapp"
$AppServicePlan="my-webapp-service-plan"
$WebAppName="my-simple-webapp-3612"


# Create a Resource Group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

# Create an App Service Plan
New-AzAppServicePlan -Name $AppServicePlan -Location $Location -ResourceGroupName $ResourceGroupName `
-Tier Basic -Linux

# Create a Web App
New-AzWebApp -Location $Location -Name $WebAppName -ResourceGroupName $ResourceGroupName -AppServicePlan $AppServicePlan

# Create a Slot for Web App
New-AzWebAppSlot -Name my-webapp-slot -ResourceGroupName $ResourceGroupName -Slot "staging"

# Create a Web App not from a template but rather from a repository.
$GitHubRepo="https://github.com/chirupan/AzureSimpleWebApp.git"

# Create a Properties Object
$PropertiesObject = @{
    repoUrl =  "$GitHubRepo";
    branch = "master";
    isManualIntegration = "true";
}

Set-AzResource -PropertyObject $PropertiesObject -ResourceGroupName $ResourceGroupName `
-ResourceType Microsoft.Web/sites/sourcecontrols `
-ResourceName $WebAppName/web -ApiVersion 2015-08-01 -Force

# ResourceType changes to Microsoft.Web/sites/slots/sourcecontrols when deploying to a slot
# ResourceName also changes to $WebAppName/$NameOfSlot/web when deploying to a slot

# Main reason for deploying to a slot is that , later on you can switch slots i.e. from staging to prod and vice-versa
Switch-AzWebAppSlot -Name $WebAppName -ResourceGroupName $ResourceGroupName -SourceSlotName "staging" -DestinationSlotName "production"