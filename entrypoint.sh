#!/bin/sh

export SECRET_KEY=$(date +%s | sha256sum | base64 | head -c 32)
./manage.py runserver $HOST:$PORT