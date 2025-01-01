#!/bin/bash

read -p "Enter the username whose permission you want to check: " username

if [ ! -d "$username" ]; then
  echo "User doesn't exists"
  exit 1
fi

kubectl auth can-i --list --context="$username-context"
