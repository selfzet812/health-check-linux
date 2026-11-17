#!/bin/bash

target_ips=("1.1.1.1" "9.9.9.9" "208.67.222.222") #Cloudflare, Quad9, Cisco OpenDNS

#CPU STAT
cpu() {
  echo $'\n\n-------CPU_STAT------------\n'
  awk '{print "load average: " $1, $2, $3 }' /proc/loadavg
  awk '{print "uptime in hours: "int($1 % 86400) /  3600 }' /proc/uptime
  echo $'\n\n-------Top_5_Cpu_Usage_Proc------------\n'
  ps -o pid,user,%mem,%cpu,comm --sort=-%cpu  | head -n6

}

#RAM STAT
mem() {
  echo $'\n-------Mem_Usage--------\n'
  awk '/MemTotal:/ {a=$2} /MemFree:/ {b=$2} END {printf "MemUsed: " int((a - b) / 1024 ) "/" int(a / 1024) " Mb"  }' /proc/meminfo
  echo $'\n\n-------Top_5_Mem_Usage_Proc------------\n'
  awk '/^Name:/ {c=$2} /^Pid:/ {b=$2}  /^VmRSS:/ {int(a=$2 / 1024); print c, b, a " mB"}' /proc/[0-9]*/status  | sort -rnk3 | head -n5
  echo $'\n-----------END------------\n'

}




#DISK STAT
disk() {
  echo $'\n-------Disk_Usage--------\n'
  echo $'\nFilesystem        Size  Used Avail Use% Mounted on '
  df -h | sort | head -n2
  echo $'\n-----------END------------\n'
}



#network check
#verify state of the default interface is UP
#check ICMP connectivity to trusted IPs 
#verify DNS resolution and reachability of google.com


network() {
  echo $'\n---------------NETWORK---------------\n'
  iface=$(awk 'NR == 2 {print $1}' /proc/net/route) #find out the standard interface
  iface_status=$(cat /sys/class/net/$iface/operstate)
  echo "$iface interface status: " "$iface_status" 
     
  if [[ "$iface_status" = "up"  ]]; then
    
    for i in "${target_ips[@]}"; do
      if ping -c 1 -W 2 "$i" > /dev/null 2>&1; then
        echo "Instance have internet access"
          
          if getent hosts google.com > /dev/null; then
            echo "DNS                   : OK"
          else
            echo "DNS                   : FAIL"
          fi 
       
       break
      else
        echo "can't ping target L3\L4 PROBLEM !"
      fi
    
    done  
  fi
  echo "serverIP: " $(curl -s -m 3 checkip.amazonaws.com) #in other case when u have pub_ip at interface info u can use hostname -I  
  echo "hostname        : ""$HOSTNAME"
  echo $'\n---------------END---------------\n'
}

case "$@" in
  "")
    cpu; mem; disk; network 
    ;;
  mem|cpu|network|disk)  
    "$@"
    ;;
  *)
    echo 'unknown command: ' "$@"
    ;;
esac
