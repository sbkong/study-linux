```bash
#!/bin/bash
## ProgName backupMySQLDump v2.0
## ProgBy doly 2015.05.27
# crontab -e
#03 * * * * su - root -c '/root/backupMySQLDump'

################### user variables ########################

## 백업디렉토리
backup_dir=/backup/DB/

## 보관수
backup_cnt=360 # 24시간*15일

## DB root 비밀번호
db_root_pw='비밀번호'

isCompress=1 # 1:Compress, other:no compress

###########################################################

## 오늘날짜 및 시간 구하기
today=`date '+%Y.%m.%d.%H'`

## 오래된 데이터 삭제
old_backup_dir=`ls -t $backup_dir 2>/dev/null`
i=0
for dir in $old_backup_dir ; do
    i=$(($i+1))
    if [ "$i" -gt "$backup_cnt" ] ; then
        echo "rm -rf $backup_dir/$dir"
        rm -rf $backup_dir/$dir
    fi
done

## 백업경로 생성
mkdir -p $backup_dir/$today/

## 데이터베이스 리스트 구하기
db_list=`echo "show databases;" | mysql -N -uroot -p"$db_root_pw"`

## 각 DB에 테이블 들 구하기
for db in $db_list ; do
    # create backup dir
    mkdir -p $backup_dir/$today/$db/
    table_list=`echo "show tables;" | mysql -N -uroot -p"$db_root_pw" $db`
    for table in $table_list ; do
        echo "Backup \"${db}\" Database \"${table}\" Table"
        mysqldump --lock-all-tables --skip-lock-tables --create-options --quick --single-transaction -uroot -p"$db_root_pw" $db $table > $backup_dir/$today/$db/${table}.sql
        if [ "$isCompress" = "1" ]; then
            echo "gzip ${backup_dir}/${today}/$db/${table}.sql"
            gzip ${backup_dir}/${today}/$db/${table}.sql
            echo "gzip -d ${table}.sql.gz" >> $backup_dir/$today/$db/restore.sh
        else
            echo "restore command : mysql -uroot -p\"$db_root_pw\" $db < ${table}.sql" >> $backup_dir/$today/$db/restore.sh
        fi
    done
    test -f $backup_dir/$today/$db/restore.sh && chmod 700 $backup_dir/$today/$db/restore.sh
done

```
