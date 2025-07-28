#!/data/data/com.termux/files/usr/bin/bash  

# ========== 1. 检查中心节点存活（端口8000） ==========  
check_server() {  
    # 使用nc检测端口（超时1秒）  
    nc -z -w 1 127.0.0.1 8000 >/dev/null 2>&1  
    if [ $? -ne 0 ]; then  
        alert_msg="$(date +'%Y-%m-%d %H:%M:%S') 告警：中心节点端口8000未响应！"  
        echo "$alert_msg" >> alert.log  
        termux-notification -t "SRE监控" -c "$alert_msg"  
    fi  
}  


# ========== 2. 检查日志同步延迟（失败日志存于failed_logs.txt） ==========  
check_delay() {  
    if [ -f failed_logs.txt ]; then  
        # 提取最后一行日志的时间戳（格式：log_id:user_action,time=1690000000,node=...）  
        latest_line=$(tail -n1 failed_logs.txt 2>/dev/null)  
        if [ -n "$latest_line" ]; then  
            latest_time=$(echo "$latest_line" | awk -F',' '{print $2}' | awk -F'=' '{print $2}')  
            if [ -n "$latest_time" ]; then  
                current_time=$(date +%s)  
                delay=$((current_time - latest_time))  
                if [ $delay -gt 10 ]; then  # 延迟超10秒告警  
                    alert_msg="$(date +'%Y-%m-%d %H:%M:%S') 告警：日志同步延迟${delay}秒！"  
                    echo "$alert_msg" >> alert.log  
                    termux-notification -t "SRE监控" -c "$alert_msg"  
                fi  
            fi  
        fi  
    fi  
}  


# ========== 3. 检查Termux磁盘占用（精确匹配根目录） ==========  
check_disk() {  
    # 查找Termux根目录的磁盘信息（/data/data/com.termux/files）  
    disk_info=$(df -h | grep '/data/data/com.termux/files$')  
    if [ -n "$disk_info" ]; then  
        # 提取占用百分比（如 "85%" → 85）  
        disk_usage=$(echo "$disk_info" | awk '{print $5}' | sed 's/%//')  
        # 确保是数字且超80%  
        if [[ $disk_usage =~ ^[0-9]+$ ]] && [ $disk_usage -gt 80 ]; then  
            alert_msg="$(date +'%Y-%m-%d %H:%M:%S') 告警：磁盘占用${disk_usage}%！"  
            echo "$alert_msg" >> alert.log  
            termux-notification -t "SRE监控" -c "$alert_msg"  
        fi  
    fi  
}  


# ========== 执行所有检查 ==========  
check_server  
check_delay  
check_disk
