## 1.
Я не очень понял первый вопрос, ведь написанно, что нужно отразить 7 последних строк из wtmp и last, но last то команда. Я просто с помощью ласт вывел 7 последних строк.
```
[root@dev log]# last -n 7
root     pts/1        195.200.19.156   Mon Dec  2 16:32   still logged in
root     pts/0        217.66.159.14    Mon Dec  2 16:28   still logged in
root     pts/0        195.200.19.156   Thu Nov 28 18:56 - 19:11  (00:14)
root     tty1                          Mon Nov 25 18:06   still logged in
reboot   system boot  5.4.17-2136.310. Mon Nov 25 18:05   still running
reboot   system boot  5.4.17-2136.307. Mon Nov 25 18:02 - 18:05  (00:02)
reboot   system boot  5.4.17-2136.307. Mon Nov 25 17:27 - 18:01  (00:33)

wtmp begins Wed Sep 21 08:11:39 2022
```
## 2.
В описании утилиты написано:
kern cannot be generated from userspace process, automatically converted to user
```
[root@dev ~]# logger -p kern.info "wassup"
[root@dev ~]# sudo tail /var/log/messages
...
Dec  2 17:01:24 dev root[122747]: wassup
```
## 3.
```
[root@dev log]# journalctl -u systemd-logind -n 25
-- Logs begin at Mon 2024-11-25 18:05:35 UTC, end at Mon 2024-12-02 17:07:04 UTC. --
Nov 28 18:56:58 dev.local systemd-logind[633]: New session 3 of user root.
Nov 28 19:11:18 dev.local systemd-logind[633]: Session 3 logged out. Waiting for processes to exit.
Nov 28 19:11:18 dev.local systemd-logind[633]: Removed session 3.
Dec 02 16:28:10 dev.local systemd-logind[633]: New session 4 of user root.
Dec 02 16:32:42 dev.local systemd-logind[633]: New session 5 of user root.
Dec 02 16:59:21 dev.local systemd-logind[633]: Session 5 logged out. Waiting for processes to exit.
Dec 02 16:59:21 dev.local systemd-logind[633]: Removed session 5.
Dec 02 16:59:25 dev.local systemd-logind[633]: New session 6 of user root.
```
## 4.
```
[root@dev etc]# sudo nano /etc/rsyslog.d/mylog.conf
*.info    /var/log/my.log
[root@dev etc]# sudo touch /var/log/my.log
[root@dev etc]# sudo chmod 777 /var/log/my.log
[root@dev etc]# sudo chown root:root /var/log/my.log
[root@dev etc]# sudo systemctl restart rsyslog
[root@dev etc]# logger -p user.info "Test message 1"
[root@dev etc]# logger -p user.info "Test message 2"
[root@dev etc]# sudo tail /var/log/my.log
Dec  2 17:36:33 dev rsyslogd[124546]: [origin software="rsyslogd" swVersion="8.2102.0-7.el8_6.1" x-pid="124546" x-info="https://www.rsyslog.com"] start
Dec  2 17:36:33 dev systemd[1]: Started System Logging Service.
Dec  2 17:36:33 dev sudo[124541]: pam_unix(sudo:session): session closed for user root
Dec  2 17:36:33 dev rsyslogd[124546]: imjournal: journal files changed, reloading...  [v8.2102.0-7.el8_6.1 try https://www.rsyslog.com/e/0 ]
Dec  2 17:36:58 dev root[124551]: Test message 1
Dec  2 17:37:00 dev root[124552]: Test message 2
Dec  2 17:37:06 dev sshd[124553]: Connection closed by authenticating user root 45.15.158.98 port 53894 [preauth]
Dec  2 17:37:09 dev sudo[124556]:    root : TTY=pts/1 ; PWD=/etc ; USER=root ; COMMAND=/bin/cat /var/log/my.log
Dec  2 17:37:09 dev sudo[124556]: pam_unix(sudo:session): session opened for user root by root(uid=0)
Dec  2 17:37:09 dev sudo[124556]: pam_unix(sudo:session): session closed for user root
```
## 5.
```
[root@dev rsyslog.d]# sudo nano /etc/rsyslog.d/ssh.conf
authpriv.*    /var/log/ssh/ssh.log
[root@dev rsyslog.d]# sudo mkdir -p /var/log/ssh
[root@dev rsyslog.d]# sudo chmod 644 /var/log/ssh
[root@dev rsyslog.d]# sudo chown root:root /var/log/ssh
[root@dev rsyslog.d]# sudo systemctl restart rsyslog
[root@dev logrotate.d]# sudo nano ssh
/var/log/ssh/ssh.log {
    daily
    size 1M
    rotate 10
}
[root@dev logrotate.d]# sudo logrotate -f /etc/logrotate.d/ssh
[root@dev logrotate.d]# ls /var/log/ssh
ssh.log.1
```
## 6.
```
 journalctl --since "1 hour ago"
-- Logs begin at Mon 2024-11-25 18:05:35 UTC, end at Mon 2024-12-02 18:04:01 UTC. --
Dec 02 17:04:29 dev.local sshd[122778]: Invalid user ren from 45.15.158.98 port 55138
Dec 02 17:04:29 dev.local sshd[122778]: Connection closed by invalid user ren 45.15.158.98 port 55138 [preauth]
Dec 02 17:04:56 dev.local sshd[122781]: Received disconnect from 103.49.238.247 port 51118:11: Bye Bye [preauth]
Dec 02 17:04:56 dev.local sshd[122781]: Disconnected from authenticating user root 103.49.238.247 port 51118 [preauth]
Dec 02 17:05:00 dev.local sshd[122787]: Connection closed by authenticating user root 45.15.158.98 port 33222 [preauth]
Dec 02 17:05:30 dev.local sshd[122796]: Invalid user lilu from 45.15.158.98 port 48506
Dec 02 17:05:30 dev.local sshd[122796]: Connection closed by invalid user lilu 45.15.158.98 port 48506 [preauth]
Dec 02 17:06:01 dev.local sshd[122799]: Invalid user admin from 45.15.158.98 port 37752
Dec 02 17:06:01 dev.local sshd[122799]: Connection closed by invalid user admin 45.15.158.98 port 37752 [preauth]
Dec 02 17:06:32 dev.local sshd[122802]: Invalid user demo from 45.15.158.98 port 47784
Dec 02 17:06:32 dev.local sshd[122802]: Connection closed by invalid user demo 45.15.158.98 port 47784 [preauth]
Dec 02 17:07:04 dev.local sshd[122807]: Connection closed by authenticating user root 45.15.158.98 port 34966 [preauth]
Dec 02 17:07:36 dev.local sshd[122814]: Connection closed by authenticating user root 45.15.158.98 port 35562 [preauth]
Dec 02 17:08:06 dev.local sshd[122818]: Invalid user seafile from 103.49.238.247 port 33858
Dec 02 17:08:06 dev.local sshd[122818]: Received disconnect from 103.49.238.247 port 33858:11: Bye Bye [preauth]
Dec 02 17:08:06 dev.local sshd[122818]: Disconnected from invalid user seafile 103.49.238.247 port 33858 [preauth]
Dec 02 17:08:08 dev.local sshd[122821]: Connection closed by authenticating user root 45.15.158.98 port 43198 [preauth]
Dec 02 17:08:41 dev.local sshd[122824]: Connection closed by authenticating user root 45.15.158.98 port 40686 [preauth]
Dec 02 17:09:14 dev.local sshd[122827]: Invalid user vpn from 45.15.158.98 port 46118
Dec 02 17:09:14 dev.local sshd[122827]: Connection closed by invalid user vpn 45.15.158.98 port 46118 [preauth]
Dec 02 17:09:46 dev.local sshd[122830]: Invalid user students from 45.15.158.98 port 51868
Dec 02 17:09:46 dev.local sshd[122830]: Connection closed by invalid user students 45.15.158.98 port 51868 [preauth]
Dec 02 17:10:19 dev.local sshd[122833]: Connection closed by authenticating user root 45.15.158.98 port 41620 [preauth]
Dec 02 17:10:51 dev.local sshd[122836]: Connection closed by authenticating user root 45.15.158.98 port 47744 [preauth]
Dec 02 17:11:16 dev.local sshd[122839]: Invalid user avis from 103.49.238.247 port 33648
Dec 02 17:11:16 dev.local sshd[122839]: Received disconnect from 103.49.238.247 port 33648:11: Bye Bye [preauth]
Dec 02 17:11:16 dev.local sshd[122839]: Disconnected from invalid user avis 103.49.238.247 port 33648 [preauth]
Dec 02 17:11:23 dev.local sshd[122842]: Connection closed by authenticating user root 45.15.158.98 port 52562 [preauth]
lines 1-29
```