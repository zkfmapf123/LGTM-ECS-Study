#################################### Test ####################################
locust:
	cd containers/__locust__ && docker build -t locust . && docker run -p 8089:8089 locust

#################################### Service ####################################
deploy-hello:
	./svc-deploy.sh hello-repository/test ./containers/__svc-hello service hello-svc-test-svc

deploy-bye:
	./svc-deploy.sh bye-repository/test ./containers/__svc-bye service bye-svc-test-svc

#################################### Monitoring ####################################
deploy-loki:
	./svc-deploy.sh loki-repository/test ./containers/loki monitoring loki-svc-test-svc

deploy-grafana:
	./deploy.sh grafana-repository/test ./containers/grafana monitoring grafana-svc-test-svc

deploy-prometheus:
	./deploy.sh prometheus-repository/test ./containers/prometheus monitoring prometheus-svc-test-svc

deploy-tempo:
	./svc-deploy.sh tempo-repository/test ./containers/tempo monitoring tempo-svc-test-svc