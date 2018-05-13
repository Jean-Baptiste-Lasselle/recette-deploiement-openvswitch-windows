

# Liste des sources de téléchargement des binaires

* [dotnet-sdk-2.1.200-win-x64.exe]  :   la dernière mise à jour SDK .NET framework, pour préparer le terrain pour les commandes `msbuild` => trop gros fichier pour être inclut dans le repo, vous devrez le télécharger vous-même, pour l'installer manuellement.
Comme en atteste mon commit incluant le fichier `dotnet-sdk-2.1.200-win-x64.exe` de plus de 100 Mo, Github fixe une limite de 100 Mo pour les fichiers inclut dans les repos gratuits:
![Github fixe une limite de 100 Mo ](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-openvswitch-windows/raw/master/doc/screenshots/limite-100Mo-GITHUB.png)

* [vs_buildtools__1840196686.1526156758.exe]  :   pour pouvoir faire des commandes `msbuild` sans installer visualstudio en entier (le sdk l'inclut peut-être déjà....)
* [dotNetFx35setup.exe]  :   .NET Framework 3.5, dépendance à l'exécution de "Wix Tools"
* [wix311.exe]  :   "Wix Tools", un outil qui était manifestement nécessaire au build chez cloudbase


page où on été trouvés les liens de téléchargement:

https://www.visualstudio.com/downloads/


![les 2 downloads ](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-openvswitch-windows/raw/master/bin/screenshots/telechargment-net-framework-update.png)




page où a été trouvé le lien de téléchargement de la mise à jour .NET framework:

https://www.microsoft.com/net/download/windows

![impression écran](ccc)



# Dépendances d'ordre supérieur à 1

Donc non résolues automatiquement... (peut-être y-a-t-il du package manager microsoft en la matière pour les ops)

* Dépendance "Wix tools" <=> .NET Framework 3.5 :

![Dépendance "Wix tools" <=> .NET Framework 3.5](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-openvswitch-windows/raw/master/doc/screenshots/derniere-erreur/dependance-wix-tools-net-framework-3.5.png)


