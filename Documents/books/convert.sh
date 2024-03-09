#!/bin/bash

INPUT_FILE=$1
OUTPUT_FILE=$2

INPUT_FILE_EXTENSION=$(echo $INPUT_FILE | sed 's/^.*\.//')
FILE_NAME=$(echo $OUTPUT_FILE | sed 's/\..*$//')

EBOOK_CONVERTER=ebook-convert

EPUB_EXT="epub"
MOBI_EXT="mobi"

if [ $INPUT_FILE_EXTENSION != $EPUB_EXT ]; then
	echo "unsupported input file extenstion"
	exit 2
fi

TMP_MOBI_FILE="$TMPDIR$FILE_NAME.$MOBI_EXT"

$EBOOK_CONVERTER "$INPUT_FILE" "$TMP_MOBI_FILE"
$EBOOK_CONVERTER "$TMP_MOBI_FILE" "$OUTPUT_FILE.$EPUB_EXT"

echo "\n"
echo $INPUT_FILE
echo $OUTPUT_FILE

echo $INPUT_FILE_EXTENSION
echo $FILE_NAME
echo $TMP_MOBI_FILE
