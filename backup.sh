#!/bin/bash
# @author: Sébastien SERRE
# @mail: sebastien@thivinfo
# License: GPL
#
# Backup directory constant
DST=/path/to/files/backup/storage
DSTDB=/path/to/files/backup/storage
DATE=`date +%d-%m-%Y`

## Delete more than X days backup
#
echo "Start Cleaning : "`date "+%d-%m-%Y %T"` >> $DST/log
find $DST -type f -mtime +X | xargs -r rm # replace X by number of days you want to keep
find $DSTDB -type f -mtime +X |xargs -r rm # replace X by number of days you want to keep
echo "Stop Cleaning : "`date "+%d-%m-%Y %T"` >> $DST/log

echo "Start Copy : "`date "+%d-%m-%Y %T"` >> $DST/log
cd $DST
if [ ! -d "temp" ]; then
	mkdir temp;
fi

#files backup; add path separated by a space
for i in path/to/file/to/backup path/to/file/to/backup;
			do
				cd $i;
    			folder=$(basename `pwd`);
    			cp -R $i $DST/temp
				tar -zcf $DST/$folder-$DATE.tar.gz $DST/temp/$folder
				rm -rf $DST/temp/$folder
			done

			echo "End Copy : "`date "+%d-%m-%Y %T"` >> $DST/log

			#start rsync to a remote host
			echo "Start rsync : "`date "+%d-%m-%Y %T"` >> $DST/log
			rsync -e ssh -avz --delete-after ~/main/path/backup/ user@fdomain:~/path/to/store/backup/in/remote/host
			echo "Stop rsync : "`date "+%d-%m-%Y %T"` >> $DST/log