#!/usr/bin/env bash

USER_CREATED=false

set_up_user() {
    if [[ "$USER_CREATED" == false ]]; then
        read -p "Enter username: " -r username
        read -p "Enter password: " -r password

        echo "Credentials username: '$username', password '$password'"
        read -r -p "Continue? (Y/n): " response && [[ $response == [yY] ]] || exit 1

        sed -i "s/__username__/$username/g" ./install_configs/user_credentials.json
        sed -i "s/__password__/$password/g" ./install_configs/user_credentials.json

        USER_CREATED=true
    else
        echo "User already created"
    fi
}

archinstall --config ./install_configs/user_configuration.json --disk-layout ./install_configs/user_disk_layout.json --creds ./install_configs/user_credentials.json
