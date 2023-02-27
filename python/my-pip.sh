#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "No package name supplied."
    exit 1
fi

PACKAGE_NAME="$1"

pip install -U pip

if pip install "$PACKAGE_NAME"; then
    echo "$PACKAGE_NAME" >>./requirements.txt
fi
