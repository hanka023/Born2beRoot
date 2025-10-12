!!!!!!!!!!!!!!!!!!!!!  NOT WORKING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!!!!!!!!!!!!!!!!!!!DO NOT COPY THIS FILE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!




#!/bin/bashvcpu

#architecture
arch=$(uname -a)

#physical CPU
pcpu=$(grep "physical id" /proc/cpuinfo | wc -l)

#virtual CPU
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)

#total RAM / used ram / % of used ram / v MB 
tram=$(free -m | awk '$1 == "Mem:" {printf "%.2f", $2/1024}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free -m | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')



#total disks / used discs / %of using discs
tdisk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{t += $2} END {printf "%.2f", t/1024}')
udisk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{u += $3} END {print u}')
pdisk=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{u += $3} {t += $2} END {printf("%d"), u/t*100}')

#CPU load -> user load + system load
cpul=$(vmstat 1 2 | tail -1 | awk '{printf $15}')
cpu_op=$(expr 00 - $cpul)
cpu_fin=$(printf "%.1f" $cpu_op)

#Last boot
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

#LVM use = number of logical volumes / is LVM used? (yes/no)
lvmt=$(lsblk | grep -c "lvm" )
lvmu=$(if [ "$lvmt" -eq 0 ]; then echo no; else echo yes; fi)

# u need 2 install net tools [$ sudo apt install net-tools]

#number of active TCP connections
ctcp=$(ss -t | grep ESTAB | wc -l)

#active users
ulog=$(users | wc -w)

#IP address of machine
ip=$(hostname -I)

#MAC address
mac=$(ip link show |awk '$1 == "link/ether" {print $2}')

#number of using SUDO in journalct log
cmds=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "
        #Architecture: $arch
        #CPU physical: $pcpu
        #CPU virtual: $vcpu
        #Memory Usage: ${uram}MB/${tram}GB ${pram}%
        #Disk Usage: ${udisk}MB/$tdisk $pdisk%
        #CPU load: $cpul
        #Last boot: $lb
        #LVM use: $lvmu
        #Connexions TCP: $ctcp ESTABLISHED
        #User log: $ulog
        #Network: IP $ip ($mac)
        #SUdo: $cmds cmd
"

  #broadcast  info to all terminals





