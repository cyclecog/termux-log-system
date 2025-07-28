import requests  
import time  
import os  
import argparse  

parser = argparse.ArgumentParser()  
parser.add_argument('--node', default='node1', help='节点标识')  
parser.add_argument('--server', default='http://127.0.0.1:8000', help='中心节点地址')  
args = parser.parse_args()  

CENTRAL_URL = args.server  
NODE_NAME = args.node  
RETRY_COUNT = 3  

# 生成唯一日志ID：时间戳（毫秒）+ 节点标识 + 随机数（可选）  
def get_unique_log_id():  
    return f"{int(time.time() * 1000)}_{NODE_NAME}"  # 毫秒级时间戳+节点名，确保唯一  

def send_log(log_id, content):  
    for i in range(RETRY_COUNT):  
        try:  
            resp = requests.post(CENTRAL_URL, data=f"{log_id}:{content}".encode())  
            if resp.status_code == 200:  
                print(f"日志{log_id}发送成功")  
                return  
        except Exception as e:  
            print(f"尝试{i+1}失败：{str(e)}，2秒后重试...")  
            time.sleep(2)  
    print(f"日志{log_id}发送失败，记录到本地缓存")  
    with open('failed_logs.txt', 'a') as f:  
        f.write(f"{log_id}:{content}\n")  

if __name__ == '__main__':  
    while True:  
        log_id = get_unique_log_id()  # 每次生成唯一ID  
        content = f"user_action,time={time.time()},node={NODE_NAME}"  
        send_log(log_id, content)  
        time.sleep(5)
