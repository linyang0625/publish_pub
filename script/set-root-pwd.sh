#!/usr/bin/env bash
sudo passwd root << EOF
$1
$1
EOF

su root << EOF
$1
sed -ri 's/^#?(PermitRootLogin)\s+(yes|no)/\1 yes/' /etc/ssh/sshd_config
sed -ri 's/^#?(PasswordAuthentication)\s+(yes|no)/\1 yes/' /etc/ssh/sshd_config

systemctl restart sshd
echo -e "\n"
EOF

echo -e "Setting login using root with password success!"
