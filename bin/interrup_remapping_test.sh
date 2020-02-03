#!/bin/sh
for i in $(dmesg | grep ecap | awk '{print $NF}'); do
  if [ $(( (0x$i & 0xf) >> 3 )) -ne 1 ]; then
    echo "Interrupt remapping not supported"
    exit 1
  fi
done
