#!/bin/sh
mkdir /tmp/trojan-go
wget -O /tmp/trojan-go/trojan-go.zip https://github.com/p4gefau1t/trojan-go/releases/latest/download/trojan-go-linux-amd64.zip
unzip /tmp/trojan-go/trojan-go.zip -d /tmp/trojan-go
install -d /usr/local/share/trojan-go
mv /tmp/trojan-go/geoip.dat /tmp/trojan-go/geosite.dat /usr/local/share/trojan-go
install -m 0755 /tmp/trojan-go/trojan-go /usr/local/bin/trojan-go
rm -r /tmp/trojan-go
install -d /usr/local/etc/trojan-go
cat << EOF > /usr/local/etc/trojan-go/config.yaml
run-type: server
local-addr: 0.0.0.0
local-port: $PORT
remote-addr: $REMOTE_ADDR
remote-port: $REMOTE_PORT
log-level: 5
password:
  - $TROJAN_PASSWORD
router:
  enabled: true
  block:
    - 'geoip:private'
  geoip: /usr/local/share/trojan-go/geoip.dat
  geosite: /usr/local/share/trojan-go/geosite.dat
websocket:
  enabled: true
  path: $WEBSOCKET_PATH
shadowsocks:
  enabled: $SHADOWSOCKS_ENABLED
  method: $SHADOWSOCKS_METHOD
  password: $SHADOWSOCKS_PASSWORD
transport-plugin:
  enabled: true
  type: plaintext

EOF
/usr/local/bin/trojan-go -config /usr/local/etc/trojan-go/config.yaml
