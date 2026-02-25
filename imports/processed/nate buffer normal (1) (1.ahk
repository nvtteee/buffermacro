#Persistent
SetKeyDelay, 0
global ToggleKeys := false

Gui, Status:New, +AlwaysOnTop +ToolWindow -Caption +E0x20
Gui, Status:Color, FF0000
Gui, Status:Add, Text, cWhite vStatusText w30 Center, OFF
Gui, Status:Show, x0 y0 NoActivate, MacroStatus

SetTimer, Zero, 10
SetTimer, One, 10
SetTimer, Two, 10
SetTimer, Three, 10
SetTimer, Four, 10
SetTimer, Five, 10
SetTimer, Six, 10
SetTimer, Seven, 10
SetTimer, Nine, 10
SetTimer, Tkey, 10
SetTimer, Gkey, 10
SetTimer, ZKey, 10
SetTimer, RKey, 10
SetTimer, YKey, 10
SetTimer, CKey, 10
SetTimer, XButton1Key, 10
SetTimer, XButton2Key, 10
SetTimer, EqualsKey, 10
SetTimer, HyphenKey, 10
SetTimer, CapsKey, 10
SetTimer, TabKey, 10
SetTimer, QKey, 10

RControl::
    ToggleKeys := !ToggleKeys
    if (ToggleKeys)
    {
        Gui, Status:Color, 00FF00
        GuiControl, Status:, StatusText, ON
        SoundBeep 800, 80
    }
    else
    {
        Gui, Status:Color, FF0000
        GuiControl, Status:, StatusText, OFF
        SoundBeep 600, 80
    }
    Gui, Status:Show, NoActivate
    return

One()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("1", "P"))
        {
            Send {Blind}1
        }
    }
}

Two()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("2", "P"))
        {
            Send {Blind}2
        }
    }
}

Three()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("3", "P"))
        {
            Send {Blind}3
        }
    }
}

Four()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("4", "P"))
        {
            Send {Blind}4
        }
    }
}

QKey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        while (ToggleKeys && GetKeyState("Q", "P"))
        {
            Send {Blind}q
            Sleep, 10
        }
    }
}

Tkey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("T", "P"))
        {
            Send {Blind}t
        }
    }
}

Gkey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("G", "P"))
        {
            Send {Blind}g
        }
    }
}

Five()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("5", "P"))
        {
            Send {Blind}5
        }
    }
}

Six()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("6", "P"))
        {
            Send {Blind}6
        }
    }
}

Seven()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("7", "P"))
        {
            Send {Blind}7
        }
    }
}

XButton1Key()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("-", "P"))
        {
            Send {Blind}-
        }
    }
}

ZKey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("Z", "P"))
        {
            Send {Blind}z
        }
    }
}

RKey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("R", "P"))
        {
            Send {Blind}r
        }
    }
}

XButton2Key()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("V", "P"))
        {
            Send {Blind}V
        }
    }
}

YKey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("Y", "P"))
        {
            Send {Blind}y
        }
    }
}

Nine()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("9", "P"))
        {
            Send {Blind}9
        }
    }
}

CKey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("C", "P"))
        {
            Send {Blind}c
        }
    }
}

Zero()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("0", "P"))
        {
            Send {Blind}0
        }
    }
}

EqualsKey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("=", "P"))
        {
            Send {Blind}=
        }
    }
}

HyphenKey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("-", "P"))
        {
            Send {Blind}-
        }
    }
}

CapsKey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("CapsLock", "T"))
        {
            Send {Blind}{CapsLock}
        }
    }
}

TabKey()
{
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (ToggleKeys && GetKeyState("Tab", "P"))
        {
            Send {Blind}{Tab}
        }
    }
}