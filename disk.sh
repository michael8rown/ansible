#!/bin/bash
set -e -o pipefail

#   W A R N I N G ! !     W A R N I N G ! !     W A R N I N G ! !     W A R N I N G ! !

#   W A R N I N G ! !     W A R N I N G ! !     W A R N I N G ! !     W A R N I N G ! !

#   W A R N I N G ! !
#   W A R N I N G ! !
#   W A R N I N G ! !

# WARNING!! THIS SCRIPT IS DESTRUCTIVE!! IT'S A WORK IN PROGRESS. USE AT YOUR OWN RISK

rm -f .disk.txt

#cat p.txt | grep  disk | sed -E 's/^([^ ]+) .*$/\1/g' | wc -l
#exit

lsblk | grep " disk" | sed -E 's/^([^ ]+) .*$/\1/g' > .disk.txt

if [[ $(cat .disk.txt | wc -l) > 1 ]]; then
  echo "The following disks are present:"
  cat .disk.txt
  read -p "Which one are you partitioning? " device
  # NEED TO FIGURE OUT HOW TO PREVENT PROCEEDING IF VALID OPTION IS NOT CHOSEN
else
  device=$(cat .disk.txt)
fi

echo "Partioning for /dev/${device}"

read -p "How many partitions would you like to create? " parts

rm -f .disk.txt

for i in $(seq 1 $parts); do

  until [[ $type == [brhs] ]]; do
    read -p "Label for partition $i: (b)oot, (r)oot, (h)ome, or (s)wap " type
  done

  case $type in
    b) t=ef00 ;;
    r) t=8300 ;;
    h) t=8302 ;;
    s) t=8200 ;;
    *)
  esac

  read -p "Size for partition $i: (e.g., 16G or 1990M) " size

  echo "-n ${i}:0:+${size} -t ${i}:${t}" >> .disk.txt
  echo

  type=''

done

perl -i -pe 's/\n/ /g' .disk.txt

j=$(cat .disk.txt)

echo

sgdisk $j /dev/${device} -p
