```bash
#!/bin/bash
# Prog Name : backupCompress v1.0
# Prog by doly 2015.05.27
# cron : 00 01 * * * su - root -c '/root/backupCompress'

## User Variables
backup_dir="/backup"
backup_count=3
home_dirs="/home"
bk_dirs="/bin /boot /data /etc /lib /lib64 /opt /root /sbin /usr /var"

export Today=`date '+%Y-%m-%d'`

## 1. delete 오래된 백업데이터 삭제
dirlists=`/bin/ls -t $backup_dir/ 2>/dev/null`
i=1
for dir in $dirlists ; do
    if [ "$i" -ge $backup_count ]; then
        /bin/rm -rf $backup_dir/$dir
    fi
    i=$(($i+1))
done

## 2. 새로운 디렉토리 생성
/bin/mkdir -p ${backup_dir}/$Today
cd ${backup_dir}/$Today

## 3. home 디렉토리 별, 사용자별로 백업을 한다.
for i in $home_dirs ; do
    dirlists=`/bin/ls -t $i 2>/dev/null`
    i_name=`echo $i | sed "s///_/g"`
    for dir in $dirlists ; do
        echo "$i/$dir -> ${backup_dir}/$Today/$i_name.$dir.tar.gz"
        tar cfzp ${backup_dir}/$Today/$i_name.$dir.tar.gz $i/$dir
        echo "tar xvfpz $i_name.$dir.tar.gz" >> ${backup_dir}/$Today/restore.$i_name.sh
    done
    chmod 744 ${backup_dir}/$Today/restore.$i_name.sh
done

## 4. 기타 디렉토리를 백업한다
for dir in $bk_dirs ; do
    if [ -d $dir ] ; then
        dir_name=`echo $dir | sed "s///_/g"`
        echo "$dir -> ${backup_dir}/$Today/$dir_name.tar.gz"
        tar cfzp ${backup_dir}/$Today/$dir_name.tar.gz $dir
    fi
done

```
