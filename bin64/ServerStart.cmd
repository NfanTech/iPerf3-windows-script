@echo off
set port=5201
set /p port=����������˿�(Ĭ��5201):
echo ��%port%�˿���������
iperf3.exe -s -p %port%