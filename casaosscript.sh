#!/bin/bash

# ==========================================
# PROXMOX CASAOS DEPLOYER 
# Author: Damian Iglesias
# Version: 2.0
# ==========================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Logging setup
LOG_FILE="/var/log/casaos_deploy.log"
exec > >(tee -a "$LOG_FILE") 2>&1

clear
echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}       CASAOS DEPLOYER                       ${NC}"
echo -e "${BLUE}=============================================${NC}"

# 1. Check Root
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}❌ Please run as root${NC}"
  exit 1
fi

# 2. Maintenance Mode (If already installed)
if command -v casaos &> /dev/null; then
    echo -e "${YELLOW}ℹ️  CasaOS is already installed.${NC}"
    echo "1) Reset User Password"
    echo "2) Check Service Status"
    echo "3) Update System"
    echo "4) Exit"
    read -p "Select an option: " opt
    case $opt in
        1)
            read -p "Enter username: " username
            casaos-user-service-db-util -reset-user-password -u $username
            exit ;;
        2)
            systemctl status casaos --no-pager
            exit ;;
        3)
            apt update && apt upgrade -y
            exit ;;
        *) exit ;;
    esac
fi

# 3. New Installation Logic
echo -e "${YELLOW} Step 1: Installing Dependencies (fastfetch, etc)...${NC}"
apt-get update > /dev/null
apt-get install curl wget git htop fastfetch -y

# 4. Install CasaOS
echo -e "${YELLOW} Step 2: Running CasaOS Installer...${NC}"
curl -fsSL https://raw.githubusercontent.com/IceWhaleTech/get/main/get.sh | bash

# 5. Directory Structure
echo -e "${YELLOW} Step 3: Creating Media structure...${NC}"
mkdir -p /DATA/Media/{Movies,TV_Shows} /DATA/Downloads
chmod -R 777 /DATA/Media
echo -e "${GREEN}✅ Folders ready in /DATA/Media${NC}"

# 6. Final Health Check
echo -e "${YELLOW} Step 4: Final Health Check...${NC}"
if systemctl is-active --quiet casaos; then
    echo -e "${GREEN}✅ CasaOS Service: RUNNING${NC}"
else
    echo -e "${RED}❌ CasaOS Service: FAILED${NC}"
fi

IP_ADDR=$(hostname -I | awk '{print $1}')
echo -e "\n${GREEN}DONE! Log saved at $LOG_FILE${NC}"
echo -e "Access: http://$IP_ADDR"