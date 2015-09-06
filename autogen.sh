#!/bin/bash
LDPRESENT=1
command -v edje_cc >/dev/null 2>&1 || { echo >&2 "Edje compiler not found"; exit 1; }
command -v ldconfig >/dev/null 2>&1 || { echo >&2 "Warning! Ldconfig not found. GTK3 version detection is not possible. Appropriate version need to be copied manually."; LDPRESENT=0;}
rm -f Makefile

if [ $LDPRESENT -eq 1 ]
then
VERSIONSTR=`ldconfig -v | grep libgtk-3`
VERSIONPARSE=(`echo $VERSIONSTR | tr '.' ' '`)
VERSIONINFO=${VERSIONPARSE[7]}
if [ "$VERSIONINFO" -ge "800" ]
then
if [ "$VERSIONINFO" -lt "899" ]
then
GTKVER="3.8"
fi
fi 
if [ "$VERSIONINFO" -ge "1000" ]
then
if [ "$VERSIONINFO" -lt "1099" ]
then
GTKVER="3.10"
fi
fi 
if [ "$VERSIONINFO" -ge "1200" ]
then
if [ "$VERSIONINFO" -lt "1299" ]
then
GTKVER="3.12"
fi
fi
if [ "$VERSIONINFO" -ge "1400" ]
then
if [ "$VERSIONINFO" -lt "1499" ]
then
GTKVER="3.14"
fi
fi
if [ "$VERSIONINFO" -ge "1600" ]
then
if [ "$VERSIONINFO" -lt "1699" ]
then
GTKVER="3.16"
fi
fi
echo "Version of GTK3 is "${GTKVER}
DETGTK="cp -rf gtk/GTK_"${GTKVER}"/detourious ~/.themes"
DETDARKGTK="cp -rf gtk/GTK_"${GTKVER}"/detourious-dark ~/.themes"
fi

echo 'all:
	edje_cc -id . -fd . main.edc -o detourious.edj
	edje_cc -DBUILD_ILLUME=1 -DUSE_BOLD_FONT=1 -id . -fd . main.edc -o detourious-illume.edj
	edje_cc -DCOLORS=1 -id . -fd . main.edc -o detourious-dark.edj
	edje_cc -DBUILD_ILLUME=1 -DUSE_BOLD_FONT=1 -DCOLORS=1 -id . -fd . main.edc -o detourious-illume-dark.edj

install:
	rm -f ~/.elementary/themes/detourious.edj
	rm -f ~/.elementary/themes/detourious-illume.edj
	rm -f ~/.elementary/themes/detourious-dark.edj
	rm -f ~/.elementary/themes/detourious-illume-dark.edj
	cp detourious.edj ~/.elementary/themes
	cp detourious-illume.edj ~/.elementary/themes
	cp detourious-dark.edj ~/.elementary/themes
	cp detourious-illume-dark.edj ~/.elementary/themes'> Makefile

if [ $LDPRESENT -eq 1 ]
then
	echo '	rm -rf ~/.themes/detourious
	rm -rf ~/.themes/detourious-dark
	'${DETGTK}'
	'${DETDARKGTK}'
' >> Makefile
else
	echo '
' >> Makefile
fi
echo "Alright. Type 'make' to build and then 'make install' to install." 
