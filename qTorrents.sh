#!/usr/bin/env bash

#		qTorrrents.sh by ignaci0
#		
#		This program is free software; you can redistribute it and/or modify
#		it under the terms of the GNU General Public License as published by
#		the Free Software Foundation; either version 2 of the License, or
#		(at your option) any later version.
#		
#		This program is distributed in the hope that it will be useful,
#		but WITHOUT ANY WARRANTY; without even the implied warranty of
#		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#		GNU General Public License for more details.
#		
#		You should have received a copy of the GNU General Public License
#		along with this program; if not, write to the Free Software
#		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#		MA 02110-1301, USA.
#
#		Instructions:
#			This scripts needs two arguments, the queue directory, 
#			i.e. the source directory and the watch directorty.
#
#			Also you'll have to add the following line to the .rtorrent.rc:
#
#				system.method.set_key=event.download.finished,move_complete,"execute=~/enqueue_rtorrent.sh,~/queue,~/torrents"
#
#			Where ~/queue and ~/torrents are their arguments
#

LOGFILE=`dirname $0`"/"`basename $0 .sh`".log"
QUEUE_DIR=$1
WATCH_DIR=$2

function logger()
{
	printf "[`date`] $*\n" >> $LOGFILE;
}

function check_directory()
{
	dir=$1
	desc=$2
	if [[ ! -d "$dir" ]]
	then
		logger "$desc directory not found: $dir";
		exit 1;
	fi
}

check_directory "$QUEUE_DIR" "Queue";
check_directory "$WATCH_DIR" "Watch";

file=$(ls -tr -w1 $QUEUE_DIR/*.torrent 2>/dev/null | head -n 1 )

if [[ "x$file" != "x" ]]
then
	mv "$file" "$WATCH_DIR";
	rv=$?
	if [[ $rv -eq 0 ]]
	then
		logger "$file added to the watch directory";
	else
		logger "Couln't move file $file to the watch directory";
	fi
fi

exit $rv;

