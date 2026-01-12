# proxmox-casaos-deploy
A Bash script to automate the transformation of a raw Proxmox LXC container into a full-featured Home Media Server using CasaOS.
#  Features (At the moment)
*   **System Update:** Auto-updates Debian/Ubuntu repositories.
*   **Tools:** Installs `curl`, `wget`, `htop`, `neofetch`.
*   **CasaOS:** Installs the core OS using the official raw source.
*   **Media Ready:** Automatically creates the directory structure for **Jellyfin/Plex** (`/DATA/Media/Movies`, etc.) and sets permissions to avoid Docker issues
    #  Usage
    ## Run this inside your fresh Proxmox LXC container:
    ### wget https://raw.githubusercontent.com/damianiglesias/proxmox-casaos-deploy/main/setup_home_server.sh
    ### ./setup_home_server.sh
