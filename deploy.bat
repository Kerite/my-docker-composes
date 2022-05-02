@echo off
set curdir=%cd%
for %%i in (nginx-proxy, mysql, redis, cloud, rss-hub) do (
	cd %curdir%\%%i
    docker-compose up -d
)
pause
