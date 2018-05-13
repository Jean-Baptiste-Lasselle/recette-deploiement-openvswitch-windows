# Résumé: on provisionne une configuration opérationnelle d'hyper-V, on supoose virutalbox déjà installé sur le poste windows, les VMs seront créé en utilisant l'interface de para-virutalisation Hyper-V

# pré-requis: il faut avoir activé la virtualisation via le boot manager BIOS / UEFI
# Il faut activer Hyper-V sur la machine Windows (8/10 pro), avec la commande: 
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
# La commande inverse:
# Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
# puis re-démarrerla machine, de manière forcée si nécessaire (le poste est unposte personnel, et n'a pas vocation à être utilsié pendant les opérations)
Restart-Computer -Force

# Après avoir re-démarré, il faudra installer openvswitch for Windows, la version distribuée par Cloudbase:
# https://cloudbase.it/openvswitch/#download
cd C:\moi\IAAS\the-devops-program\recettes\provision-openvswitch\windows\
msiexec /i .\bin\cloudbase.it\openvswitch-hyperv-2.5.0.msi /l*v log.txt
# très amusant: après avoir activé hyper-V, la virutalisation système est remise aux paramètres par défaut, je
# dois retourner dans la séquence de boot pour ré-activer les options de virtualisation




# Petites commandes de tests syntaxe Powershell

# $machin = Read-Host -Prompt "Saisissez une valeur :"
# echo "Vous avez saisit exactement la chaîne de caractères située entre crochets: [$machin]"


# echo "Voici le contenu du répertoire: [$(pwd)\bin]"
# ls "$(pwd)\bin"

# $cestfini = Read-Host -Prompt "Pressez entrée pour terminer ce script"

