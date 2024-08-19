```bash
#!/bin/bash
## ProgName : backupRsyncNumber v1.0
## Prog by doly 2015.05.27
# cron : 00 01 * * * su - root -c '/root/backupRsyncNumber'

## User Variables
backup_dir="/backup"
bk_dirs="/bin /boot /data /etc /lib /lib64 /opt /root /sbin /usr /var"
backup_days=3

## 백업 디렉토리 계산(1970년1월1일부터 현재 날짜/초의 나머지)
timestamp=`date '+%s'` # timestamp 시간
bkDir=$((($timestamp/86400)%backup_days))
backup_dir="$backup_dir/$bkDir"

## Rsync 함수
function sync_bak {
    from=$1
    to=$2
    opt="$3"

    if [ ! -d "$to" ] ; then mkdir -p $to ; fi
    rsync -a --delete $opt $from $to
}

## 백업
for dir in $bk_dirs ; do
    if [ -d $dir ] ; then
        echo "$dir -> $backup_dir//$dir"
        sync_bak $dir $backup_dir/$dir
    fi
done
touch $backup_dir

```
