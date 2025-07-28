# Termux Lightweight Distributed Logging System
 
A hands-on project for simulating distributed log pipelines in constrained environments
 
Overview
 
I built this project to practice distributed system observability under resource constraints (using Termux on Android). It’s a lightweight pipeline that handles multi-node log collection, failure recovery, and real-time monitoring—all scripts and logic are written from scratch, with SSH for secure GitHub sync.
 
What I Implemented
 
- Multi-node log emission: Each Termux instance (simulating a "node") generates unique logs with timestamp+nodeID to avoid duplication.
- Failure resilience: Local caching for failed logs ( failed_logs.txt ) and automatic retries when the central server recovers.
- Proactive monitoring: A bash script ( monitor.sh ) checks server liveness, log latency, and disk usage—triggers Termux notifications on anomalies.
- One-click workflows:  start_all.sh  to spin up services,  verify.sh  to validate end-to-end functionality (critical for quick debugging).
 
Prerequisites
 
- Environment: Termux (tested on Android 13)
- Dependencies (I had to troubleshoot these initially):
# Install core tools for notifications and network checks  
pkg install termux-tools netcat-openbsd -y  

# Install HTTP client library for inter-node communication  
pip install requests  
 
 
Getting Started
 
1. Clone the Repo (SSH for Secure Access)
 
I prefer SSH over HTTPS for GitHub sync (avoids repeated password input):
 
# Clone via SSH (replace with your repository URL)  
git clone git@github.com:your-username/termux-log-system.git  

# Navigate to project directory  
cd termux-log-system  
 
 
2. Launch the Central Server
 
Starts an HTTP server to receive and store logs:
 
python3 central_server.py  
# Success indicator: "Central server running on http://127.0.0.1:8000"  
 
 
3. Start Log Producers (Simulate Distributed Nodes)
 
Open new Termux sessions (or split panes) to mimic multiple nodes:
 
# Node 1  
python3 log_sender.py --node node1 --server http://127.0.0.1:8000  

# Node 2 (for scale testing)  
python3 log_sender.py --node node2 --server http://127.0.0.1:8000  
 
 
4. One-Click Deployment
 
I wrote  start_all.sh  to avoid manual steps (super useful for demos!):
 
# Make the script executable 
chmod +x start_all.sh  

# Launch all services with one command  
./start_all.sh  
 
 
5. Validate the System
 
 verify.sh  checks if logs flow correctly from nodes to the central server:
 
# Make the script executable  
chmod +x verify.sh  

# Run validation  
./verify.sh  
# Success output: "All components working—logs synced properly"  
 
 
6. Monitor in Real-Time
 
 monitor.sh  runs in the background to catch issues (I added this after a server crash during testing):
 
# Make the script executable  
chmod +x monitor.sh  

# Start monitoring  
./monitor.sh  
 
 
Triggers Termux notifications for:
 
- Central server downtime (port 8000 unresponsive)
- Log latency >10s (stuck in  failed_logs.txt )
- Disk usage >80% (Termux storage is limited!)
 
Key Learnings (Relevant for Interviews)
 
- SSH over HTTPS: Using SSH for GitHub sync reduced auth friction—had to troubleshoot  known_hosts  issues initially (fixed by  ssh-keygen  and adding keys to GitHub).
- Bash scripting quirks: Handling exit codes in  verify.sh  and  monitor.sh  taught me to test edge cases (e.g., empty log files).
- Distributed systems basics: Designing retry logic showed me why idempotency matters (avoid duplicate logs when retrying).
 
Repository Structure
 
termux-log-system/  
├── central_server.py   # Receives and stores logs  
├── log_sender.py       # Generates and sends logs from nodes  
├── monitor.sh          # Health checks + alerts  
├── start_all.sh        # One-click deployment  
├── verify.sh           # End-to-end validation  
└── README.md           # Project documentation  
 
 
Contributing
 
Feel free to fork and tweak! I’m still optimizing the log ID algorithm for higher concurrency—pull requests welcome.
