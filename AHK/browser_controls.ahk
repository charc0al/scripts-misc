global address_bar
global alertTitle
global browser
global browserName = "Chrome"
global envString
global suffix
global DevSel
global StageSel
global ProdSel
global debugEnabled = 0

initChrome()
{
	killChrome:
	ifWinExist ahk_class Chrome_WidgetWin_0
	{
		WinClose ahk_class Chrome_WidgetWin_0
		goto killChrome
	}
	ifNotExist %A_AppData%\GoogleChromePortable
	{
		alert("Chrome", "Chrome portable not detected, copying from T:\. This may take a minute or two.", 3)
		FileCopyDir, T:\Test Services\Charlie's Scripts\GoogleChromePortable, %A_AppData%\GoogleChromePortable
		alert("Chrome", "Done copying chrome.", 3)
	}
	run %A_AppData%\GoogleChromePortable\GoogleChromePortable.exe
	winWait ahk_class Chrome_WidgetWin_0
	sleep 1000
	return
}

setBrowser(str)
{
	if(inStr(str,"Chrome"))
	{
		browserName := "Chrome"
		loop
		{
			num := A_Index-1
			winGet, chrome_id, ID, ahk_class Chrome_WidgetWin_%num%
			if(chrome_id <> "")
				break
		}
		address_bar := "Chrome_OmniboxView1" ;chrome
		alertTitle := "The page at"
		global browser := chrome_id
	}
	else if(inStr(str,"IE8"))
	{
		browserName := "IE"
		winGet, ie_id, ID, ahk_class IEFrame
		address_bar := "Edit1" ;IE
		alertTitle := "Message from webpage"
		global browser := ie_id
	}
}

setBrowserByTitle(str)
{
	winGet, browser_id, ID, str
	global browser := browser_id
}

setEnv(str)
{
	DevSel := 0
	StageSel := 0
	ProdSel := 0
	if(regExMatch(str,"[Ss][Tt][Aa][Gg][Ee]"))
	{
		envString := "stage2"
		suffix := "_stage"
		StageSel := 1
	}
	else if(regExMatch(str,"[Dd][Ee][Vv]"))
	{
		envString := "dev"
		suffix := "_dev"
		DevSel := 1
	}
	else if(regExMatch(str,"[Pp][Rr][Oo][Dd]"))
	{
		envString := "www"
		suffix := "_prod"
		ProdSel := 1
	}
}

doLogin(env,usr,pas)
{
	sleep 1000
	navigate("https://" . env . ".assurantemployeebenefits.com/wps/portal/home", 1000)
	loginURL := "https://" .  env . ".assurantemployeebenefits.com/wps/portal/OMIT/OAMainLogin"
	tryLogin:
	navigate(loginURL, 1000)
	js("function waitLogin(){if(document.getElementsByName('PASSWORD').length){alert('ready');} else {window.setTimeout(waitLogin,200);}} waitLogin();", 100)
	closeAlert(3)
	if errorLevel
		goto tryLogin
	js("document.getElementsByName('USERNAME')[0].value='" . usr . "';document.getElementsByName('PASSWORD')[0].value='" . pas . "';document.getElementsByName('PASSWORD')[0].focus();", 0)
	controlGetText, currentURL, %address_bar%, ahk_id %browser%
	js("document.getElementsByName('login')[0].click()", 1000)
	return 1
}

js(str, delay = 0)
{
	scriptStr = javascript: %str%
	controlSetText, %address_bar%, %scriptStr%, ahk_id %browser%
	controlSend, %address_bar%, +{Enter}, ahk_id %browser%
	sleep %delay%
	return 0
}

waitForLoad(delay = 0)
{
	sleep 1000
	js("function waitLoad(){if(document.getElementsByClassName('dialogTopLeft').length){window.setTimeout(waitLoad,200);}else{alert('Done.');}} waitLoad();", 0)
	closeAlert()
	sleep %delay%
}

navigate(str, delay = 500)
{
	controlSetText, %address_bar%, %str%, ahk_id %browser%
	controlSend, %address_bar%, +{Enter}, ahk_id %browser%
	sleep %delay%
	return 0
}

saveHTML(directory, file, ext = "htm")
{
	trySaveHTML:
	winActivate, ahk_id %browser%
	send ^s
	winWait, ahk_class #32770, ,1
	if errorLevel
		goto trySaveHTML
	saveAs(directory, file, ext)
	run, %comspec% /c rmdir `"%directory%\%file%_files`" /s /q, ,hide
}

saveAs(directory, file, ext)
{
	ifNotExist %directory%
		fileCreateDir, %directory%
	trySaveAs:
	winWait, ahk_class #32770
	controlSetText, Edit1, %directory%\%file%.%ext%, ahk_class #32770
	debug("Ready to save.")
	controlSend, Edit1, {Enter}, ahk_class #32770
	sleep 250
	ifWinExist, ahk_class #32770
		controlsend, , y, ahk_class #32770
	WinWaitClose, ahk_class #32770
	sleep 500
	ifNotExist %directory%\%file%.%ext%
	{
		alert(theTitle, "Save failed, trying again...", 3)
		goto trySaveAs
	}
}

clickBtn(str, delay = 500)
{
	js("var buttons = document.getElementsByTagName('button'); for(i=0;i<buttons.length;i++){if(buttons[i].className!=''){buttons[i].setAttribute('id',buttons[i].innerText+'-button');}}")
	js("document.getElementById('" . str . "-button').disabled=false;")
	js("document.getElementById('" . str . "-button').click();")
	sleep %delay%
}

; --------------- clickDialogBtn ---------------
; Author:			Charles Mehrer, 2012-04-25
; Description:		Clicks on a button in a gwt DialogBox with the specified text
; Parameters:			<str>	The text on the button you wish to click.
; Returns:			Nothing.
clickDialogBtn(str, delay = 500)
{
	js("var dialogBtns = document.getElementsByClassName('gwt-DialogBox')[0].getElementsByTagName('button'); for(i=0;i<dialogBtns.length;i++){dialogBtns[i].setAttribute('id','dialogBtn-'+dialogBtns[i].innerText);}")
	js("document.getElementById('dialogBtn-" . str . "').click()")
	waitForLoad()
	sleep %delay%
}

mouseEvent(eventStr, element)
{
	js("var mouseTarget = " . element . "; simMouseEvent = document.createEvent('MouseEvent');simMouseEvent.initEvent('" . eventStr . "', true, false);mouseTarget.dispatchEvent(simMouseEvent);",200)
}

sendBrowser(keys)
{
	blockinput send
	controlSend, ahk_parent, %keys%, ahk_id %browser%
	blockinput off
	return
}

debug(str)
{
	if(debugEnabled)
		msgbox %str%
}

closeAlert(waitSec = 100)
{
	winWait, %alertTitle%, ,waitSec
	sleep 50
	if not (ErrorLevel)
		winClose, %alertTitle%
}

getMsgText(byRef var, waitSec = 5)
{
	winWait, %alertTitle%, ,waitSec
	sleep 100
	if(ErrorLevel)
		return
	send ^c
	winClose, %alertTitle%
	var := clipboard
}

alert(title, msg, timeout)
{
	msgBox, ,%title%, %msg%, %timeout%
}