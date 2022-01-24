#!/bin/bash

wall    $'\t#Architecture:\t' \
                `uname -snrm` `head -n 2 /etc/os-release | grep "PRETTY" | cut -d '"' -f 2` \
        $'\n\t#CPU physical:\t' \
                `grep 'physical id' /proc/cpuinfo | uniq | wc -l` \
        $'\n\t#vCPU:\t\t' \
                `grep 'processor' /proc/cpuinfo | uniq | wc -l` \
        $'\n\t#Memory Usage:\t' \
                `free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3, $2, $3*100/$2}'` \
        $'\n\t#Disk Usage:\t' \
                `df -Bg | grep "/dev/" | grep -v "/boot" | \
                awk '{ud += $3} {fd += $2} END {print ud"/"fd "GB (" ud/fd*100 "%)"}'` \
        $'\n\t#CPU Load:\t' \
                `top -bn1 | grep '^%Cpu' | awk '{printf("%.1f%%"), $2 + $4}'` \
        $'\n\t#Last Boot:\t' \
                `who -b | awk '{print $3 " " $4}'` \
        $'\n\t#LVM use:\t' \
                `lsblk | grep "lvm" | awk '{if ($1) {print "yes";exit;} else {print "no"}}'` \
        $'\n\t#Conections TCP:' \
                `cat /proc/net/sockstat{,6} | \
                awk '$1 == "TCP:" {if ($3 > 0) {print $3 " ESTABLISHED"} else {print $3 " NOT ESTABLISHED"}}'` \
        $'\n\t#Use log:\t' \
                `users | wc -w` \
        $'\n\t#Network:\t' \
                'IP' `hostname -I | awk '{print $1}'` \
                `ip link show | grep "link/ether" | awk 'NR==1{print "(" $2 ")"}'` \
        $'\n\t#Sudo:\t\t' \
                `grep "sudo" /var/log/auth.log | wc -l` 'cmd'