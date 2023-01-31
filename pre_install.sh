#!/usr/bin/env bash

read -p "Enter username: " -r username
read -p "Enter password: " -r password

echo "Credentials username: '$username', password '$password'"
read -r -p "Continue? (Y/n): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

sed -i "s/__username__/$username/g" user_credentials.json
sed -i "s/__password__/$password/g" user_credentials.json

archinstall --config ./user_configuration.json --disk-layout ./user_disk_layout.json --creds ./user_credentials.json
