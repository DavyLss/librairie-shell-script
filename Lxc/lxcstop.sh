#!/bin/bash

########################################################
#Script permet juste de stopper tout les containers lxc#
#et d'éteindre le machine hôte, pratique pour proxmox  #
########################################################
apt install parallel -y
lxc-ls -f | grep RUNNING | cut -f 1 -d " " | parallel lxc-start {}
