@echo off

set ENV_NAME=%~1
if "%ENV_NAME%" == "" (
  rem 環境値を入力
  set /p ENV_NAME="環境名を入力してください。"
)
set base=./
if "%ENV_NAME%" == "" goto exit_bat

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
rem 専用環境のフォルダ作成
if not exist "%env_base%" (
  echo %ENV_NAME% 用の環境を新規に作ります
  pause
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


if exist "C:\Program Files\Arduino IDE\Arduino IDE.exe" (
  echo Arduino IDE を起動します
  timeout 3
  start "" "C:\Program Files\Arduino IDE\Arduino IDE.exe"
  goto exit_bat
)
if exist "%USERPROFILE%\AppData\Local\Programs\Arduino IDE\Arduino IDE.exe" (
  echo Arduino IDE を起動します
  timeout 3
  start "" "%USERPROFILE%\AppData\Local\Programs\Arduino IDE\Arduino IDE.exe"
  goto exit_bat
)

:exit_bat
