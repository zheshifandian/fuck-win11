@echo off
%1 %2
ver|find "5.">NUL&&goto :Admin
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :Admin","","runas",1)(window.close)&goto :eof
:Admin
pushd "%~dp0"

SET "Addition=%~dp0bin\Addition"
SET "aria2c=%~dp0bin\bin\aria2c.exe"
SET "Registry=%~dp0bin\Registry"
SET "sed=%~dp0bin\bin\sed\sed.exe"

if not exist %~dp0image\install.wim ( echo install.wim doesn't exist ) & pause exit
if not exist %~dp0image\winre.wim ( echo winre.wim doesn't exist ) & pause exit

call :Prepare-Addition
call "%~dp0bin\bin\NSudo.exe" -U:T -P:E "%~dp0build.bat"

exit

:Prepare-Addition
if not exist %Addition%\Registry ( mkdir %Addition%\Registry 2>NUL )
if not exist %Addition%\Runtime\DirectX ( mkdir %Addition%\Runtime\DirectX 2>NUL )
if not exist %Addition%\Runtime\VC++ ( mkdir %Addition%\Runtime\VC++ 2>NUL )
if not exist %Addition%\Registry\*.reg (
    echo Preparing Registry Files
    for /f "delims=" %%i in (' dir /aa /b %Registry% ^| findstr .reg ') do (
    %sed% -e 's/HKLM\\\MT_SOFTWARE/HKEY_LOCAL_MACHINE\\\SOFTWARE/g' -e 's/HKLM\\\MT_NTUSER/HKEY_CURRENT_USER/g' -e 's/HKLM\\\MT_DEFAULT/HKEY_USERS\\\.DEFAULT/g' -e 's/HKLM\\\MT_SYSTEM\\\ControlSet001/HKEY_LOCAL_MACHINE\\\SYSTEM\\\CurrentControlSet/g' -e 's/HKLM\\\MT_SYSTEM/HKEY_LOCAL_MACHINE\\\SYSTEM/g' "%Registry%\%%i" > "tmp\%%i"
    PowerShell -Command "& { get-content "tmp\%%i" -encoding utf8 | set-content "%Addition%\Registry\%%i" -encoding unicode }"
    )
)
if exist %Addition%\Runtime\DirectX\*.exe (
    if exist %Addition%\Runtime\DirectX\*.aria2 (
        del /q /s %Addition%\Runtime\DirectX\* >NUL
        echo Downloading DirectX Runtime
        %aria2c% -i %~dp0bin\lists\DirectX.txt -c >NUL
    )
) else (
    echo Downloading DirectX Runtime
    %aria2c% -i %~dp0bin\lists\DirectX.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2005_x86.exe (
    if exist %Addition%\Runtime\VC++\VC++2005_x86.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2005_x86.* >NUL
        echo Downloading VC++2005_x86
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2005_x86.txt -c >NUL
    )
) else (
    echo Downloading VC++2005_x86
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2005_x86.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2008_x86.exe (
    if exist %Addition%\Runtime\VC++\VC++2008_x86.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2008_x86.* >NUL
        echo Downloading VC++2008_x86
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2008_x86.txt -c >NUL
    )
) else (
    echo Downloading VC++2008_x86
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2008_x86.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2010_x86.exe (
    if exist %Addition%\Runtime\VC++\VC++2010_x86.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2010_x86.* >NUL
        echo Downloading VC++2010_x86
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2010_x86.txt -c >NUL
    )
) else (
    echo Downloading VC++2010_x86
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2010_x86.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2012_x86.exe (
    if exist %Addition%\Runtime\VC++\VC++2012_x86.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2012_x86.* >NUL
        echo Downloading VC++2012_x86
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2012_x86.txt -c >NUL
    )
) else (
    echo Downloading VC++2012_x86
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2012_x86.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2013_x86.exe (
    if exist %Addition%\Runtime\VC++\VC++2013_x86.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2013_x86.* >NUL
        echo Downloading VC++2013_x86
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2013_x86.txt -c >NUL
    )
) else (
    echo Downloading VC++2013_x86
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2013_x86.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2015-2022_x86.exe (
    if exist %Addition%\Runtime\VC++\VC++2015-2022_x86.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2015-2022_x86.* >NUL
        echo Downloading VC++2015-2022_x86
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2015-2022_x86.txt -c >NUL
    )
) else (
    echo Downloading VC++2015-2022_x86
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2015-2022_x86.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2005_x64.exe (
    if exist %Addition%\Runtime\VC++\VC++2005_x64.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2005_x64.* >NUL
        echo Downloading VC++2005_x64
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2005_x64.txt -c >NUL
    )
) else (
    echo Downloading VC++2005_x64
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2005_x64.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2008_x64.exe (
    if exist %Addition%\Runtime\VC++\VC++2008_x64.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2008_x64.* >NUL
        echo Downloading VC++2008_x64
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2008_x64.txt -c >NUL
    )
) else (
    echo Downloading VC++2008_x64
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2008_x64.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2010_x64.exe (
    if exist %Addition%\Runtime\VC++\VC++2010_x64.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2010_x64.* >NUL
        echo Downloading VC++2010_x64
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2010_x64.txt -c >NUL
    )
) else (
    echo Downloading VC++2010_x64
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2010_x64.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2012_x64.exe (
    if exist %Addition%\Runtime\VC++\VC++2012_x64.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2012_x64.* >NUL
        echo Downloading VC++2012_x64
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2012_x64.txt -c >NUL
    )
) else (
    echo Downloading VC++2012_x64
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2012_x64.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2013_x64.exe (
    if exist %Addition%\Runtime\VC++\VC++2013_x64.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2013_x64.* >NUL
        echo Downloading VC++2013_x64
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2013_x64.txt -c >NUL
    )
) else (
    echo Downloading VC++2013_x64
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2013_x64.txt -c >NUL
)
if exist %Addition%\Runtime\VC++\VC++2015-2022_x64.exe (
    if exist %Addition%\Runtime\VC++\VC++2015-2022_x64.exe.aria2 (
        del /q /s %Addition%\Runtime\VC++\VC++2015-2022_x64.* >NUL
        echo Downloading VC++2015-2022_x64
        %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2015-2022_x64.txt -c >NUL
    )
) else (
    echo Downloading VC++2015-2022_x64
    %aria2c% -i %~dp0bin\lists\VCRuntime\VC++2015-2022_x64.txt -c >NUL
)
goto :eof