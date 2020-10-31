#!/bin/bash

USER_HOME=/home/ops-user
mkdir -p $USER_HOME/.ssh
chmod 700 $USER_HOME/.ssh

authorized_keys=$USER_HOME/.ssh/authorized_keys
touch $authorized_keys
chmod 600 $authorized_keys

touch $authorized_keys
for user in $GITHUB_USERS; do
  echo "Getting ${user}'s public key from GitHub"
  curl -s "https://github.com/${user}.keys" >> $authorized_keys
done
echo "" >> $authorized_keys
chown -R ops-user:ops-users $USER_HOME
echo "Starting SSH daemon"
/usr/sbin/sshd -D

