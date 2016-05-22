#!/bin/sh

# scrape a GP result table to CSV format

curl $1 \
	| egrep '(<td|<tr)' \
	| tr -d '\n\r\t' | tr ',' ';' \
	| sed 's/<t[dr][^>]*>//g' \
	| awk '
		BEGIN {
			RS=" *</tr> *"
			FS=" *</td> *"
			OFS=","
		}
		/[0-9]\./ {
			$1 = $1
			print $0
		}
	'
