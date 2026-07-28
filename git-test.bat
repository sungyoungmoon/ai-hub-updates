@echo off
setlocal
rem ------------------------------------------------------------------
rem  AI Hub network test - double-click me.
rem  Runs every connection test at once, then opens the results in
rem  Notepad. Nothing on this PC is changed; every test is read-only
rem  and every setting applies to that one test only.
rem ------------------------------------------------------------------
set "GIT=%LOCALAPPDATA%\Programs\AI Hub\mingit\cmd\git.exe"
set "URL=https://github.com/sungyoungmoon/ai-hub-updates.git"
set "LOG=%TEMP%\git-test-results.txt"

echo.
echo   Running network tests - takes 1-2 minutes.
echo   A Notepad window opens with the results when finished.
echo   Please leave this window alone until then...
echo.

echo AI Hub network test  %DATE% %TIME% > "%LOG%"
echo user: %USERNAME%   pc: %COMPUTERNAME% >> "%LOG%"

echo. >> "%LOG%"
echo ===== 1. bundled git present? ===== >> "%LOG%"
"%GIT%" --version >> "%LOG%" 2>&1
echo [exit %ERRORLEVEL%] >> "%LOG%"

echo   test 2 of 9...
echo. >> "%LOG%"
echo ===== 2. plain connect - expected to fail ===== >> "%LOG%"
"%GIT%" ls-remote %URL% >> "%LOG%" 2>&1
echo [exit %ERRORLEVEL%] >> "%LOG%"

echo   test 3 of 9...
echo. >> "%LOG%"
echo ===== 3. connect with revocation check off ===== >> "%LOG%"
"%GIT%" -c http.schannelCheckRevoke=false ls-remote %URL% >> "%LOG%" 2>&1
echo [exit %ERRORLEVEL%] >> "%LOG%"

echo   test 4 of 9...
echo. >> "%LOG%"
echo ===== 4. connect with certificate check fully off ===== >> "%LOG%"
"%GIT%" -c http.sslVerify=false ls-remote %URL% >> "%LOG%" 2>&1
echo [exit %ERRORLEVEL%] >> "%LOG%"

echo   test 5 of 9...
echo. >> "%LOG%"
echo ===== 5. connect using the OpenSSL certificate system ===== >> "%LOG%"
"%GIT%" -c http.sslBackend=openssl ls-remote %URL% >> "%LOG%" 2>&1
echo [exit %ERRORLEVEL%] >> "%LOG%"

echo   test 6 of 9...
echo. >> "%LOG%"
echo ===== 6. OpenSSL system, certificate check off ===== >> "%LOG%"
"%GIT%" -c http.sslBackend=openssl -c http.sslVerify=false ls-remote %URL% >> "%LOG%" 2>&1
echo [exit %ERRORLEVEL%] >> "%LOG%"

echo   test 7 of 9...
echo. >> "%LOG%"
echo ===== 7. is a full Git installed on this PC? ===== >> "%LOG%"
where git >> "%LOG%" 2>&1
git --version >> "%LOG%" 2>&1
git ls-remote %URL% >> "%LOG%" 2>&1
echo [exit %ERRORLEVEL%] >> "%LOG%"

echo   test 8 of 9...
echo. >> "%LOG%"
echo ===== 8. proxy settings on this PC ===== >> "%LOG%"
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer >> "%LOG%" 2>&1
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL >> "%LOG%" 2>&1
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable >> "%LOG%" 2>&1
netsh winhttp show proxy >> "%LOG%" 2>&1

echo   test 9 of 9...
echo. >> "%LOG%"
echo ===== 9. Windows own downloader - same path the app updater uses ===== >> "%LOG%"
curl.exe -sS -I --max-time 25 https://api.github.com/ >> "%LOG%" 2>&1
echo [exit %ERRORLEVEL%] >> "%LOG%"
echo ----- and with revocation check off ----- >> "%LOG%"
curl.exe -sS -I --ssl-no-revoke --max-time 25 https://api.github.com/ >> "%LOG%" 2>&1
echo [exit %ERRORLEVEL%] >> "%LOG%"

echo. >> "%LOG%"
echo ===== done ===== >> "%LOG%"

echo.
echo   Done. Opening the results...
start notepad "%LOG%"
