<p align="center">
  <img src="![Untitled jepg](https://github.com/user-attachments/assets/307a396b-2edc-4b9c-b805-f974e2bb57cc)
" width="200">
</p>
# proxmox-casaos-deploy
A Bash script to automate the transformation of a raw Proxmox LXC container into a full-featured Home Media Server using CasaOS.
##  Features (At the moment)
*   **System Update:** Auto-updates Debian/Ubuntu repositories.
*   **Tools:** Installs `curl`, `wget`, `htop`, `neofetch`.
*   **CasaOS:** Installs the core OS using the official raw source.
*   **Media Ready:** Automatically creates the directory structure for **Jellyfin/Plex** (`/DATA/Media/Movies`, etc.) and sets permissions to avoid Docker issues
    ##  Usage
    ## Run this inside your fresh Proxmox LXC container:
    * wget https://raw.githubusercontent.com/damianiglesias/proxmox-casaos-deploy/main/setup_home_server.sh
    * ./setup_home_server.sh
