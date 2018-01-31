#!/usr/bin/env bash
set -eu

# Generate the static pages in public/
hugo

# Switch to the master branch
git checkout master

# Clone public/ to ./
rsync -r --exclude='.git/' --exclude='public/' --delete-after public/ ./

# Add modifications
git add --all
git reset -- public/
