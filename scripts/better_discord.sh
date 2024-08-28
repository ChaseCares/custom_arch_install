#!/usr/bin/env bash

export XDG_CONFIG_HOME="/home/chase/.config"

if ! betterdiscordctl reinstall; then
    betterdiscordctl install
fi
