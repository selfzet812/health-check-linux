# System Health-Check Script

A lightweight Bash utility for auditing and monitoring key Linux system components and resource metrics.

## Usage Examples

### 1. CPU & Load Metrics
Displays current system time, uptime, load average, and the top 5 CPU-consuming processes:

```bash
./health-check.sh cpu
```

**Example output:**
```text
-------CPU_STAT------------

load average: 0.00 0.00 0.00
uptime in hours: 9


-------Top_5_Cpu_Usage_Proc------------

    PID USER     %MEM %CPU COMMAND
  67565 ec2-user  0.2  0.0 bash
  68177 ec2-user  0.1  0.0 health-check.sh
  68180 ec2-user  0.1  0.0 ps
  68181 ec2-user  0.0  0.0 head
```

---

### 2. Memory Usage
Displays RAM utilization in `<used>/<total>` format and the top 5 memory-consuming processes:

```bash
./health-check.sh mem
```

**Example output:**
```text
-------Mem_Usage--------

MemUsed: 753/1909 Mb

-------Top_5_Mem_Usage_Proc------------

systemd-journal 1135 34.0352 mB
systemd 1 17.4688 mB
amazon-ssm-agen 1964 16.5586 mB
systemd-resolve 1589 15.375 mB
systemd 2122 14.1797 mB

-----------END------------
```

---

### 3. Disk Usage
Displays disks and partitions, total size, used and available space, usage percentage, and mount points:

```bash
./health-check.sh disk
```

**Example output:**
```text
Filesystem        Size  Used Avail Use% Mounted on 
/dev/nvme0n1p1     40G  2.2G   38G   6% /
/dev/nvme0n1p128   10M  1.3M  8.7M  13% /boot/efi
```

---

### 4. Network & Connectivity
Displays the default network interface status, internet access availability, DNS resolution and reachability of `google.com`, public IP address, and system hostname:

```bash
./health-check.sh network
```

**Example output:**
```text
ens5 interface status:  up
Instance have internet access
DNS                   : OK
serverIP:  123.123.123.123
hostname        : ip-172-1-11-111.eu-central-1.compute.internal
```
