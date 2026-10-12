FROM alpine:edge

ENV UUID=550e8400-e29b-41d4-a716-446655440000
ENV PORT=8080

RUN apk add --no-cache curl ca-certificates bash jq tar \
    && mkdir -p /tmp/xray /usr/local/bin /etc/xray \
    && XRAY_URL="https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip" \
    && curl -sL -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip ${XRAY_URL} \
    && unzip /tmp/xray/xray.zip -d /tmp/xray \
    && install -m 755 /tmp/xray/xray /usr/local/bin/xray \
    && rm -rf /tmp/xray

COPY config.json /etc/xray/config.json
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8080

CMD ["/entrypoint.sh"]
