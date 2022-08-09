# Install VictoriaMetrics and Grafana by docker-compose
1. Clone project
```
git clone https://github.com/razumv/helpers/
```
2. Enter to directory
```
cd helpers/vm
```
3. Install docker, docker-compose
```
curl -s https://raw.githubusercontent.com/razumv/helpers/main/tools/install_docker.sh | bash
```
4. Start VictoriaMetrics and Grafana in background
```
docker-compose up -d
```
