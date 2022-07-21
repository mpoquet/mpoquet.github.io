#!/usr/bin/env bash
set -eux

nix-build
rm -rf /tmp/site-dump
mkdir /tmp/site-dump
cp -r --no-preserve=all result/* /tmp/site-dump/
rm result

git checkout gh-pages
git reset --hard fee35b7ce673814db7f3119f607a3210c7f89af5
cp -r --no-preserve=all /tmp/site-dump/* ./
git add *
git commit -m 'dump'
