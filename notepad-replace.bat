@echo off
REM This will replace Windows notepad with the program of your choice
REM The use of this script is AT YOUR OWN RISK.
REM filename to backup to
SET backupto=oldnotepad.exe
REM get file from parameter supplied
SET file=%1
REM if backup file exists, end the script
IF EXIST %windir%\system32\dllcache\%backupto% GOTO alreadyreplaced
REM If you do not specify a parameter, end the script
REM brackets are needed as spaces are ignored
IF (%file%) == () GOTO nofile
REM If source file does not exist, the replacement can not be made
IF NOT EXIST %file% GOTO nofile
attrib -r -h -s %windir%\system32\dllcache
ren %windir%\system32\dllcache\notepad.exe %backupto%
attrib +r +h +s %windir%\system32\dllcache
del %windir%\notepad.exe
copy /Y %file% %windir%\notepad.exe
del %windir%\system32\notepad.exe
copy /Y %file% %windir%\system32\notepad.exe
REM other folders that may contain notepad
IF EXIST C:\I386\notepad.exe ren C:\I386\notepad.exe %backupto%
IF EXIST %windir%\ServicePackFiles\i386\notepad.exe ren %windir%\ServicePackFiles\i386\notepad.exe %backupto%
GOTO end
:alreadyreplaced
attrib -r -h -s %windir%\system32\dllcache
ren %windir%\system32\dllcache\%backupto% notepad.exe
attrib +r +h +s %windir%\system32\dllcache
REM deleting the other notepad files will cause WFP to replace with  the one in the dll cache
del %windir%\system32\notepad.exe
del %windir%\notepad.exe
REM other folders that may contain notepad
IF EXIST C:\I386\%backupto% ren C:\I386\%backupto% notepad.exe
IF EXIST %windir%\ServicePackFiles\i386\%backupto% ren %windir%\ServicePackFiles\i386\%backupto% notepad.exe
echo ------------------------------------------------------
echo  Notepad has already been replaced, original restored
echo ------------------------------------------------------
GOTO end
:nofile
echo ----------------------------------------------------
echo  You did not specify a file, or file does not exist
echo ----------------------------------------------------
:end