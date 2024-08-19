```bash
#!/bin/bash
## ProgName : backupRsyncHistory v1.0
## Prog by doly 2015.05.27
# cron : 00 01 * * * su - root -c '/root/backupRsyncHistory'

### User Variables ###
BACKUP_DIR="/backup/fullbackup"
BACKUP_HIST_DIR="/backup/old"
DIRS="/bin /boot /data /etc /lib /lib64 /opt /root /sbin /usr /var"
RetainDays=30

### System Variables ###
export LANG=en
today="`date '+%Y-%m-%d'`"

function sync_bak {
    from=$1
    to=$2
    opt="$3"

    if [ "$2" == "" ]; then to="$BACKUP_DIR/$from"; fi
    if [ ! -d "$to" ]; then mkdir -p $to; fi
    if [ ! -d "$BACKUP_HIST_DIR/$from" ]; then mkdir -p $BACKUP_HIST_DIR/$from; fi
    echo "rsync -ab --delete --backup-dir=\"$BACKUP_HIST_DIR/$from\" --suffix=\".$today\" $opt $from/ $to/"
    rsync -ab --delete --backup-dir="$BACKUP_HIST_DIR/$from" --suffix=".$today" $opt $from/ $to/
}

## Do Backup
for dir in $DIRS; do
    if [ -d $dir ]; then
        sync_bak $dir
    fi
done
touch $BACKUP_DIR

### Log file Delete
find $BACKUP_HIST_DIR/ -ctime +$RetainDays -type f -exec rm -f {} \;

```
