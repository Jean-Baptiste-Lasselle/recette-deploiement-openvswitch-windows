# Résumé

Une première recette de provision OpenVswitch sur une machine windows (édition pro) de type desktop / laptop

Le but étant d'essayer d'inter-connecter des VMs dans un réseau isolé layer 2

# Testé sous 

* Windows 10 Desktop professional ed.

# Structure

* `./bin` :  les exécutables micorsoft à installer avant de pouvoir utiliser [la recette que je teste](https://github.com/cloudbase/ovs-windows-installer)
* `./recette-testee` :  le contenu complet du repo de [la recette que je teste](https://github.com/cloudbase/ovs-windows-installer)

# Utilisation

En exécutant le script `operations.bat`, en tant qu'administrateur. C'est une installation interactive, aucune option silencieuse pour l'instant.

# Liste des recettes testées

* https://github.com/cloudbase/ovs-windows-installer    :  version testée au commit initial, qui semble correspondre à cette [distribution cloudbase d'openvswitch pour windows](https://cloudbase.it/openvswitch/)
* http://docs.openvswitch.org/en/latest/intro/install/windows/  : prochaine recette à tester


# Recette testée: Dernières erreurs obtenues à la provision de commutateurs hyper-v/openvswitch

Donc en ayant:
* activé hyper-v avec power shell `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All`
* re-démarré la machine
* installé openvswitch avec [la distribution cloudbase pour windows](https://cloudbase.it/openvswitch/#download):
```
# en utilisant la version contenue dans le repo :[./bin/cloudbase.it/openvswitch-hyperv-2.7.0-certified.msi]
msiexec /i .\bin\cloudbase.it\openvswitch-hyperv-2.7.0-certified.msi /l*v log.txt
# msiexec /i C:\moi\IAAS\the-devops-program\recettes\provision-openvswitch\windows\bin\cloudbase.it\openvswitch-hyperv-2.7.0-certified.msi /l*v log.txt
```
* et là, j'ai appliqué :
```
#!Powershell@Microsoft
# - Pour retirer tous les switch virtuels dont le nom comme par "JiblVswitch"
Remove-VMSwitch -Name JiblVswitch*
# - Pour lister tous les Switch virtuels:
Get-VMSwitchExtension -VMSwitchName *
# (On notera la présence d'un switch par défaut, taggué cloudbase, qui corresppond à l'instance openvswitch installée par la distribution cloudbase.it)
# -  Pour créer de nouveaux switchs des 3 types principaux: Private, Internal, External :
Import-Module Hyper-V
$ethernet = Get-NetAdapter -Name ethernet
# $wifi = Get-NetAdapter -Name wi-fi
New-VMSwitch -Name JIblexternalSwitch -NetAdapterName $ethernet.Name -AllowManagementOS $true -Notes "Réseau de communication entre VMs, bridgé sur le réseau physique de l'hôte de virutalisation"

# New-VMSwitch -Name JiblWiFiExternalSwitch -NetAdapterName $wifi.Name -AllowManagementOS $true -Notes 'Parent OS, VMs, wifi'

# - Je pourrais essayer de connecter 2 VMs virtualBox avec un openVswitch de type Internal, sur chaque hôte Hyper-V? 
# New-VMSwitch -Name JiblInternalSwitch -SwitchType Internal -Notes 'Internal VMs only'
# 
# New-VMSwitch -Name JiblprivateSwitch -SwitchType Private -Notes 'Internal VMs only'

```

Observez: jk'ai comenté tous les autres types de création de switch openvswitch virutels
Car Celui qui m'intéresse est celui de type external, et je ne veux pas que mes VMs comuniquent par du WIFI, mais bien par Ethernet/FibreOptique.

Attention!!! il est très important de mettre `-AllowManagementOS $true`, et non  `-AllowManagementOS $false`:
* `$false`, l'Hôte de virutalisation Windows n'aura plus accès à internet
* `$true`, l'Hôte de virutalisation Windows aura accès à internet

Suite à cette création de switch openVswitch, j'ai un nouveau choix de reseau bridge proposé par VirtualBox, et mieux, le choix du type de carte 
physique installé dans ma machine hôte de virutalisation, n'est plus diponible.


Arrivé là, j'ai une problématique: je ne peux plus créer de VM virutalBox 64bits, unqiuement que 32 bits.
Pour rétablir la situation, j'ai du:
* vérifier l'activation de la virualisation Intel sur mon CPU
* désactiver hyper-v `# Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V`
* re-démarrer la machine
* re-vérifier l'activation Intel VT-x du CPU
* Aller au menu windows graphique "Activer ou Désactiver des fonctionnalités Windows", pour bien dé-cocher les cases "Hyper-V" (toutes), et de même pour le NET framework que j'avais installé pour le build cloudbase.it d'openvswitch pour windows. DAns ce menu, j'ai pu vérifer:
  * Que la commande `# Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V` a désactivé la partie  "Platefrome Hyper-V", mais pas la partie "Outils d'administration Hyper-V".
  * Je la désactive donc manuellement pour valider la solution, puis il faudra trouver la commande powershell correspondante
* re-démarrer la machine
* re-vérifier l'activation Intel VT-x du CPU
* désinstaller VirtualBox
* re-démarrer la machine
* re-vérifier l'activation Intel VT-x du CPU
* ré-installer VirtualBox
* Et ouf! ça y est, j'ai à nouveau accès normal à la virtualisation avec virutalbox

J'ai bien vérifié:

* dès que j'exécute `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All` (+ reboot windows), je n'ai plus que le choix 32bits pour les VMs virtual box
* dès que je désactive TOUTES les fonctionnalités Hyper-V avec le menu graphique "Activer ou Désactiver des fonctionnalités Windows" (+ reboot windows), j'ai à nouvau le choix 64bits pour les VMs virtual box
* et je n'ai pas eu à ré-installer VirtualBox
* et à chaque reboot, j'ai pu vérifier que l'option de virtualisation Intel VT-x était toujours activée ("Enabled") dans le BIOS / UEFI 
* Ce ne peut donc être qu'une limite imposée de Hyper-V, 32 bits VM uniuqment sur Virual box 

Pour terminer, si je n'exécute pas la commande ccc d'activation d'Hyper-V, alors pour totues les autres commandes 
de création du switch openvswitch, on obtient une erreur, et les erreurs sont les suivantes:

![erreurs hyper-v non-activé ](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-openvswitch-windows/raw/master/doc/screenshots/powershell-enable-hyper-v.17.erreurs-si-je-n-active-pas-hyper-v.png)


## Remarques kytes




# pour les bonnes pratiques de configuration réseau Hyper-V: https://www.altaro.com/hyper-v/virtual-networking-configuration-best-practices/

![erreur partie1](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-openvswitch-windows/raw/master/doc/screenshots/derniere-erreur/last-error-hero-1.png)


# Recette testée: Dernières erreurs obtenues au build cloudbase

![erreur partie1](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-openvswitch-windows/raw/master/doc/screenshots/derniere-erreur/last-error-hero-1.png)

![erreur partie2](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-openvswitch-windows/raw/master/doc/screenshots/derniere-erreur/last-error-hero-2.png)

![erreur partie3](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-openvswitch-windows/raw/master/doc/screenshots/derniere-erreur/last-error-hero-3.png)

![erreur partie4](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-openvswitch-windows/raw/master/doc/screenshots/derniere-erreur/last-error-hero-4.png)





# méthode alternatve rapide à tester

##  Résumé

* on provisionne une configuration opérationnelle d'hyper-V, en exécutant le script powershell `provision-hyper-v.ps1`
* on supoose virutalbox déjà installé sur le poste windows, (ou on le provisionne avec PowerShell, puis [ansible](https://docs.ansible.com/ansible/2.5/dev_guide/developing_modules_general_windows.html) si nécessaire)
* les VMs seront créé en utilisant l'interface de para-virutalisation Hyper-V, et un nouveau type de réseau "Bridge Network" doit être proposé, non plus uniquement "VirutalBox Host-only Ethernet adapter" et le modèle de carte Ethernet de l'hôte de virutalisation
* Le nouveau type de "Bridge network" ("Accès par pont"), proposé pour la configuration d'une carte réseau d'une VM virtualbox, doit correspondre au nom du switch virtuel créé avec OpenVSwitch


## Coderie

```
#!Powershell@Microsoft

# pré-requis: il faut avoir activé la virtualisation via le boot manager BIOS / UEFI
# Il faut activer Hyper-V sur la machine Windows (8/10 pro), avec la commande: 
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
# puis re-démarrerla machine, de manière forcée si nécessaire (le poste est unposte personnel, et n'a pas vocation à être utilsié pendant les opérations)
Restart-Computer -Force

# Après avoir re-démarré, il faudra installer openvswitch for Windows, la version distribuée par Cloudbase:
# https://cloudbase.it/openvswitch/#download
# en utilisant la version contenue dans le repo :[./bin/cloudbase.it/openvswitch-hyperv-2.7.0-certified.msi]

msiexec /i .\bin\cloudbase.it\openvswitch-hyperv-2.7.0-certified.msi /l*v log.txt


```


# Nouvelle Piste

Il s'agit d'un article qui montre comment configurer l'hôte VirutalBox pour qu'il fonctionne avec OpenVSwitch, et que les réseaux des VMs virtualbox puissent être connectés aux switchs ovs :
https://sites.google.com/site/nandydandyoracle/openvswitch-ovs/configuring-virtualbox-vms-for-openvswitch-networking

Cet artricle fait référence à d'autres:

* pour faire le build from source d'openvswitch: https://sites.google.com/site/nandydandyoracle/openvswitch-ovs/openvswitch-source-build-oracle-linux-7-uek4
* Cet article traite un sujet différent (cluster de ....), mais le Système DNS / DHCP décrit est le même que celui utilisé dans l'article pour gérer les réseaux openvswitch : https://sites.google.com/site/nandydandyoracle/oracle-rac-in-lxc-linux-containers/oracle-12c-rac-asm-flex-cluster-on-lxc-linux-containers-ubuntu-14-10

Tous ces articles sont sous format PDF dans ce repo dans le répertoire `./doc/nouvelle-piste/`
