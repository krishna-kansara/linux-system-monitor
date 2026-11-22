#!/bin/bash

PROJECT_NAME="Linux System Monitor"
HOST=$(hostname)
LOG_FILE="/root/linux-system-monitor/monitor.log"

read_cpu_stats() {
    awk '/^cpu / {
        idle=$5+$6
        total=0
        for(i=2; i<=9; i++) total+=$i
        print total, idle
    }' /proc/stat
}

read_network_stats() {
    awk 'NR>2 {
        gsub(":", "", $1)
        if($1!="lo") {
            rx+=$2
            tx+=$10
        }
    }
    END {
        printf "%.0f %.0f\n", rx, tx
    }' /proc/net/dev
}

while true
do
    CPU1=$(read_cpu_stats)
    NET1=$(read_network_stats)

    sleep 1

    CPU2=$(read_cpu_stats)

    sleep 4

    NET2=$(read_network_stats)

    read TOTAL1 IDLE1 <<< "$CPU1"
    read TOTAL2 IDLE2 <<< "$CPU2"

    read RX1 TX1 <<< "$NET1"
    read RX2 TX2 <<< "$NET2"

    CPU_USAGE=$(awk -v t1="$TOTAL1" -v t2="$TOTAL2" \
    -v i1="$IDLE1" -v i2="$IDLE2" \
    'BEGIN {
        total=t2-t1
        idle=i2-i1
        if(total>0)
            printf "%.2f", (total-idle)*100/total
        else
            print "0.00"
    }')

    MEM_USAGE=$(free | awk '/^Mem:/ {
        if($2>0)
            printf "%.2f", ($2-$7)*100/$2
    }')

    DISK_USAGE=$(df -P / | awk 'NR==2 {
        gsub("%","",$5)
        print $5
    }')

    RX_RATE=$(awk -v a="$RX1" -v b="$RX2" \
    'BEGIN {printf "%.2f", (b-a)/5120}')

    TX_RATE=$(awk -v a="$TX1" -v b="$TX2" \
    'BEGIN {printf "%.2f", (b-a)/5120}')

    clear

    echo "======================================"
    echo "       $PROJECT_NAME"
    echo "======================================"

    echo "Hostname: $HOST"
    echo "Date: $(date)"
    echo "Uptime: $(uptime -p)"

    echo "--------------------------------------"
    echo "CPU MONITORING"
    echo "--------------------------------------"
    echo "CPU Usage: $CPU_USAGE%"

    echo "--------------------------------------"
    echo "MEMORY MONITORING"
    echo "--------------------------------------"
    echo "Memory Usage: $MEM_USAGE%"
    free -h

    echo "--------------------------------------"
    echo "DISK MONITORING"
    echo "--------------------------------------"
    echo "Disk Usage: $DISK_USAGE%"
    df -h /

    echo "--------------------------------------"
    echo "NETWORK MONITORING"
    echo "--------------------------------------"
    echo "Download: $RX_RATE KB/s"
    echo "Upload: $TX_RATE KB/s"

    echo "--------------------------------------"
    echo "RESOURCE ALERTS"
    echo "--------------------------------------"

    if awk -v v="$CPU_USAGE" 'BEGIN {exit !(v>=80)}'
    then
        echo "WARNING: High CPU usage!"
    fi

    if awk -v v="$MEM_USAGE" 'BEGIN {exit !(v>=80)}'
    then
        echo "WARNING: High Memory usage!"
    fi

    if (( DISK_USAGE >= 80 ))
    then
        echo "WARNING: High Disk usage!"
    fi

    echo "======================================"

    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    printf "%s | CPU: %s%% | RAM: %s%% | Disk: %s%% | Download: %s KB/s | Upload: %s KB/s\n" \
    "$TIMESTAMP" "$CPU_USAGE" "$MEM_USAGE" "$DISK_USAGE" \
    "$RX_RATE" "TX_RATE" >> "$LOG_FILE"

    echo "Monitoring data saved to monitor.log"
    echo "Refreshing in 5 seconds..."
    echo "Press CTRL+C to stop"

done
