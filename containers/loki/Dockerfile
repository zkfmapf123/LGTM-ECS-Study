# containers/loki/Dockerfile

FROM grafana/loki:3.4.1

WORKDIR /etc/loki

# 필요한 디렉토리 생성 및 권한 설정
RUN mkdir -p /tmp/loki/chunks && \
    mkdir -p /tmp/loki/rules && \
    mkdir -p /tmp/loki/index && \
    mkdir -p /tmp/loki/boltdb-shipper-active && \
    mkdir -p /tmp/loki/boltdb-shipper-cache && \
    chown -R loki:loki /tmp/loki

# 설정 파일 복사
COPY loki-config.yaml /etc/loki/local-config.yaml

# 포트 노출
EXPOSE 3100 9096

# 헬스체크 설정
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3100/ready || exit 1

# 실행 명령
CMD ["-config.file=/etc/loki/local-config.yaml"]