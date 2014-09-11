#! /bin/sh
# simple-webapp-backup - A useful shellscript to backup and restore every Webapp which is based on MySQL and Files
# Copyright (C) 2014 Patrick Puritscher <blackout289@gmail.com>
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

#Config
APPNAME="Simple App"
APPSOURCEDIR="/var/www/webapp";
APPDATABASE="webapp";
APPDATABASEUSER="root"
RESTOREDIR="/var/www/webapp_backup";

usage() {
echo "usage: sh reset.sh [[[--create] [--restore] [--version]] | [-h]]"
}

##Restore App
restore() {
echo "$APPNAME will be restored..."

#Reset DB
echo "Please log in to the database:"
mysql -u $APPDATABASEUSER -p $APPDATABASE < $RESTOREDIR/dump.sql

#Reset destination
rm -R $APPSOURCEDIR/
mkdir $APPSOURCEDIR/
cp -Rp $RESTOREDIR/source/. $APPSOURCEDIR/.

echo "$APPNAME has been restored!"
}

##Backup App
create() {
if [ "$backupdefault" = "1" ]; then
	echo -n "Overwrite Default-Backup?(y/n) > "
	read overwritedefault
	if [ "$overwritedefault" != "y" ]; then
		echo "Backup cancelled!"
		exit
	fi
fi
echo "Creating new Backup.."

#Dump DB
echo "Please log in to the database:"
mysqldump -u $APPDATABASEUSER -p --add-drop-database $APPDATABASE > $RESTOREDIR/dump.sql

#Copy Files
if [ -d $RESTOREDIR/source/ ]; then
	rm -R $RESTOREDIR/source/
fi
mkdir $RESTOREDIR/source/
cp -Rp $APPSOURCEDIR/. $RESTOREDIR/source/.

echo "Backup is ready!"
}

##Check Backupversion
checkversion() {
#Version existing?
if [ ! -d $RESTOREDIR/backup_"$backupversion" ]; then
	echo "There's no backup called $backupversion"
	echo -n "Do you want to create a new one?(y/n) > "
	read dobackupdir
	if [ "$dobackupdir" = "y" ]; then
		mkdir $RESTOREDIR/backup_"$backupversion"
	else
		exit
	fi
fi
}
if [ "$1" = "" ]; then
	usage
	exit;
fi
while [ "$1" != "" ]; do
    case $1 in
        --create )      create=1
                                ;;
        --restore )    restore=1
                                ;;
		--version )    version=1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
    esac
    shift
done

if [ "$version" = "1" ]; then
    echo "Please enter a backupversion:"
	read backupversion
	checkversion
	RESTOREDIR=$RESTOREDIR/backup_"$backupversion"
	backupdefault=0
else
	if [ ! -d $RESTOREDIR/_backup_default ]; then
		mkdir $RESTOREDIR/_backup_default
	fi
	RESTOREDIR=$RESTOREDIR/_backup_default
	backupdefault=1
fi
if [ "$restore" = "1" ]; then
	restore
	exit
fi
if [ "$create" = "1" ]; then
	create
	exit
fi
