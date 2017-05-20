#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Recommended for catching common errors.
;#NoTrayIcon
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

a::
sendraw @
return

b::
send 8
return

c::
send ©
return

e::
send 3
return

f::
send F
return

g::
send 9
return

i::
sendraw |
return


l::
send 1
return

o::
send 0
return

p::
send ¶
return 

s::
send 5
return

t::
send 7
return

u::
send µ
return

v::
sendraw \/
return

w::
send W
return

y::
send Y
return

z::
send Z
return


^!+Esc::
exitApp
return