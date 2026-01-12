#!/bin/bash

# ==========================================
# PROXMOX CASAOS DEPLOYER
# Author: Damian Iglesias
# ==========================================

# Ccolours
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${BLUE}"
echo "   _____                 ____   _____ "
echo "  / ____|               / __ \ / ____|"
echo " | |     __ _ ___  __ _| |  | | (___  "
echo " | |    / _\` / __|/ _\` | |  | |\___ \ "
echo " | |___| (_| \__ \ (_| | |__| |____) |"
echo "  \_____\__,_|___/\__,_|\____/|_____/ "
echo "        DEPLOYER FOR PROXMOX          "
echo -e "${NC}"

# 1. Root status
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}Please run as root${NC}"
  exit
fi

# 2. update system
echo -e "${YELLOW}📦 Step 1: Updating System...${NC}"
apt-get update && apt-get upgrade -y
echo -e "${GREEN}✅ System Updated.${NC}"

# 3. installation utils 
echo -e "${YELLOW}🛠️ Step 2: Installing Utils (htop, neofetch, git)...${NC}"
apt-get update > /dev/null 2>&1
apt-get install curl wget git htop neofetch -y
if command -v neofetch &> /dev/null; then
    echo -e "${GREEN}✅ Utils installed.${NC}"
else
    echo -e "${YELLOW}⚠️  Retrying neofetch installation...${NC}"
    apt-get install neofetch -y
fi

# 4. casaos install
echo -e "${YELLOW}🏠 Step 3: Installing CasaOS...${NC}"
curl -fsSL https://get.casaos.io | bash

# 5. Media and movies config
echo -e "${YELLOW}📂 Step 4: Creating Media Directories...${NC}"
mkdir -p /DATA/Media/Movies
mkdir -p /DATA/Media/TV_Shows
mkdir -p /DATA/Downloads
chmod -R 777 /DATA/Media
echo -e "${GREEN}✅ Directories created at /DATA/Media${NC}"

# 6. Final
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo ""
echo -e "${GREEN}#############################################${NC}"
echo -e "${GREEN}#       🎉 HOME SERVER READY! 🎉            #${NC}"
echo -e "${GREEN}#############################################${NC}"
echo ""
echo -e "   Access your Dashboard at:"
echo -e "   👉 http://$IP_ADDRESS"
echo ""