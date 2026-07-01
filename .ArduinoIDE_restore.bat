@echo off

echo Œ³‚ÌŠÂ‹«‚É–ß‚µ‚Ü‚·
pause

set base=./
if exist "%base%\.backup\.arduinoIDE" (
  rmdir "%USERPROFILE%\.arduinoIDE" /S /Q
  robocopy "%base%\.backup\.arduinoIDE" "%USERPROFILE%\.arduinoIDE"                 /move /dcopy:t
)
if exist "%base%\.backup\arduino-ide" (
  rmdir "%USERPROFILE%\AppData\Roaming\arduino-ide" /S /Q
  robocopy "%base%\.backup\arduino-ide" "%USERPROFILE%\AppData\Roaming\arduino-ide" /move /dcopy:t
)
if exist "%base%\.backup\arduino" (
  rmdir "%USERPROFILE%\AppData\Local\arduino" /S /Q
  robocopy "%base%\.backup\arduino"     "%USERPROFILE%\AppData\Local\arduino"       /move /dcopy:t
)
if exist "%base%\.backup\libraries" (
  rmdir "%USERPROFILE%\Documents\Arduino\libraries" /S /Q
  robocopy "%base%\.backup\libraries"   "%USERPROFILE%\Documents\Arduino\libraries" /move /dcopy:t
)
if exist "%base%\.backup" (
  rmdir "%base%\.backup" /S /Q
)

echo Œ³‚ÌŠÂ‹«‚É–ß‚è‚Ü‚µ‚½
pause

:restore_cd
