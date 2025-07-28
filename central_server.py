from http.server import BaseHTTPRequestHandler, HTTPServer  
import os  

class LogHandler(BaseHTTPRequestHandler):  
    def do_POST(self):  
        content_len = int(self.headers.get('Content-Length'))  
        log_data = self.rfile.read(content_len).decode()  
        log_id = log_data.split(':')[0]  
        # 确保存储目录存在  
        os.makedirs('central_logs', exist_ok=True)  
        # 去重逻辑：仅当日志不存在时写入  
        log_path = f'central_logs/{log_id}.log'  
        if not os.path.exists(log_path):  
            with open(log_path, 'w') as f:  
                f.write(log_data)  
            self.send_response(200)  
        else:  
            self.send_response(409)  # 冲突：日志已存在  
        self.end_headers()  

if __name__ == '__main__':  
    # 绑定本地IP，允许同局域网访问（若要外网访问，改0.0.0.0）  
    server = HTTPServer(('127.0.0.1', 8000), LogHandler)  
    print("中心节点启动：http://127.0.0.1:8000")  
    server.serve_forever()

sys.stdout = open('central_server.log', 'w')
