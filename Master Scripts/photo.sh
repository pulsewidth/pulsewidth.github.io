#!/bin/bash

d=$(date +%y%m%d)
f=$d

if test -f "$1"; then
  echo "photo: $1"
  if [ $2 ]
    then f="$f-$2"
  fi
  echo "file: $f"
  high="log/image/high/$d.jpg"
  low="log/image/$d.jpg"
  convert $1 -auto-orient -resize 50% $high
  convert $high -auto-orient -resize 800 $low
  echo "[![$d](/$low)](/$high)" > log/$f.md
  vim log/$f.md
fi
