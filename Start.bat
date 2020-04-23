ECHO OFF
CLS
color 3f
set dir=%cd%
set TUmode=
set TitleTUmode=TCP
set TitleMUPort=��
set MUNum=1
set CommandSave=
set NextIpType=ipv6
set Ipvx=-4
::ϵͳ����
if "%PROCESSOR_ARCHITECTURE%"=="x86" set target=bin 
if "%PROCESSOR_ARCHITECTURE%"=="x86" set name=32λ
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set target=bin64 
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set name=64λ

:: �汾����
set Mver=iperf 3.1.3
set modver= 1.3.0.0
set Mdate=2019/06/18
:: ��ȡ�°汾
echo ���ڼ�����

set "Nver=ping newversion.timzhong.top -n 1 -w 1^|findstr /i "[""
for /f "tokens=2 delims=[]" %%1 in ('%Nver%') do set Nver= %%1
set VerCheck=�ɸ���%Nver%
if "%Nver%"=="" set VerCheck=�޷���ȡ���°汾�ţ���������
if "%Nver%"=="%modver%" set VerCheck=��ǰΪ���°汾

::��ʼ������
TITLE Iperf3 TCP/UDP���� %name% ��ǰΪ%TitleTUmode% %TitleMUPort%�߳�ģʽ %Ipvx%
:STARTS
::��ȡ����IP
set "m=ipconfig^|findstr /i "ipv4""
for /f "tokens=14* delims=: " %%1 in ('%m%') do set myip=%%2
if "%myip%"=="" set myip=�޷���ȡIP�������в�ѯ
CLS
ECHO.
ECHO.           Iperf���ٹ�����  ʱ�䣺%DATE% %TIME:~0,8%
ECHO.           
ECHO.           ��ǰ�汾��%Mver%   �༭�汾��%modver%.fyxdfg %Mdate%
ECHO.                                   ���¼�飺%VerCheck%
ECHO.           ����IP: %myip% �����ھ������������豸���Ӵ�ip
ECHO. =============================================================================
ECHO. 
ECHO.
ECHO.
ECHO.            1.��������      2.��ͨ����(�Զ������)   3.���ļ�����   
ECHO.            4.TCP/UDP�л�   5.�ظ��ϴβ���           6.��װTelnet
ECHO.            7.�л�%NextIpType%
ECHO.            8.���߳�
ECHO.            0.ˢ��������
ECHO.
ECHO.                                               
ECHO. ɶ��������ѡ9���Ȿ��nat����
ECHO.
ECHO. ���£�https://github.com/NfanTech/iPerf3-windows-script
ECHO. =============================================================================
echo.
:CHO
set choice=
set /p choice=�����Ӧ���֣�Ȼ�󰴻س���:
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
echo ѡ����Ч������������
echo.
goto STARTS

:SERVER
echo ##########################
echo #                        #
echo # �����´����趨�����˿� #
echo #                        #
echo ##########################
echo.
cd %dir%/%target%
start ServerStart.cmd
pause
GOTO STARTS

:CilnetA
cd %dir%/%target%
set /p IP=������IP:
set Port=5201
set /p Port=������˿�(Ĭ��5201):
set speed=100000
set /p speed=������Ŀ���ٶ�(��λMbps):
echo -R �������
echo -O time(sec) TCP�ӳ�������TCP������
echo -Z �ظ�ʹ����ͬ����(���ٿͻ���CPUռ��)
echo -cport port(num) ǿ�ƿͻ���ʹ�ù̶��˿�(��ֹ�Ͷ˿ڷ���)
echo -t time(sec) �ܲ���ʱ��
set userspace = 
set /p userspace=�������Զ������(-x xxx)��


iperf3.exe %TUmode% %Ipvx% -c %IP% -p %Port% -P %MUNum% -b %speed%M %userspace%
set CommandSave=iperf3.exe %TUmode% %Ipvx% -c %IP% -p %Port% -P %MUNum% -b %speed%M %userspace%

pause
GOTO STARTS

:CilnetB
cd %dir%/%target%
set /p IP=������IP:
set Port=5201
set /p Port=������˿�(Ĭ��5201):
set /p N=�������ļ���С(Ĭ��10M):
set speed=100000
set /p speed=������Ŀ���ٶ�(Ĭ��10Gbps):
iperf3.exe -c %IP% %Ipvx% -p %Port% -P %MUNum% -n %N%M -b %speed%M
set CommandSave=iperf3.exe -c %IP% %Ipvx% -p %Port% -P %MUNum% -n %N%M -b %speed%M

pause
GOTO STARTS

:TtoU
set /p TUmodeput=0�л���TCP��1�л���UDP��
if ��%TUmodeput%��==��0�� set TUmode=
if ��%TUmodeput%��==��0�� set TitleTUmode=TCP
if ��%TUmodeput%��==��1�� set TUmode=-u
if ��%TUmodeput%��==��1�� set TitleTUmode=UDP
pause
GOTO STARTS

:ReTest
%CommandSave%
pause
GOTO STARTS

:Tools
echo ���ڰ�װtelnet�ͻ���...
pkgmgr /iu:"TelnetClient"
echo ���ڿ�������...
net start telnet 
pause
GOTO STARTS

:SetIpType
::set /p Ipvxput=0�л���ipv4��1�л���ipv6��
if ��%NextIpType%��==��ipv4�� GOTO GOTOv4
if ��%NextIpType%��==��ipv6�� GOTO GOTOv6

:GOTOv4
set Ipvx=-4
TITLE Iperf3 TCP/UDP���� %name% ��ǰΪ%TitleTUmode% %TitleMUPort%�߳�ģʽ %Ipvx%
set NextIpType=ipv6
GOTO STARTS

:GOTOv6
set Ipvx=-6
TITLE Iperf3 TCP/UDP���� %name% ��ǰΪ%TitleTUmode% %TitleMUPort%�߳�ģʽ %Ipvx%
set NextIpType=ipv4
GOTO STARTS

:MUPort
::MUNum���߳��߳���
set /p MUNumInput=���������0���߳���:
set MUNum=%MUNumInput%
echo %MUNum%
::���ػ�����
set TitleMUPort=%MUNumInput%
if "%MUNumInput%"=="1" set TitleMUPort=��
if "%MUNumInput%"=="2" set TitleMUPort=˫
if "%MUNumInput%"=="3" set TitleMUPort=��

::�����趨
TITLE Iperf3 TCP/UDP���� %name% ��ǰΪ%TitleTUmode% %TitleMUPort%�߳�ģʽ %Ipvx%
echo �趨�ɹ�
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
