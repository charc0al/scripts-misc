#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory\


F7:: {
  trayTip Remotr Restarter, Restarting Remotr in 1 minute!, 10
  sleep 5000
  Process,Close,RemotrServer.exe
  if (ErrorLevel) {
    sleep 60000
    run C:\Program Files (x86)\Remotr\RemotrServer.exe
  } else {
    trayTip Remotr Restarter, ERROR unable to kill RemotrServer.exe, 10
    sleep 10000
  }
  return
}
