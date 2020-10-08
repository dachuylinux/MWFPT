# Backup storage directory
backup_folder=/data/backupDaily

# MySQL user
user=root

# MySQL password
password=abcbcbcbcbc

# Number of days to store the backup
keep_day=3

sqlfile=$backup_folder/all-database-$(date +%d-%m-%Y_%H-%M-%S).sql
zipfile=$backup_folder/all-database-$(date +%d-%m-%Y_%H-%M-%S).tar.gz

# Create a backup
mysqldump -u $user -p$password -h 127.0.0.1 --skip-lock-tables --all-databases > $sqlfile

if [ $? == 0 ]; then
   echo 'Sql dump created'
else
   echo 'mysqldump return non-zero code'
   exit
fi

# Compress backup
tar -czvf $zipfile $sqlfile

if [ $? == 0 ]; then
   echo 'The backup was successfully compressed'
else
   echo 'Error compressing backup'
   exit
fi

rm $sqlfile

echo $zipfile

# Delete old backups
find $backupfolder -name "*.tar.gz" -mtime +$keep_day -delete
