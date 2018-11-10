#!/bin/bash
# Clones a RPi file system locally
#   Usage: ./clone.sh pi@192.168.1.59 /nfs/clientX.
sudo rsync -xa --progress --rsync-path="sudo rsync" --exclude '/var/swap' --stats $1:/ $2
grep proc $2/etc/fstab > $2/etc/fstab.new
mv $2/etc/fstab.new $2/etc/fstab
