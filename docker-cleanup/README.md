# 🐳 Docker Cleanup Script

## 📄 Documentation
This is a simple bash script to clean up your Docker environment by removing all containers and images. It's useful for freeing up disk space and starting fresh with Docker.

### dcleanup
This script performs the following operations:
- Stops all running Docker containers
- Removes all Docker containers (running or stopped)
- Removes all Docker images

## 📋 Usage
1. Make the script executable:
   ```bash
   chmod +x dcleanup
   ```

2. Optionally, move the script to a directory in your PATH for easy access:
   ```bash
   sudo mv dcleanup /usr/local/bin/
   ```

3. Run the script:
   ```bash
   dcleanup
   ```

## ⚠️ Warning
**CAUTION**: This script will remove ALL Docker containers and images from your system. 
This action cannot be undone. Make sure you have backups or can rebuild any important images 
before running this script.

## 🏗️ Architecture diagram
```mermaid
flowchart TD
    start[Start Script] --> stop[Stop All Containers]
    stop --> remove[Remove All Containers]
    remove --> rmi[Remove All Images]
    rmi --> complete[Cleanup Complete]
    
    classDef process fill:#e6f7ff,stroke:#333,stroke-width:1px,color:#000000
    classDef warning fill:#ffe6cc,stroke:#333,stroke-width:1px,color:#000000
    
    class start,stop,remove,rmi,complete process
```
