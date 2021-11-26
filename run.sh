#!/bin/sh
#Caddy deploy
mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/
wget -qO- $CONFIGCADDY  >/etc/caddy/Caddyfile

#trojan-go deploy
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
remote-addr: 127.0.0.1
remote-port: $CAPORT
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

/usr/local/bin/trojan-go -config /usr/local/etc/trojan-go/config.yaml &
/usr/bin/caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
