#!/bin/bash
#set -x

XKBMAP=`which setxkbmap`

if ! [ "$XKBMAP" ]; then
	echo "setxkbmap not found, not enabling keyboard"
	exit 1
fi

## Check $DISPLAY is set, if not there's no point in setting up the keyboard.
## We could do with a better check here...
if [ "$DISPLAY" >> /dev/null ]; then
	## We are running Xorg (somewhere)

	if ! [ `setxkbmap -query | awk '/layout/ {print $2}' | grep "apl"` ]; then
	## We have no APL layout - so lets set one up - we're going to use the Windows Key.

	## Setup keyboard map
	##Get the rules we're using
	XKBRULES=`setxkbmap -query | awk '/rules/ {print $2}'` 2>/dev/null
	##Get the keyboard model
	XKBMODEL=`setxkbmap -query | awk '/model/ {print $2}'` 2>/dev/null
	## get the FIRST (default) language
	XKBLAYOUT=`setxkbmap -query | awk '/layout/ {print $2}' | sed 's/,.*//'` 2>/dev/null
	## check the variant of the FIRST layout
	XKBVARIANT=`setxkbmap -query | awk '/variant/ {print $2}' | sed 's/,.*//'` 2>/dev/null
	## Check the keyboarding options
	XKBOPTIONS=`setxkbmap -query | awk '/options/ {print $2}'` 2>/dev/null

	##Set the keyboard up to use APL as the second language with any WIN key (While pressed) as the accelerator.

	${XKBMAP} -rules ${XKBRULES} -model ${XKBMODEL} -layout "${XKBLAYOUT},apl" -variant "${XKBVARIANT},dyalog" -option ",grp:win_switch" 2>/dev/null

	fi
fi
