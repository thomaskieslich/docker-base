# docker-base
Based on the great [Webdevops Dockerfile](https://github.com/webdevops/Dockerfile).  

## First Run
`make build` create the images defined in docker-compose.yml. After that you can 
start docker with `make start` and stop with `make stop`.

The default Configuration runs the current Appache with PHP and MYSQL. 

The Idea is that you can easily change Ports and Versions with the .env File 
and enable/disable Components in docker-compose.yml.