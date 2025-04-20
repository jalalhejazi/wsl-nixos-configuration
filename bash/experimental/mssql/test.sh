#!/usr/bin/env bash

## Origin: https://github.com/jalalhejazi/powershell-profile/blob/main/docker/microservices.ps1

echo '[+] Stop running mssql'
docker container rm -f mssql &>/dev/null

echo '[+] Remove Docker image'
docker image rm mcr.microsoft.com/mssql/server:2019-latest &>/dev/null

echo "[+] Start time $(date +%R:%S)"
START=$(date +%s)
echo '[+] Download image from Docker hub (1.55GB)'
docker pull mcr.microsoft.com/mssql/server:2019-latest &>/dev/null


echo '[+] Start new mssql'
docker container run --name mssql --rm -d -e 'TZ=Europe/Copenhagen' -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=Djakp88t" -p 1433:1433 jalalhejazi/microservice_sqlserver &>/dev/null

echo '[+] Wait 20 seconds for the database to be ready'
sleep 20

echo '[+] Connect to master database and run some SQL for testing the connection'
echo 'SELECT @@version'
echo 'SELECT current_timestamp'
docker exec -i mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P 'Djakp88t' << EOT
SELECT @@version;
GO

SELECT current_timestamp;
GO

EXIT
EOT
echo "[+] End time $(date +%R:%S)"
END=$(date +%s)
date +%R:%S
echo "Time used: $((END-START)) seconds"