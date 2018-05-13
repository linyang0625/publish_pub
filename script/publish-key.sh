#!/bin/bash
yum install -y sshpass

sshkey_home="/root/jenkins_sshkey"
rm -rf $sshkey_home
mkdir $sshkey_home
ssh-keygen -t rsa -f "$sshkey_home/id_rsa" -N ""

while read ip pwd
do 
#echo "$ip || $pwd"
sshpass -p $pwd ssh-copy-id -o StrictHostKeyChecking=no -i $sshkey_home/id_rsa.pub root@$ip
done < server.txt 
