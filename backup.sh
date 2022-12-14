#!/bin/bash
# Description : Simple Backup System
# User        : Christoph Koschel
# Version     :  1.0.0

OPTIONS=""

function mainmenu() {
	clear
	echo "|-----------------------------------|"
	echo "|  Hauptmenu                        |"
	echo "|-----------------------------------|"
	echo "|  (0) Setup                        |"
	echo "|  (1) Backup erstellen             |"
	echo "|  (2) Backup zurück spielen        |"
	echo "|  (3) Inhalt des Backups           |"
	echo "|  (4) Backup löschen               |"
	echo "|  (5) Exit                         |"
	echo "|-----------------------------------|"
	read -p "|  Eingabe > " CMD
}

function backup() {
	OPTIONS="c"
	clear
	echo "|-----------------------------------|"
	echo "|  BACKUP                           |"
	echo "|-----------------------------------|"
	echo "|  BACKUP in einer Datei speichern  |"
	echo "|-----------------------------------|"
	echo "|  (1) Ja                           |"
	echo "|  (2) Nein                         |"
	echo "|-----------------------------------|"
	read -p "|  Eingabe > " FILE

	if [ $FILE == 1 ]
	then
		OPTIONS=$OPTIONS"f"
	fi

	clear
	echo "|-----------------------------------|"
	echo "|  BACKUP                           |"
	echo "|-----------------------------------|"
	echo "|  Welche Kompression soll          |"
	echo "|  verwendet werden                 |"
	echo "|-----------------------------------|"
	echo "|  (1) zip                          |"
	echo "|  (2) bzip                         |"
	echo "|  (3) xz                           |"
	echo "|-----------------------------------|"
	read -p "|  Eingabe > " COMP

	case $COMP in
		1)
			OPTIONS=$OPTIONS"z"
			;;
		2)
			OPTIONS=$OPTIONS"j"
			;;
		3)
			OPTIONS=$OPTIONS"J"
			;;
		*)
			OPTIONS=$OPTIONS"z"
	esac

	clear
	echo "|-----------------------------------|"
	echo "|  BACKUP                           |"
	echo "|-----------------------------------|"
	echo "|  Welcher ordner soll gesichtert   |"
	echo "|  Werden                           |"
	echo "|-----------------------------------|"
	read -p "| Eingabe > " SRC


	echo "Erstellen Backup..."
	tar $OPTIONS $(pwd)/backups/$(date +%Y%m%d-%H%M%S)-backup.tgz $SRC
	echo "Backup wurde erstellt"
}

function undoBackup() {
	OPTIONS="xfz"

	clear
	echo "|-----------------------------------|"
	echo "|  RESTORE                          |"
	echo "|-----------------------------------|"
	echo "|  Wählen sie ein Backup aus        |"
	echo "|-----------------------------------|"
	I=0;
	for ITEM in ./backups/*.tgz
	do
		echo "|  ("$I") "$ITEM"  |"
		I=$((I+1))
	done

	echo "|-----------------------------------|"
	read -p "|  Eingabe > " F

	I=0
	FILE="x"
	for ITEM in ./backups/*.tgz
	do
		if [ "$F" =  "$I" ]
		then
			if [ "$FILE" = "x" ]
			then
				FILE="$ITEM"
			fi
		fi
		I=$((I+1))
	done

	clear
	echo "|-----------------------------------|"
	echo "|  RESTORE                          |"
	echo "|-----------------------------------|"
	echo "|  Wo soll das Bachup eingespeißt   |"
	echo "|  werden                           |"
	echo "|-----------------------------------|"
	read -p "|  Eingabe > " DEST

	tar $OPTIONS $FILE -C $DEST
}

function deleteBackup() {
	clear
	echo "|-----------------------------------|"
	echo "|  DELETE BACKUP                    |"
	echo "|-----------------------------------|"
	echo "|  Wählen sie ein Backup aus        |"
	echo "|-----------------------------------|"
	I=0;
	for ITEM in ./backups/*.tgz
	do
		echo "|  ("$I") "$ITEM"  |"
		I=$((I+1))
	done

	echo "|-----------------------------------|"
	read -p "|  Eingabe > " F

	I=0
	FILE="x"
	for ITEM in ./backups/*.tgz
	do
		if [ "$F" =  "$I" ]
		then
			if [ "$FILE" = "x" ]
			then
				FILE="$ITEM"
			fi
		fi
		I=$((I+1))
	done

	rm $FILE
}

function listBackup() {
	clear
	echo "|-----------------------------------|"
	echo "|  LIST DATA                        |"
	echo "|-----------------------------------|"
	echo "|  Wählen sie ein Backup aus        |"
	echo "|-----------------------------------|"
	I=0;
	for ITEM in ./backups/*.tgz
	do
		echo "|  ("$I") "$ITEM"  |"
		I=$((I+1))
	done

	echo "|-----------------------------------|"
	read -p "|  Eingabe > " F

	I=0
	FILE="x"
	for ITEM in ./backups/*.tgz
	do
		if [ "$F" =  "$I" ]
		then
			if [ "$FILE" = "x" ]
			then
				FILE="$ITEM"
			fi
		fi
		I=$((I+1))
	done

	echo "|-----------------------------------|"
	echo "|  LIST DATA                        |"
	echo "|-----------------------------------|"

	TMP_FILE="____DATA____.txt"
	tar tf $FILE > $TMP_FILE
	more $TMP_FILE
#	for LINE in $DATA
#	do
#		echo "|  "$LINE
#	done
#	read -p "Press any key to continue"
	rm $TMP_FILE
}

function installProgram() {
	if [ -d ./backups ]
	then
		rm -r ./backups
	fi

	mkdir ./backups
}

function deinstallProgram() {
	if [ test -d ./backups ]
	then
		rm -r ./backups
	fi
}

function setup() {
	while :
	do
		clear
		echo "|-----------------------------------|"
		echo "|  SETUP                            |"
		echo "|-----------------------------------|"
		echo "|  (0) Installieren                 |"
		echo "|  (1) De-Installieren              |"
		echo "|  (2) Exit                         |"
		echo "|-----------------------------------|"
		read -p "|  Eingabe > " SETUP

			case $SETUP in
			0)
				installProgram
				;;
			1)
				deinstallProgram
				;;
			2)
				break
				;;
			*)
				echo "Wrong user input"
				;;
		esac
		sleep 1
	done
}

function doTask() {
	COUNT=$(ls ./backups | wc -l)
	if [ $COUNT = 0 ]
	then
		echo "You can only do backups or the setup"
		sleep 1
		return
	fi

	case $1 in
		2)
			undoBackup
			;;
		3)
			listBackup
			;;
		4)
			deleteBackup
			;;
	esac
}


while :
do
	clear
	mainmenu

	case  $CMD in
		0)
			setup
			;;

		1)
			backup
			;;
		2|3|4)
			doTask $CMD
			;;
		5)
			exit 0
			;;
		*)
			echo "Wrong user input. You can not read do you?"
	esac
	sleep 1
done
