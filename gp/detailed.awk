# mangle a scraped detailed csv so that the individual puzzle
# points come in postgres array format
#
# 111.,My Name,Country,Nick,15,20,-,0,35,3,2,01:21:06,
# to
# 111.,My Name,Country,Nick,35,3,2,01:21:06,"{15,20,NULL,0}"

BEGIN {
	FS = ","
}

function toint(a) {
	if (a == "-")
		return "NULL"
	return a
}

{
	for (i = 1; i <= 4; i++)
		printf("%s,", $i)
	for (i = NF-4; i < NF; i++)
		printf("%s,", $i)
	printf("\"{")
	printf(toint($5))
	for (i = 6; i < NF-4; i++)
		printf(",%s", toint($i))
	printf("}\"\n")
}
