#!/usr/bin/env bash
set -eux

nix-build
rm -rf /tmp/site-dump
mkdir /tmp/site-dump
cp -r --no-preserve=all result/* /tmp/site-dump/
rm result

git checkout gh-pages
git reset --hard pre-dump
cp -r --no-preserve=all /tmp/site-dump/* ./
git add blog _downloads
git commit -m 'heavy dump (tarballs, pdf...)'
git branch -f heavy-dump
git clean -f
