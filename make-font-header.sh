#!/bin/sh
#
# Generate a psplash font file suitable for compilation, there
# are no buildroot packages for otf2bdf or bdftobogl which is
# why this script is added to show the conversion steps performed
#

if [ -z "$1" -o ! -f "$1" ]; then
	echo "Usage: $(basename $0) <file.ttf>"
	exit 1
fi
if [ -z "$2" ]; then
	FONT_NAME="custom"
else
	FONT_NAME="$2"
fi

otf2bdf -p 28 -r 75 -v $1 -o ${FONT_NAME}-font.bdf
bdftobogl ${FONT_NAME}-font.bdf > ${FONT_NAME}-font.h
rm ${FONT_NAME}-font.bdf

sed -i 's/#include "bogl\.h"/#include "psplash\.h"/g' ${FONT_NAME}-font.h
sed -i "s/struct bogl_font font_${FONT_NAME}_font/PSplashFont ${FONT_NAME}_font/g" \
	${FONT_NAME}-font.h
