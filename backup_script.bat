@echo off

REM Get the current date
for /F "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set DATE=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%
set WEEK=%DATE:~0,4%-%DATE:~5,2%
set MONTH=%DATE:~0,4%-%DATE:~5,2%

REM Daily Backup
git checkout main
git pull origin main
git checkout -b backup/daily/%DATE%
git push origin backup/daily/%DATE%

REM Weekly Backup (every Sunday)
for /F "tokens=1,2,3,4,5 delims=/ " %%a in ('powershell -command "& {Get-Date}"') do (
    set DayOfWeek=%%a
)
if %DayOfWeek%==Sunday (
    git checkout main
    git pull origin main
    git checkout -b backup/weekly/%WEEK%
    git push origin backup/weekly/%WEEK%
)

REM Monthly Backup (first day of the month)
for /F "tokens=1,2 delims= " %%a in ('powershell -command "& {Get-Date -Format d}"') do (
    set DayOfMonth=%%a
)
if %DayOfMonth%==01 (
    git checkout main
    git pull origin main
    git checkout -b backup/monthly/%MONTH%
    git push origin backup/monthly/%MONTH%
)
