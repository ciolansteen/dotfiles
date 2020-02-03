#!/bin/bash

### Mounting folders part
# Check for mount points

if mount | grep http > /dev/null; then
    echo "WWW folder mounted"
else
    echo "WWW folder not mounted"
fi
### Services running part
# Check for running services



