#!/data/data/com.termux/files/usr/bin/bash  

# 1. 启动中心节点（后台运行，避免阻塞）  
echo "启动中心节点..."  
python3 central_server.py &  
sleep 3  # 等待中心节点初始化  

# 2. 启动日志源节点1  
echo "启动日志源node1..."  
python3 log_sender.py --node node1 --server http://127.0.0.1:8000 &  

# 3. 启动日志源节点2  
echo "启动日志源node2..."  
python3 log_sender.py --node node2 --server http://127.0.0.1:8000 &  

echo "所有服务启动完成！可通过以下命令查看日志："  
echo "  - 中心节点：tail -f central_server.log"  
echo "  - 日志源：tail -f log_sender_node1.log （需手动把输出重定向到文件）"
