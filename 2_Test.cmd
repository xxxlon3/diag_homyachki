@echo off
set lpr= 188.235.141.139
set workdir=%cd%\diag
set net=%workdir%\net
set pingdir=%net%\ping
set speed=%net%\speed
set tr=%net%\tracert
set yadns=77.7.8.8
set domru=st.saratov.ertelecom.ru
@del 3_*
rem mode con: cols=39 lines=3  &color 1E
chcp 1251 > nul
for %%d in (%workdir% %net% %pingdir% %speed% %tr%) do mkdir %%d
for /f "skip=1 tokens=1* delims=: " %%A in ('nslookup myip.opendns.com. resolver1.opendns.com 2^>NUL^|find "Address:"') Do echo=%%B >> %net%\%%B
WMIC CPU Get Name /Value >> %workdir%\cpu.txt
@systeminfo >> %workdir%\systemsysteminfo.txt
netstat -r >> %net%\route.txt
ipconfig /all >> %net%\ipconfig.txt
for /f "tokens=3" %%a in ('route -4 print 0.* ^| FIND "0.0.0.0"') do ping %%a >> %pingdir%\chackGW%%a.txt
for %%e in (ping tracert) do (for %%f in (%lpr%, %yadns%, %domru%) do  %%e %%f >> %net%\%%e\%%f.txt)
for %%g in (%domru%) do iperf3.exe -c %%g -P 10 -V --logfile %speed%\%%g.txt
iperf3.exe -c %domru% -P 10 -V --logfile %speed%\%domru%.txt
7za.exe a 3_diag_%date%_%username%_%computername%.zip %workdir%
rmdir /Q /S %workdir%
msg "%username%" Готово
