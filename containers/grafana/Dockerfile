FROM grafana/grafana:latest

COPY ./grafana.ini /etc/grafana/grafana.ini
COPY ./dashboards /var/lib/grafana/dashboards

ENV GF_SECURITY_ADMIN_USER=admin
ENV GF_SECURITY_ADMIN_PASSWORD=admin
ENV GF_USERS_ALLOW_SIGN_UP=false 
ENV GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource

EXPOSE 3000