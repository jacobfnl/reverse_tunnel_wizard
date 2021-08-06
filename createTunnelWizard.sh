#!/bin/bash

if [ "$(whoami)" != 'root' ]; then
  echo "You must execute this script as root/sudo."
  echo "Exiting... "
  exit 1
fi

apt update
apt install autossh -y

echo -n "

Remote Port Identifier: "
read -r myport
echo -n "INTERMEDIATE account username: "
read -r mydomainuser
echo -n "INTERMEDIATE host address: "
read -r mydomain

#createuserprompt()
while true
do
  echo -n "
Create autotunnel user? [Y/n]: "
  read -r shouldCreateUser
  if [ "$shouldCreateUser" == 'y' ] || [ "$shouldCreateUser" == 'Y' ] || [ "$shouldCreateUser" == '' ];
  then
    echo "creating user:- autotunnel"
    useradd -m -s /sbin/nologin autotunnel
    cp copyid.sh /home/autotunnel/
    su - autotunnel -s ./copyid.sh "$mydomainuser" "$mydomain"
    rm /home/autotunnel/copyid.sh
    break
  elif [ "$shouldCreateUser" == 'n' ];
  then
    echo "skipping user creation"
    break
  fi
done


if [ -f /etc/systemd/system/watchmen.service ]
  then
      echo "watchmen service already exists, replacing..."
      rm /etc/systemd/system/watchmen.service
fi

cat << EOF >> /etc/systemd/system/watchmen.service
[Unit]
Description=Keep a tunnel to $mydomain open
After=network-online.target

[Service]
Type=forking
User=autotunnel
ExecStart=/usr/bin/autossh -f -M 0 -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=false -N $mydomainuser@$mydomain -R $myport:localhost:22
ExecStop=/usr/bin/pkill -9 -u autotunnel
Restart=always

[Install]
WantedBy=multi-user.target
EOF

cat << EOF >> connectToRemote
#!/bin/bash
ssh -i /home/autotunnel/.ssh/id_ed25519 "$mydomainuser"@"$mydomain"
EOF
chmod +x connectToRemote
cp connectToRemote /usr/bin/
rm connectToRemote

systemctl enable watchmen.service
systemctl start watchmen.service