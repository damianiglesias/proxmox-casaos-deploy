#!/bin/bash

# ==========================================
# � PROXMOX CASAOS DEPLOYER & ADMIN TOOL
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
echo -e "${BLUE}       CASAOS DEPLOYER & ADMIN TOOL          ${NC}"
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
    echo "3) Exit"
    read -p "Select an option: " opt
    case $opt in
        1)
            read -p "Enter username: " username
            casaos-user-service-db-util -reset-user-password -u $username
            exit ;;
        2)
            systemctl status casaos --no-pager
            exit ;;
        *) exit ;;
    esac
fi

# 3. Installation Logic
echo -e "${YELLOW}📦 Step 1: Installing Dependencies...${NC}"
apt-get update
apt-get install curl wget git htop neofetch -y
if ! command -v curl &> /dev/null; then
    echo -e "${RED}❌ FATAL ERROR: curl could not be installed. Check your internet connection.${NC}"
    exit 1
fi

# 4. Install CasaOS
echo -e "${YELLOW}🏠 Step 2: Running CasaOS Installer...${NC}"
curl -fsSL https://raw.githubusercontent.com/IceWhaleTech/get/main/get.sh | bash

# 5. Directory Structure
echo -e "${YELLOW}📂 Step 3: Creating Media structure...${NC}"
mkdir -p /DATA/Media/Movies
mkdir -p /DATA/Media/TV_Shows
mkdir -p /DATA/Downloads
chmod -R 777 /DATA/Media
echo -e "${GREEN}✅ Folders ready in /DATA/Media${NC}"

# 6. Final Health Check
echo -e "${YELLOW}🏥 Step 4: Final Health Check...${NC}"
sleep 5 
if systemctl is-active --quiet casaos; then
    echo -e "${GREEN}✅ CasaOS Service: RUNNING${NC}"
else
    echo -e "${RED}❌ CasaOS Service: FAILED TO START${NC}"
fi

IP_ADDR=$(hostname -I | awk '{print $1}')
echo -e "\n${GREEN}DONE! Log saved at $LOG_FILE${NC}"
echo -e "Access: http://$IP_ADDR"
