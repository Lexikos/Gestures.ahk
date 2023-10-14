DefaultGestures:    ; Init section for default gestures.
    ; Default_D_R never closes these windows:
    GroupAdd, CloseBlacklist, ahk_class Progman         ; Desktop
    GroupAdd, CloseBlacklist, ahk_class Shell_TrayWnd   ; Taskbar
return

Default_L:
    SetTitleMatchMode, RegEx
    if WinActive("ahk_group ^Explorer$")
        Send !{Left}
    else if WinActive("- (Microsoft )?Visual C\+\+")
        Send ^-
    else if WinActive("ahk_class ^#32770$") && G_ControlExist("SHELLDLL_DefView1")
        ; Possibly a File dialog, so try sending "Back" command.
        SendMessage, 0x111, 0xA00B ; WM_COMMAND, ID
    else
        Send {Browser_Back}
    return
Default_R:
    SetTitleMatchMode, RegEx
    if WinActive("ahk_group ^Explorer$")
        Send !{Right}
    else if WinActive("- (Microsoft )?Visual C\+\+")
        Send ^+-
    else
        Send {Browser_Forward}
    return

; Close Application (or Firefox tab) - down, then right
Default_D_R:
    ifWinActive, ahk_group CloseBlacklist
        return

    ; close previously minimized window for good
    if m_ClosingWindow
        gosub gdCheckCloseApp

    ; remember ID of window
    m_ClosingWindow := WinActive("A")

    if m_ClosingWindow
    {
        WinMinimize ; deactivate the window, reactivating next window down in the z-order
        WinHide ; hide window
        ; give 3 second delay before actually closing
        SetTimer, gdCloseApp, 3000
        ; allow the Escape key to cancel (and show the window again)
        Hotkey, Escape, gdCancelCloseApp, On
    }
return

gdCloseApp:
    ; disable timer and cancel hotkey
    SetTimer, gdCloseApp, Off
    Hotkey, Escape, gdCancelCloseApp, Off

gdCheckCloseApp:
    if m_ClosingWindow
    {
        DetectHiddenWindows, Off
        ; don't close the window if it is visible
        ; (for example, user may have pressed a hotkey causing the m_ClosingWindow to be shown before it closes)
        if (! WinExist("ahk_id " m_ClosingWindow))
        {
            DetectHiddenWindows, On
            WinClose, ahk_id %m_ClosingWindow%
            DetectHiddenWindows, Off
        }
        m_ClosingWindow := 0
    }
return

; Press Escape within 3 seconds to cancel "Close App"
gdCancelCloseApp:
    ; disable timer and hotkey
    SetTimer, gdCloseApp, Off
    Hotkey, Escape, gdCancelCloseApp, Off

    ; show the window again
    WinShow, ahk_id %m_ClosingWindow%
    WinActivate, ahk_id %m_ClosingWindow%
    m_ClosingWindow := 0

    ; play a sound
    SoundPlay, *-1
return


; Reload the Script.
Default_R_D_L_U:
    gosub TrayMenu_Reload
return

; Edit script/config.
Default_L_D_R_U:
    Menu, EditFile, Add, Edit &Gestures.ahk         , TrayMenu_Edit
    Menu, EditFile, Add, Edit Gestures_&Default.ahk , TrayMenu_Edit
    Menu, EditFile, Add, Edit Gestures_&User.ahk    , TrayMenu_Edit
    Menu, EditFile, Show
    Menu, EditFile, Delete
return

Default_L_D:    ; Minimize
    G_MinimizeActiveWindow()
    return
Default_R_U:    ; Maximize
    PostMessage, 0x112, 0xF030, , , A ; WM_SYSCOMMAND, SC_MAXIMIZE
    return

Default_R_L:
Default_L_R:
    WinGet, mm, MinMax, A
    if ((lastMinTime+2000 > A_TickCount && WinExist("ahk_id " lastMinID))   ; undo recent minimize
        OR (mm && WinActive("A"))                                           ; active window is minimized or maximized, restore it
        OR WinExist(G_GetLastMinimizedWindow()))                            ; restore "top-most" minimized window
    {
        ; PostMessage, WM_SYSCOMMAND, SC_RESTORE  ; -- restores the window, playing relevant "Restore" sound
        PostMessage, 0x112, 0xF120
        lastMinTime = 0
        lastMinID = 0
    }
    return

Default_L_D_U:
Default_U_L_D_U: ; <-- compensate for bad habit
    if WinExist(G_GetLastMinimizedWindow())
        PostMessage, 0x112, 0xF120
    return

Default_R_L_R_L:
Default_L_R_L_R:
    WinActive("A")
    WinGet, mm, MinMax
    if mm
        SendMessage, 0x112, 0xF120 ; WM_SYSCOMMAND, SC_RESTORE
    PostMessage, 0x112, 0xF010 ; WM_SYSCOMMAND, SC_MOVE
    Send {Left}{Right}
    return
