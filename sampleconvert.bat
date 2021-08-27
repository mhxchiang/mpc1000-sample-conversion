@echo off
REM Enter location of your sox.exe file here:
set sox="C:\Program Files (x86)\sox-14-4-2\sox.exe" 
 
:menu	
cls
echo This is a script to convert all samples in the batch file's directory and its subdirectories to Akai MPC1000 format (44 100 hz, 16 bit) or custom formats using SoX. See http://sox.sourceforge.net/ for more info.
echo You must have SoX 14-4-2 installed to the directory "C:\Program Files (x86)\sox-14-4-2\sox.exe" or alternatively edit the directory to the sox binary at the top of the batch file to reflect your install directory/sox version.
echo Once you have created the converted sample library it will be stored in a folder called "Converted" in the same directory as this batch file. 
echo WARNING: BE VERY CAREFUL with this script. Always keep a backup of your sample library, I am not responsible for any damages caused to your system/files/intellectual property.
echo:
echo:
echo                                              MENU
echo:
echo				1. Create MPC1000 compatible sample library (44100hz, 16bit)
echo				2. Create custom sample library (you set the sample rate/bit depth) ( beta )
echo				3. Delete previously converted sample library
echo				4. PC to MPC ( beta )
echo				q. Quit			
echo: 
 
set /p choice="Enter your choice: "
if "%choice%"=="1" goto one
if "%choice%"=="2" goto two
if "%choice%"=="3" goto three
if "%choice%"=="4" goto four
if "%choice%"=="q" exit
 
:one
REM Clean any unremoved conversions out of the original library. (incase it crashed the first time you ran it)
for /R "%~dp0" %%f in (*___MPC.wav) do (
	del "%%f"
)
 
REM Carry out conversion.
for /R "%~dp0" %%f in (*.wav *.aif *.aiff *.mp3) do (
	%sox% "%%f" -G -V -r 44100 -b 16 "%%~df%%~pf%%~nf___MPC.wav" 
)
 
REM Move the converted samples to a mirrored library.
rmdir /q /s "%~dp0Converted"
mkdir "%~dp0Converted"
robocopy "%~dp0\" "%~dp0Converted\\" *___MPC.wav /MIR /E /MOV
rmdir /s /q "%~dp0Converted\Converted"
 
echo Operation complete!
goto menu
 
 
:two
 
set /p samp="Enter sample rate (one integer no spaces or commas): "
 
set /p bit="Enter bit depth(one integer no spaces or commas): "
 
REM Clean any unremoved conversions out of the original library. (incase it crashed the first time you ran it)
for /R "%~dp0" %%f in (*___MPC.wav) do (
	del "%%f"
)
 
REM Carry out conversion.
for /R "%~dp0" %%f in (*.wav *.aif *.aiff *.mp3) do (
	%sox% "%%f" -G -V -r %samp% -b %bit% "%%~df%%~pf%%~nf___MPC.wav" 
)
 
REM Move the converted samples to a mirrored library.
rmdir /q /s "%~dp0Converted"
mkdir "%~dp0Converted"
robocopy "%~dp0\" "%~dp0Converted\\" *___MPC.wav /MIR /E /MOV
rmdir /s /q "%~dp0Converted\Converted"
 
echo Operation complete!
goto menu
 
:three
rmdir /q /s "%~dp0Converted"
for /R "%~dp0" %%f in (*___MPC.wav) do (
	del "%%f"
)
goto menu
 
:four
set /p drivelet="Enter the path to sample folder on your MPC (ie. H:\Samples): "
robocopy "%~dp0Converted\\" "%drivelet%" /XN /E
goto menu