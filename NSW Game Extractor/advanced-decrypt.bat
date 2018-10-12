@echo off

if exist tools\prod.keys (goto strt)
if exist tools\KEYS.* copy /y tools\KEYS.* tools\prod.keys

:strt
if not exist tools\prod.keys echo : : Missing prod.keys file! Place them in tools folder.
echo.
if not exist tools\prod.keys pause
if not exist tools\prod.keys exit
if exist "xciDecrypted" RD /S /Q "xciDecrypted"
if exist "ncaDecrypted" RD /S /Q "ncaDecrypted"
if exist "ncaDecrypted" RD /S /Q "nspDecrypted"
if exist tools\prod.keys copy /y tools\prod.keys tools\KEYS.txt >nul 2>&1
if "%~x1"==".nca" (goto nca)
if "%~x1"==".nsp" (goto nsp)
if "%~x1"==".xci" (goto back)
if "%~x1"=="" echo : : Don't click on batch file just Drag file on it.
if "%~x1"=="" echo.
if "%~x1"=="" pause
if "%~x1"=="" exit
echo : : I only accept XCI, NCA, and NSP files.
echo.
pause
exit

:back

cls
echo *********************************************
echo.
echo   Do you want to Extract XCI file - Press 1
echo.
echo   Do you want ExeFS and romfs.istorage - Press 2    *Note* - This will also Patch main.npdm
echo.
echo   Do you just want the game files - Press 3
echo.
echo   Do you want to convert XCI to NSP - Press 4
echo.    
echo **********************************************
echo.
set /p DG= Your Choice (1-4):
if "%DG%"== "1" (goto glta)
if "%DG%"== "2" (goto here)
if "%DG%"== "3" (goto game)
if "%DG%"== "4" (goto x2n)
echo You can only choose 1-4
pause
cls
goto back

:x2n
cls
echo : : Converting "%~nx1" to "%~n1.nsp"
copy /y "%~dp0\tools\prod.keys" "%~dp0\prod.keys" >nul 2>&1
tools\4nxci.exe "%~1" >tools\newr.txt
del "%~dp0\prod.keys"
ren "*000.nsp" "%~n1.nsp"
if exist "*800.nsp" ren "*800.nsp" "%~n1-[UPD].nsp"
:loopp
set TID=
if exist "*0??.nsp" set /a num+=1
for /f "tokens=1,2,3,4" %%J in (tools\newr.txt) do if "%%J %%K %%L"=="DLC NSP %num%:" set TID=%%M
if exist "%TID%" ren "%TID%" "%~n1-[DLC-%num%].nsp"
if "%TID%"=="" goto dunnr
if %num%==99 goto dunnr
if exist "*0??.nsp" goto loopp
:dunnr
cls
RD /S /Q 4nxci_extracted_xci
del tools\newr.txt
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit

:here

cls
MD xciDecrypted
echo :: Decrypting......Secure Directory
"%~dp0tools\hactool.exe" -k "%~dp0tools\prod.keys" -t xci --securedir=xciDecrypted "%~1" >nul 2>&1
cls
dir "xciDecrypted" /b /o-s > xciDecrypted\nca_name.txt
set /P nca_file= < xciDecrypted\nca_name.txt
echo :: Decrypting......Secure Directory...
echo :: DONE!
echo.
echo :: Searching.......For biggest NCA file...
echo :: DONE! ["%nca_file%"]
echo.
echo :: Dercypting......"%nca_file%"
"%~dp0tools\hactool.exe" -k "%~dp0tools\prod.keys" --header=xciDecrypted\new.txt "xciDecrypted\%nca_file%" > "xciDecrypted\new1.txt" 2>&1
cls
echo :: Decrypting......Secure Directory...
echo :: DONE!
echo.
echo :: Searching.......For biggest NCA file...
echo :: DONE! ["%nca_file%"]
echo.
echo :: Decrypting......"%nca_file%"...
echo :: DONE!
echo.
echo :: Searching.......For TitleID...
for /f "skip=20 tokens=1,2*" %%O in (xciDecrypted\new1.txt) do if "%%O %%P"=="Title ID:" set Title=%%Q

echo %Title% > xciDecrypted\test.tx
set "CodeFile=xciDecrypted\test.tx"
set "TempFile=%CodeFile%.tmp"
del "%TempFile%" 2>nul
for /F "usebackq delims=" %%I in ("%CodeFile%") do call :EncodeLine "%%~I"
if exist "%TempFile%" move /Y "%TempFile%" "%CodeFile%"
goto :EOF

:EncodeLine
set "InputLine=%~1"
set "OutputLine="

:NextChar
set a=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set a=%OutputLine%.v
if /I "%OutputLine%" == " 2" set a=%OutputLine%.v
if /I "%OutputLine%" == " 3" set a=%OutputLine%.v
if /I "%OutputLine%" == " 4" set a=%OutputLine%.v
if /I "%OutputLine%" == " 5" set a=%OutputLine%.v
if /I "%OutputLine%" == " 6" set a=%OutputLine%.v
if /I "%OutputLine%" == " 7" set a=%OutputLine%.v
if /I "%OutputLine%" == " 8" set a=%OutputLine%.v
if /I "%OutputLine%" == " 9" set a=%OutputLine%.v
if /I "%OutputLine%" == " a" set a=%OutputLine%.v
if /I "%OutputLine%" == " b" set a=%OutputLine%.v
if /I "%OutputLine%" == " c" set a=%OutputLine%.v
if /I "%OutputLine%" == " d" set a=%OutputLine%.v
if /I "%OutputLine%" == " e" set a=%OutputLine%.v
if /I "%OutputLine%" == " f" set a=%OutputLine%.v
if /I "%OutputLine%" == " 0" set a=%OutputLine%.v
set "OutputLine="
if not "%a%" == "no" goto next

:next
set b=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set b=%OutputLine%.u
if /I "%OutputLine%" == " 2" set b=%OutputLine%.u
if /I "%OutputLine%" == " 3" set b=%OutputLine%.u
if /I "%OutputLine%" == " 4" set b=%OutputLine%.u
if /I "%OutputLine%" == " 5" set b=%OutputLine%.u
if /I "%OutputLine%" == " 6" set b=%OutputLine%.u
if /I "%OutputLine%" == " 7" set b=%OutputLine%.u
if /I "%OutputLine%" == " 8" set b=%OutputLine%.u
if /I "%OutputLine%" == " 9" set b=%OutputLine%.u
if /I "%OutputLine%" == " a" set b=%OutputLine%.u
if /I "%OutputLine%" == " b" set b=%OutputLine%.u
if /I "%OutputLine%" == " c" set b=%OutputLine%.u
if /I "%OutputLine%" == " d" set b=%OutputLine%.u
if /I "%OutputLine%" == " e" set b=%OutputLine%.u
if /I "%OutputLine%" == " f" set b=%OutputLine%.u
if /I "%OutputLine%" == " 0" set b=%OutputLine%.u
set "OutputLine="
if not "%b%" == "no" goto next

:next
set c=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set c=%OutputLine%.t
if /I "%OutputLine%" == " 2" set c=%OutputLine%.t
if /I "%OutputLine%" == " 3" set c=%OutputLine%.t
if /I "%OutputLine%" == " 4" set c=%OutputLine%.t
if /I "%OutputLine%" == " 5" set c=%OutputLine%.t
if /I "%OutputLine%" == " 6" set c=%OutputLine%.t
if /I "%OutputLine%" == " 7" set c=%OutputLine%.t
if /I "%OutputLine%" == " 8" set c=%OutputLine%.t
if /I "%OutputLine%" == " 9" set c=%OutputLine%.t
if /I "%OutputLine%" == " a" set c=%OutputLine%.t
if /I "%OutputLine%" == " b" set c=%OutputLine%.t
if /I "%OutputLine%" == " c" set c=%OutputLine%.t
if /I "%OutputLine%" == " d" set c=%OutputLine%.t
if /I "%OutputLine%" == " e" set c=%OutputLine%.t
if /I "%OutputLine%" == " f" set c=%OutputLine%.t
if /I "%OutputLine%" == " 0" set c=%OutputLine%.t
set "OutputLine="
if not "%c%" == "no" goto next

:next
set d=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set d=%OutputLine%.s
if /I "%OutputLine%" == " 2" set d=%OutputLine%.s
if /I "%OutputLine%" == " 3" set d=%OutputLine%.s
if /I "%OutputLine%" == " 4" set d=%OutputLine%.s
if /I "%OutputLine%" == " 5" set d=%OutputLine%.s
if /I "%OutputLine%" == " 6" set d=%OutputLine%.s
if /I "%OutputLine%" == " 7" set d=%OutputLine%.s
if /I "%OutputLine%" == " 8" set d=%OutputLine%.s
if /I "%OutputLine%" == " 9" set d=%OutputLine%.s
if /I "%OutputLine%" == " a" set d=%OutputLine%.s
if /I "%OutputLine%" == " b" set d=%OutputLine%.s
if /I "%OutputLine%" == " c" set d=%OutputLine%.s
if /I "%OutputLine%" == " d" set d=%OutputLine%.s
if /I "%OutputLine%" == " e" set d=%OutputLine%.s
if /I "%OutputLine%" == " f" set d=%OutputLine%.s
if /I "%OutputLine%" == " 0" set d=%OutputLine%.s
set "OutputLine="
if not "%d%" == "no" goto next

:next
set e=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set e=%OutputLine%.r
if /I "%OutputLine%" == " 2" set e=%OutputLine%.r
if /I "%OutputLine%" == " 3" set e=%OutputLine%.r
if /I "%OutputLine%" == " 4" set e=%OutputLine%.r
if /I "%OutputLine%" == " 5" set e=%OutputLine%.r
if /I "%OutputLine%" == " 6" set e=%OutputLine%.r
if /I "%OutputLine%" == " 7" set e=%OutputLine%.r
if /I "%OutputLine%" == " 8" set e=%OutputLine%.r
if /I "%OutputLine%" == " 9" set e=%OutputLine%.r
if /I "%OutputLine%" == " a" set e=%OutputLine%.r
if /I "%OutputLine%" == " b" set e=%OutputLine%.r
if /I "%OutputLine%" == " c" set e=%OutputLine%.r
if /I "%OutputLine%" == " d" set e=%OutputLine%.r
if /I "%OutputLine%" == " e" set e=%OutputLine%.r
if /I "%OutputLine%" == " f" set e=%OutputLine%.r
if /I "%OutputLine%" == " 0" set e=%OutputLine%.r
set "OutputLine="
if not "%e%" == "no" goto next

:next
set f=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set f=%OutputLine%.q
if /I "%OutputLine%" == " 2" set f=%OutputLine%.q
if /I "%OutputLine%" == " 3" set f=%OutputLine%.q
if /I "%OutputLine%" == " 4" set f=%OutputLine%.q
if /I "%OutputLine%" == " 5" set f=%OutputLine%.q
if /I "%OutputLine%" == " 6" set f=%OutputLine%.q
if /I "%OutputLine%" == " 7" set f=%OutputLine%.q
if /I "%OutputLine%" == " 8" set f=%OutputLine%.q
if /I "%OutputLine%" == " 9" set f=%OutputLine%.q
if /I "%OutputLine%" == " a" set f=%OutputLine%.q
if /I "%OutputLine%" == " b" set f=%OutputLine%.q
if /I "%OutputLine%" == " c" set f=%OutputLine%.q
if /I "%OutputLine%" == " d" set f=%OutputLine%.q
if /I "%OutputLine%" == " e" set f=%OutputLine%.q
if /I "%OutputLine%" == " f" set f=%OutputLine%.q
if /I "%OutputLine%" == " 0" set f=%OutputLine%.q
set "OutputLine="
if not "%f%" == "no" goto next

:next
set g=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set g=%OutputLine%.g
if /I "%OutputLine%" == " 2" set g=%OutputLine%.g
if /I "%OutputLine%" == " 3" set g=%OutputLine%.g
if /I "%OutputLine%" == " 4" set g=%OutputLine%.g
if /I "%OutputLine%" == " 5" set g=%OutputLine%.g
if /I "%OutputLine%" == " 6" set g=%OutputLine%.g
if /I "%OutputLine%" == " 7" set g=%OutputLine%.g
if /I "%OutputLine%" == " 8" set g=%OutputLine%.g
if /I "%OutputLine%" == " 9" set g=%OutputLine%.g
if /I "%OutputLine%" == " a" set g=%OutputLine%.g
if /I "%OutputLine%" == " b" set g=%OutputLine%.g
if /I "%OutputLine%" == " c" set g=%OutputLine%.g
if /I "%OutputLine%" == " d" set g=%OutputLine%.g
if /I "%OutputLine%" == " e" set g=%OutputLine%.g
if /I "%OutputLine%" == " f" set g=%OutputLine%.g
if /I "%OutputLine%" == " 0" set g=%OutputLine%.g
set "OutputLine="
if not "%g%" == "no" goto next

:next
set h=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set h=%OutputLine%.h
if /I "%OutputLine%" == " 2" set h=%OutputLine%.h
if /I "%OutputLine%" == " 3" set h=%OutputLine%.h
if /I "%OutputLine%" == " 4" set h=%OutputLine%.h
if /I "%OutputLine%" == " 5" set h=%OutputLine%.h
if /I "%OutputLine%" == " 6" set h=%OutputLine%.h
if /I "%OutputLine%" == " 7" set h=%OutputLine%.h
if /I "%OutputLine%" == " 8" set h=%OutputLine%.h
if /I "%OutputLine%" == " 9" set h=%OutputLine%.h
if /I "%OutputLine%" == " a" set h=%OutputLine%.h
if /I "%OutputLine%" == " b" set h=%OutputLine%.h
if /I "%OutputLine%" == " c" set h=%OutputLine%.h
if /I "%OutputLine%" == " d" set h=%OutputLine%.h
if /I "%OutputLine%" == " e" set h=%OutputLine%.h
if /I "%OutputLine%" == " f" set h=%OutputLine%.h
if /I "%OutputLine%" == " 0" set h=%OutputLine%.h
set "OutputLine="
if not "%h%" == "no" goto next

:next
set i=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set i=%OutputLine%.i
if /I "%OutputLine%" == " 2" set i=%OutputLine%.i
if /I "%OutputLine%" == " 3" set i=%OutputLine%.i
if /I "%OutputLine%" == " 4" set i=%OutputLine%.i
if /I "%OutputLine%" == " 5" set i=%OutputLine%.i
if /I "%OutputLine%" == " 6" set i=%OutputLine%.i
if /I "%OutputLine%" == " 7" set i=%OutputLine%.i
if /I "%OutputLine%" == " 8" set i=%OutputLine%.i
if /I "%OutputLine%" == " 9" set i=%OutputLine%.i
if /I "%OutputLine%" == " a" set i=%OutputLine%.i
if /I "%OutputLine%" == " b" set i=%OutputLine%.i
if /I "%OutputLine%" == " c" set i=%OutputLine%.i
if /I "%OutputLine%" == " d" set i=%OutputLine%.i
if /I "%OutputLine%" == " e" set i=%OutputLine%.i
if /I "%OutputLine%" == " f" set i=%OutputLine%.i
if /I "%OutputLine%" == " 0" set i=%OutputLine%.i
set "OutputLine="
if not "%i%" == "no" goto next

:next
set j=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set j=%OutputLine%.j
if /I "%OutputLine%" == " 2" set j=%OutputLine%.j
if /I "%OutputLine%" == " 3" set j=%OutputLine%.j
if /I "%OutputLine%" == " 4" set j=%OutputLine%.j
if /I "%OutputLine%" == " 5" set j=%OutputLine%.j
if /I "%OutputLine%" == " 6" set j=%OutputLine%.j
if /I "%OutputLine%" == " 7" set j=%OutputLine%.j
if /I "%OutputLine%" == " 8" set j=%OutputLine%.j
if /I "%OutputLine%" == " 9" set j=%OutputLine%.j
if /I "%OutputLine%" == " a" set j=%OutputLine%.j
if /I "%OutputLine%" == " b" set j=%OutputLine%.j
if /I "%OutputLine%" == " c" set j=%OutputLine%.j
if /I "%OutputLine%" == " d" set j=%OutputLine%.j
if /I "%OutputLine%" == " e" set j=%OutputLine%.j
if /I "%OutputLine%" == " f" set j=%OutputLine%.j
if /I "%OutputLine%" == " 0" set j=%OutputLine%.j
set "OutputLine="
if not "%j%" == "no" goto next

:next
set k=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set k=%OutputLine%.k
if /I "%OutputLine%" == " 2" set k=%OutputLine%.k
if /I "%OutputLine%" == " 3" set k=%OutputLine%.k
if /I "%OutputLine%" == " 4" set k=%OutputLine%.k
if /I "%OutputLine%" == " 5" set k=%OutputLine%.k
if /I "%OutputLine%" == " 6" set k=%OutputLine%.k
if /I "%OutputLine%" == " 7" set k=%OutputLine%.k
if /I "%OutputLine%" == " 8" set k=%OutputLine%.k
if /I "%OutputLine%" == " 9" set k=%OutputLine%.k
if /I "%OutputLine%" == " a" set k=%OutputLine%.k
if /I "%OutputLine%" == " b" set k=%OutputLine%.k
if /I "%OutputLine%" == " c" set k=%OutputLine%.k
if /I "%OutputLine%" == " d" set k=%OutputLine%.k
if /I "%OutputLine%" == " e" set k=%OutputLine%.k
if /I "%OutputLine%" == " f" set k=%OutputLine%.k
if /I "%OutputLine%" == " 0" set k=%OutputLine%.k
set "OutputLine="
if not "%k%" == "no" goto next

:next
set l=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set l=%OutputLine%.l
if /I "%OutputLine%" == " 2" set l=%OutputLine%.l
if /I "%OutputLine%" == " 3" set l=%OutputLine%.l
if /I "%OutputLine%" == " 4" set l=%OutputLine%.l
if /I "%OutputLine%" == " 5" set l=%OutputLine%.l
if /I "%OutputLine%" == " 6" set l=%OutputLine%.l
if /I "%OutputLine%" == " 7" set l=%OutputLine%.l
if /I "%OutputLine%" == " 8" set l=%OutputLine%.l
if /I "%OutputLine%" == " 9" set l=%OutputLine%.l
if /I "%OutputLine%" == " a" set l=%OutputLine%.l
if /I "%OutputLine%" == " b" set l=%OutputLine%.l
if /I "%OutputLine%" == " c" set l=%OutputLine%.l
if /I "%OutputLine%" == " d" set l=%OutputLine%.l
if /I "%OutputLine%" == " e" set l=%OutputLine%.l
if /I "%OutputLine%" == " f" set l=%OutputLine%.l
if /I "%OutputLine%" == " 0" set l=%OutputLine%.l
set "OutputLine="
if not "%l%" == "no" goto next

:next
set m=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set m=%OutputLine%.m
if /I "%OutputLine%" == " 2" set m=%OutputLine%.m
if /I "%OutputLine%" == " 3" set m=%OutputLine%.m
if /I "%OutputLine%" == " 4" set m=%OutputLine%.m
if /I "%OutputLine%" == " 5" set m=%OutputLine%.m
if /I "%OutputLine%" == " 6" set m=%OutputLine%.m
if /I "%OutputLine%" == " 7" set m=%OutputLine%.m
if /I "%OutputLine%" == " 8" set m=%OutputLine%.m
if /I "%OutputLine%" == " 9" set m=%OutputLine%.m
if /I "%OutputLine%" == " a" set m=%OutputLine%.m
if /I "%OutputLine%" == " b" set m=%OutputLine%.m
if /I "%OutputLine%" == " c" set m=%OutputLine%.m
if /I "%OutputLine%" == " d" set m=%OutputLine%.m
if /I "%OutputLine%" == " e" set m=%OutputLine%.m
if /I "%OutputLine%" == " f" set m=%OutputLine%.m
if /I "%OutputLine%" == " 0" set m=%OutputLine%.m
set "OutputLine="
if not "%m%" == "no" goto next

:next
set n=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set n=%OutputLine%.n
if /I "%OutputLine%" == " 2" set n=%OutputLine%.n
if /I "%OutputLine%" == " 3" set n=%OutputLine%.n
if /I "%OutputLine%" == " 4" set n=%OutputLine%.n
if /I "%OutputLine%" == " 5" set n=%OutputLine%.n
if /I "%OutputLine%" == " 6" set n=%OutputLine%.n
if /I "%OutputLine%" == " 7" set n=%OutputLine%.n
if /I "%OutputLine%" == " 8" set n=%OutputLine%.n
if /I "%OutputLine%" == " 9" set n=%OutputLine%.n
if /I "%OutputLine%" == " a" set n=%OutputLine%.n
if /I "%OutputLine%" == " b" set n=%OutputLine%.n
if /I "%OutputLine%" == " c" set n=%OutputLine%.n
if /I "%OutputLine%" == " d" set n=%OutputLine%.n
if /I "%OutputLine%" == " e" set n=%OutputLine%.n
if /I "%OutputLine%" == " f" set n=%OutputLine%.n
if /I "%OutputLine%" == " 0" set n=%OutputLine%.n
set "OutputLine="
if not "%n%" == "no" goto next

:next
set o=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set o=%OutputLine%.o
if /I "%OutputLine%" == " 2" set o=%OutputLine%.o
if /I "%OutputLine%" == " 3" set o=%OutputLine%.o
if /I "%OutputLine%" == " 4" set o=%OutputLine%.o
if /I "%OutputLine%" == " 5" set o=%OutputLine%.o
if /I "%OutputLine%" == " 6" set o=%OutputLine%.o
if /I "%OutputLine%" == " 7" set o=%OutputLine%.o
if /I "%OutputLine%" == " 8" set o=%OutputLine%.o
if /I "%OutputLine%" == " 9" set o=%OutputLine%.o
if /I "%OutputLine%" == " a" set o=%OutputLine%.o
if /I "%OutputLine%" == " b" set o=%OutputLine%.o
if /I "%OutputLine%" == " c" set o=%OutputLine%.o
if /I "%OutputLine%" == " d" set o=%OutputLine%.o
if /I "%OutputLine%" == " e" set o=%OutputLine%.o
if /I "%OutputLine%" == " f" set o=%OutputLine%.o
if /I "%OutputLine%" == " 0" set o=%OutputLine%.o
set "OutputLine="
if not "%o%" == "no" goto next

:next
set p=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set p=%OutputLine%.p
if /I "%OutputLine%" == " 2" set p=%OutputLine%.p
if /I "%OutputLine%" == " 3" set p=%OutputLine%.p
if /I "%OutputLine%" == " 4" set p=%OutputLine%.p
if /I "%OutputLine%" == " 5" set p=%OutputLine%.p
if /I "%OutputLine%" == " 6" set p=%OutputLine%.p
if /I "%OutputLine%" == " 7" set p=%OutputLine%.p
if /I "%OutputLine%" == " 8" set p=%OutputLine%.p
if /I "%OutputLine%" == " 9" set p=%OutputLine%.p
if /I "%OutputLine%" == " a" set p=%OutputLine%.p
if /I "%OutputLine%" == " b" set p=%OutputLine%.p
if /I "%OutputLine%" == " c" set p=%OutputLine%.p
if /I "%OutputLine%" == " d" set p=%OutputLine%.p
if /I "%OutputLine%" == " e" set p=%OutputLine%.p
if /I "%OutputLine%" == " f" set p=%OutputLine%.p
if /I "%OutputLine%" == " 0" set p=%OutputLine%.p
set "OutputLine="
if not "%p%" == "no" goto dun

:dun

set "aa=%a: =%"
set "bb=%b: =%"
set "cc=%c: =%"
set "dd=%d: =%"
set "ee=%e: =%"
set "ff=%f: =%"
set "gg=%g: =%"
set "hh=%h: =%"
set "ii=%i: =%"
set "jj=%j: =%"
set "kk=%k: =%"
set "ll=%l: =%"
set "mm=%m: =%"
set "nn=%n: =%"
set "oo=%o: =%"
set "pp=%p: =%"
set "aaa=%aa:.v=%"
set "bbb=%bb:.u=%"
set "ccc=%cc:.t=%"
set "ddd=%dd:.s=%"
set "eee=%ee:.r=%"
set "fff=%ff:.q=%"
set "ggg=%gg:.g=%"
set "hhh=%hh:.h=%"
set "iii=%ii:.i=%"
set "jjj=%jj:.j=%"
set "kkk=%kk:.k=%"
set "lll=%ll:.l=%"
set "mmm=%mm:.m=%"
set "nnn=%nn:.n=%"
set "ooo=%oo:.o=%"
set "ppp=%pp:.p=%"


echo %ooo%%ppp%%mmm%%nnn%%kkk%%lll%%iii%%jjj%%ggg%%hhh%%eee%%fff%%ccc%%ddd%%aaa%%bbb% > title2.txt
set /P title2= <title2.txt
del title2.txt

CALL :UpCase2 title2

:UpCase2
FOR %%P IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "%1=%%%1:%%~P%%"

CALL :UpCase Title

:UpCase
cls
FOR %%P IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "%1=%%%1:%%~P%%"
echo.
echo ******************************************************
echo.
echo : : Paste TitleID you wish to Patch "main.npdm" with
echo.
echo : : Must be 16 characters (e.g. 01002d4007ae0000) 
echo.
echo : : If you do not wish to patch TitleID press N
echo.
set /P ntid= : :
echo.
if /I "%ntid%" == "N" goto nop


echo %ntid% > xciDecrypted\test2.tx
set "CodeFile=xciDecrypted\test2.tx"
set "TempFile=%CodeFile%.tmp"
del "%TempFile%" 2>nul
for /F "usebackq delims=" %%I in ("%CodeFile%") do call :EncodeLine "%%~I"
if exist "%TempFile%" move /Y "%TempFile%" "%CodeFile%"
goto :EOF

:EncodeLine
set "InputLine=%~1"
set "OutputLine="

:NextChar
set a=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set a=%OutputLine%.v
if /I "%OutputLine%" == " 2" set a=%OutputLine%.v
if /I "%OutputLine%" == " 3" set a=%OutputLine%.v
if /I "%OutputLine%" == " 4" set a=%OutputLine%.v
if /I "%OutputLine%" == " 5" set a=%OutputLine%.v
if /I "%OutputLine%" == " 6" set a=%OutputLine%.v
if /I "%OutputLine%" == " 7" set a=%OutputLine%.v
if /I "%OutputLine%" == " 8" set a=%OutputLine%.v
if /I "%OutputLine%" == " 9" set a=%OutputLine%.v
if /I "%OutputLine%" == " a" set a=%OutputLine%.v
if /I "%OutputLine%" == " b" set a=%OutputLine%.v
if /I "%OutputLine%" == " c" set a=%OutputLine%.v
if /I "%OutputLine%" == " d" set a=%OutputLine%.v
if /I "%OutputLine%" == " e" set a=%OutputLine%.v
if /I "%OutputLine%" == " f" set a=%OutputLine%.v
if /I "%OutputLine%" == " 0" set a=%OutputLine%.v
set "OutputLine="
if not "%a%" == "no" goto next

:next
set b=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set b=%OutputLine%.u
if /I "%OutputLine%" == " 2" set b=%OutputLine%.u
if /I "%OutputLine%" == " 3" set b=%OutputLine%.u
if /I "%OutputLine%" == " 4" set b=%OutputLine%.u
if /I "%OutputLine%" == " 5" set b=%OutputLine%.u
if /I "%OutputLine%" == " 6" set b=%OutputLine%.u
if /I "%OutputLine%" == " 7" set b=%OutputLine%.u
if /I "%OutputLine%" == " 8" set b=%OutputLine%.u
if /I "%OutputLine%" == " 9" set b=%OutputLine%.u
if /I "%OutputLine%" == " a" set b=%OutputLine%.u
if /I "%OutputLine%" == " b" set b=%OutputLine%.u
if /I "%OutputLine%" == " c" set b=%OutputLine%.u
if /I "%OutputLine%" == " d" set b=%OutputLine%.u
if /I "%OutputLine%" == " e" set b=%OutputLine%.u
if /I "%OutputLine%" == " f" set b=%OutputLine%.u
if /I "%OutputLine%" == " 0" set b=%OutputLine%.u
set "OutputLine="
if not "%b%" == "no" goto next

:next
set c=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set c=%OutputLine%.t
if /I "%OutputLine%" == " 2" set c=%OutputLine%.t
if /I "%OutputLine%" == " 3" set c=%OutputLine%.t
if /I "%OutputLine%" == " 4" set c=%OutputLine%.t
if /I "%OutputLine%" == " 5" set c=%OutputLine%.t
if /I "%OutputLine%" == " 6" set c=%OutputLine%.t
if /I "%OutputLine%" == " 7" set c=%OutputLine%.t
if /I "%OutputLine%" == " 8" set c=%OutputLine%.t
if /I "%OutputLine%" == " 9" set c=%OutputLine%.t
if /I "%OutputLine%" == " a" set c=%OutputLine%.t
if /I "%OutputLine%" == " b" set c=%OutputLine%.t
if /I "%OutputLine%" == " c" set c=%OutputLine%.t
if /I "%OutputLine%" == " d" set c=%OutputLine%.t
if /I "%OutputLine%" == " e" set c=%OutputLine%.t
if /I "%OutputLine%" == " f" set c=%OutputLine%.t
if /I "%OutputLine%" == " 0" set c=%OutputLine%.t
set "OutputLine="
if not "%c%" == "no" goto next

:next
set d=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set d=%OutputLine%.s
if /I "%OutputLine%" == " 2" set d=%OutputLine%.s
if /I "%OutputLine%" == " 3" set d=%OutputLine%.s
if /I "%OutputLine%" == " 4" set d=%OutputLine%.s
if /I "%OutputLine%" == " 5" set d=%OutputLine%.s
if /I "%OutputLine%" == " 6" set d=%OutputLine%.s
if /I "%OutputLine%" == " 7" set d=%OutputLine%.s
if /I "%OutputLine%" == " 8" set d=%OutputLine%.s
if /I "%OutputLine%" == " 9" set d=%OutputLine%.s
if /I "%OutputLine%" == " a" set d=%OutputLine%.s
if /I "%OutputLine%" == " b" set d=%OutputLine%.s
if /I "%OutputLine%" == " c" set d=%OutputLine%.s
if /I "%OutputLine%" == " d" set d=%OutputLine%.s
if /I "%OutputLine%" == " e" set d=%OutputLine%.s
if /I "%OutputLine%" == " f" set d=%OutputLine%.s
if /I "%OutputLine%" == " 0" set d=%OutputLine%.s
set "OutputLine="
if not "%d%" == "no" goto next

:next
set e=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set e=%OutputLine%.r
if /I "%OutputLine%" == " 2" set e=%OutputLine%.r
if /I "%OutputLine%" == " 3" set e=%OutputLine%.r
if /I "%OutputLine%" == " 4" set e=%OutputLine%.r
if /I "%OutputLine%" == " 5" set e=%OutputLine%.r
if /I "%OutputLine%" == " 6" set e=%OutputLine%.r
if /I "%OutputLine%" == " 7" set e=%OutputLine%.r
if /I "%OutputLine%" == " 8" set e=%OutputLine%.r
if /I "%OutputLine%" == " 9" set e=%OutputLine%.r
if /I "%OutputLine%" == " a" set e=%OutputLine%.r
if /I "%OutputLine%" == " b" set e=%OutputLine%.r
if /I "%OutputLine%" == " c" set e=%OutputLine%.r
if /I "%OutputLine%" == " d" set e=%OutputLine%.r
if /I "%OutputLine%" == " e" set e=%OutputLine%.r
if /I "%OutputLine%" == " f" set e=%OutputLine%.r
if /I "%OutputLine%" == " 0" set e=%OutputLine%.r
set "OutputLine="
if not "%e%" == "no" goto next

:next
set f=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set f=%OutputLine%.q
if /I "%OutputLine%" == " 2" set f=%OutputLine%.q
if /I "%OutputLine%" == " 3" set f=%OutputLine%.q
if /I "%OutputLine%" == " 4" set f=%OutputLine%.q
if /I "%OutputLine%" == " 5" set f=%OutputLine%.q
if /I "%OutputLine%" == " 6" set f=%OutputLine%.q
if /I "%OutputLine%" == " 7" set f=%OutputLine%.q
if /I "%OutputLine%" == " 8" set f=%OutputLine%.q
if /I "%OutputLine%" == " 9" set f=%OutputLine%.q
if /I "%OutputLine%" == " a" set f=%OutputLine%.q
if /I "%OutputLine%" == " b" set f=%OutputLine%.q
if /I "%OutputLine%" == " c" set f=%OutputLine%.q
if /I "%OutputLine%" == " d" set f=%OutputLine%.q
if /I "%OutputLine%" == " e" set f=%OutputLine%.q
if /I "%OutputLine%" == " f" set f=%OutputLine%.q
if /I "%OutputLine%" == " 0" set f=%OutputLine%.q
set "OutputLine="
if not "%f%" == "no" goto next

:next
set g=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set g=%OutputLine%.g
if /I "%OutputLine%" == " 2" set g=%OutputLine%.g
if /I "%OutputLine%" == " 3" set g=%OutputLine%.g
if /I "%OutputLine%" == " 4" set g=%OutputLine%.g
if /I "%OutputLine%" == " 5" set g=%OutputLine%.g
if /I "%OutputLine%" == " 6" set g=%OutputLine%.g
if /I "%OutputLine%" == " 7" set g=%OutputLine%.g
if /I "%OutputLine%" == " 8" set g=%OutputLine%.g
if /I "%OutputLine%" == " 9" set g=%OutputLine%.g
if /I "%OutputLine%" == " a" set g=%OutputLine%.g
if /I "%OutputLine%" == " b" set g=%OutputLine%.g
if /I "%OutputLine%" == " c" set g=%OutputLine%.g
if /I "%OutputLine%" == " d" set g=%OutputLine%.g
if /I "%OutputLine%" == " e" set g=%OutputLine%.g
if /I "%OutputLine%" == " f" set g=%OutputLine%.g
if /I "%OutputLine%" == " 0" set g=%OutputLine%.g
set "OutputLine="
if not "%g%" == "no" goto next

:next
set h=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set h=%OutputLine%.h
if /I "%OutputLine%" == " 2" set h=%OutputLine%.h
if /I "%OutputLine%" == " 3" set h=%OutputLine%.h
if /I "%OutputLine%" == " 4" set h=%OutputLine%.h
if /I "%OutputLine%" == " 5" set h=%OutputLine%.h
if /I "%OutputLine%" == " 6" set h=%OutputLine%.h
if /I "%OutputLine%" == " 7" set h=%OutputLine%.h
if /I "%OutputLine%" == " 8" set h=%OutputLine%.h
if /I "%OutputLine%" == " 9" set h=%OutputLine%.h
if /I "%OutputLine%" == " a" set h=%OutputLine%.h
if /I "%OutputLine%" == " b" set h=%OutputLine%.h
if /I "%OutputLine%" == " c" set h=%OutputLine%.h
if /I "%OutputLine%" == " d" set h=%OutputLine%.h
if /I "%OutputLine%" == " e" set h=%OutputLine%.h
if /I "%OutputLine%" == " f" set h=%OutputLine%.h
if /I "%OutputLine%" == " 0" set h=%OutputLine%.h
set "OutputLine="
if not "%h%" == "no" goto next

:next
set i=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set i=%OutputLine%.i
if /I "%OutputLine%" == " 2" set i=%OutputLine%.i
if /I "%OutputLine%" == " 3" set i=%OutputLine%.i
if /I "%OutputLine%" == " 4" set i=%OutputLine%.i
if /I "%OutputLine%" == " 5" set i=%OutputLine%.i
if /I "%OutputLine%" == " 6" set i=%OutputLine%.i
if /I "%OutputLine%" == " 7" set i=%OutputLine%.i
if /I "%OutputLine%" == " 8" set i=%OutputLine%.i
if /I "%OutputLine%" == " 9" set i=%OutputLine%.i
if /I "%OutputLine%" == " a" set i=%OutputLine%.i
if /I "%OutputLine%" == " b" set i=%OutputLine%.i
if /I "%OutputLine%" == " c" set i=%OutputLine%.i
if /I "%OutputLine%" == " d" set i=%OutputLine%.i
if /I "%OutputLine%" == " e" set i=%OutputLine%.i
if /I "%OutputLine%" == " f" set i=%OutputLine%.i
if /I "%OutputLine%" == " 0" set i=%OutputLine%.i
set "OutputLine="
if not "%i%" == "no" goto next

:next
set j=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set j=%OutputLine%.j
if /I "%OutputLine%" == " 2" set j=%OutputLine%.j
if /I "%OutputLine%" == " 3" set j=%OutputLine%.j
if /I "%OutputLine%" == " 4" set j=%OutputLine%.j
if /I "%OutputLine%" == " 5" set j=%OutputLine%.j
if /I "%OutputLine%" == " 6" set j=%OutputLine%.j
if /I "%OutputLine%" == " 7" set j=%OutputLine%.j
if /I "%OutputLine%" == " 8" set j=%OutputLine%.j
if /I "%OutputLine%" == " 9" set j=%OutputLine%.j
if /I "%OutputLine%" == " a" set j=%OutputLine%.j
if /I "%OutputLine%" == " b" set j=%OutputLine%.j
if /I "%OutputLine%" == " c" set j=%OutputLine%.j
if /I "%OutputLine%" == " d" set j=%OutputLine%.j
if /I "%OutputLine%" == " e" set j=%OutputLine%.j
if /I "%OutputLine%" == " f" set j=%OutputLine%.j
if /I "%OutputLine%" == " 0" set j=%OutputLine%.j
set "OutputLine="
if not "%j%" == "no" goto next

:next
set k=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set k=%OutputLine%.k
if /I "%OutputLine%" == " 2" set k=%OutputLine%.k
if /I "%OutputLine%" == " 3" set k=%OutputLine%.k
if /I "%OutputLine%" == " 4" set k=%OutputLine%.k
if /I "%OutputLine%" == " 5" set k=%OutputLine%.k
if /I "%OutputLine%" == " 6" set k=%OutputLine%.k
if /I "%OutputLine%" == " 7" set k=%OutputLine%.k
if /I "%OutputLine%" == " 8" set k=%OutputLine%.k
if /I "%OutputLine%" == " 9" set k=%OutputLine%.k
if /I "%OutputLine%" == " a" set k=%OutputLine%.k
if /I "%OutputLine%" == " b" set k=%OutputLine%.k
if /I "%OutputLine%" == " c" set k=%OutputLine%.k
if /I "%OutputLine%" == " d" set k=%OutputLine%.k
if /I "%OutputLine%" == " e" set k=%OutputLine%.k
if /I "%OutputLine%" == " f" set k=%OutputLine%.k
if /I "%OutputLine%" == " 0" set k=%OutputLine%.k
set "OutputLine="
if not "%k%" == "no" goto next

:next
set l=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set l=%OutputLine%.l
if /I "%OutputLine%" == " 2" set l=%OutputLine%.l
if /I "%OutputLine%" == " 3" set l=%OutputLine%.l
if /I "%OutputLine%" == " 4" set l=%OutputLine%.l
if /I "%OutputLine%" == " 5" set l=%OutputLine%.l
if /I "%OutputLine%" == " 6" set l=%OutputLine%.l
if /I "%OutputLine%" == " 7" set l=%OutputLine%.l
if /I "%OutputLine%" == " 8" set l=%OutputLine%.l
if /I "%OutputLine%" == " 9" set l=%OutputLine%.l
if /I "%OutputLine%" == " a" set l=%OutputLine%.l
if /I "%OutputLine%" == " b" set l=%OutputLine%.l
if /I "%OutputLine%" == " c" set l=%OutputLine%.l
if /I "%OutputLine%" == " d" set l=%OutputLine%.l
if /I "%OutputLine%" == " e" set l=%OutputLine%.l
if /I "%OutputLine%" == " f" set l=%OutputLine%.l
if /I "%OutputLine%" == " 0" set l=%OutputLine%.l
set "OutputLine="
if not "%l%" == "no" goto next

:next
set m=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set m=%OutputLine%.m
if /I "%OutputLine%" == " 2" set m=%OutputLine%.m
if /I "%OutputLine%" == " 3" set m=%OutputLine%.m
if /I "%OutputLine%" == " 4" set m=%OutputLine%.m
if /I "%OutputLine%" == " 5" set m=%OutputLine%.m
if /I "%OutputLine%" == " 6" set m=%OutputLine%.m
if /I "%OutputLine%" == " 7" set m=%OutputLine%.m
if /I "%OutputLine%" == " 8" set m=%OutputLine%.m
if /I "%OutputLine%" == " 9" set m=%OutputLine%.m
if /I "%OutputLine%" == " a" set m=%OutputLine%.m
if /I "%OutputLine%" == " b" set m=%OutputLine%.m
if /I "%OutputLine%" == " c" set m=%OutputLine%.m
if /I "%OutputLine%" == " d" set m=%OutputLine%.m
if /I "%OutputLine%" == " e" set m=%OutputLine%.m
if /I "%OutputLine%" == " f" set m=%OutputLine%.m
if /I "%OutputLine%" == " 0" set m=%OutputLine%.m
set "OutputLine="
if not "%m%" == "no" goto next

:next
set n=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set n=%OutputLine%.n
if /I "%OutputLine%" == " 2" set n=%OutputLine%.n
if /I "%OutputLine%" == " 3" set n=%OutputLine%.n
if /I "%OutputLine%" == " 4" set n=%OutputLine%.n
if /I "%OutputLine%" == " 5" set n=%OutputLine%.n
if /I "%OutputLine%" == " 6" set n=%OutputLine%.n
if /I "%OutputLine%" == " 7" set n=%OutputLine%.n
if /I "%OutputLine%" == " 8" set n=%OutputLine%.n
if /I "%OutputLine%" == " 9" set n=%OutputLine%.n
if /I "%OutputLine%" == " a" set n=%OutputLine%.n
if /I "%OutputLine%" == " b" set n=%OutputLine%.n
if /I "%OutputLine%" == " c" set n=%OutputLine%.n
if /I "%OutputLine%" == " d" set n=%OutputLine%.n
if /I "%OutputLine%" == " e" set n=%OutputLine%.n
if /I "%OutputLine%" == " f" set n=%OutputLine%.n
if /I "%OutputLine%" == " 0" set n=%OutputLine%.n
set "OutputLine="
if not "%n%" == "no" goto next

:next
set o=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set o=%OutputLine%.o
if /I "%OutputLine%" == " 2" set o=%OutputLine%.o
if /I "%OutputLine%" == " 3" set o=%OutputLine%.o
if /I "%OutputLine%" == " 4" set o=%OutputLine%.o
if /I "%OutputLine%" == " 5" set o=%OutputLine%.o
if /I "%OutputLine%" == " 6" set o=%OutputLine%.o
if /I "%OutputLine%" == " 7" set o=%OutputLine%.o
if /I "%OutputLine%" == " 8" set o=%OutputLine%.o
if /I "%OutputLine%" == " 9" set o=%OutputLine%.o
if /I "%OutputLine%" == " a" set o=%OutputLine%.o
if /I "%OutputLine%" == " b" set o=%OutputLine%.o
if /I "%OutputLine%" == " c" set o=%OutputLine%.o
if /I "%OutputLine%" == " d" set o=%OutputLine%.o
if /I "%OutputLine%" == " e" set o=%OutputLine%.o
if /I "%OutputLine%" == " f" set o=%OutputLine%.o
if /I "%OutputLine%" == " 0" set o=%OutputLine%.o
set "OutputLine="
if not "%o%" == "no" goto next

:next
set p=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set p=%OutputLine%.p
if /I "%OutputLine%" == " 2" set p=%OutputLine%.p
if /I "%OutputLine%" == " 3" set p=%OutputLine%.p
if /I "%OutputLine%" == " 4" set p=%OutputLine%.p
if /I "%OutputLine%" == " 5" set p=%OutputLine%.p
if /I "%OutputLine%" == " 6" set p=%OutputLine%.p
if /I "%OutputLine%" == " 7" set p=%OutputLine%.p
if /I "%OutputLine%" == " 8" set p=%OutputLine%.p
if /I "%OutputLine%" == " 9" set p=%OutputLine%.p
if /I "%OutputLine%" == " a" set p=%OutputLine%.p
if /I "%OutputLine%" == " b" set p=%OutputLine%.p
if /I "%OutputLine%" == " c" set p=%OutputLine%.p
if /I "%OutputLine%" == " d" set p=%OutputLine%.p
if /I "%OutputLine%" == " e" set p=%OutputLine%.p
if /I "%OutputLine%" == " f" set p=%OutputLine%.p
if /I "%OutputLine%" == " 0" set p=%OutputLine%.p
set "OutputLine="
if not "%p%" == "no" goto dun

:dun

set "aa=%a: =%"
set "bb=%b: =%"
set "cc=%c: =%"
set "dd=%d: =%"
set "ee=%e: =%"
set "ff=%f: =%"
set "gg=%g: =%"
set "hh=%h: =%"
set "ii=%i: =%"
set "jj=%j: =%"
set "kk=%k: =%"
set "ll=%l: =%"
set "mm=%m: =%"
set "nn=%n: =%"
set "oo=%o: =%"
set "pp=%p: =%"
set "aaa=%aa:.v=%"
set "bbb=%bb:.u=%"
set "ccc=%cc:.t=%"
set "ddd=%dd:.s=%"
set "eee=%ee:.r=%"
set "fff=%ff:.q=%"
set "ggg=%gg:.g=%"
set "hhh=%hh:.h=%"
set "iii=%ii:.i=%"
set "jjj=%jj:.j=%"
set "kkk=%kk:.k=%"
set "lll=%ll:.l=%"
set "mmm=%mm:.m=%"
set "nnn=%nn:.n=%"
set "ooo=%oo:.o=%"
set "ppp=%pp:.p=%"


echo %ooo%%ppp%%mmm%%nnn%%kkk%%lll%%iii%%jjj%%ggg%%hhh%%eee%%fff%%ccc%%ddd%%aaa%%bbb%> title9.txt
set /P title9= <title9.txt
del title9.txt
if exist "xciDecrypted\%Title%\romfs.istorage" goto ps7
MD  xciDecrypted\%Title%
"%~dp0\tools\hactool.exe" -k "%~dp0\tools\prod.keys" --romfs="xciDecrypted\%Title%\romfs.istorage" --exefsdir="xciDecrypted\%Title%" "xciDecrypted\%nca_file%" >nul 2>&1
if not exist "xciDecrypted\%Title%\romfs.istorage" goto step3
:ps7
set di="%~dp0\xciDecrypted\%Title%"
set di6="%di:"=%"
set di2="%~dp0"
set "di3=%di2:"=%"
echo "%di3%"
set "title3=%title2: =%"
echo "%title3%"

move/Y "%di%\main.npdm" "%~dp0\main"
"%~dp0\tools\sfk" -yes replace -binary "/%title3%/%title9%/" -dir %di3% -file main
move/Y "%~dp0\main" "%di6%\main.npdm"

if exist "xciDecrypted\logo" RD /S /Q "xciDecrypted\logo"
if exist "xciDecrypted\normal" RD /S /Q "xciDecrypted\normal"
if exist "xciDecrypted\secure" RD /S /Q "xciDecrypted\secure"
if exist "xciDecrypted\update" RD /S /Q "xciDecrypted\update"
if exist "xciDecrypted\*.nca" del "xciDecrypted\*.nca"
if exist "xciDecrypted\*.txt" del "xciDecrypted\*.txt"
if exist "xciDecrypted\*.tx" del "xciDecrypted\*.tx"
cls
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit

:step3
tools\sed -i~ 1d xciDecrypted\nca_name.txt
set /P nca2_file= < xciDecrypted\nca_name.txt
"%~dp0\tools\hactool.exe" -k "%~dp0\tools\prod.keys" --romfs="xciDecrypted\%Title%\romfs.istorage" --exefsdir="xciDecrypted\%Title%\exefs" "xciDecrypted\%nca2_file%" >nul 2>&1
if exist "xciDecrypted\*.nca" del "xciDecrypted\*.nca"
if exist "xciDecrypted\*.txt" del "xciDecrypted\*.txt"
if exist xciDecrypted\*.tik del xciDecrypted\*.tik
if exist xciDecrypted\*.cert del xciDecrypted\*.cert
goto ps7

:nop
if exist "xciDecrypted\%Title%\romfs.istorage" goto ps6
MD  xciDecrypted\%Title%
"%~dp0tools\hactool.exe" -k "%~dp0tools\prod.keys" --romfs="xciDecrypted\%Title%\romfs.istorage" --exefsdir="xciDecrypted\%Title%\exefs" "xciDecrypted\%nca_file%" >nul 2>&1
if not exist "xciDecrypted\%Title%\romfs.istorage" goto nw3
:ps6
if exist "xciDecrypted\logo" RD /S /Q "xciDecrypted\logo"
if exist "xciDecrypted\normal" RD /S /Q "xciDecrypted\normal"
if exist "xciDecrypted\secure" RD /S /Q "xciDecrypted\secure"
if exist "xciDecrypted\update" RD /S /Q "xciDecrypted\update"
if exist "xciDecrypted\*.nca" del "xciDecrypted\*.nca"
if exist "xciDecrypted\*.txt" del "xciDecrypted\*.txt"
if exist "xciDecrypted\*.tx" del "xciDecrypted\*.tx"
cls
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit

:nw3
tools\sed -i~ 1d xciDecrypted\nca_name.txt
set /P nca2_file= < xciDecrypted\nca_name.txt
echo %nca2_file%
"%~dp0tools\hactool.exe" -k "%~dp0tools\prod.keys" -t nca --romfs="xciDecrypted\%Title%\romfs.istorage" --exefsdir="xciDecrypted\%Title%\exefs" "xciDecrypted\%nca2_file%"
cls
if exist "xciDecrypted\logo" RD /S /Q "xciDecrypted\logo"
if exist "xciDecrypted\normal" RD /S /Q "xciDecrypted\normal"
if exist "xciDecrypted\secure" RD /S /Q "xciDecrypted\secure"
if exist "xciDecrypted\update" RD /S /Q "xciDecrypted\update"
if exist "xciDecrypted\*.nca" del "xciDecrypted\*.nca"
if exist "xciDecrypted\*.txt" del "xciDecrypted\*.txt"
if exist "xciDecrypted\*.tx" del "xciDecrypted\*.tx"
if exist xciDecrypted\*.tik del xciDecrypted\*.tik
if exist xciDecrypted\*.cert del xciDecrypted\*.cert
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit


:glta

cls
echo :: Decrypting......"%~nx1"
"%~dp0tools\hactool.exe" -k "%~dp0tools\prod.keys" -t xci --outdir=xciDecrypted "%~1" >nul 2>&1
cls
dir "xciDecrypted\secure" /b /o-s > xciDecrypted\nca_name.txt
set /P nca_file= < xciDecrypted\nca_name.txt
del xciDecrypted\nca_name.txt
cls
"%~dp0tools\hactool.exe" -k "%~dp0tools\prod.keys" --header=xciDecrypted\new.txt "xciDecrypted\secure\%nca_file%" > xciDecrypted\new1.txt 2>&1
cls
echo :: Decrypting....."%nca_file%"
for /f "skip=20 tokens=1,2*" %%O in (xciDecrypted\new1.txt) do if "%%O %%P"=="Title ID:" set Title=%%Q
CALL :UpCase Title

:UpCase

FOR %%P IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "%1=%%%1:%%~P%%"
if exist "xciDecrypted\*.nca" del "xciDecrypted\*.nca"
if exist "xciDecrypted\*.txt" del "xciDecrypted\*.txt"
cls
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit

:game

cls
echo :: Decrypting......"%~nx1"
"%~dp0tools\hactool.exe" -k "%~dp0\tools\prod.keys" -t xci --securedir=xciDecrypted "%~1" >nul 2>&1
cls
dir "xciDecrypted" /b /o-s > xciDecrypted\nca_name.txt
set /P nca_file= < xciDecrypted\nca_name.txt
"%~dp0tools\hactool.exe" -k "%~dp0\tools\prod.keys" --header=xciDecrypted\new.txt "xciDecrypted\%nca_file%" > xciDecrypted\new1.txt 2>&1
cls
echo :: Decrypting....."%nca_file%"
for /f "skip=20 tokens=1,2*" %%O in (xciDecrypted\new1.txt) do if "%%O %%P"=="Title ID:" set Title=%%Q
CALL :UpCase Title

:UpCase

FOR %%P IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "%1=%%%1:%%~P%%"
MD  xciDecrypted\%Title%
"%~dp0tools\hactool.exe" -k "%~dp0\tools\prod.keys" --section0dir="xciDecrypted\%Title%" --section1dir="xciDecrypted\%Title%" --section2dir="xciDecrypted\%Title%" --section3dir="xciDecrypted\%Title%" "xciDecrypted\%nca_file%">nul 2>&1
if not exist "xciDecrypted\%Title%\main" goto step2 
if exist "xciDecrypted\*.nca" del "xciDecrypted\*.nca"
if exist "xciDecrypted\*.txt" del "xciDecrypted\*.txt"
if exist xciDecrypted\*.tik del xciDecrypted\*.tik
if exist xciDecrypted\*.cert del xciDecrypted\*.cert
cls
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit

:step2
tools\sed -i~ 1d xciDecrypted\nca_name.txt
set /P nca2_file= < xciDecrypted\nca_name.txt
"%~dp0tools\hactool.exe" -k "%~dp0\tools\prod.keys" --section0dir="xciDecrypted\%Title%" --section1dir="xciDecrypted\%Title%" --section2dir="xciDecrypted\%Title%" --section3dir="xciDecrypted\%Title%" "xciDecrypted\%nca2_file%"  >nul 2>&1
if exist "xciDecrypted\*.nca" del "xciDecrypted\*.nca"
if exist "xciDecrypted\*.txt" del "xciDecrypted\*.txt"
if exist xciDecrypted\*.tik del xciDecrypted\*.tik
if exist xciDecrypted\*.cert del xciDecrypted\*.cert
cls
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit

:nca

if "%~x1"==".nca" MD ncaDecrypted
cls
echo :: Decrypting......"%~nx1"
"%~dp0tools\hactool.exe" -k "%~dp0tools\prod.keys" --section0dir="ncaDecrypted" --section1dir="ncaDecrypted" --section2dir="ncaDecrypted" --section3dir="ncaDecrypted" "%~1" >ncaDecrypted\tk9.txt
"%~dp0tools\sfk.exe" ftext ncaDecrypted\tk9.txt Error: section 0 >ncaDecrypted\tk8.txt
"%~dp0tools\sfk.exe" ftext ncaDecrypted\tk9.txt [WARN] Unable to match rights id to titlekey. Update title.keys? >ncaDecrypted\tj8.txt
set /P tk7=<ncaDecrypted\tk8.txt
set /P tj7=<ncaDecrypted\tj8.txt
del ncaDecrypted\tk9.txt
del ncaDecrypted\tk8.txt
del ncaDecrypted\tj9.txt
del ncaDecrypted\tj8.txt
cls
if "%tk7%"=="Error: section 0 is corrupted!" (goto ntk)
if "%tj7%"=="[WARN] Unable to match rights id to titlekey. Update title.keys?" (goto ntk)
goto dune
:ntk

if exist "%~dp1*tik" goto ft2
cls
setlocal
echo.
echo This NCA needs a Titlekey to extract. Paste titlekey here. Spaces are OK! If you don't know it enter N.
echo.
set /P tk6=
echo %tk6%>tools\tl.txt
if /I "%tk6%"==N (goto dune)
FOR /F "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16" %%G IN (tools\tl.txt) DO set tk8=%%G%%H%%I%%J%%K%%L%%M%%N%%O%%P%%Q%%R%%S%%T%%U%%V
del tools\tl.txt
"%~dp0tools\hactool.exe" --titlekey="%tk8%" --section0dir="ncaDecrypted" --section1dir="ncaDecrypted" --section2dir="ncaDecrypted" --section3dir="ncaDecrypted" "%~1" >nul 2>&1
:dune

cls
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit

:ft2
(for %%J in ("%~dp1*tik") do (for /f %%K in ('"%~dp0\tools\tf.exe" %%J') do set tk1=%%K))>nul
"%~dp0tools\hactool.exe" --titlekey="%tk1%" --section0dir="ncaDecrypted" --section1dir="ncaDecrypted" --section2dir="ncaDecrypted" --section3dir="ncaDecrypted" "%~1" >nul 2>&1
cls
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit

:nsp

MD nspDecrypted
set file=%~1
set filename=%~n1
echo : : Decrypting "%filename%"
"%~dp0tools\hactool.exe" -k "%~dp0tools\prod.keys" -t pfs0 --pfs0dir=nspDecrypted "%~1" > tools\new3.txt
(for %%J in (nspDecrypted\*.tik) do (for /f %%K in ('"%~dp0\tools\tf.exe" %%J') do set tk1=%%K))>nul
set offset=132
FOR /F "tokens=*" %%I in ('""%~dp0tools\od.exe" -j%offset% -N16 -w16 -t c "tools\new3.txt" | "%~dp0tools\cut.exe" -c 8- |"%~dp0tools\sed.exe" 's/ //g'"') do set tk=%%I
del tools\new3.txt
CALL :UpCase tk

:UpCase

FOR %%P IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "%1=%%%1:%%~P%%"

:back2

cls
echo ***********************************************
echo.
echo    Do you want to Extract NSP file - Press 1
echo.   
echo    Do you want ExeFS and romfs.istorage - Press 2    *NOTE* - This will Patch "main.npdm"
echo.   
echo    Do you just want the game files - Press 3 
echo.
echo    Do you want to Convert NSP to XCI - Press 4
echo.
echo ************************************************
echo   TitleID  - [%tk%]
echo.
echo   TitleKey - [%tk1%]
echo ************************************************
echo.
set /p DG1= Your Choice (1-4):
if "%DG1%"=="1" (goto glta2)
if "%DG1%"=="2" (goto here2)
if "%DG1%"=="3" (goto game2)
if "%DG1%"=="4" (goto n2x)
echo You can only choose 1-4
pause
cls
goto back2

:here2

echo %tk% > nspDecrypted\test.tx
set "CodeFile=nspDecrypted\test.tx"
set "TempFile=%CodeFile%.tmp"
del "%TempFile%" 2>nul
for /F "usebackq delims=" %%I in ("%CodeFile%") do call :EncodeLine "%%~I"
if exist "%TempFile%" move /Y "%TempFile%" "%CodeFile%"
goto :EOF

:EncodeLine
set "InputLine=%~1"
set "OutputLine="

:NextChar
set a=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set a=%OutputLine%.v
if /I "%OutputLine%" == " 2" set a=%OutputLine%.v
if /I "%OutputLine%" == " 3" set a=%OutputLine%.v
if /I "%OutputLine%" == " 4" set a=%OutputLine%.v
if /I "%OutputLine%" == " 5" set a=%OutputLine%.v
if /I "%OutputLine%" == " 6" set a=%OutputLine%.v
if /I "%OutputLine%" == " 7" set a=%OutputLine%.v
if /I "%OutputLine%" == " 8" set a=%OutputLine%.v
if /I "%OutputLine%" == " 9" set a=%OutputLine%.v
if /I "%OutputLine%" == " a" set a=%OutputLine%.v
if /I "%OutputLine%" == " b" set a=%OutputLine%.v
if /I "%OutputLine%" == " c" set a=%OutputLine%.v
if /I "%OutputLine%" == " d" set a=%OutputLine%.v
if /I "%OutputLine%" == " e" set a=%OutputLine%.v
if /I "%OutputLine%" == " f" set a=%OutputLine%.v
if /I "%OutputLine%" == " 0" set a=%OutputLine%.v
set "OutputLine="
if not "%a%" == "no" goto next

:next
set b=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set b=%OutputLine%.u
if /I "%OutputLine%" == " 2" set b=%OutputLine%.u
if /I "%OutputLine%" == " 3" set b=%OutputLine%.u
if /I "%OutputLine%" == " 4" set b=%OutputLine%.u
if /I "%OutputLine%" == " 5" set b=%OutputLine%.u
if /I "%OutputLine%" == " 6" set b=%OutputLine%.u
if /I "%OutputLine%" == " 7" set b=%OutputLine%.u
if /I "%OutputLine%" == " 8" set b=%OutputLine%.u
if /I "%OutputLine%" == " 9" set b=%OutputLine%.u
if /I "%OutputLine%" == " a" set b=%OutputLine%.u
if /I "%OutputLine%" == " b" set b=%OutputLine%.u
if /I "%OutputLine%" == " c" set b=%OutputLine%.u
if /I "%OutputLine%" == " d" set b=%OutputLine%.u
if /I "%OutputLine%" == " e" set b=%OutputLine%.u
if /I "%OutputLine%" == " f" set b=%OutputLine%.u
if /I "%OutputLine%" == " 0" set b=%OutputLine%.u
set "OutputLine="
if not "%b%" == "no" goto next

:next
set c=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set c=%OutputLine%.t
if /I "%OutputLine%" == " 2" set c=%OutputLine%.t
if /I "%OutputLine%" == " 3" set c=%OutputLine%.t
if /I "%OutputLine%" == " 4" set c=%OutputLine%.t
if /I "%OutputLine%" == " 5" set c=%OutputLine%.t
if /I "%OutputLine%" == " 6" set c=%OutputLine%.t
if /I "%OutputLine%" == " 7" set c=%OutputLine%.t
if /I "%OutputLine%" == " 8" set c=%OutputLine%.t
if /I "%OutputLine%" == " 9" set c=%OutputLine%.t
if /I "%OutputLine%" == " a" set c=%OutputLine%.t
if /I "%OutputLine%" == " b" set c=%OutputLine%.t
if /I "%OutputLine%" == " c" set c=%OutputLine%.t
if /I "%OutputLine%" == " d" set c=%OutputLine%.t
if /I "%OutputLine%" == " e" set c=%OutputLine%.t
if /I "%OutputLine%" == " f" set c=%OutputLine%.t
if /I "%OutputLine%" == " 0" set c=%OutputLine%.t
set "OutputLine="
if not "%c%" == "no" goto next

:next
set d=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set d=%OutputLine%.s
if /I "%OutputLine%" == " 2" set d=%OutputLine%.s
if /I "%OutputLine%" == " 3" set d=%OutputLine%.s
if /I "%OutputLine%" == " 4" set d=%OutputLine%.s
if /I "%OutputLine%" == " 5" set d=%OutputLine%.s
if /I "%OutputLine%" == " 6" set d=%OutputLine%.s
if /I "%OutputLine%" == " 7" set d=%OutputLine%.s
if /I "%OutputLine%" == " 8" set d=%OutputLine%.s
if /I "%OutputLine%" == " 9" set d=%OutputLine%.s
if /I "%OutputLine%" == " a" set d=%OutputLine%.s
if /I "%OutputLine%" == " b" set d=%OutputLine%.s
if /I "%OutputLine%" == " c" set d=%OutputLine%.s
if /I "%OutputLine%" == " d" set d=%OutputLine%.s
if /I "%OutputLine%" == " e" set d=%OutputLine%.s
if /I "%OutputLine%" == " f" set d=%OutputLine%.s
if /I "%OutputLine%" == " 0" set d=%OutputLine%.s
set "OutputLine="
if not "%d%" == "no" goto next

:next
set e=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set e=%OutputLine%.r
if /I "%OutputLine%" == " 2" set e=%OutputLine%.r
if /I "%OutputLine%" == " 3" set e=%OutputLine%.r
if /I "%OutputLine%" == " 4" set e=%OutputLine%.r
if /I "%OutputLine%" == " 5" set e=%OutputLine%.r
if /I "%OutputLine%" == " 6" set e=%OutputLine%.r
if /I "%OutputLine%" == " 7" set e=%OutputLine%.r
if /I "%OutputLine%" == " 8" set e=%OutputLine%.r
if /I "%OutputLine%" == " 9" set e=%OutputLine%.r
if /I "%OutputLine%" == " a" set e=%OutputLine%.r
if /I "%OutputLine%" == " b" set e=%OutputLine%.r
if /I "%OutputLine%" == " c" set e=%OutputLine%.r
if /I "%OutputLine%" == " d" set e=%OutputLine%.r
if /I "%OutputLine%" == " e" set e=%OutputLine%.r
if /I "%OutputLine%" == " f" set e=%OutputLine%.r
if /I "%OutputLine%" == " 0" set e=%OutputLine%.r
set "OutputLine="
if not "%e%" == "no" goto next

:next
set f=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set f=%OutputLine%.q
if /I "%OutputLine%" == " 2" set f=%OutputLine%.q
if /I "%OutputLine%" == " 3" set f=%OutputLine%.q
if /I "%OutputLine%" == " 4" set f=%OutputLine%.q
if /I "%OutputLine%" == " 5" set f=%OutputLine%.q
if /I "%OutputLine%" == " 6" set f=%OutputLine%.q
if /I "%OutputLine%" == " 7" set f=%OutputLine%.q
if /I "%OutputLine%" == " 8" set f=%OutputLine%.q
if /I "%OutputLine%" == " 9" set f=%OutputLine%.q
if /I "%OutputLine%" == " a" set f=%OutputLine%.q
if /I "%OutputLine%" == " b" set f=%OutputLine%.q
if /I "%OutputLine%" == " c" set f=%OutputLine%.q
if /I "%OutputLine%" == " d" set f=%OutputLine%.q
if /I "%OutputLine%" == " e" set f=%OutputLine%.q
if /I "%OutputLine%" == " f" set f=%OutputLine%.q
if /I "%OutputLine%" == " 0" set f=%OutputLine%.q
set "OutputLine="
if not "%f%" == "no" goto next

:next
set g=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set g=%OutputLine%.g
if /I "%OutputLine%" == " 2" set g=%OutputLine%.g
if /I "%OutputLine%" == " 3" set g=%OutputLine%.g
if /I "%OutputLine%" == " 4" set g=%OutputLine%.g
if /I "%OutputLine%" == " 5" set g=%OutputLine%.g
if /I "%OutputLine%" == " 6" set g=%OutputLine%.g
if /I "%OutputLine%" == " 7" set g=%OutputLine%.g
if /I "%OutputLine%" == " 8" set g=%OutputLine%.g
if /I "%OutputLine%" == " 9" set g=%OutputLine%.g
if /I "%OutputLine%" == " a" set g=%OutputLine%.g
if /I "%OutputLine%" == " b" set g=%OutputLine%.g
if /I "%OutputLine%" == " c" set g=%OutputLine%.g
if /I "%OutputLine%" == " d" set g=%OutputLine%.g
if /I "%OutputLine%" == " e" set g=%OutputLine%.g
if /I "%OutputLine%" == " f" set g=%OutputLine%.g
if /I "%OutputLine%" == " 0" set g=%OutputLine%.g
set "OutputLine="
if not "%g%" == "no" goto next

:next
set h=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set h=%OutputLine%.h
if /I "%OutputLine%" == " 2" set h=%OutputLine%.h
if /I "%OutputLine%" == " 3" set h=%OutputLine%.h
if /I "%OutputLine%" == " 4" set h=%OutputLine%.h
if /I "%OutputLine%" == " 5" set h=%OutputLine%.h
if /I "%OutputLine%" == " 6" set h=%OutputLine%.h
if /I "%OutputLine%" == " 7" set h=%OutputLine%.h
if /I "%OutputLine%" == " 8" set h=%OutputLine%.h
if /I "%OutputLine%" == " 9" set h=%OutputLine%.h
if /I "%OutputLine%" == " a" set h=%OutputLine%.h
if /I "%OutputLine%" == " b" set h=%OutputLine%.h
if /I "%OutputLine%" == " c" set h=%OutputLine%.h
if /I "%OutputLine%" == " d" set h=%OutputLine%.h
if /I "%OutputLine%" == " e" set h=%OutputLine%.h
if /I "%OutputLine%" == " f" set h=%OutputLine%.h
if /I "%OutputLine%" == " 0" set h=%OutputLine%.h
set "OutputLine="
if not "%h%" == "no" goto next

:next
set i=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set i=%OutputLine%.i
if /I "%OutputLine%" == " 2" set i=%OutputLine%.i
if /I "%OutputLine%" == " 3" set i=%OutputLine%.i
if /I "%OutputLine%" == " 4" set i=%OutputLine%.i
if /I "%OutputLine%" == " 5" set i=%OutputLine%.i
if /I "%OutputLine%" == " 6" set i=%OutputLine%.i
if /I "%OutputLine%" == " 7" set i=%OutputLine%.i
if /I "%OutputLine%" == " 8" set i=%OutputLine%.i
if /I "%OutputLine%" == " 9" set i=%OutputLine%.i
if /I "%OutputLine%" == " a" set i=%OutputLine%.i
if /I "%OutputLine%" == " b" set i=%OutputLine%.i
if /I "%OutputLine%" == " c" set i=%OutputLine%.i
if /I "%OutputLine%" == " d" set i=%OutputLine%.i
if /I "%OutputLine%" == " e" set i=%OutputLine%.i
if /I "%OutputLine%" == " f" set i=%OutputLine%.i
if /I "%OutputLine%" == " 0" set i=%OutputLine%.i
set "OutputLine="
if not "%i%" == "no" goto next

:next
set j=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set j=%OutputLine%.j
if /I "%OutputLine%" == " 2" set j=%OutputLine%.j
if /I "%OutputLine%" == " 3" set j=%OutputLine%.j
if /I "%OutputLine%" == " 4" set j=%OutputLine%.j
if /I "%OutputLine%" == " 5" set j=%OutputLine%.j
if /I "%OutputLine%" == " 6" set j=%OutputLine%.j
if /I "%OutputLine%" == " 7" set j=%OutputLine%.j
if /I "%OutputLine%" == " 8" set j=%OutputLine%.j
if /I "%OutputLine%" == " 9" set j=%OutputLine%.j
if /I "%OutputLine%" == " a" set j=%OutputLine%.j
if /I "%OutputLine%" == " b" set j=%OutputLine%.j
if /I "%OutputLine%" == " c" set j=%OutputLine%.j
if /I "%OutputLine%" == " d" set j=%OutputLine%.j
if /I "%OutputLine%" == " e" set j=%OutputLine%.j
if /I "%OutputLine%" == " f" set j=%OutputLine%.j
if /I "%OutputLine%" == " 0" set j=%OutputLine%.j
set "OutputLine="
if not "%j%" == "no" goto next

:next
set k=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set k=%OutputLine%.k
if /I "%OutputLine%" == " 2" set k=%OutputLine%.k
if /I "%OutputLine%" == " 3" set k=%OutputLine%.k
if /I "%OutputLine%" == " 4" set k=%OutputLine%.k
if /I "%OutputLine%" == " 5" set k=%OutputLine%.k
if /I "%OutputLine%" == " 6" set k=%OutputLine%.k
if /I "%OutputLine%" == " 7" set k=%OutputLine%.k
if /I "%OutputLine%" == " 8" set k=%OutputLine%.k
if /I "%OutputLine%" == " 9" set k=%OutputLine%.k
if /I "%OutputLine%" == " a" set k=%OutputLine%.k
if /I "%OutputLine%" == " b" set k=%OutputLine%.k
if /I "%OutputLine%" == " c" set k=%OutputLine%.k
if /I "%OutputLine%" == " d" set k=%OutputLine%.k
if /I "%OutputLine%" == " e" set k=%OutputLine%.k
if /I "%OutputLine%" == " f" set k=%OutputLine%.k
if /I "%OutputLine%" == " 0" set k=%OutputLine%.k
set "OutputLine="
if not "%k%" == "no" goto next

:next
set l=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set l=%OutputLine%.l
if /I "%OutputLine%" == " 2" set l=%OutputLine%.l
if /I "%OutputLine%" == " 3" set l=%OutputLine%.l
if /I "%OutputLine%" == " 4" set l=%OutputLine%.l
if /I "%OutputLine%" == " 5" set l=%OutputLine%.l
if /I "%OutputLine%" == " 6" set l=%OutputLine%.l
if /I "%OutputLine%" == " 7" set l=%OutputLine%.l
if /I "%OutputLine%" == " 8" set l=%OutputLine%.l
if /I "%OutputLine%" == " 9" set l=%OutputLine%.l
if /I "%OutputLine%" == " a" set l=%OutputLine%.l
if /I "%OutputLine%" == " b" set l=%OutputLine%.l
if /I "%OutputLine%" == " c" set l=%OutputLine%.l
if /I "%OutputLine%" == " d" set l=%OutputLine%.l
if /I "%OutputLine%" == " e" set l=%OutputLine%.l
if /I "%OutputLine%" == " f" set l=%OutputLine%.l
if /I "%OutputLine%" == " 0" set l=%OutputLine%.l
set "OutputLine="
if not "%l%" == "no" goto next

:next
set m=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set m=%OutputLine%.m
if /I "%OutputLine%" == " 2" set m=%OutputLine%.m
if /I "%OutputLine%" == " 3" set m=%OutputLine%.m
if /I "%OutputLine%" == " 4" set m=%OutputLine%.m
if /I "%OutputLine%" == " 5" set m=%OutputLine%.m
if /I "%OutputLine%" == " 6" set m=%OutputLine%.m
if /I "%OutputLine%" == " 7" set m=%OutputLine%.m
if /I "%OutputLine%" == " 8" set m=%OutputLine%.m
if /I "%OutputLine%" == " 9" set m=%OutputLine%.m
if /I "%OutputLine%" == " a" set m=%OutputLine%.m
if /I "%OutputLine%" == " b" set m=%OutputLine%.m
if /I "%OutputLine%" == " c" set m=%OutputLine%.m
if /I "%OutputLine%" == " d" set m=%OutputLine%.m
if /I "%OutputLine%" == " e" set m=%OutputLine%.m
if /I "%OutputLine%" == " f" set m=%OutputLine%.m
if /I "%OutputLine%" == " 0" set m=%OutputLine%.m
set "OutputLine="
if not "%m%" == "no" goto next

:next
set n=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set n=%OutputLine%.n
if /I "%OutputLine%" == " 2" set n=%OutputLine%.n
if /I "%OutputLine%" == " 3" set n=%OutputLine%.n
if /I "%OutputLine%" == " 4" set n=%OutputLine%.n
if /I "%OutputLine%" == " 5" set n=%OutputLine%.n
if /I "%OutputLine%" == " 6" set n=%OutputLine%.n
if /I "%OutputLine%" == " 7" set n=%OutputLine%.n
if /I "%OutputLine%" == " 8" set n=%OutputLine%.n
if /I "%OutputLine%" == " 9" set n=%OutputLine%.n
if /I "%OutputLine%" == " a" set n=%OutputLine%.n
if /I "%OutputLine%" == " b" set n=%OutputLine%.n
if /I "%OutputLine%" == " c" set n=%OutputLine%.n
if /I "%OutputLine%" == " d" set n=%OutputLine%.n
if /I "%OutputLine%" == " e" set n=%OutputLine%.n
if /I "%OutputLine%" == " f" set n=%OutputLine%.n
if /I "%OutputLine%" == " 0" set n=%OutputLine%.n
set "OutputLine="
if not "%n%" == "no" goto next

:next
set o=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set o=%OutputLine%.o
if /I "%OutputLine%" == " 2" set o=%OutputLine%.o
if /I "%OutputLine%" == " 3" set o=%OutputLine%.o
if /I "%OutputLine%" == " 4" set o=%OutputLine%.o
if /I "%OutputLine%" == " 5" set o=%OutputLine%.o
if /I "%OutputLine%" == " 6" set o=%OutputLine%.o
if /I "%OutputLine%" == " 7" set o=%OutputLine%.o
if /I "%OutputLine%" == " 8" set o=%OutputLine%.o
if /I "%OutputLine%" == " 9" set o=%OutputLine%.o
if /I "%OutputLine%" == " a" set o=%OutputLine%.o
if /I "%OutputLine%" == " b" set o=%OutputLine%.o
if /I "%OutputLine%" == " c" set o=%OutputLine%.o
if /I "%OutputLine%" == " d" set o=%OutputLine%.o
if /I "%OutputLine%" == " e" set o=%OutputLine%.o
if /I "%OutputLine%" == " f" set o=%OutputLine%.o
if /I "%OutputLine%" == " 0" set o=%OutputLine%.o
set "OutputLine="
if not "%o%" == "no" goto next

:next
set p=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set p=%OutputLine%.p
if /I "%OutputLine%" == " 2" set p=%OutputLine%.p
if /I "%OutputLine%" == " 3" set p=%OutputLine%.p
if /I "%OutputLine%" == " 4" set p=%OutputLine%.p
if /I "%OutputLine%" == " 5" set p=%OutputLine%.p
if /I "%OutputLine%" == " 6" set p=%OutputLine%.p
if /I "%OutputLine%" == " 7" set p=%OutputLine%.p
if /I "%OutputLine%" == " 8" set p=%OutputLine%.p
if /I "%OutputLine%" == " 9" set p=%OutputLine%.p
if /I "%OutputLine%" == " a" set p=%OutputLine%.p
if /I "%OutputLine%" == " b" set p=%OutputLine%.p
if /I "%OutputLine%" == " c" set p=%OutputLine%.p
if /I "%OutputLine%" == " d" set p=%OutputLine%.p
if /I "%OutputLine%" == " e" set p=%OutputLine%.p
if /I "%OutputLine%" == " f" set p=%OutputLine%.p
if /I "%OutputLine%" == " 0" set p=%OutputLine%.p
set "OutputLine="
if not "%p%" == "no" goto dun

:dun

set "aa=%a: =%"
set "bb=%b: =%"
set "cc=%c: =%"
set "dd=%d: =%"
set "ee=%e: =%"
set "ff=%f: =%"
set "gg=%g: =%"
set "hh=%h: =%"
set "ii=%i: =%"
set "jj=%j: =%"
set "kk=%k: =%"
set "ll=%l: =%"
set "mm=%m: =%"
set "nn=%n: =%"
set "oo=%o: =%"
set "pp=%p: =%"
set "aaa=%aa:.v=%"
set "bbb=%bb:.u=%"
set "ccc=%cc:.t=%"
set "ddd=%dd:.s=%"
set "eee=%ee:.r=%"
set "fff=%ff:.q=%"
set "ggg=%gg:.g=%"
set "hhh=%hh:.h=%"
set "iii=%ii:.i=%"
set "jjj=%jj:.j=%"
set "kkk=%kk:.k=%"
set "lll=%ll:.l=%"
set "mmm=%mm:.m=%"
set "nnn=%nn:.n=%"
set "ooo=%oo:.o=%"
set "ppp=%pp:.p=%"


echo %ooo%%ppp%%mmm%%nnn%%kkk%%lll%%iii%%jjj%%ggg%%hhh%%eee%%fff%%ccc%%ddd%%aaa%%bbb% > title2.txt
set /P title2= <title2.txt
del title2.txt

CALL :UpCase2 title2

:UpCase2
FOR %%P IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "%1=%%%1:%%~P%%"

cls
echo.
echo ******************************************************
echo.
echo : : Paste TitleID you wish to Patch "main.npdm" with
echo.
echo : : Must be 16 characters (e.g. 01002d4007ae0000) 
echo.
echo : : If you do not wish to patch TitleID press N
echo.
set /P ntid= : :
echo.
if /I "%ntid%" == "N" goto nop

echo %ntid% > nspDecrypted\test2.tx
set "CodeFile=nspDecrypted\test2.tx"
set "TempFile=%CodeFile%.tmp"
del "%TempFile%" 2>nul
for /F "usebackq delims=" %%I in ("%CodeFile%") do call :EncodeLine "%%~I"
if exist "%TempFile%" move /Y "%TempFile%" "%CodeFile%"
goto :EOF

:EncodeLine
set "InputLine=%~1"
set "OutputLine="

:NextChar
set a=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set a=%OutputLine%.v
if /I "%OutputLine%" == " 2" set a=%OutputLine%.v
if /I "%OutputLine%" == " 3" set a=%OutputLine%.v
if /I "%OutputLine%" == " 4" set a=%OutputLine%.v
if /I "%OutputLine%" == " 5" set a=%OutputLine%.v
if /I "%OutputLine%" == " 6" set a=%OutputLine%.v
if /I "%OutputLine%" == " 7" set a=%OutputLine%.v
if /I "%OutputLine%" == " 8" set a=%OutputLine%.v
if /I "%OutputLine%" == " 9" set a=%OutputLine%.v
if /I "%OutputLine%" == " a" set a=%OutputLine%.v
if /I "%OutputLine%" == " b" set a=%OutputLine%.v
if /I "%OutputLine%" == " c" set a=%OutputLine%.v
if /I "%OutputLine%" == " d" set a=%OutputLine%.v
if /I "%OutputLine%" == " e" set a=%OutputLine%.v
if /I "%OutputLine%" == " f" set a=%OutputLine%.v
if /I "%OutputLine%" == " 0" set a=%OutputLine%.v
set "OutputLine="
if not "%a%" == "no" goto next

:next
set b=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set b=%OutputLine%.u
if /I "%OutputLine%" == " 2" set b=%OutputLine%.u
if /I "%OutputLine%" == " 3" set b=%OutputLine%.u
if /I "%OutputLine%" == " 4" set b=%OutputLine%.u
if /I "%OutputLine%" == " 5" set b=%OutputLine%.u
if /I "%OutputLine%" == " 6" set b=%OutputLine%.u
if /I "%OutputLine%" == " 7" set b=%OutputLine%.u
if /I "%OutputLine%" == " 8" set b=%OutputLine%.u
if /I "%OutputLine%" == " 9" set b=%OutputLine%.u
if /I "%OutputLine%" == " a" set b=%OutputLine%.u
if /I "%OutputLine%" == " b" set b=%OutputLine%.u
if /I "%OutputLine%" == " c" set b=%OutputLine%.u
if /I "%OutputLine%" == " d" set b=%OutputLine%.u
if /I "%OutputLine%" == " e" set b=%OutputLine%.u
if /I "%OutputLine%" == " f" set b=%OutputLine%.u
if /I "%OutputLine%" == " 0" set b=%OutputLine%.u
set "OutputLine="
if not "%b%" == "no" goto next

:next
set c=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set c=%OutputLine%.t
if /I "%OutputLine%" == " 2" set c=%OutputLine%.t
if /I "%OutputLine%" == " 3" set c=%OutputLine%.t
if /I "%OutputLine%" == " 4" set c=%OutputLine%.t
if /I "%OutputLine%" == " 5" set c=%OutputLine%.t
if /I "%OutputLine%" == " 6" set c=%OutputLine%.t
if /I "%OutputLine%" == " 7" set c=%OutputLine%.t
if /I "%OutputLine%" == " 8" set c=%OutputLine%.t
if /I "%OutputLine%" == " 9" set c=%OutputLine%.t
if /I "%OutputLine%" == " a" set c=%OutputLine%.t
if /I "%OutputLine%" == " b" set c=%OutputLine%.t
if /I "%OutputLine%" == " c" set c=%OutputLine%.t
if /I "%OutputLine%" == " d" set c=%OutputLine%.t
if /I "%OutputLine%" == " e" set c=%OutputLine%.t
if /I "%OutputLine%" == " f" set c=%OutputLine%.t
if /I "%OutputLine%" == " 0" set c=%OutputLine%.t
set "OutputLine="
if not "%c%" == "no" goto next

:next
set d=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set d=%OutputLine%.s
if /I "%OutputLine%" == " 2" set d=%OutputLine%.s
if /I "%OutputLine%" == " 3" set d=%OutputLine%.s
if /I "%OutputLine%" == " 4" set d=%OutputLine%.s
if /I "%OutputLine%" == " 5" set d=%OutputLine%.s
if /I "%OutputLine%" == " 6" set d=%OutputLine%.s
if /I "%OutputLine%" == " 7" set d=%OutputLine%.s
if /I "%OutputLine%" == " 8" set d=%OutputLine%.s
if /I "%OutputLine%" == " 9" set d=%OutputLine%.s
if /I "%OutputLine%" == " a" set d=%OutputLine%.s
if /I "%OutputLine%" == " b" set d=%OutputLine%.s
if /I "%OutputLine%" == " c" set d=%OutputLine%.s
if /I "%OutputLine%" == " d" set d=%OutputLine%.s
if /I "%OutputLine%" == " e" set d=%OutputLine%.s
if /I "%OutputLine%" == " f" set d=%OutputLine%.s
if /I "%OutputLine%" == " 0" set d=%OutputLine%.s
set "OutputLine="
if not "%d%" == "no" goto next

:next
set e=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set e=%OutputLine%.r
if /I "%OutputLine%" == " 2" set e=%OutputLine%.r
if /I "%OutputLine%" == " 3" set e=%OutputLine%.r
if /I "%OutputLine%" == " 4" set e=%OutputLine%.r
if /I "%OutputLine%" == " 5" set e=%OutputLine%.r
if /I "%OutputLine%" == " 6" set e=%OutputLine%.r
if /I "%OutputLine%" == " 7" set e=%OutputLine%.r
if /I "%OutputLine%" == " 8" set e=%OutputLine%.r
if /I "%OutputLine%" == " 9" set e=%OutputLine%.r
if /I "%OutputLine%" == " a" set e=%OutputLine%.r
if /I "%OutputLine%" == " b" set e=%OutputLine%.r
if /I "%OutputLine%" == " c" set e=%OutputLine%.r
if /I "%OutputLine%" == " d" set e=%OutputLine%.r
if /I "%OutputLine%" == " e" set e=%OutputLine%.r
if /I "%OutputLine%" == " f" set e=%OutputLine%.r
if /I "%OutputLine%" == " 0" set e=%OutputLine%.r
set "OutputLine="
if not "%e%" == "no" goto next

:next
set f=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set f=%OutputLine%.q
if /I "%OutputLine%" == " 2" set f=%OutputLine%.q
if /I "%OutputLine%" == " 3" set f=%OutputLine%.q
if /I "%OutputLine%" == " 4" set f=%OutputLine%.q
if /I "%OutputLine%" == " 5" set f=%OutputLine%.q
if /I "%OutputLine%" == " 6" set f=%OutputLine%.q
if /I "%OutputLine%" == " 7" set f=%OutputLine%.q
if /I "%OutputLine%" == " 8" set f=%OutputLine%.q
if /I "%OutputLine%" == " 9" set f=%OutputLine%.q
if /I "%OutputLine%" == " a" set f=%OutputLine%.q
if /I "%OutputLine%" == " b" set f=%OutputLine%.q
if /I "%OutputLine%" == " c" set f=%OutputLine%.q
if /I "%OutputLine%" == " d" set f=%OutputLine%.q
if /I "%OutputLine%" == " e" set f=%OutputLine%.q
if /I "%OutputLine%" == " f" set f=%OutputLine%.q
if /I "%OutputLine%" == " 0" set f=%OutputLine%.q
set "OutputLine="
if not "%f%" == "no" goto next

:next
set g=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set g=%OutputLine%.g
if /I "%OutputLine%" == " 2" set g=%OutputLine%.g
if /I "%OutputLine%" == " 3" set g=%OutputLine%.g
if /I "%OutputLine%" == " 4" set g=%OutputLine%.g
if /I "%OutputLine%" == " 5" set g=%OutputLine%.g
if /I "%OutputLine%" == " 6" set g=%OutputLine%.g
if /I "%OutputLine%" == " 7" set g=%OutputLine%.g
if /I "%OutputLine%" == " 8" set g=%OutputLine%.g
if /I "%OutputLine%" == " 9" set g=%OutputLine%.g
if /I "%OutputLine%" == " a" set g=%OutputLine%.g
if /I "%OutputLine%" == " b" set g=%OutputLine%.g
if /I "%OutputLine%" == " c" set g=%OutputLine%.g
if /I "%OutputLine%" == " d" set g=%OutputLine%.g
if /I "%OutputLine%" == " e" set g=%OutputLine%.g
if /I "%OutputLine%" == " f" set g=%OutputLine%.g
if /I "%OutputLine%" == " 0" set g=%OutputLine%.g
set "OutputLine="
if not "%g%" == "no" goto next

:next
set h=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set h=%OutputLine%.h
if /I "%OutputLine%" == " 2" set h=%OutputLine%.h
if /I "%OutputLine%" == " 3" set h=%OutputLine%.h
if /I "%OutputLine%" == " 4" set h=%OutputLine%.h
if /I "%OutputLine%" == " 5" set h=%OutputLine%.h
if /I "%OutputLine%" == " 6" set h=%OutputLine%.h
if /I "%OutputLine%" == " 7" set h=%OutputLine%.h
if /I "%OutputLine%" == " 8" set h=%OutputLine%.h
if /I "%OutputLine%" == " 9" set h=%OutputLine%.h
if /I "%OutputLine%" == " a" set h=%OutputLine%.h
if /I "%OutputLine%" == " b" set h=%OutputLine%.h
if /I "%OutputLine%" == " c" set h=%OutputLine%.h
if /I "%OutputLine%" == " d" set h=%OutputLine%.h
if /I "%OutputLine%" == " e" set h=%OutputLine%.h
if /I "%OutputLine%" == " f" set h=%OutputLine%.h
if /I "%OutputLine%" == " 0" set h=%OutputLine%.h
set "OutputLine="
if not "%h%" == "no" goto next

:next
set i=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set i=%OutputLine%.i
if /I "%OutputLine%" == " 2" set i=%OutputLine%.i
if /I "%OutputLine%" == " 3" set i=%OutputLine%.i
if /I "%OutputLine%" == " 4" set i=%OutputLine%.i
if /I "%OutputLine%" == " 5" set i=%OutputLine%.i
if /I "%OutputLine%" == " 6" set i=%OutputLine%.i
if /I "%OutputLine%" == " 7" set i=%OutputLine%.i
if /I "%OutputLine%" == " 8" set i=%OutputLine%.i
if /I "%OutputLine%" == " 9" set i=%OutputLine%.i
if /I "%OutputLine%" == " a" set i=%OutputLine%.i
if /I "%OutputLine%" == " b" set i=%OutputLine%.i
if /I "%OutputLine%" == " c" set i=%OutputLine%.i
if /I "%OutputLine%" == " d" set i=%OutputLine%.i
if /I "%OutputLine%" == " e" set i=%OutputLine%.i
if /I "%OutputLine%" == " f" set i=%OutputLine%.i
if /I "%OutputLine%" == " 0" set i=%OutputLine%.i
set "OutputLine="
if not "%i%" == "no" goto next

:next
set j=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set j=%OutputLine%.j
if /I "%OutputLine%" == " 2" set j=%OutputLine%.j
if /I "%OutputLine%" == " 3" set j=%OutputLine%.j
if /I "%OutputLine%" == " 4" set j=%OutputLine%.j
if /I "%OutputLine%" == " 5" set j=%OutputLine%.j
if /I "%OutputLine%" == " 6" set j=%OutputLine%.j
if /I "%OutputLine%" == " 7" set j=%OutputLine%.j
if /I "%OutputLine%" == " 8" set j=%OutputLine%.j
if /I "%OutputLine%" == " 9" set j=%OutputLine%.j
if /I "%OutputLine%" == " a" set j=%OutputLine%.j
if /I "%OutputLine%" == " b" set j=%OutputLine%.j
if /I "%OutputLine%" == " c" set j=%OutputLine%.j
if /I "%OutputLine%" == " d" set j=%OutputLine%.j
if /I "%OutputLine%" == " e" set j=%OutputLine%.j
if /I "%OutputLine%" == " f" set j=%OutputLine%.j
if /I "%OutputLine%" == " 0" set j=%OutputLine%.j
set "OutputLine="
if not "%j%" == "no" goto next

:next
set k=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set k=%OutputLine%.k
if /I "%OutputLine%" == " 2" set k=%OutputLine%.k
if /I "%OutputLine%" == " 3" set k=%OutputLine%.k
if /I "%OutputLine%" == " 4" set k=%OutputLine%.k
if /I "%OutputLine%" == " 5" set k=%OutputLine%.k
if /I "%OutputLine%" == " 6" set k=%OutputLine%.k
if /I "%OutputLine%" == " 7" set k=%OutputLine%.k
if /I "%OutputLine%" == " 8" set k=%OutputLine%.k
if /I "%OutputLine%" == " 9" set k=%OutputLine%.k
if /I "%OutputLine%" == " a" set k=%OutputLine%.k
if /I "%OutputLine%" == " b" set k=%OutputLine%.k
if /I "%OutputLine%" == " c" set k=%OutputLine%.k
if /I "%OutputLine%" == " d" set k=%OutputLine%.k
if /I "%OutputLine%" == " e" set k=%OutputLine%.k
if /I "%OutputLine%" == " f" set k=%OutputLine%.k
if /I "%OutputLine%" == " 0" set k=%OutputLine%.k
set "OutputLine="
if not "%k%" == "no" goto next

:next
set l=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set l=%OutputLine%.l
if /I "%OutputLine%" == " 2" set l=%OutputLine%.l
if /I "%OutputLine%" == " 3" set l=%OutputLine%.l
if /I "%OutputLine%" == " 4" set l=%OutputLine%.l
if /I "%OutputLine%" == " 5" set l=%OutputLine%.l
if /I "%OutputLine%" == " 6" set l=%OutputLine%.l
if /I "%OutputLine%" == " 7" set l=%OutputLine%.l
if /I "%OutputLine%" == " 8" set l=%OutputLine%.l
if /I "%OutputLine%" == " 9" set l=%OutputLine%.l
if /I "%OutputLine%" == " a" set l=%OutputLine%.l
if /I "%OutputLine%" == " b" set l=%OutputLine%.l
if /I "%OutputLine%" == " c" set l=%OutputLine%.l
if /I "%OutputLine%" == " d" set l=%OutputLine%.l
if /I "%OutputLine%" == " e" set l=%OutputLine%.l
if /I "%OutputLine%" == " f" set l=%OutputLine%.l
if /I "%OutputLine%" == " 0" set l=%OutputLine%.l
set "OutputLine="
if not "%l%" == "no" goto next

:next
set m=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set m=%OutputLine%.m
if /I "%OutputLine%" == " 2" set m=%OutputLine%.m
if /I "%OutputLine%" == " 3" set m=%OutputLine%.m
if /I "%OutputLine%" == " 4" set m=%OutputLine%.m
if /I "%OutputLine%" == " 5" set m=%OutputLine%.m
if /I "%OutputLine%" == " 6" set m=%OutputLine%.m
if /I "%OutputLine%" == " 7" set m=%OutputLine%.m
if /I "%OutputLine%" == " 8" set m=%OutputLine%.m
if /I "%OutputLine%" == " 9" set m=%OutputLine%.m
if /I "%OutputLine%" == " a" set m=%OutputLine%.m
if /I "%OutputLine%" == " b" set m=%OutputLine%.m
if /I "%OutputLine%" == " c" set m=%OutputLine%.m
if /I "%OutputLine%" == " d" set m=%OutputLine%.m
if /I "%OutputLine%" == " e" set m=%OutputLine%.m
if /I "%OutputLine%" == " f" set m=%OutputLine%.m
if /I "%OutputLine%" == " 0" set m=%OutputLine%.m
set "OutputLine="
if not "%m%" == "no" goto next

:next
set n=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set n=%OutputLine%.n
if /I "%OutputLine%" == " 2" set n=%OutputLine%.n
if /I "%OutputLine%" == " 3" set n=%OutputLine%.n
if /I "%OutputLine%" == " 4" set n=%OutputLine%.n
if /I "%OutputLine%" == " 5" set n=%OutputLine%.n
if /I "%OutputLine%" == " 6" set n=%OutputLine%.n
if /I "%OutputLine%" == " 7" set n=%OutputLine%.n
if /I "%OutputLine%" == " 8" set n=%OutputLine%.n
if /I "%OutputLine%" == " 9" set n=%OutputLine%.n
if /I "%OutputLine%" == " a" set n=%OutputLine%.n
if /I "%OutputLine%" == " b" set n=%OutputLine%.n
if /I "%OutputLine%" == " c" set n=%OutputLine%.n
if /I "%OutputLine%" == " d" set n=%OutputLine%.n
if /I "%OutputLine%" == " e" set n=%OutputLine%.n
if /I "%OutputLine%" == " f" set n=%OutputLine%.n
if /I "%OutputLine%" == " 0" set n=%OutputLine%.n
set "OutputLine="
if not "%n%" == "no" goto next

:next
set o=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set o=%OutputLine%.o
if /I "%OutputLine%" == " 2" set o=%OutputLine%.o
if /I "%OutputLine%" == " 3" set o=%OutputLine%.o
if /I "%OutputLine%" == " 4" set o=%OutputLine%.o
if /I "%OutputLine%" == " 5" set o=%OutputLine%.o
if /I "%OutputLine%" == " 6" set o=%OutputLine%.o
if /I "%OutputLine%" == " 7" set o=%OutputLine%.o
if /I "%OutputLine%" == " 8" set o=%OutputLine%.o
if /I "%OutputLine%" == " 9" set o=%OutputLine%.o
if /I "%OutputLine%" == " a" set o=%OutputLine%.o
if /I "%OutputLine%" == " b" set o=%OutputLine%.o
if /I "%OutputLine%" == " c" set o=%OutputLine%.o
if /I "%OutputLine%" == " d" set o=%OutputLine%.o
if /I "%OutputLine%" == " e" set o=%OutputLine%.o
if /I "%OutputLine%" == " f" set o=%OutputLine%.o
if /I "%OutputLine%" == " 0" set o=%OutputLine%.o
set "OutputLine="
if not "%o%" == "no" goto next

:next
set p=no
set "OutputLine=%OutputLine% %InputLine:~0,1%"
set "InputLine=%InputLine:~1%"
if /I "%OutputLine%" == " 1" set p=%OutputLine%.p
if /I "%OutputLine%" == " 2" set p=%OutputLine%.p
if /I "%OutputLine%" == " 3" set p=%OutputLine%.p
if /I "%OutputLine%" == " 4" set p=%OutputLine%.p
if /I "%OutputLine%" == " 5" set p=%OutputLine%.p
if /I "%OutputLine%" == " 6" set p=%OutputLine%.p
if /I "%OutputLine%" == " 7" set p=%OutputLine%.p
if /I "%OutputLine%" == " 8" set p=%OutputLine%.p
if /I "%OutputLine%" == " 9" set p=%OutputLine%.p
if /I "%OutputLine%" == " a" set p=%OutputLine%.p
if /I "%OutputLine%" == " b" set p=%OutputLine%.p
if /I "%OutputLine%" == " c" set p=%OutputLine%.p
if /I "%OutputLine%" == " d" set p=%OutputLine%.p
if /I "%OutputLine%" == " e" set p=%OutputLine%.p
if /I "%OutputLine%" == " f" set p=%OutputLine%.p
if /I "%OutputLine%" == " 0" set p=%OutputLine%.p
set "OutputLine="
if not "%p%" == "no" goto dun

:dun

set "aa=%a: =%"
set "bb=%b: =%"
set "cc=%c: =%"
set "dd=%d: =%"
set "ee=%e: =%"
set "ff=%f: =%"
set "gg=%g: =%"
set "hh=%h: =%"
set "ii=%i: =%"
set "jj=%j: =%"
set "kk=%k: =%"
set "ll=%l: =%"
set "mm=%m: =%"
set "nn=%n: =%"
set "oo=%o: =%"
set "pp=%p: =%"
set "aaa=%aa:.v=%"
set "bbb=%bb:.u=%"
set "ccc=%cc:.t=%"
set "ddd=%dd:.s=%"
set "eee=%ee:.r=%"
set "fff=%ff:.q=%"
set "ggg=%gg:.g=%"
set "hhh=%hh:.h=%"
set "iii=%ii:.i=%"
set "jjj=%jj:.j=%"
set "kkk=%kk:.k=%"
set "lll=%ll:.l=%"
set "mmm=%mm:.m=%"
set "nnn=%nn:.n=%"
set "ooo=%oo:.o=%"
set "ppp=%pp:.p=%"


echo %ooo%%ppp%%mmm%%nnn%%kkk%%lll%%iii%%jjj%%ggg%%hhh%%eee%%fff%%ccc%%ddd%%aaa%%bbb%> title9.txt
set /P title9= <title9.txt
del title9.txt

dir "nspDecrypted" /b /o-s > nspDecrypted\nca_name.txt
set /P nca_file= < nspDecrypted\nca_name.txt
del nspDecrypted\nca_name.txt
MD nspDecrypted\%tk%
"%~dp0tools\hactool.exe" --titlekey=%tk1% --romfs="nspDecrypted\%tk%\romfs.istorage" --exefsdir="nspDecrypted\%tk%\exefs" "nspDecrypted\%nca_file%" >nul 2>&1
set di="%~dp0\nspDecrypted\%tk%\exefs"
set di6="%di:"=%"
set di2="%~dp0"
set "di3=%di2:"=%"
set "title3=%title2: =%"

move/Y "%di%\main.npdm" "%~dp0\main"
"%~dp0tools\sfk" -yes replace -binary "/%title3%/%title9%/" -dir %di3% -file main
move/Y "%~dp0\main" "%di6%\main.npdm"

cls
del nspDecrypted\*.nca
del nspDecrypted\*.cert
del nspDecrypted\*.tik
del nspDecrypted\*.xml
del nspDecrypted\*.tx

:glta2
cls
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit

:game2

dir "nspDecrypted" /b /o-s > nspDecrypted\nca_name.txt
set /P nca_file= < nspDecrypted\nca_name.txt
del nspDecrypted\nca_name.txt
MD nspDecrypted\%tk%
"%~dp0tools\hactool.exe" --titlekey=%tk1%  --section0dir="nspDecrypted\%tk%" --section1dir="nspDecrypted\%tk%" --section2dir="nspDecrypted\%tk%" --section3dir="nspDecrypted\%tk%" "nspDecrypted\%nca_file%" >nul 2>&1
cls
del nspDecrypted\*.nca
del nspDecrypted\*.cert
del nspDecrypted\*.tik
del nspDecrypted\*.xml
del nspDecrypted\*.tx
cls
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit

:nop

dir "nspDecrypted" /b /o-s > nspDecrypted\nca_name.txt
set /P nca_file= < nspDecrypted\nca_name.txt
del nspDecrypted\nca_name.txt
MD nspDecrypted\%tk%
"%~dp0tools\hactool.exe" --titlekey=%tk1% --romfs="nspDecrypted\%tk%\romfs.istorage" --exefsdir="nspDecrypted\%tk%\exefs" "nspDecrypted\%nca_file%" >nul 2>&1


cls
del nspDecrypted\*.nca
del nspDecrypted\*.cert
del nspDecrypted\*.tik
del nspDecrypted\*.xml
del nspDecrypted\*.tx
cls
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit


:n2x
setlocal
cls
if exist nspDecrypted RD /S /Q nspDecrypted
MD nspDecrypted\rawsecure
echo.
echo hactool v1.2.0  by SciresM
echo --------------
tools\hactool.exe -k tools\keys.txt -t pfs0 --pfs0dir=nspDecrypted\rawsecure "%file%"
echo.
if exist nspDecrypted\rawsecure\*.jpg del nspDecrypted\rawsecure\*.jpg
dir "nspDecrypted\rawsecure\*.nca" /b /o:-s > nspDecrypted\ncalist.txt
(
set /p nca1=
set /p nca2=
set /p nca3=
set /p nca4=
)<nspDecrypted\ncalist.txt
del nspDecrypted\ncalist.txt
MD nspDecrypted\secure
MD nspDecrypted\update
MD nspDecrypted\normal
move /Y nspDecrypted\rawsecure\%nca1% nspDecrypted\secure >nul 2>&1
move /Y nspDecrypted\rawsecure\%nca2% nspDecrypted\secure >nul 2>&1
move /Y nspDecrypted\rawsecure\%nca3% nspDecrypted\secure >nul 2>&1
move /Y nspDecrypted\rawsecure\%nca4% nspDecrypted\secure >nul 2>&1
dir "nspDecrypted\rawsecure\" /b /o:s > nspDecrypted\lclist.txt
(
set /p lc11=
set /p lc21=
set /p lc31=
set /p lc41=
)<nspDecrypted\lclist.txt
del nspDecrypted\lclist.txt
set lc1=nspDecrypted\rawsecure\%lc11%
set lc2=nspDecrypted\rawsecure\%lc21%
set lc3=nspDecrypted\rawsecure\%lc31%
set lc4=nspDecrypted\rawsecure\%lc41%
echo ************************************************************************************************************************
echo.
echo nspBuild 3.0 Beta  by CVFireDragon
echo -----------------
echo.
if "%lc4%"=="nspDecrypted\rawsecure\" goto nex
tools\nspbuild.py "nspDecrypted\%filename%[lc].nsp" %lc1% %lc2% %lc3% %lc4%
goto crxci
:nex
tools\nspbuild.py "nspDecrypted\%filename%[lc].nsp" %lc1% %lc2% %lc3%
:crxci
xcopy /y "tools\game_info_preset.ini" "nspDecrypted\" >nul 2>&1
RENAME nspDecrypted\game_info_preset.ini "game_info.ini"
RD /S /Q nspDecrypted\rawsecure\
echo.
echo ************************************************************************************************************************
echo.
tools\hacbuild.exe xci_auto nspDecrypted  "nspDecrypted\%filename%.xci"
RD /S /Q nspDecrypted\secure
RD /S /Q nspDecrypted\normal
RD /S /Q nspDecrypted\update
del nspDecrypted\game_info.ini"
RD /S /Q nspDecrypted\rawsecure
echo.
echo ************************************************************************************************************************
echo.
echo DONE!  DONE!   DONE!   DONE!   DONE!
echo     DONE!   DONE!    DONE!   DONE!
echo  DONE!  DONE!   DONE!    DONE!   DONE!
echo     DONE!   DONE!   DONE!    DONE!   
echo DONE!  DONE!   DONE!   DONE!    DONE!
PING -n 2 127.0.0.1 >NUL 2>&1
exit





















