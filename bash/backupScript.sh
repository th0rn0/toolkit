#!/bin/bash

TMP_DIR=/tmp/backups
BACKUP_DIR=/mnt/backups
DIR_NAME=$2-$(date '+%d-%m-%Y')

if [[ ! -e $TMP_DIR ]]; then
	mkdir $TMP_DIR
fi

cp -r $1 $TMP_DIR/$DIR_NAME
cd $TMP_DIR
tar -zvcf $DIR_NAME.tar.gz $DIR_NAME/


mv $DIR_NAME.tar.gz $BACKUP_DIR
ls $BACKUP_DIR
rm -rf $TMP_DIR/$DIR_NAME