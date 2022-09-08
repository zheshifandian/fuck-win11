@echo off
%1 %2
ver|find "5.">NUL&&goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin

SET "Sudo=%SystemRoot%\Addition\NSudo.exe"
SET "Registry=%SystemRoot%\Addition\Registry"
SET "Runtime=%SystemRoot%\Addition\Runtime"

if exist %SystemRoot%\Addition\NetFX35 (
    echo Install NetFX35
    Dism /Online /Add-Package /PackagePath:%SystemRoot%\Addition\NetFX35 /NoRestart /Quiet
)
call :Install %Runtime%\DirectX /silent
call :Install %Runtime%\VC++ /q
call :Import-Reg "%Registry%"

Dism /Online /Set-ReservedStorageState /State:Disabled /Quiet

powercfg /h off

%NSudo% -U:T -P:E REG ADD "HKCU\SOFTWARE\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\Applications\photoviewer.dll\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\Applications\photoviewer.dll\shell\print\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3056" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-70" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Bitmap\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-83" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Gif\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.JFIF\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3055" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-72" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Jpeg\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3057" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-71" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Png\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff" /v "FriendlyTypeName" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll,-3058" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\imageres.dll,-122" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Tiff\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\wmphoto.dll,-400" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open" /v "MuiVerb" /t REG_EXPAND_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3043" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Classes\PhotoViewer.FileAssoc.Wdp\shell\open\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\rundll32.exe \"%%ProgramFiles%%\Windows Photo Viewer\PhotoViewer.dll\", ImageView_Fullscreen %%1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorUser" /t REG_DWORD /d "0" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationDescription" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3069" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities" /v "ApplicationName" /t REG_SZ /d "@%%ProgramFiles%%\Windows Photo Viewer\photoviewer.dll,-3009" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableOSUpgrade" /t REG_DWORD /d "1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DisableWindowsUpdateAccess" /t REG_DWORD /d "1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager" /v "BackupCount" /t REG_DWORD /d "2" /f
%NSudo% -U:T -P:E REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager\LastKnownGood" /v "Enabled" /t REG_DWORD /d "1" /f

rmdir /q /s "%SystemRoot%\Addition" 2>NUL
shutdown -r -f -t 3
del /F /Q %0
exit

:Import-Reg
for /f "delims=" %%i in (' dir /aa /b "%~1" ^| findstr .reg ') do ( call cmd /c %NSudo% -U:T -P:E reg import "%~1\%%i" )
goto :eof

:Install
for /f "delims=" %%i in (' dir /aa /b "%~1" ^| findstr .exe 2^>NUL') do ( 
    echo Installing [%%i]
    %~1\%%i %~2
)
goto :eof
