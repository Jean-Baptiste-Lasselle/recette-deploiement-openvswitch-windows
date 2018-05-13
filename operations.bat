REM -------------------------------  ENVIRONNEMENT --------------------------------------
REM -------------------------------  ENVIRONNEMENT --------------------------------------
REM -------------------------------  ENVIRONNEMENT --------------------------------------
set GIT_PATH=C:\moi\mes.logiciels\git\installation\cmd\

REM set PATH="%PATH%;%GIT_PATH%"
set URL_REPO_GIT_RECETTE_TESTEE=https://github.com/cloudbase/ovs-windows-installer
set MSBUILD_HOME=C:\Windows\Microsoft.NET\Framework\v4.0.30319\
set MSI_EXEC_HOME=C:\Windows\System32
REM set MAISON_OPS=%cd%
set MAISON_OPS=C:\moi\IAAS\the-devops-program\recettes\provision-openvswitch\windows

set PATH=%PATH%;%GIT_PATH%;%MAISON_OPS%;%MSBUILD_HOME%
REM -- On installe l'outillage qui permet de faire le build de la solution .NET framework de la recette testée: 
REM call .\bin\dotnet-sdk-2.1.200-win-x64.exe
REM call .\bin\vs_buildtools__1840196686.1526156758.exe
REM -- Tiens apparrement, il faudrait installer cet outil suipplémentaire pour le build:
REM https://github.com/wixtoolset/wix3/releases/download/wix3111rtm/wix311.exe
REM http://wixtoolset.org/
REM -- mais "Wix toolset"  a pour dépendance obligatoire le .NET FRamework 3.5 (nota bene: moi j'étais en .NET FRamework 4, et apprarement, il y a eut une dépraciation système... Donc ce build pourrait ne pas être maintenu)
REM - Installation du .NET Framework 3.5
REM call .\bin\dotNetFx35setup.exe
REM - Installation de "Wix toolset"
REM call .\bin\wix311.exe

REM -------------------------------    OPERATIONS  --------------------------------------
REM -------------------------------    OPERATIONS  --------------------------------------
REM -------------------------------    OPERATIONS  --------------------------------------
cd %MAISON_OPS%
REM On fait le git clone de la recette testée:
rmdir /S /Q %MAISON_OPS%\provision-openvswitch-kytes
mkdir %MAISON_OPS%\provision-openvswitch-kytes
cd %MAISON_OPS%\provision-openvswitch-kytes
git clone "%URL_REPO_GIT_RECETTE_TESTEE%" .

REM on commence par faire le build qui produit un MSI, installateur d'OpenVswitch
REM rmdir /S /Q %MAISON_OPS%\build-openvswitch
REM mkdir %MAISON_OPS%\build-openvswitch
REM PATH="%PATH%;%MAISON_OPS%" && call "%MSBUILD_HOME%MSBuild.exe" %MAISON_OPS%\provision-openvswitch-kytes\ovs-windows-installer.sln /p:Platform=x86 /p:Configuration=Release;OutputPath=%MAISON_OPS%\build-openvswitch

call "%MSBUILD_HOME%\MSBuild.exe" %MAISON_OPS%\provision-openvswitch-kytes\ovs-windows-installer.sln /p:Platform=x86 /p:Configuration=Release


REM puis on lance l'installation silencieuse du MSI produit:

call msiexec /i %MAISON_OPS%\build-openvswitch\OpenvSwitch.msi ADDLOCAL=OpenvSwitchCLI,OpenvSwitchDriver /l*v log.txt