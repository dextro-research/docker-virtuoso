#! /bin/bash

# This file needs to be copied into the /data directory

export PATH=/usr/local/virtuoso-opensource/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export AWS_ACCESS_KEY_ID=<KEY_ID>
export AWS_SECRET_ACCESS_KEY=<SECRET_KEY>
export AWS_DEFAULT_REGION=us-east-1

mkdir -p /usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso_backups
mkdir -p /usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso_backups/backups

cd /usr/local/virtuoso-opensource/var/lib/virtuoso/db

NOW="$(date +"%m-%d-%y_%H_%M")-dextro-graph-backup"
mkdir -p virtuoso_backups/$NOW

# this would be the virtuoso backup method...
isql-v EXEC="dump_one_graph('http://dextro.co', './backup', 10000000);" -U <USER> -P <PASSWORD>

mv backup* virtuoso_backups/backups/${NOW}

cd /usr/local/virtuoso-opensource/var/lib/virtuoso/db
aws s3 sync virtuoso_backups s3://dextro-alexandria

# Remove backups more than 14 days old
find /usr/local/virtuoso-opensource/var/lib/virtuoso/db/virtuoso_backups/* -mtime +14 -exec rm -rf {} \;