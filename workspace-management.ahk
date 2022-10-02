; Globals
DesktopCount = 2 ; Windows starts with 2 desktops at boot
CurrentDesktop = 1 ; Desktop count is 1-indexed (Microsoft numbers them this way)

mapDesktopsFromRegistry() {
  global CurrentDesktop, DesktopCount, CurrentDesktopId

  IdLength := 32
  RegRead, CurrentDesktopId, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, CurrentVirtualDesktop
  if (CurrentDesktopId) {
    IdLength := StrLen(CurrentDesktopId)
  }

  RegRead, DesktopList, HKEY_CURRENT_USER, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops, VirtualDesktopIDs
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
      OutputDebug, Current desktop number is %CurrentDesktop% with an ID of %DesktopIter%.
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
  global CurrentDesktop, DesktopCount
  mapDesktopsFromRegistry()
  if (targetDesktop > DesktopCount || targetDesktop < 1) {
    return
  }
  
  while(CurrentDesktop < targetDesktop) {
    Send ^#{Right}
    CurrentDesktop++
  }

  while(CurrentDesktop > targetDesktop) {
    Send ^#{Left}
    CurrentDesktop--
    OutputDebug, [left] target: %targetDesktop% current: %CurrentDesktop%
  }
}

mapDesktopsFromRegistry()

#\::switchDesktopByNumber(1)
#z::switchDesktopByNumber(2)
#x::switchDesktopByNumber(3)
#c::switchDesktopByNumber(4)

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