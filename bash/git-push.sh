#!/usr/bin/env bash

## make the script executable
## chmod +x git-push.sh
NOWT=$(date +"%Y-%m-%d %T")
git add .
git commit -m "$NOWT Automated git push"
git push origin main


