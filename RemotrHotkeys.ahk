#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory

Table := RemotrServer
remotrId := 0

Process, Exist, %Table%
remotrId := ErrorLevel
If ErrorLevel
{
  msgbox RemotrID: %remotrId%
}

F9::
WinClose, % "ahk_pid " remotrId
sleep 15000
run C:\Program Files (x86)\Remotr\RemotrServer.exe
return

F10::
Process, Close, %remotrId%
sleep 15000
run C:\Program Files (x86)\Remotr\RemotrServer.exe
return

F7::
  trayTip Remotr Restarter, Restarting Remotr(RemotrID: %remotrId%) in 1 minute!, 10
  sleep 5000
  Process, Close, %remotrId%
  if (ErrorLevel) {
    sleep 55000
  } else {
    trayTip Remotr Restarter, Not working trying hard kill, 10
    KillProcess(%Table%)
    sleep 10000
  }
  run C:\Program Files (x86)\Remotr\RemotrServer.exe
return


F8::
  send {W up}
  send {S up}
  send {A up}
  send {D up}
  send {Shift up}
  send {LShift up}
  send {Ctrl up}
  send {LCtrl up}
  send {LButton up}
  send {RButton up}
return

KillProcess(proc)
{
    static SYNCHRONIZE                 := 0x00100000
    static STANDARD_RIGHTS_REQUIRED    := 0x000F0000
    static OSVERSION                   := (A_OSVersion = "WIN_XP" ? 0xFFF : 0xFFFF)
    static PROCESS_ALL_ACCESS          := STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE | OSVERSION

    local tPtr := pPtr := nTTL := 0, PList := ""
    if !(DllCall("wtsapi32.dll\WTSEnumerateProcesses", "Ptr", 0, "Int", 0, "Int", 1, "PtrP", pPtr, "PtrP", nTTL))
        return "", DllCall("kernel32.dll\SetLastError", "UInt", -1)

    tPtr := pPtr
    loop % (nTTL)
    {
        if (InStr(PList := StrGet(NumGet(tPtr + 8)), proc))
        {
            ZID := NumGet(tPtr + 4, "UInt")
            if !(hProcess := DllCall("kernel32.dll\OpenProcess", "UInt", PROCESS_ALL_ACCESS, "UInt", FALSE, "UInt", ZID, "Ptr"))
                return DllCall("kernel32.dll\GetLastError")
            if !(DllCall("kernel32.dll\TerminateProcess", "Ptr", hProcess, "UInt", 0))
                return DllCall("kernel32.dll\GetLastError")
            if !(DllCall("kernel32.dll\CloseHandle", "Ptr", hProcess))
                return DllCall("kernel32.dll\GetLastError")
        }
        tPtr += (A_PtrSize = 4 ? 16 : 24)
    }
    DllCall("wtsapi32.dll\WTSFreeMemory", "Ptr", pPtr)

    return "", DllCall("kernel32.dll\SetLastError", "UInt", nTTL)
}
