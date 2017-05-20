elevateAdmin(){
	if (A_UserName = "pj7960")
		runAs, administrator, winxpsupport
	else
		runAs
}

muteVolume()
{
	soundSet 0
	soundGet, sound_mute, Master, mute 
	if (sound_mute = "Off")
		send {Volume_Mute}
}