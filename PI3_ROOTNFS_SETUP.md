# ROOTNFS setup and boot raspberry-pi 3b/b+ (Nov. 2018)

Before running this tutorial - please ensure:

- Create a folder for ROOT NFS (I use `~/rpi/rootnfs`)

## Global references

- `$ROOTNFS_HOME`: Directory where ROOT NFS for RPi is located

***This guide is mostly from [this blog post](https://blockdev.io/network-booting-a-raspberry-pi-3/)***

### Flash Raspbian and prepare RPi devices

1. Download and use latest Raspbian image

2. Flash to SD card, boot, run through standard config

3. Once flashed and updated, ensure SSH is enabled and GL driver (through `raspi-config`)

4. Disable swap on the device: 
```sh
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo update-rc.d dphys-swapfile remove
```

5. Update the RPi firmware and reboot:
```sh
sudo rpi-update
```

6. Edit `/boot/config.txt` to have an entry:
```sh
echo program_usb_boot_mode=1 | sudo tee -a /boot/config.txt
```

7. Finally, reboot the RPi:
```sh
sudo reboot
```

### Copy root filesystem from device to NFS server machine

I've had trouble copying directly from a re-mounted SD card - so I prefer to `rsync` over SSH to my workstation. After the image is copied I always create a tarball in case I mess up my chroot I'm installing into.

1. Ensure $ROOTNFS_HOME is created

2. `rsync` over SSH from RPi to NFS server (***NOTE: This can take a while***):
```sh
# Replace with your IP address of the RPi
sudo rsync -xa --progress --rsync-path="sudo rsync" --exclude '/var/swap' --stats pi@192.168.1.59:/ $ROOT_NFS
```

3. Create a backup of the filesystem on the server
```sh
sudo tar -czvf rootnfs-backup.tar.gz $ROOT_NFS
```

### Prepare ROOT NFS on server

***NOTE: I use Ubuntu LTS (18.04) and a Debian-based system.***

1. Ensure nfs-server is installed (`apt install nfs-kernel-server` )

2. Add `$ROOTNFS_HOME` to your exports path
```sh
echo "$ROOTNFS_HOME *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports
``` 

3. Update to ensure the new path is exported
```sh
sudo exportfs -rav
```

### Update boot partition on the SD card

Power off and remove the SD card on the RPi. Plug the SD card back into your workstation. Find out where the `/boot` partition of the device is mounted (This can vary - Ubuntu LTS usually auto-mounts at a path - use the disk util if you are not sure)

1. Make a copy of boot/cmdline.txt
```sh
cp /media/$USER/boot/cmdline.txt /media/$USER/boot/cmdline-backup.txt
```

2. Edit boot/cmdline.txt to NFS root boot:

```sh
# Insert-your-favorite editor here
# NOTE: My system auto-mounts at /media/$USER/boot
vim /media/$USER/boot/cmdline.txt
```

2.) Replace the entire contents with this line (ensure no extra new lines):
```
selinux=0 dwc_otg.lpm_enable=0 console=tty1 rootwait rw nfsroot=NFS_SERVER_IP_HERE:$ROOTNFS_HOME,v3 ip=dhcp root=/dev/nfs elevator=deadline
```

3.) Unmount and eject SD card.

4.) Plug back into RPi and boot - might take a few minutes before the device network boots off of the NFS root. 