#!/bin/bash

if (($(ps -auxww|wc -l) > 15));then
    pkill -kill -u $(whoami)
    echo "强制清理"
fi

if [ "$(ps -auxww | grep xray | grep "config.json" | grep -v grep)" = "" ]; then
    while [ "$(top | grep xray)" != "" ]; do
        echo "强制关闭xray"
        pkill -kill -u $(whoami)
        sleep 1s
    done
    cd ~/xray/
    rm -f nohup.out
    nohup ./xray -c config.json >/dev/null 2>&1 &
    echo "已重新启动xray"
fi