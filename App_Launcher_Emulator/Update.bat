set online_version=20230516.1
set update_file_path="%temp%\App_Launcher_Emulator_Update.7z"

set updater_initialized=1

if not exist _Tools_\7z\7z.exe (
	cls
	echo Downloading 7zip...
	md _Tools_\7z 2>nul 1>nul 0>nul
	curl -s -L -H "Cache-Control: no-cache, no-store, must-revalidate" -o "_Tools_\7z\7z.exe" "https://raw.githubusercontent.com/bdstd/xlua/main/7z/7z.exe"
	curl -s -L -H "Cache-Control: no-cache, no-store, must-revalidate" -o "_Tools_\7z\7z.dll" "https://raw.githubusercontent.com/bdstd/xlua/main/7z/7z.dll"
)

del /q %update_file_path% 2>nul 1>nul
set current_version=0
set /p current_version=<_Tools_\version.txt
cls
echo Update Begin...
echo [+] Current Version = %current_version%
echo [+] Online Version = %online_version%
if %current_version%==%online_version% (
	echo [+] Latest Version, No Need Update!
	echo [+] Done!
) else (
	set do_update=1
)
if %do_update%==1 (
	echo [+] Downloading Update File...
	echo.
	curl -L -H "Cache-Control: no-cache" -o %update_file_path% "https://raw.githubusercontent.com/bdstd/xlua/main/App_Launcher_Emulator/Update.7z"
	if %ERRORLEVEL%==1 (
		echo.
		echo [!] Failed To Download Update File, Please Try Again Later!
		echo [+] Done!
		pause>nul
		exit
	) else (
		echo.
		echo [+] Extracting Update File...
		_Tools_\7z\7z.exe x -pbdstd %update_file_path% 2>nul 1>nul
		if %ERRORLEVEL%==0 (
			set /p new_version=<_Temp_Update_\_Tools_\Version.txt
			echo [+] Updating To %new_version%...
		) else (
			echo [!] Failed To Extract Update File!
		)
	)
)

if exist _Temp_Update_ (
	taskkill /f /im 7z.exe 2>nul 1>nul 0>nul
	taskkill /f /im nircmd.exe 2>nul 1>nul 0>nul
	taskkill /f /im nircmd64.exe 2>nul 1>nul 0>nul
	taskkill /f /im lua.exe 2>nul 1>nul 0>nul
	taskkill /f /im wget.exe 2>nul 1>nul 0>nul
	taskkill /f /im x_adb.exe 2>nul 1>nul 0>nul
	REM taskkill /f /im vbox-img.exe 2>nul 1>nul 0>nul
	
	REM _Tools_
	del /s /q _Tools_ 2>nul 1>nul 0>nul
	rd /s /q _Tools_ 2>nul 1>nul 0>nul
	
	REM _Batch_
	del /s /q _Batch_ 2>nul 1>nul 0>nul
	rd /s /q _Batch_ 2>nul 1>nul 0>nul
	
	REM Custom
	md _Custom_ 2>nul 1>nul
	if not exist _Custom_\_adb_custom.adb_cmd (
		copy /y _Temp_Custom_\_adb_custom.adb_cmd _Custom_\ 2>nul 1>nul 0>nul
	)
	
	REM Fix Gameloop TSettingCenter.exe
	if exist _Gameloop_\TxGameAssistant\ui\TSettingCenter.exe (
		md _Temp_Update_\_Gameloop_ 2>nul 1>nul 0>nul
		xcopy /s /y /f _Temp_Fix_\_Gameloop_ _Temp_Update_\_Gameloop_\ 2>nul 1>nul 0>nul
	)
	
	REM Clean Up
	del /s /q _Temp_Beta_ 2>nul 1>nul 0>nul
	rd /s /q _Temp_Beta_ 2>nul 1>nul 0>nul
	del /s /q _Temp_Custom_ 2>nul 1>nul 0>nul
	rd /s /q _Temp_Custom_ 2>nul 1>nul 0>nul
	del /s /q _Temp_Fix_ 2>nul 1>nul 0>nul
	rd /s /q _Temp_Fix_ 2>nul 1>nul 0>nul
	
	xcopy /s /y /f _Temp_Update_\*.* 2>nul 1>nul 0>nul
	del /s /q _Temp_Update_ 2>nul 1>nul 0>nul
	rd /s /q _Temp_Update_ 2>nul 1>nul 0>nul
	start z_Changelog.txt 2>nul 1>nul 0>nul
	
	del /q %update_file_path% 2>nul 1>nul 0>nul
)