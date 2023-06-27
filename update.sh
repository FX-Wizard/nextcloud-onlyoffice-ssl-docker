# Handy script to update containers to the latest verions
docker pull nextcloud:apache
docker pull onlyoffice/documentserver:latest 
docker compose restart