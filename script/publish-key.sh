#!/bin/bash
sshkey_home="/root/jenkins_sshkey"
rm -rf $sshkey_home
mkdir $sshkey_home
ssh-keygen -t rsa -f "$sshkey_home/id_rsa" -N ""

#at $sshkey_home/id_rsa.pub >> /root/.ssh/authorized_keys
#ssh -o StrictHostKeyChecking=no -i $sshkey_home/id_rsa root@127.0.0.1
#echo "Login self success!"

while read ip pwd; do 
#expect scp_pub.exp $ip $pwd "$sshkey_home/id_rsa.pub"
expect << EOF
spawn scp -o StrictHostKeyChecking=no $sshkey_home/id_rsa.pub root@$ip:/root/my_id_rsa.pub
expect "password:"
send "$pwd\r"
expect eof
EOF

expect << EOF
    spawn ssh root@$ip
    expect "password:"
    send "$pwd\r"
    expect "*#*" {send "cat /root/my_id_rsa.pub >> /root/.ssh/authorized_keys && rm -f /root/my_id_rsa.pub\r"}
    expect "*#*"
    send "exit\r"
    expect eof
    spawn ssh -i "$sshkey_home/id_rsa" root@$ip
    expect "]#" {send "echo 'Login $ip using ssh key success!'\r"}
    expect "]#" {send "exit\r"}
    expect eof
EOF
done < /root/.ssh/servers.txt

