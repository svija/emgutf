@ECHO OFF
IF NOT "%1%"=="" GOTO START_TEST
ECHO USAGE: %0% xam_file_name
GOTO END
@ECHO ON

:START_TEST
REM Find Visual Studio or Msbuild
SET VS2005="%VS80COMNTOOLS%..\IDE\devenv.com"
SET VS2008="%VS90COMNTOOLS%..\IDE\devenv.com"
SET VS2010="%VS100COMNTOOLS%..\IDE\devenv.com"
SET VS2012="%VS110COMNTOOLS%..\IDE\devenv.com"
SET VS2013="%VS120COMNTOOLS%..\IDE\devenv.com"
SET VS2015="%VS140COMNTOOLS%..\IDE\devenv.com"
IF EXIST "%windir%\Microsoft.NET\Framework\v3.5\MSBuild.exe" SET MSBUILD35=%windir%\Microsoft.NET\Framework\v3.5\MSBuild.exe
IF EXIST "%windir%\Microsoft.NET\Framework64\v3.5\MSBuild.exe" SET MSBUILD35=%windir%\Microsoft.NET\Framework64\v3.5\MSBuild.exe
IF EXIST "%windir%\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe" SET MSBUILD40=%windir%\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe

IF EXIST "%MSBUILD35%" SET DEVENV="%MSBUILD35%"
IF EXIST "%MSBUILD40%" SET DEVENV="%MSBUILD40%"
IF EXIST %VS2005% SET DEVENV=%VS2005% 
IF EXIST %VS2008% SET DEVENV=%VS2008%
IF EXIST %VS2010% SET DEVENV=%VS2010%
IF "%4%"=="openni" GOTO SET_BUILD_TYPE
IF EXIST %VS2012% SET DEVENV=%VS2012%

IF EXIST %VS2013% SET DEVENV=%VS2013%
IF EXIST %VS2015% SET DEVENV=%VS2015%
REM IF "%2%"=="gpu" GOTO SET_BUILD_TYPE
REM IF NOT "%3%"=="WindowsStore10" GOTO SET_BUILD_TYPE


:SET_BUILD_TYPE
IF %DEVENV%=="%MSBUILD35%" SET BUILD_TYPE=/property:Configuration=Release
IF %DEVENV%=="%MSBUILD40%" SET BUILD_TYPE=/property:Configuration=Release
IF %DEVENV%==%VS2005% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2008% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2010% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2012% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2013% SET BUILD_TYPE=/Build "Release|Any CPU"
IF %DEVENV%==%VS2015% SET BUILD_TYPE=/Build "Release|Any CPU"

IF %DEVENV%=="%MSBUILD35%" SET CMAKE_CONF="Visual Studio 12 2005%OS_MODE%"
IF %DEVENV%=="%MSBUILD40%" SET CMAKE_CONF="Visual Studio 12 2005%OS_MODE%"
IF %DEVENV%==%VS2005% SET CMAKE_CONF="Visual Studio 8 2005%OS_MODE%"
IF %DEVENV%==%VS2008% SET CMAKE_CONF="Visual Studio 9 2008%OS_MODE%"
IF %DEVENV%==%VS2010% SET CMAKE_CONF="Visual Studio 10%OS_MODE%"
IF %DEVENV%==%VS2012% SET CMAKE_CONF="Visual Studio 11%OS_MODE%"
IF %DEVENV%==%VS2013% SET CMAKE_CONF="Visual Studio 12%OS_MODE%"
IF %DEVENV%==%VS2015% SET CMAKE_CONF="Visual Studio 14%OS_MODE%"

mkdir tmp
SET XAM_FILE_NAME=%1%
cp %XAM_FILE_NAME% "tmp/%XAM_FILE_NAME%.zip"
cd tmp
unzip %XAM_FILE_NAME%.zip
cd emgutf*\samples\Emgu.TF.Android.Example
..\..\..\..\xamarin-component.exe restore Emgu.TF.Android.Example.sln
call %DEVENV% %BUILD_TYPE% Emgu.TF.Android.Example.sln /project AndroidExamples 
cd ..\..\..\..

:END