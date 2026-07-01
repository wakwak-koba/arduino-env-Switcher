@echo off

set ENV_NAME=%~1
if "%ENV_NAME%" == "" (
  rem 環境値を入力
  set /p ENV_NAME="環境名を入力してください。"
)
if "%ENV_NAME%" == "" goto exit_bat

set base=./
if not exist "%base%\.backup" (
  rem 初回起動時ぽいので、いちお退避させとく
  echo Arduino IDE.bat が初めて実行されます。
  echo 現在の環境を %base%\.backup に移動したうえで専用環境を作ります
  echo "%CD%\%base%"
  mkdir "%base%"
  mkdir "%base%\.backup"
  robocopy "%USERPROFILE%\.arduinoIDE"                      "%base%\.backup\.arduinoIDE"  /move /dcopy:t
  robocopy "%USERPROFILE%\AppData\Roaming\arduino-ide"      "%base%\.backup\.arduino-ide" /move /dcopy:t
  robocopy "%USERPROFILE%\AppData\Local\arduino"            "%base%\.backup\arduino"      /move /dcopy:t
  if exist "%USERPROFILE%\Documents\Arduino\libraries" (
    robocopy "%USERPROFILE%\Documents\Arduino\libraries"    "%base%\.backup\libraries"    /move /dcopy:t
  )
)

set env_base=%base%\%ENV_NAME%

rem 起動用のバッチファイル作成
if not exist "%env_base%.bat" (
  echo %ENV_NAME% 用の環境を新規に作ります
  pause
  (
    echo @echo off
    echo cd /d "%%~dp0"
    echo call "%~nx0" "%ENV_NAME%"
  ) > "%ENV_NAME%.bat"
  start "" "%ENV_NAME%.bat"
  goto exit_bat
)

rem 専用環境のフォルダ作成
if not exist "%env_base%" (
  mkdir "%env_base%"
  mkdir "%env_base%\.arduinoIDE"
  echo directories:>  "%env_base%\.arduinoIDE\arduino-cli.yaml"
  echo   data: %CD%\%base%\%ENV_NAME%\Arduino15>> "%env_base%\.arduinoIDE\arduino-cli.yaml"
)
if not exist "%env_base%\arduino-ide" (
  mkdir "%env_base%\arduino-ide"
)
if not exist "%env_base%\arduino" (
  mkdir "%env_base%\arduino"
)
if not exist "%env_base%\libraries" (
  mkdir "%env_base%\libraries"
)

rem 旧環境のジャンクションを削除
if exist "%USERPROFILE%\.arduinoIDE" (
  rmdir "%USERPROFILE%\.arduinoIDE" /S /Q
)
if exist "%USERPROFILE%\AppData\Roaming\arduino-ide" (
  rmdir "%USERPROFILE%\AppData\Roaming\arduino-ide" /S /Q
)
if exist "%USERPROFILE%\AppData\Local\arduino" (
  rmdir "%USERPROFILE%\AppData\Local\arduino" /S /Q
)
if exist "%USERPROFILE%\Documents\Arduino\libraries" (
  rmdir "%USERPROFILE%\Documents\Arduino\libraries" /S /Q
)

rem 新環境のジャンクションを作成
mklink /J "%USERPROFILE%\.arduinoIDE"                 "%env_base%\.arduinoIDE"
mklink /J "%USERPROFILE%\AppData\Roaming\arduino-ide" "%env_base%\arduino-ide"
mklink /J "%USERPROFILE%\AppData\Local\arduino"       "%env_base%\arduino"
mklink /J "%USERPROFILE%\Documents\Arduino\libraries" "%env_base%\libraries"

if "%RAM_DRIVE%"=="" goto start_ide
set "LAST_CHAR=%RAM_DRIVE:~-1%"
if "%LAST_CHAR%"==":" set "FINAL_RAM_DRIVE=%RAM_DRIVE%"
if not "%LAST_CHAR%"==":" set "FINAL_RAM_DRIVE=%RAM_DRIVE%:"

vol %FINAL_RAM_DRIVE% >nul 2>&1
if errorlevel 1 goto start_ide

rem 作業領域を RAM_DRIVE に変更する
if not exist "%FINAL_RAM_DRIVE%\arduino" (
  mkdir "%FINAL_RAM_DRIVE%\arduino"
)
if not exist "%FINAL_RAM_DRIVE%\arduino\%ENV_NAME%" (
  mkdir "%FINAL_RAM_DRIVE%\arduino\%ENV_NAME%"
)

rmdir "%USERPROFILE%\AppData\Local\arduino" /S /Q
mklink /J "%USERPROFILE%\AppData\Local\arduino"       "%FINAL_RAM_DRIVE%\arduino\%ENV_NAME%"

:start_ide
if exist "C:\Program Files\Arduino IDE\Arduino IDE.exe" (
  start "" "C:\Program Files\Arduino IDE\Arduino IDE.exe"
  goto exit_bat
)
if exist "%USERPROFILE%\AppData\Local\Programs\Arduino IDE\Arduino IDE.exe" (
  start "" "%USERPROFILE%\AppData\Local\Programs\Arduino IDE\Arduino IDE.exe"
  goto exit_bat
)

:exit_bat
