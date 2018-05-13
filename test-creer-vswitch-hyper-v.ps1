# Résumé: on provisionne une configuration opérationnelle d'hyper-V, on supoose virutalbox déjà installé sur le poste windows, les VMs seront créé en utilisant l'interface de para-virutalisation Hyper-V

<#

 CreateHyperVSwitches.ps1

 ed wilson, msft

 hsg-10-9-13

#>

Import-Module Hyper-V

# $ethernet = Get-NetAdapter -Name ethernet
$ethernet = Get-NetAdapter -Name Ethernet

# $wifi = Get-NetAdapter -Name wi-fi

 

New-VMSwitch -Name JIblexternalSwitch -NetAdapterName $ethernet.Name -AllowManagementOS $true -Notes "Réseau de communication entre VMs, bridgé sur le réseau physique de l'hôte de virutalisation"
# New-VMSwitch -Name JiblWiFiExternalSwitch -NetAdapterName $wifi.Name -AllowManagementOS $true -Notes 'Parent OS, VMs, wifi'
# New-VMSwitch -Name JiblprivateSwitch -SwitchType Private -Notes 'Internal VMs only'
# New-VMSwitch -Name internalSwitch -SwitchType Internal -Notes 'Parent OS, and internal VMs'