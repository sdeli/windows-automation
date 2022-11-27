; Globals
DesktopCount = 2 ; Windows starts with 2 desktops at boot
CurrentDesktop = 1 ; Desktop count is 1-indexed (Microsoft numbers them this way)
currentAnimation = no animation
CreateGUID()
{
    VarSetCapacity(pguid, 16, 0)
    if !(DllCall("ole32.dll\CoCreateGuid", "ptr", &pguid)) {
        size := VarSetCapacity(sguid, (38 << !!A_IsUnicode) + 1, 0)
        if (DllCall("ole32.dll\StringFromGUID2", "ptr", &pguid, "ptr", &sguid, "int", size))
            return StrGet(&sguid)
    }
    return ""
}

mapDesktopsFromRegistry() {
  global CurrentDesktop, DesktopCount, CurrentDesktopId

  IdLength := 32
  RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, CurrentVirtualDesktop
  FileAppend, CurrentDesktopId: %CurrentDesktopId% `n, C:\Users\delis\Desktop\windows-automation\logs.txt
  if (CurrentDesktopId) {
    IdLength := StrLen(CurrentDesktopId)
  }

  RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
  FileAppend, DesktopList: %DesktopList% `n, C:\Users\delis\Desktop\windows-automation\logs.txt
  if (DesktopList) {
    DesktopListLength := StrLen(DesktopList)
    DesktopCount := DesktopListLength / IdLength
  } else {
    DesktopCount := 1
  }

  i := 0
  while (CurrentDesktopId and i < DesktopCount) {
    StartPos := (i * IdLength) + 1
    DesktopIter := SubStr(DesktopList, StartPos, IdLength)
    ; MsgBox "4 StartPos: " . %StartPos% . " " . "DesktopIter: " . %DesktopIter% . " " . "CurrentDesktopId: " . %CurrentDesktopId% . " "  . "DesktopCount: " . %DesktopCount% . " "
    
    if (DesktopIter = CurrentDesktopId) {
      CurrentDesktop := i + 1
      FileAppend, Current desktop number is %CurrentDesktop% with an ID of %DesktopIter% `n, C:\Users\delis\Desktop\windows-automation\logs.txt
      break
    }

    i++
  }
}

getSessionId()
{
  ProcessId := DllCall("GetCurrentProcessId", "UInt")
  if ErrorLevel {
    OutputDebug, Error getting current process id: %ErrorLevel%
    return
  }

  OutputDebug, Current Process Id: %ProcessId%
  DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
  if ErrorLevel {
    OutputDebug, Error getting session id: %ErrorLevel%
    return
  }

  OutputDebug, Current Session Id: %SessionId%
  return SessionId
}

switchDesktopByNumber(targetDesktop)
{
  global CurrentDesktop, DesktopCount, currentAnimation
  prevDesktop := -1
  GUID_1 := CreateGUID()
  currentAnimation := GUID_1
  FileAppend, ================= %GUID_1%`n, C:\Users\delis\Desktop\windows-automation\logs.txt
  mapDesktopsFromRegistry()
  if (targetDesktop > DesktopCount || targetDesktop < 1) {
    return
  }
  
  while(CurrentDesktop < targetDesktop) {
    ; FileAppend, ================= `n, C:\Users\delis\Desktop\windows-automation\logs.txt
    if (currentAnimation != GUID_1) {
      return
    }
    if (prevDesktop === CurrentDesktop) {
      Sleep 100
      continue
    }
    prevDesktop := CurrentDesktop

    ; FileAppend, target2: %targetDesktop% current: %CurrentDesktop% prevDesktop: %prevDesktop% `n, C:\Users\delis\Desktop\windows-automation\logs.txt
    Send ^#{Right}
    ; FileAppend, target2 finish: %targetDesktop% current: %CurrentDesktop% `n, C:\Users\delis\Desktop\windows-automation\logs.txt
    Sleep 50
    mapDesktopsFromRegistry()
  }

  while(CurrentDesktop > targetDesktop) {
    ; FileAppend, ================= `n, C:\Users\delis\Desktop\windows-automation\logs.txt
    if (currentAnimation != GUID_1) {
      return
    }
    if (prevDesktop === CurrentDesktop) {
      Sleep 100
      continue
    }
    prevDesktop := CurrentDesktop

    ; FileAppend, target: %targetDesktop% current: %CurrentDesktop%  prevDesktop: %prevDesktop% `n, C:\Users\delis\Desktop\windows-automation\logs.txt
    Send ^#{Left}
    ; FileAppend, target finish: %targetDesktop% current: %CurrentDesktop% `n, C:\Users\delis\Desktop\windows-automation\logs.txt
    Sleep 50
    mapDesktopsFromRegistry()
  }
}

mapDesktopsFromRegistry()

#\::switchDesktopByNumber(1)
#z::switchDesktopByNumber(2)
#x::switchDesktopByNumber(3)
#a::switchDesktopByNumber(4)
#s::switchDesktopByNumber(5)
; #d::switchDesktopByNumber(6)

!,::Send |
!Backspace::Send ^{Backspace}
!+r::Send ^+r
![::Send ^[
!]::Send ^]
!Enter::Send ^{Enter}
!a::Send ^a
!f::Send ^f
!s::Send ^s
!z::Send ^z
!+z::Send ^+z
!w::Send ^w
!c::Send ^c
!v::Send ^v
!1::Send ^+{Tab}
!2::Send ^{Tab}
!Right::Send ^{Right}
!Left::Send ^{Left}
!+Right::Send ^+{Right}
!+Left::Send ^+{Left}
^!Right::Send {End}
^!Left::Send {Home}

::cn::console.log()