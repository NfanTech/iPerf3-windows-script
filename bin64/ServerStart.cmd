@echo off
set port=5201
set /p port=请输入监听端口(默认5201):
echo 在%port%端口启动服务
iperf3.exe -s -p %port%