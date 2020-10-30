

RedHat:RHCA / Preparation CentOs 

echo 'hello' >>fichier.stdout (ajouter dans le fichier hello sans ecraser le contenu)
echo 'hello' >fichier.stdout (ajouter dans le fichier hello, on ecrasons le contenu de fichier)
cat >fin (j'écris dans le fichier fin en temp réel et je ferme avec ctr)
cat >fin >>END (j'écris dansns le fichier fin en temp réel et je ferme quand je tape le mot END)

To change hostname 
--------------------------------------------------------
hostnamectl
hostname -f yeste-desktop
hostnamectl set-hostname yeste-desktop
hostctl set hostname yeste-desktop
hostnamectl


Compression and archiving 
--------------------------

Tar 'archiving '
tar -cvf  'nameofthefile' ....
tar -xcvf 'nameofthefile' ....
tar -jcvf 'nameofthefile' ....
tar -zcvf 'nameofthefile' ....

zip (1)              - package and compress (archive) files
tar (1)              - manual page for tar 1.26
tar (5)              - format of tape archive files
gzip (1)             - compress or expand files


symbolic link:
-------------

ln -s  file1 file2 

Hard link:
-----------

ln file1 file2 


Read the manuel :
-----------------
man 'command'
info 'command'
whatis 'command'
apropos 'command'
usr/share/doc

Runlevel
----------- 

O>>> Halt
1>>> single user mode 
2>>> multiuser, no network*
3>>> multiuser with network
4>>> not used 
5>>> multiuser, network , X windows graphical 
6>>> Reboot

To apply the runlevel
---------------------------------------------------------------
telinit 'number of runlevel'
init 'number of runlevel'
shutdown -r (Reboot)
shutdown -h (Halt)

vi /etc/inittab (file with number of actual runlevel)
Or 'to run runlevel 3'
[root@yeste-desktop ~]# systemctl set-default multi-user.target 
Removed symlink /etc/systemd/system/default.target.
Created symlink from /etc/systemd/system/default.target to /usr/lib/systemd/system/multi-user.target.
for 'runlevel 5'
[root@yeste-desktop ~]# systemctl set-default graphical.target 


----------------------------------------------------------------
Conditions ...

Cpu :
-Ask if the process should be using a lot cpu ...
   -If yes, renice If no, kill

RAM :
-check swap
-If it seems wrong kill it 

I/o :
-Often temporary, can really slow down a system ! 'check wait time'
-----------------------------------------------------------------

Kill PID
Killall -9 firefox
pKill -9 <pattern>


signel process:
sighup : 1
sigkill: 9   force
sigterm: 15 'default'

"before pkill is used, pgrep is wise !!"

------------------------------------------------------------------
Nice level :
------------ 

-20 : highest priority
  0 : normal, defeult priority
 19 : lowest priority 

 nice -n 0 firefox
 renice -n 19 firefox 

 chkconfig --list (process stared in which runlevel etc...)

 --------------------------------------------------------------------
Partition :
-----------

fdisk 
parted

Disk utility -- GUI

LVM : 'manage using system-config-lvm tools or command ligne '
-------------------------------------------------------------------

pvcreate /dev/sdb  'physical volume created'
pvdisplat          'Display your physical volume'
vgcreate VG-centosdesktop /dev/sdb  'volume group created'
vgextend VG-centosdesktop /dev/sdc  'Extend the volume group'
lvcreate -L 2G VG-Centosdesktop      'Create a local volume into the group volum VG-Centosdesktop'
lvrename /dev/VG-Centosdesktop/lvol0 /dev/VG-Centosdesktop/lv-data
lvextend -L +0.6G /dev/VG-Centosdesktop/lv-data  'to reseize your logical volume and add 0.6G'

Mount your logical volume .
---------------------------
lsblk : To check the tree of disques
cd /mnt
ls
sudo mkdir -vp /mnt/centos/{data,pic}
ls
cd centos/
mount /dev/VG-Centosdesktop/lv-data /mnt/centos/data
mount /dev/VG-Centosdesktop/lv-pic /mnt/centos/pic

To see our logical volume :
----------------------------------------------------------------------------------------------
'Filesystem                              Size  Used Avail Use% Mounted on
/dev/sda3                                18G  4.6G   14G  26% /
devtmpfs                                1.2G     0  1.2G   0% /dev
tmpfs                                   1.2G     0  1.2G   0% /dev/shm
tmpfs                                   1.2G   11M  1.2G   1% /run
tmpfs                                   1.2G     0  1.2G   0% /sys/fs/cgroup
/dev/sda1                               297M  171M  126M  58% /boot
tmpfs                                   233M   28K  233M   1% /run/user/1000
/dev/sr0                                 56M   56M     0 100% /run/media/sysadmin/VMware Tools
/dev/mapper/VG--Centosdesktop-lv--data  2.5G  7.9M  2.4G   1% /mnt/centos/data
/dev/mapper/VG--Centosdesktop-lv--pic   2.0G  6.0M  1.8G   1% /mnt/centos/pic
[root@localhost centos]# 
'

-----------------------------------------------------------------------------------------------

Pasta = data
filesystem = Box it comes in 
Journal = label on the box (ext3/ext4)

type of filesystem 

ext4 = for the most of all types of filesystem (linux base > most used)
ext2/ext3 = large filesystem
XFS/rieserfs = for litle chunk of Data 


mount and create a fils-type
----------------------------------
mount -t ext4 /dev/sdc2 /etc/log
mkfs.ext4 /dev/sdc2
mkfs.ext4 /dev/sdc3
mkfs.xfs /dev/sdc4
mkfs.swap /dev/sdc5
mkfs.xfs -f /dev/sdc4
mount -t ext4 /dev/sdc2 /var/log/coollog
mount -t ext4 /dev/sdc3 /etc/log
umont /dev/sdc3 'to unmount'



encrypt Partition with cryptsetup 
-----------------------------------
cryptsetup luksFormat 'devnamepartition'
cryptsetup luksOpen   'devnamepartition' 'name'
cryptsetup luksClose  'devnamepartition' 'name'

exemple:
----------
[root@localhost ~]# umount /dev/sdc4
[root@localhost ~]# cryptsetup luksFormat /dev/sdc4

WARNING!
========
This will overwrite data on /dev/sdc4 irrevocably.

Are you sure? (Type uppercase yes): YES
Enter passphrase: 
Verify passphrase: 
[root@localhost ~]# 
[root@localhost ~]# cryptsetup luksOpen /dev/sdc4 enryptdata
Enter passphrase for /dev/sdc4: 
[root@localhost ~]# ls -l /dev/mapper/
total 0
crw-------. 1 root root 10, 236 Apr 26 06:23 control
lrwxrwxrwx. 1 root root       7 Apr 26 08:52 enryptdata -> ../dm-2
lrwxrwxrwx. 1 root root       7 Apr 26 06:23 VG--Centosdesktop-lv--data -> ../dm-0
lrwxrwxrwx. 1 root root       7 Apr 26 06:23 VG--Centosdesktop-lv--pic -> ../dm-1
[root@localhost ~]# 

Mount the encrypted filesystem:
---------------------------------

[root@localhost ~]# mkfs.ext4 /dev/mapper/enryptdata
[root@localhost ~]# mount /dev/mapper/enryptdata /root/Downloads/movies
[root@localhost ~]# 
[root@localhost ~]# ls -l /dev/mapper/enryptdata 
lrwxrwxrwx. 1 root root 7 Apr 26 08:58 /dev/mapper/enryptdata -> ../dm-2
[root@localhost ~]# 
root@localhost ~]# umount /root/Downloads/movies
[root@localhost ~]# 
[root@localhost ~]# cryptsetup luksClose enryptdata
[root@localhost ~]# 
[root@localhost ~]# 
---------------------------------------------------------------------------------------

chmoding,chowning,chgrping FOR PERMESSIONS 

r=4, w=2, o=1
chmod ugo+rwx 'filesystem' (total control 777 to all user group, and other)
Or 
chmod 777 'filesystem' (total control 777 to all user group, and other)

chmod u-wx 'filesystem' (remove write and excute for the user)
chmod go-rw  'filesystem' (remove read and write for group and other)

chown yeste.revengers 'filesystem' (to change the owner and group for the filesystem)
chgrp  revengers 'filesystem' (to change the group for the filesystem)


Another PERMESSIONS 'SPECIAL'

r=s, g=s, o=t

chmod u+S  'filesystem' > sets SUID=4
chmod g+s  'filesystem' > sets SGID=2
chmod o+t  'filesystem' > sets Sticky bit=1

chmod 4421 > s--|r--|--x 
chmod 6421 > r--|-w-|--x

---------------------------------------------------------------------------------------------
ACLs PERMESSIONS (getfacl and setfacl)
-----------------------------------------
setfacl -m  'ACL'   'file'  (modify)
setfacl -b  'ACL'   'file'  (ecrase acl info)
setfacl -d  'ACL'   'file'  (set default act info)
setfacl -k  'ACL'   'file'  (ecrase default acl info)


To add acl (the user yeste to be RW into rootfile.txt )

[root@localhost afolder]# getfacl rootfile.txt 
# file: rootfile.txt
# owner: root
# group: root
user::rw-
group::---
other::---

[root@localhost afolder]# setfacl -m u:yeste:rw rootfile.txt 
[root@localhost afolder]# 
[root@localhost afolder]# 
[root@localhost afolder]# getfacl rootfile.txt 
# file: rootfile.txt
# owner: root
# group: root
user::rw-
user:yeste:rw-
group::---
mask::rw-
other::---
[root@localhost afolder]# ls -l
total 8
-rw-rw-r--. 1 root root  0 Apr 30 05:10 myfile.txt
-rw-rw----+ 1 root root 23 Apr 30 05:21 rootfile.txt

To remove acl from a file .
----------------------------

[root@localhost afolder]# setfacl -b rootfile.txt 
[root@localhost afolder]# ls -l
total 4
-rw-rw-r--. 1 root root  0 Apr 30 05:10 myfile.txt
-rw-------. 1 root root 23 Apr 30 05:21 rootfile.txt
[root@localhost afolder]# 

--------------------------------------------------------------------------------------
Local account
--------------

/etc/passwd  > user info
/etc/group   > more secure, password info
/etc/shadow  > group info
/etc/gshadow > group passwords  

useradd,usermod,userdel | groupadd,groupmod,groupdel
passwd > to change password
chage -l  > more details about users password 


--------------------------------------------------------------------------------------

Configure network 
-----------------

To disable Gui NetworkManager :

[root@localhost afolder]# service NetworkManager stop
Redirecting to /bin/systemctl stop NetworkManager.service
[root@localhost afolder]# chkconfig NetworkManager off 


static steps:

 1) set IP > /etc/sysconfig/network-scripts
 2) set Gateway > /etc/sysconfig/network
 3) set DNS > /etc/resolv.Config
-----------------------------------------------------------------------------------------

Hosting virtual machines
-------------------------

yum groupinstall "group1" "group2" "group3"

yum groupinstall virtualization "virtualization client" "virtualization platform"  "virtualization tools"


---------------------------------------------------------------------------------------------
manage package RPM with yum
----------------------------
Yum search                  Yum install/update
-----------                 -------------------
yum search 'apache'         yum install 
yum list                    yum remove
yum list installed          yum update
yum grouplist               yum groupinstall
yum info                    yum localinstall
yum reposit all

------------------------------------------------------------------------------------------------
Apache On CentOs 'httpd'
-------------------------

-config files in 2 places:
  etc/sysconfig/httpd
  etc/httpd
-files served from /var/www/html/index.html

launch 'localhost' into firefox check if its apache installed 
if we need that the httpd service start automatiquely on boot :
chkconfig httpd on


------------------------------------------------------------------------------------------
FTP on Centos (very secure ftpd) :vsftpd
-------------------------------------------

fileconfig : /etc/vsftpd
file : /var/ftp/pub

if we need that the service start automatiquely on boot :
chkconfig vsftpd on

------------------------------------------------------------------------------------------

Cron and time services
-------------------------
Runs in 3 ways 

1)cron.hourly,cron.daily,cron.monthly,cron.weekly
  -/etc/cron.hourly
  -/etc/cron.daily
  -/etc/cron.monthly
  -/etc/cron.weekly

2)/etc/crontab and /etc/cron.d (has extra field for user) 

3)personal crontab


NTP time server 
----------------

service ntpd start
service ntpd stop 
ntpdate pool.ntp.org (to configure ur time correctly with an existing global ntp server )
chkconfig ntpd on (to start automatiquely in boot)
date (to check date of the server)

-------------------------------------------------------------------------------------------------
Security ENhanced Linux (SElinux)
----------------------------------
"If you've configured thing correctly , but stuff doesn't work look for SElinux issues"

/etc/sysconfig/SElinux

setenforce 1   (to enable enforcing selinux mode)
setenforce 0   (to disable enforcing selinux mode)

SELINUX=enforcing, permissive, disable  