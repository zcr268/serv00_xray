rm -rf ~/xray
mkdir -p ~/xray

if [ "$(ps -efww | grep xray | grep "config.json" | grep -v grep)" = "" ]; then
    while [ "$(top | grep xray)" != "" ]; do
        echo "强制关闭xray"
        killall -9 xray
        sleep 1s
    done
    cd ~/xray/
    rm -f nohup.out
    nohup ./xray -c config.json >/dev/null 2>&1 &
    echo "已重新启动xray"
fi
port=$(devil port list|grep xray|awk '{print $1}')
key=$1

cd ~/xray
wget https://github.com/XTLS/Xray-core/releases/download/v1.8.20/Xray-freebsd-64.zip && unzip Xray-freebsd-64.zip &&  && echo '{
    "log": {
        "loglevel": "warning"
    },
    "routing": {
        "domainStrategy": "IPIfNonMatch",
        "rules": [
            {
                "type": "field",
                "ip": [
                    "geoip:cn",
                    "geoip:private"
                ],
                "outboundTag": "block"
            }
        ]
    },
    "inbounds": [
        {
            "listen": "0.0.0.0",
            "port": '$port',
            "protocol": "vmess",
            "settings": {
                "clients": [
                  {
                    "id": "'$key'",
                    "alterId": 0
                  }
                ],
                "disableInsecureEncryption": false
              },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                  "acceptProxyProtocol": false,
                  "path": "/xx",
                  "headers": {}
                }
              },
              "sniffing":{
                "enabled": false,
                "destOverride": [
                  "http",
                  "tls"
                ]
              }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "tag": "block"
        }
    ]
}' >~/xray/config.json && { nohup ./xray -c config.json >/dev/null 2>&1 & } && echo "已重新启动xray"
