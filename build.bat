@echo off
pushd "%~dp0"

SET "Build=%~dp0build"
SET "Dism=%~dp0bin\bin\Dism\dism.exe"
SET "Dism-Extra=/English /LogLevel:3 /NoRestart /ScratchDir:%~dp0tmp /Quiet"
SET "Image=%~dp0image"
SET "ImageLanguage=zh-CN"
SET "Lists=%~dp0bin\lists"
SET "MT=%~dp0mount"
SET "MT-Users=%MT%\Users"
SET "MT-Windows=%MT%\Windows"
SET "MT-Windows-INF=%MT-Windows%\INF"
SET "MT-Windows-System32=%MT-Windows%\System32"
SET "MT-Windows-System32-DriverStore=%MT-Windows-System32%\DriverStore"
SET "MT-Windows-System32-DriverStore-FileRepository=%MT-Windows-System32-DriverStore%\FileRepository"
SET "MT-Windows-SysWOW64=%MT-Windows%\SysWOW64"
SET "MT-Windows-WinSxS=%MT-Windows%\WinSxS"
SET "Packs=%~dp0packages\P"
SET "PSFExtractor=%~dp0bin\bin\PSF\PSFExtractor.exe"
SET "Update=%~dp0packages\U"
SET "wimlib-imagex=%~dp0bin\bin\wimlib-imagex\wimlib-imagex.exe"
SET "Unpack=%~dp0bin\bin\7z\7z.exe"

if exist %~dp0mount\windows (
    echo Unmounting mounted Image
    Dism /Unmount-Wim /MountDir:%~dp0mount /Discard /Quiet
)
call :Prepare
call :Prepare-Update

echo Processing WinRE.wim
call :Mount-Image %Image%\winre.wim 1
call :Update-ServicingStackDynamicUpdate
call :Update-CumulativeUpdate
call :ResetBase
call :Capture-Image %Build%\winre.wim "Microsoft Windows Recovery Environment (x64)" %Lists%\ExclusionList.ini /Bootable
call :UnMount
call :Wimlib-Imagex-Optimize %Build%\winre.wim lzx

echo Processing Install.wim
call :Mount-Image %Image%\install.wim 1
call :Update-ServicingStackDynamicUpdate
call :Update-CumulativeUpdate
call :ResetBase

echo Processing Install.wim
xcopy "%~dp0bin\Restart.bat" "%MT-Users%\Default\Desktop\" /Y >NUL
xcopy "%~dp0bin\Unattend.xml" "%MT-Windows%\Panther\" /Y >NUL
for /f "delims=" %%i in (' findstr /i . %Lists%\RemoveCapability.txt 2^>NUL ') do ( call :Remove-Capability "%%i" )
call :Apply-Unattend %~dp0bin\Unattend.xml
call :Copy-Addition
call :Import-Reg "%Registry%"
call :Remove-Feature
call :ResetBase
call :Capture-Image %Build%\install.wim "Windows 11 Pro" %~dp0bin\lists\ExclusionList.ini
call :UnMount

echo Final Processing
call :Cleanup-UpdateFile
call :Wimlib-Imagex-Command %Build%\install.wim "add '%Build%\winre.wim' '\windows\system32\recovery\winre.wim'"
call :Wimlib-Imagex-Command %Build%\install.wim "add '%Packs%\NetFX35' '\windows\Addition\NetFX35'"
call :Wimlib-Imagex-Info "%Build%\install.wim" "1" "Windows 11 Pro" "Windows 11 Pro" "Professional" "Windows 11 Professional"
call :Export-ESD %Build%\install.wim %Build%\install.esd
for /f "delims=" %%i in (' findstr /i . %Lists%\RemoveJunkWim.txt 2^>NUL ') do ( call :Remove-File "%Build%\%%i" )
for /f "delims=" %%i in (' dir /aa /b %~dp0bin\Addition\Registry 2^>NUL ') do ( call :Remove-File "%~dp0bin\Addition\Registry\%%i" )
call :Remove-Folder "%MT%"
call :Remove-Folder "%~dp0tmp"

pause
exit

:Add-NetFX35
echo Add NetFX35
%Dism% /Image:%MT% /Add-Package /PackagePath:%Packs%\NetFX35 %Dism-Extra%
goto :eof

:Apply-Unattend
echo Apply-Unattend
%Dism% /Image:%MT% /Apply-Unattend:%~1 %Dism-Extra%
goto :eof

:Capture-Image
echo Capture-Image [%~2]
%Dism% /Capture-Image /ImageFile:%~1 /CaptureDir:%MT% /Name:"%~2" /Description="%~2" /ConfigFile:%~3 %~4 %Dism-Extra%
goto :eof

:Cleanup-UpdateFile
echo Cleanup UpdateFile
for /f "delims=" %%i in (' dir /ad /b %Update%\CU ') do ( call :Remove-Folder "%Update%\CU\%%i\" )
goto :eof

:Copy-Addition
xcopy /e /s "%~dp0bin\Addition" "%MT-Windows%\Addition\" /Y >NUL
%Unpack% x "%MT-Windows%\Addition\Runtime\DirectX\DirectX.exe" -o "%MT-Windows%\Addition\Runtime\DirectX" -aoa >NUL 2>&1
del /q /s "%~dp0bin\Addition\Registry" >NUL 2>&1
del /q /s "%MT-Windows%\Addition\Runtime\DirectX\DirectX.exe" >NUL 2>&1
goto :eof

:Export-ESD
echo export [%~2]
%wimlib-imagex% export %~1 all %~2 --solid --solid-compress=lzms:100 >NUL 2>&1
goto :eof

:Export-WIM
echo export [%~1] to [%~3]
%Dism% /export-image /sourceimagefile:%~1 /sourceindex:%~2 /destinationimagefile:%~3 %Dism-Extra%
goto :eof

:Import-Reg
call :Mount-ImageRegistry
for /f "delims=" %%i in (' dir /aa /b "%~1" ^| findstr .reg ') do ( 
    echo Import Reg [%%i]
    reg import "%~1\%%i"
)
call :UnMount-ImageRegistry
goto :eof

:Mount-Image
echo Mounting Image
%Dism% /Mount-Wim /WimFile:%~1 /Index:%~2 /MountDir:%MT% %Dism-Extra%
goto :eof

:Mount-ImageRegistry
reg load HKLM\MT_DEFAULT "%MT-Windows-System32%\config\DEFAULT" >NUL
reg load HKLM\MT_DRIVERS "%MT-Windows-System32%\config\DRIVERS" >NUL
reg load HKLM\MT_NTUSER "%MT%\Users\Default\ntuser.dat" >NUL
reg load HKLM\MT_SOFTWARE "%MT-Windows-System32%\config\SOFTWARE" >NUL
reg load HKLM\MT_SYSTEM "%MT-Windows-System32%\config\SYSTEM" >NUL
goto :eof

:Prepare
rmdir /q /s %~dp0build 2>NUL
rmdir /q /s %~dp0mount 2>NUL
mkdir %~dp0build 2>NUL
mkdir %~dp0mount 2>NUL
mkdir %~dp0tmp 2>NUL
goto :eof

:Prepare-Update
for /f "delims=" %%i in (' dir /aa /b %Update%\CU ^| findstr .cab ') do (
    echo Transform CumulativeUpdate
    %PSFExtractor% %Update%\CU\%%i >NUL 2>&1
)
goto :eof

:Remove-Appx
for /f "tokens=3" %%i in (' %Dism% /Image:%MT% /Get-ProvisionedAppxPackages ^| findstr PackageName ^| findstr /i "%~1" ') do (
    echo Remove [%~1]
    %Dism% /Image:%MT% /Remove-ProvisionedAppxPackage /PackageName:"%%i" %Dism-Extra%
)
goto :eof

:Remove-Capability
for /f "tokens=4" %%i in (' %Dism% /Image:%MT% /Get-Capabilities ^| findstr Capability ^| findstr /i "%~1" ') do (
    echo Remove Capability [%%i]
    %Dism% /Image:%MT% /Remove-Capability /CapabilityName:"%%i" %Dism-Extra%
)
goto :eof

:Remove-Component
call :Mount-ImageRegistry
for /f "tokens=* delims=" %%i in (' reg query "HKLM\MT_SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Packages" /f "%~1" ^| findstr /i "%~1" ') do (
    reg add "%%i" /v Visibility /t REG_DWORD /d 1 /f >NUL
    reg add "%%i" /v DefVis /t REG_DWORD /d 2 /f >NUL
    reg delete "%%i\Owners" /f >NUL
)
call :UnMount-ImageRegistry
for /f "tokens=3 delims= " %%i in (' %Dism% /Image:%MT% /Get-Packages ^| findstr /i "%~1" ^| findstr /v %ImageLanguage% ') do (
    echo Remove Component [%~1]
    %Dism% /Image:%MT% /Remove-Package /PackageName:"%%i" %Dism-Extra%
)
goto :eof

:Remove-File
del /q /s "%~1" >NUL 2>&1
goto :eof

:Remove-Folder
rmdir /q /s "%~1" >NUL 2>&1
goto :eof

:Remove-Feature
for /f "delims=" %%i in (' findstr /i . %~dp0bin\lists\RemoveFeature.txt 2^>NUL ') do (
    echo Remove Feature [%%i]
    %Dism% /Image:%MT% /Disable-Feature /FeatureName:"%%i" /Remove %Dism-Extra%
)
goto :eof

:Remove-JunkDriver-File
echo Remove Driver [%~1]
for /f "delims=" %%i in (' dir /ad /b %MT-Windows-System32-DriverStore-FileRepository% ^| findstr /i /r "%~1" ') do ( call :Remove-Folder "%MT-Windows-System32-DriverStore-FileRepository%\%%i" )
for /f "delims=" %%i in (' dir /aa /b %MT-Windows-System32-DriverStore%\en-US ^| findstr /b /i /r "%~1" ') do ( call :Remove-File "%MT-Windows-System32-DriverStore%\en-US\%%i" )
for /f "delims=" %%i in (' dir /aa /b %MT-Windows-System32-DriverStore%\zh-CN ^| findstr /b /i /r "%~1" ') do ( call :Remove-File "%MT-Windows-System32-DriverStore%\zh-CN\%%i" )
for /f "delims=" %%i in (' dir /aa /b %MT-Windows-INF% ^| findstr /i /r "%~1" ') do ( call :Remove-File "%MT-Windows-INF%\%%i" )
call :Mount-ImageRegistry
for /f "tokens=* delims=" %%i in (' reg query "HKLM\MT_DRIVERS\DriverDatabase\DriverInfFiles" /f "%~1" ^| findstr /i "%~1" ') do (
    reg delete "%%i" /f >NUL
)
for /f "tokens=* delims=" %%i in (' reg query "HKLM\MT_DRIVERS\DriverDatabase\DriverPackages" /f "%~1" ^| findstr /i "%~1" ') do (
    reg delete "%%i" /f >NUL
)
call :UnMount-ImageRegistry
goto :eof

:Remove-JunkLang-File
for /f "delims=" %%i in (' dir /ad /b %MT-Windows-System32% ^| findstr /i /r "%~1" ') do ( call :Remove-Folder "%MT-Windows-System32%\%%i" )
for /f "delims=" %%i in (' dir /ad /b %MT-Windows-SysWOW64% ^| findstr /i /r "%~1" ') do ( call :Remove-Folder "%MT-Windows-SysWOW64%\%%i" )
for /f "delims=" %%i in (' dir /ad /b %MT-Windows-WinSxS% ^| findstr /i /r "%~1" ') do ( call :Remove-Folder "%MT-Windows-WinSxS%\%%i" )
goto :eof

:Remove-JunkWinSxS-File
for /f "delims=" %%i in (' dir /ad /b %MT-Windows-WinSxS% ^| findstr /r /v "%~1" ') do ( call :Remove-Folder "%MT-Windows-WinSxS%\%%i" )
call :Remove-File "%MT-Windows-WinSxS%\pending.xml"
goto :eof

:ResetBase
echo ResetBase
call :Mount-ImageRegistry
Reg add "HKLM\MT_SOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableComponentBackups" /t REG_DWORD /d "1" /f >NUL
Reg add "HKLM\MT_SOFTWARE\Microsoft\Windows\CurrentVersion\SideBySide\Configuration" /v "DisableResetbase" /t REG_DWORD /d "0" /f >NUL
call :UnMount-ImageRegistry
%Dism% /Image:%MT% /Cleanup-Image /StartComponentCleanup /ResetBase %Dism-Extra%
goto :eof

:UnMount
echo Unmounting Image
%Dism% /Unmount-Wim /MountDir:%MT% /Discard %Dism-Extra%
goto :eof

:UnMount-ImageRegistry
reg unload HKLM\MT_DEFAULT >NUL 2>&1
reg unload HKLM\MT_DRIVERS >NUL 2>&1
reg unload HKLM\MT_NTUSER >NUL 2>&1
reg unload HKLM\MT_SOFTWARE >NUL 2>&1
reg unload HKLM\MT_SYSTEM >NUL 2>&1
goto :eof

:Update-CumulativeUpdate
echo Add Cumulative Update
for /f "tokens=*" %%i in (' dir /ad /b %Update%\CU ') do ( %Dism% /Image:%MT% /Add-Package /PackagePath:%Update%\CU\%%i %Dism-Extra% )
goto :eof

:Update-FeatureExperiencePack
echo Add Feature Experience Pack
%Dism% /Image:%MT% /Add-Package /PackagePath:%Update%\FEP %Dism-Extra%
goto :eof

:Update-FeatureUpdate
echo Add Feature Update
%Dism% /Image:%MT% /Add-Package /PackagePath:%Update%\FU %Dism-Extra%
goto :eof

:Update-SafeOSDynamicUpdate
echo Add Safe OS Dynamic Update
%Dism% /Image:%MT% /Add-Package /PackagePath:%Update%\SU %Dism-Extra%
goto :eof

:Update-ServicingStackDynamicUpdate
echo Add Servicing Stack Dynamic Update
%Dism% /Image:%MT% /Add-Package /PackagePath:%Update%\SSU %Dism-Extra% 
goto :eof

:Wimlib-Imagex-Command
echo Add File to [%~1]
%wimlib-imagex% update "%~1" --command="%~2" >NUL 2>&1
goto :eof

:Wimlib-Imagex-Info
echo set [%~1 index %~2] info
%wimlib-imagex% info "%~1" "%~2" --image-property NAME="%~3" --image-property DESCRIPTION="%~4" --image-property FLAGS="%~5" --image-property DISPLAYNAME="%~6" --image-property DISPLAYDESCRIPTION="%~6" >NUL 2>&1
goto :eof

:Wimlib-Imagex-Optimize
echo optimize [%~1]
%wimlib-imagex% optimize "%~1" --compress="%~2" >NUL 2>&1
goto :eof