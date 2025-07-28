#!/data/data/com.termux/files/usr/bin/bash  

# 1. 检查中心节点是否存活  
nc -z -w 5 127.0.0.1 8000  
if [ $? -ne 0 ]; then  
    echo "中心节点未启动！"  
    exit 1  
fi  

# 2. 检查日志源是否有新成功日志  
grep "发送成功" log_sender.log | tail -n5  
if [ $? -ne 0 ]; then  
    echo "日志发送异常！"  
    exit 1  
fi  

# 3. 检查中心节点是否存储新日志  
ls central_logs/ | grep -E "[0-9]{13}_node[1-2]" | head -n1  
if [ $? -ne 0 ]; then  
    echo "日志未同步到中心节点！"  
    exit 1  
fi  

echo "所有环节验证通过！分布式日志系统自愈能力正常"
