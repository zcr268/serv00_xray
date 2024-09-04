#!/bin/bash

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