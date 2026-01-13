#!/usr/bin/env bash

if systemctl is-active --quiet nginx; then
  echo "OK - nginx is running"
  exit 0
else
  echo "CRITICAL - nginx is NOT running"
  exit 2
fi
