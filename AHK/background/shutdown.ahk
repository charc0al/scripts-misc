global abort = 1
global monitorOff = 0

#s::
	gui, add, text, , Minutes to shutdown:
	gui, add, edit, vMinutes w200
	gui, add, checkbox, vMonitorOff, Turn off monitor?
	gui, add, button, default w100 gShutdown, OK
	gui, add, button, yp xp+100 w100, Abort
	gui, show, ,Shutdown Timer
return

Shutdown:
gui, submit
gui, destroy
seconds := minutes * 60
elevateAdmin()
run shutdown -s -f -t %seconds%, , Hide
winWait, System Shutdown, , 5
monitorSleep()
return

ButtonAbort:
elevateAdmin()
run shutdown -a, , Hide
gui, submit
gui, destroy
return

monitorSleep(){
	if(monitorOff)
		SendMessage, 0x112, 0xF170, 2,, Program Manager
}