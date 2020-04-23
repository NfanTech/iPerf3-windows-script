ECHO OFF
CLS
color 3f
set dir=%cd%
set TUmode=
set TitleTUmode=TCP
set TitleMUPort=单
set MUNum=1
set CommandSave=
set NextIpType=ipv6
set Ipvx=-4
::系统类型
if "%PROCESSOR_ARCHITECTURE%"=="x86" set target=bin 
if "%PROCESSOR_ARCHITECTURE%"=="x86" set name=32位
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set target=bin64 
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set name=64位

:: 版本名称
set Mver=iperf 3.1.3
set modver= 1.3.0.0
set Mdate=2019/06/18
:: 获取新版本
echo 正在检查更新

set "Nver=ping newversion.timzhong.top -n 1 -w 1^|findstr /i "[""
for /f "tokens=2 delims=[]" %%1 in ('%Nver%') do set Nver= %%1
set VerCheck=可更新%Nver%
if "%Nver%"=="" set VerCheck=无法获取最新版本号，请检查网络
if "%Nver%"=="%modver%" set VerCheck=当前为最新版本

::初始化标题
TITLE Iperf3 TCP/UDP测试 %name% 当前为%TitleTUmode% %TitleMUPort%线程模式 %Ipvx%
:STARTS
::获取本机IP
set "m=ipconfig^|findstr /i "ipv4""
for /f "tokens=14* delims=: " %%1 in ('%m%') do set myip=%%2
if "%myip%"=="" set myip=无法获取IP！请自行查询
CLS
ECHO.
ECHO.           Iperf测速工具箱  时间：%DATE% %TIME:~0,8%
ECHO.           
ECHO.           当前版本：%Mver%   编辑版本：%modver%.fyxdfg %Mdate%
ECHO.                                   更新检查：%VerCheck%
ECHO.           本机IP: %myip% 可以在局域网内其他设备连接此ip
ECHO. =============================================================================
ECHO. 
ECHO.
ECHO.
ECHO.            1.启动服务      2.普通测试(自定义参数)   3.单文件测试   
ECHO.            4.TCP/UDP切换   5.重复上次测试           6.安装Telnet
ECHO.            7.切换%NextIpType%
ECHO.            8.多线程
ECHO.            0.刷新主界面
ECHO.
ECHO.                                               
ECHO. 啥都看不懂选9，测本机nat性能
ECHO.
ECHO. 更新：https://github.com/NfanTech/iPerf3-windows-script
ECHO. =============================================================================
echo.
:CHO
set choice=
set /p choice=输入对应数字，然后按回车键:
if /i "%choice%"=="1" goto SERVER
if /i "%choice%"=="2" goto CilnetA
if /i "%choice%"=="3" goto CilnetB
if /i "%choice%"=="4" goto TtoU
if /i "%choice%"=="5" goto ReTest
if /i "%choice%"=="6" goto Tools
if /i "%choice%"=="7" goto SetIpType
if /i "%choice%"=="8" goto MUPort
if /i "%choice%"=="9" goto TakeItEasy
if /i "%choice%"=="0" goto STARTS
echo 选择无效，请重新输入
echo.
goto STARTS

:SERVER
echo ##########################
echo #                        #
echo # 请在新窗口设定监听端口 #
echo #                        #
echo ##########################
echo.
cd %dir%/%target%
start ServerStart.cmd
pause
GOTO STARTS

:CilnetA
cd %dir%/%target%
set /p IP=请输入IP:
set Port=5201
set /p Port=请输入端口(默认5201):
set speed=100000
set /p speed=请输入目标速度(单位Mbps):
echo -R 反向测试
echo -O time(sec) TCP延迟以跳过TCP慢启动
echo -Z 重复使用相同数据(减少客户端CPU占用)
echo -cport port(num) 强制客户端使用固定端口(防止低端口封锁)
echo -t time(sec) 总测试时间
set userspace = 
set /p userspace=请输入自定义参数(-x xxx)：


iperf3.exe %TUmode% %Ipvx% -c %IP% -p %Port% -P %MUNum% -b %speed%M %userspace%
set CommandSave=iperf3.exe %TUmode% %Ipvx% -c %IP% -p %Port% -P %MUNum% -b %speed%M %userspace%

pause
GOTO STARTS

:CilnetB
cd %dir%/%target%
set /p IP=请输入IP:
set Port=5201
set /p Port=请输入端口(默认5201):
set /p N=请输入文件大小(默认10M):
set speed=100000
set /p speed=请输入目标速度(默认10Gbps):
iperf3.exe -c %IP% %Ipvx% -p %Port% -P %MUNum% -n %N%M -b %speed%M
set CommandSave=iperf3.exe -c %IP% %Ipvx% -p %Port% -P %MUNum% -n %N%M -b %speed%M

pause
GOTO STARTS

:TtoU
set /p TUmodeput=0切换到TCP，1切换到UDP：
if “%TUmodeput%”==“0” set TUmode=
if “%TUmodeput%”==“0” set TitleTUmode=TCP
if “%TUmodeput%”==“1” set TUmode=-u
if “%TUmodeput%”==“1” set TitleTUmode=UDP
pause
GOTO STARTS

:ReTest
%CommandSave%
pause
GOTO STARTS

:Tools
echo 正在安装telnet客户端...
pkgmgr /iu:"TelnetClient"
echo 正在开启服务...
net start telnet 
pause
GOTO STARTS

:SetIpType
::set /p Ipvxput=0切换到ipv4，1切换到ipv6：
if “%NextIpType%”==“ipv4” GOTO GOTOv4
if “%NextIpType%”==“ipv6” GOTO GOTOv6

:GOTOv4
set Ipvx=-4
TITLE Iperf3 TCP/UDP测试 %name% 当前为%TitleTUmode% %TitleMUPort%线程模式 %Ipvx%
set NextIpType=ipv6
GOTO STARTS

:GOTOv6
set Ipvx=-6
TITLE Iperf3 TCP/UDP测试 %name% 当前为%TitleTUmode% %TitleMUPort%线程模式 %Ipvx%
set NextIpType=ipv4
GOTO STARTS

:MUPort
::MUNum多线程线程数
set /p MUNumInput=请输入大于0的线程数:
set MUNum=%MUNumInput%
echo %MUNum%
::本地化标题
set TitleMUPort=%MUNumInput%
if "%MUNumInput%"=="1" set TitleMUPort=单
if "%MUNumInput%"=="2" set TitleMUPort=双
if "%MUNumInput%"=="3" set TitleMUPort=三

::标题设定
TITLE Iperf3 TCP/UDP测试 %name% 当前为%TitleTUmode% %TitleMUPort%线程模式 %Ipvx%
echo 设定成功
pause
GOTO STARTS

:TakeItEasy
cd %dir%/%target%
start iperf3.exe -s
iperf3.exe -c 127.0.0.1
pause
GOTO STARTS

:COMPLETE
exit
