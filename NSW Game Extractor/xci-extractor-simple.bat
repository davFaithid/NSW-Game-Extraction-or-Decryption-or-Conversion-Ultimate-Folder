hactool.exe -k prod.keys -txci --securedir="xciDecrypted" "%~1"

dir "xciDecrypted" /b /o-s > nca_name.txt
set /P nca_file= < nca_name.txt
del nca_name.txthactool.exe -k prod.keys --exefsdir="xciDecrypted" --romfs="xciDecrypted\romfs.istorage" "xciDecrypted\%nca_file%"
del "xciDecrypted\*.nca"
del "xciDecrypted\*.tik"
del "xciDecrypted\*.cert"