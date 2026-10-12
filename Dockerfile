FROM alpine:latest

# نصب پیش‌نیازها
RUN apk update && apk add --no-cache curl unzip

# دانلود و نصب Xray-core
RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip xray.zip && \
    mv xray /usr/local/bin/xray && \
    chmod +x /usr/local/bin/xray && \
    rm xray.zip

# ایجاد فایل تنظیمات اختصاصی
RUN mkdir -p /etc/xray
RUN echo '{ \
  "inbounds": [{ \
    "port": 7860, \
    "protocol": "vless", \
    "settings": { \
      "clients": [{ \
        "id": "c1f7a0b3-9d4e-4f21-89b6-71d3a5e8c901", \
        "flow": "xtls-rprx-vision", \
        "level": 0, \
        "email": "majix@trading.com" \
      }], \
      "decryption": "none" \
    }, \
    "streamSettings": { \
      "network": "ws", \
      "wsSettings": { \
        "path": "/majix-tunnel" \
      } \
    } \
  }], \
  "outbounds": [{ \
    "protocol": "freedom", \
    "settings": {} \
  }] \
}' > /etc/xray/config.json

# اجرای سرویس
CMD ["/usr/local/bin/xray", "-config", "/etc/xray/config.json"]
