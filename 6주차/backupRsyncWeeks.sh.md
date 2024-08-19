```bash
#!/bin/bash

## ProgName : backupRsyncWeeks v1.0
## Prog by doly 2015.05.27

# cron : 00 01 * * * su - root -c '/root/backupRsyncWeeks'

## User Variables
backup_dir="/backup"
bk_dirs="/bin /boot /data /etc /lib /lib64 /opt /root /sbin /usr /var"

## 주간백업 설정
export LANG=en
week="`date '+%A'`"
backup_dir="$backup_dir/$week"

## Rsync 함수
function sync_bak {
    from=$1
    to=$2
    opt="$3"

    if [ ! -d "$to" ] ; then mkdir -p $to ; fi
    rsync -a --delete $opt $from $to
}

## 주간 백업
for dir in $bk_dirs ; do
    if [ -d $dir ] ; then
        echo "$dir -> $backup_dir//$dir"
        sync_bak $dir $backup_dir/$dir
    fi
done
touch $backup_dir

```
