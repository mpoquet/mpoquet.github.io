#!/usr/bin/env bash
set -eux

nix-build
rm -rf /tmp/site-dump
mkdir /tmp/site-dump
cp -r --no-preserve=all result/* /tmp/site-dump/
rm result

git checkout gh-pages
git reset --hard ff6a506646e43e581640f5d7e4c53659fc75d13b
cp -r --no-preserve=all /tmp/site-dump/* ./
git add *
git commit -m 'dump'
