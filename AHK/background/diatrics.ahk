+!e::
	KeyWait, e
	send é
	SendInput % "{e up}"
	loop
	{
		;KeyWait, e
		if (GetKeyState("e", "T"))
		{
			;KeyWait, e
			SendInput % "{BS}{BS}" . "É"
			break
		}
		if (GetKeyState("Shift"))
			break
	}
	msgbox exited
return