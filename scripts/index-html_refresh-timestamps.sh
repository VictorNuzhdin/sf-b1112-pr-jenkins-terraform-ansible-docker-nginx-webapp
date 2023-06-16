#!/bin/bash


##--Getting and saving current date, time and weekday number
##  index.html (fragment):
##	   <p>Webapp version..: 20230615.1</p>
##	   <p>Webapp build dob: 2023.06.15 18:30:10</p>
#
DT_NOW_TS1=$(date +'%Y%m%d')
DT_NOW_TS2=$(date +'%Y-%m-%d %H:%M:%S')
WD_NOW=$(date +'%u')
#echo "Webapp version..: $DT_NOW_TS1.$WD_NOW"    ##= Webapp version..: 20230616.5
#echo "Webapp build dob: $DT_NOW_TS2"            ##= Webapp build dob: 2023-06-16 10:32:27

##--Injecting new timestamps into index.html page
#
#index.html -> search: "Webapp version" -> replace: "<p>Webapp version..: 20230616.5</p>"
#index.html -> search: "Webapp build"   -> replace: "<p>Webapp build dob: 2023.06.16 10:32:27</p>"
#index.html -> search: "Webapp build"   -> replace: "<p>Webapp build dob: 2023-06-16 10:32:27</p>"
#
#..pattern1
#                                 2    0   2    3    0    6    1    5    .     1
#sed -i 's#Webapp version..: \([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\.\([0-9]\)#Webapp version..: 00000000.0#' src/index.html
#sed -i "s#Webapp version..: \([0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]\)\.\([0-9]\)#Webapp version..: $DT_NOW_TS1.$WD_NOW#" src/index.html
#sed -i "s#Webapp version..: \([0-9]\)\{1,8\}\.\([0-9]\)\{1,1\}#Webapp version..: $DT_NOW_TS1.$WD_NOW#" src/index.html
#
#..pattern2
#                                 2    0    2    3    .     0    6    .     1    5    1space      1    8    :     3    0    :     1    0
#sed -i 's#Webapp build dob: \([0-9][0-9][0-9][0-9]\)\.\([0-9][0-9]\)\.\([0-9][0-9]\)\s\{1,\}\([0-9][0-9]\)\:\([0-9][0-9]\)\:\([0-9][0-9]\)#Webapp build dob: 0000.00.00 00:00:00#' src/index.html
#sed -i "s#Webapp build dob: \([0-9][0-9][0-9][0-9]\)\.\([0-9][0-9]\)\.\([0-9][0-9]\)\s\{1,\}\([0-9][0-9]\)\:\([0-9][0-9]\)\:\([0-9][0-9]\)#Webapp build dob: $DT_NOW_TS2#" src/index.html
#sed -i "s#Webapp build dob: \([0-9]\)\{1,4\}\.\([0-9]\)\{1,2\}\.\([0-9]\)\{1,2\}\s\{1,1\}\([0-9]\)\{1,2\}\:\([0-9]\)\{1,2\}\:\([0-9]\)\{1,2\}#Webapp build dob: $DT_NOW_TS2#" src/index.html
#sed -i "s#Webapp build dob: \([0-9]\)\{1,4\}\-\([0-9]\)\{1,2\}\-\([0-9]\)\{1,2\}\s\{1,1\}\([0-9]\)\{1,2\}\:\([0-9]\)\{1,2\}\:\([0-9]\)\{1,2\}#Webapp build dob: $DT_NOW_TS2#" src/index.html

#
##..final patterns
sed -i "s#Webapp version..: \([0-9]\)\{1,8\}\.\([0-9]\)\{1,1\}#Webapp version..: $DT_NOW_TS1.$WD_NOW#" src/index.html
sed -i "s#Webapp build dob: \([0-9]\)\{1,4\}\-\([0-9]\)\{1,2\}\-\([0-9]\)\{1,2\}\s\{1,1\}\([0-9]\)\{1,2\}\:\([0-9]\)\{1,2\}\:\([0-9]\)\{1,2\}#Webapp build dob: $DT_NOW_TS2#" src/index.html


##--Caclulating md5 checksum of index.html page
##  index.html (fragment):
##     <p>Current page md5: <span style="color: red;">???</span></p>
##     <!--<p style="color: red;">ПРОБЛЕМА: <br>- невозможно вычислить MD5 хэш html статической страницы, <br>&nbsp; если она должна содержать свой MD5 хэш</p>-->
#
##--Resetting to [0]{32} current md5 checksum injected into index.html page
sed -i "s#Current page md5: <span style=\"color: red;\">\([0-9a-f]\)\{1,32\}#Current page md5: <span style=\"color: red;\">00000000000000000000000000000000#" src/index.html

##--Calculating current index.html md5 checksum
MD5_INDEX_HTML="$(md5sum src/index.html | cut -d ' ' -f 1)"
#echo $MD5_INDEX_HTML                                                    ##= 943e18242383093bb437819ce2be1aa4

##--Injecting new md5 checksum into index.html page
sed -i "s#Current page md5: <span style=\"color: red;\">\([0-9a-f]\)\{1,32\}#Current page md5: <span style=\"color: red;\">$MD5_INDEX_HTML#" src/index.html

##--Generating new .md5 files with checksums BEFORE injecting md5 checksum into index.html page
find src -type f -exec md5sum {} \;> checksums_src.md5
md5sum src/index.html > checksums_src_index-html.md5

##..Fix: Replacing incorrect md5 checksums of index.html
##  checksums_src.md5             -> search: "<INCORRECT_MD5>  src/index.html" -> replace: "<CORRECT_MD5>  src/index.html"
##  checksums_src_index-html.md5  -> search: "<INCORRECT_MD5>  src/index.html" -> replace: "<CORRECT_MD5>  src/index.html"
#
sed -i "s#\([0-9a-f]\)\{1,32\}\s\{1,2\}src/index.html#$MD5_INDEX_HTML  src/index.html#" checksums_src.md5
sed -i "s#\([0-9a-f]\)\{1,32\}\s\{1,2\}src/index.html#$MD5_INDEX_HTML  src/index.html#" checksums_src_index-html.md5


##--DEBUG output
echo "Webapp version..: $DT_NOW_TS1.$WD_NOW"    ##= Webapp version..: 20230616.5
echo "Webapp build dob: $DT_NOW_TS2"            ##= Webapp build dob: 2023-06-16 13:58:38
echo "Current page md5: $MD5_INDEX_HTML"        ##= Current page md5: 696ed8ac877ad19be4081c8372c59a06
