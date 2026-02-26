#Persistent
#SingleInstance, Force
SetKeyDelay, 0

global togglekeys := false
global keylist := []
global profilename := "Default"
global profiledir := A_ScriptDir . "\profiles"
global importdir := A_ScriptDir . "\imports"
global macrodir := A_ScriptDir . "\macros"
global settingsx := ""
global settingsy := ""
global statussize := "Small"
global statuspos := "Top Left"
global settingsdir := A_ScriptDir . "\settings"
global beepenabled := true
global togglekey := "RControl"
global statusvisible := true
global macroprocess := 0
global selectedmacro := "None"
global macrolist := []
FileCreateDir, %profiledir%
FileCreateDir, %importdir%
FileCreateDir, %settingsdir%
FileCreateDir, %macrodir%

defaultkeys := ["1","2","3","4","5","6","7","9","0","Q","T","G","Z","R","Y","C","=","-","CapsLock","Tab"]

importoldscripts()
loadmacrolist()
loadlastprofile(defaultkeys)
loadsettings()
buildstatusbox()
loadactivemacro()

SetTimer, spamkeys, 10

Hotkey, %togglekey%, togglemacro, On

togglemacro:
    togglekeys := !togglekeys
    if (togglekeys)
    {
        Gui, Status:Color, 00FF00
        GuiControl, Status:, statustext, ON
        if (beepenabled = 1)
            SoundBeep 800, 80
        
        if (selectedmacro != "None" and selectedmacro != "")
        {
            macropath := macrodir . "\" . selectedmacro . ".ahk"
            if FileExist(macropath)
            {
                Run, %macropath%,, , macroprocess
            }
        }
    }
    else
    {
        Gui, Status:Color, FF0000
        GuiControl, Status:, statustext, OFF
        if (beepenabled = 1)
            SoundBeep 600, 80
        
        if (macroprocess)
        {
            Process, Close, %macroprocess%
            macroprocess := 0
        }
        else if (selectedmacro != "None" and selectedmacro != "")
        {
            DetectHiddenWindows, On
            SetTitleMatchMode, 2
            WinClose, %selectedmacro%.ahk
            DetectHiddenWindows, Off
        }
    }
    if (statusvisible = 1 or statusvisible = "1")
        Gui, Status:Show, NoActivate
    return
    
F12::ExitApp

F10::
    GoSub, showsettingsgui
    return

spamkeys:
    IfWinActive, ahk_exe RobloxPlayerBeta.exe
    {
        if (togglekeys)
        {
            for index, key in keylist
            {
                if (key = "LButton" or key = "RButton" or key = "MButton")
                    continue
                if (key = "CapsLock")
                    checkkey := "CapsLock"
                else if (key = "Tab")
                    checkkey := "Tab"
                else
                    checkkey := key

                if (GetKeyState(checkkey, "P"))
                {
                    Send {Blind}{%key%}
                }
            }
        }
    }
    return

global leftbuttonpressed := false
global rightbuttonpressed := false

*~LButton::
    leftbuttonpressed := true
    haslbutton := false
    for index, key in keylist
    {
        if (key = "LButton")
        {
            haslbutton := true
            break
        }
    }
    if (haslbutton)
    {
        while (leftbuttonpressed)
        {
            IfWinActive, ahk_exe RobloxPlayerBeta.exe
            {
                if (togglekeys)
                {
                    Click, Left
                    Sleep, 4
                }
                else
                    break
            }
        }
    }
    return

*~LButton Up::
    leftbuttonpressed := false
    return

*~RButton::
    rightbuttonpressed := true
    hasrbutton := false
    for index, key in keylist
    {
        if (key = "RButton")
        {
            hasrbutton := true
            break
        }
    }
    if (hasrbutton)
    {
        while (rightbuttonpressed)
        {
            IfWinActive, ahk_exe RobloxPlayerBeta.exe
            {
                if (togglekeys)
                {
                    Click, Right
                    Sleep, 4
                }
                else
                    break
            }
        }
    }
    return

*~RButton Up::
    rightbuttonpressed := false
    return
    
global middlebuttonpressed := false

*~MButton::
    middlebuttonpressed := true
    hasmbutton := false
    for index, key in keylist
    {
        if (key = "MButton")
        {
            hasmbutton := true
            break
        }
    }
    if (hasmbutton)
    {
        while (middlebuttonpressed)
        {
            IfWinActive, ahk_exe RobloxPlayerBeta.exe
            {
                if (togglekeys)
                {
                    Click, Middle
                    Sleep, 4
                }
                else
                    break
            }
        }
    }
    return

*~MButton Up::
    middlebuttonpressed := false
    return

loadmacrolist()
{
    global macrodir, macrolist
    macrolist := []
    macrolist.Push("None")
    
    Loop, Files, %macrodir%\*.ahk
    {
        name := RegExReplace(A_LoopFileName, "\.ahk$")
        macrolist.Push(name)
    }
}

getmacrodropdown()
{
    global macrolist, selectedmacro
    list := ""
    for index, name in macrolist
    {
        if (list != "")
            list .= "|"
        if (name = selectedmacro)
            list .= name . "||"
        else
            list .= name
    }
    return list
}

loadactivemacro()
{
    global macrodir, selectedmacro
    
    if (selectedmacro = "None" or selectedmacro = "")
        return
    
    macropath := macrodir . "\" . selectedmacro . ".ahk"
    if FileExist(macropath)
    {
        #Include *i %A_ScriptDir%\macros\__active_macro.ahk
    }
}

buildstatusbox()
{
    global statussize, statuspos, statustext

    Gui, Status:Destroy

    if (statussize = "Small")
    {
        boxw := 30
        boxh := 20
        fontsize := s10
    }
    else if (statussize = "Medium")
    {
        boxw := 60
        boxh := 35
        fontsize := s16
    }
    else
    {
        boxw := 100
        boxh := 55
        fontsize := s24
    }

    SysGet, screenw, 0
    SysGet, screenh, 1

    if (statuspos = "Top Left")
    {
        posx := 0
        posy := 0
    }
    else if (statuspos = "Top Right")
    {
        posx := screenw - boxw
        posy := 0
    }
    else if (statuspos = "Bottom Left")
    {
        posx := 0
        posy := screenh - boxh - 40
    }
    else
    {
        posx := screenw - boxw
        posy := screenh - boxh - 40
    }

    Gui, Status:New, +AlwaysOnTop +ToolWindow -Caption +E0x20
    Gui, Status:Color, FF0000
    Gui, Status:Font, %fontsize%, Segoe UI
    Gui, Status:Add, Text, cWhite vstatustext w%boxw% Center, OFF
    if (statusvisible = 1 or statusvisible = "1")
        Gui, Status:Show, x%posx% y%posy% NoActivate, MacroStatus
    else
        Gui, Status:Hide
}

savesettings()
{
    global settingsdir, statussize, statuspos, beepenabled, togglekey, statusvisible
    filepath := settingsdir . "\display.ini"
    FileDelete, %filepath%
    IniWrite, %statussize%, %filepath%, Display, Size
    IniWrite, %statuspos%, %filepath%, Display, Position
    IniWrite, %beepenabled%, %filepath%, Display, Beep
    IniWrite, %togglekey%, %filepath%, Display, ToggleKey
    IniWrite, %statusvisible%, %filepath%, Display, Visible
}

loadsettings()
{
    global settingsdir, statussize, statuspos, beepenabled, togglekey, statusvisible
    filepath := settingsdir . "\display.ini"

    if FileExist(filepath)
    {
        IniRead, statussize, %filepath%, Display, Size, Small
        IniRead, statuspos, %filepath%, Display, Position, Top Left
        IniRead, beepenabled, %filepath%, Display, Beep, 1
        IniRead, statusvisible, %filepath%, Display, Visible, 1
        IniRead, togglekey, %filepath%, Display, ToggleKey, RControl
    }
}

showsettingsgui:
    IfWinExist, Macro Settings
    {
        WinGetPos, wx, wy,,, Macro Settings
        settingsx := wx
        settingsy := wy
    }
    Gui, Settings:Destroy

    loadmacrolist()

    Gui, Settings:New, +AlwaysOnTop, Macro Settings
    Gui, Settings:Font, s10, Segoe UI
    Gui, Settings:Color, 1a1a2e

    Gui, Settings:Font, s11 cWhite Bold
    Gui, Settings:Add, Text, x15 y10, Profile:
    Gui, Settings:Font, s10 cWhite Normal

    profilelist := getprofilelist()
    Gui, Settings:Add, DropDownList, x15 y35 w180 vselectedprofile gprofilechanged, %profilelist%

    Gui, Settings:Add, Button, x200 y35 w60 h25 gsaveprofile, Save
    Gui, Settings:Add, Button, x265 y35 w55 h25 gnewprofile, New
    Gui, Settings:Add, Button, x325 y35 w65 h25 grenameprofile, Rename
    Gui, Settings:Add, Button, x395 y35 w60 h25 gdeleteprofile, Delete

    Gui, Settings:Font, s11 cWhite Bold
    Gui, Settings:Add, Text, x15 y70, Macro:
    Gui, Settings:Font, s10 cWhite Normal

    macrodropdown := getmacrodropdown()
    Gui, Settings:Add, DropDownList, x15 y95 w180 vselectedmacrodrop gmacrochanged, %macrodropdown%

    Gui, Settings:Add, Button, x200 y95 w80 h25 gimportmacro, Import
    Gui, Settings:Add, Button, x285 y95 w80 h25 gdeletemacro, Delete
    Gui, Settings:Add, Button, x370 y95 w85 h25 gopenmacrofolder, Open Folder

    Gui, Settings:Font, s11 cWhite Bold
    keycount := keylist.Length()
    Gui, Settings:Add, Text, x15 y135, Active Keys (%keycount%):

    Gui, Settings:Font, s11 cWhite Normal, Consolas
    Gui, Settings:Add, ListView, x15 y160 w200 h220 vselectedkey Background1a1a2e cWhite -Hdr +LV0x10000, Key
    for index, key in keylist
    {
        displayname := key
        if (key = "=")
            displayname := "= (Equals)"
        else if (key = "-")
            displayname := "- (Hyphen)"
        else if (key = "LButton")
            displayname := "Left Click"
        else if (key = "RButton")
            displayname := "Right Click"
        else if (key = "MButton")
            displayname := "Middle Click"
        LV_Add("", index . ".  " . displayname)
    }

    Gui, Settings:Font, s10 cWhite Normal, Segoe UI
    Gui, Settings:Add, Text, x230 y135, Add Key:
    Gui, Settings:Add, Edit, x230 y160 w150 h25 vnewkeyinput,
    Gui, Settings:Add, Button, x385 y160 w70 h25 gaddkey, Add
    Gui, Settings:Add, Button, x230 y195 w225 h30 gremovekey, Remove Selected
    Gui, Settings:Add, Button, x230 y235 w225 h30 gclearallkeys, Clear All

    Gui, Settings:Font, s11 cWhite Bold
    Gui, Settings:Add, Text, x230 y280, Quick Add:
    Gui, Settings:Font, s10 cWhite Normal
    Gui, Settings:Add, Button, x230 y305 w55 h25 gquickadd1, 1-5
    Gui, Settings:Add, Button, x290 y305 w55 h25 gquickadd2, 6-0
    Gui, Settings:Add, Button, x350 y305 w55 h25 gquickadd3, QWER
    Gui, Settings:Add, Button, x410 y305 w45 h25 gquickadd4, ZXCV
    Gui, Settings:Add, Button, x230 y335 w55 h25 gaddlclick, LMB
    Gui, Settings:Add, Button, x290 y335 w55 h25 gaddlrclick, RMB
    Gui, Settings:Add, Button, x350 y335 w55 h25 gaddmclick, MMB

    Gui, Settings:Font, s10 cWhite Normal
    Gui, Settings:Add, Text, x230 y370, Or press a key:
    Gui, Settings:Add, Button, x230 y395 w225 h30 vcapturebtn gcapturekey, Click then press a key...

    Gui, Settings:Add, Button, x15 y390 w200 h25 gimportnow, Re-scan Imports Folder
    Gui, Settings:Add, Button, x15 y420 w200 h25 gshowdisplaysettings, Display Settings

    if (settingsx != "")
        Gui, Settings:Show, x%settingsx% y%settingsy% w470 h460, Macro Settings
    else
        Gui, Settings:Show, w470 h460, Macro Settings
    return

macrochanged:
    Gui, Settings:Submit, NoHide
    if (selectedmacrodrop != "")
    {
        selectedmacro := selectedmacrodrop
    }
    return

importmacro:
    FileSelectFile, macrofile, 3, %A_ScriptDir%, Select Macro File, AutoHotkey Scripts (*.ahk)
    if (macrofile != "")
    {
        SplitPath, macrofile, filename
        destpath := macrodir . "\" . filename
        
        if FileExist(destpath)
        {
            forcealwaysontop()
            MsgBox, 36, Overwrite?, A macro with that name already exists. Overwrite?
            IfMsgBox No
                return
        }
        
        FileCopy, %macrofile%, %destpath%, 1
        loadmacrolist()
        selectedmacro := RegExReplace(filename, "\.ahk$")
        GoSub, showsettingsgui
        forcealwaysontop()
        MsgBox, 64, Imported, Macro "%selectedmacro%" imported successfully.`n`nNote: Restart the script or reload profile to activate the macro.
    }
    return

deletemacro:
    Gui, Settings:Submit, NoHide
    if (selectedmacrodrop = "None" or selectedmacrodrop = "")
    {
        forcealwaysontop()
        MsgBox, 48, Error, No macro selected to delete.
        return
    }
    
    forcealwaysontop()
    MsgBox, 36, Confirm, Delete macro "%selectedmacrodrop%"?
    IfMsgBox Yes
    {
        macropath := macrodir . "\" . selectedmacrodrop . ".ahk"
        FileDelete, %macropath%
        
        if (selectedmacro = selectedmacrodrop)
            selectedmacro := "None"
        
        loadmacrolist()
        GoSub, showsettingsgui
    }
    return

openmacrofolder:
    Run, explorer.exe %macrodir%
    return

showdisplaysettings:
    Gui, Display:Destroy

    Gui, Display:New, +AlwaysOnTop, Display Settings
    Gui, Display:Font, s10, Segoe UI
    Gui, Display:Color, 1a1a2e

    Gui, Display:Font, s11 cWhite Bold
    Gui, Display:Add, Text, x15 y15, Indicator Size:
    Gui, Display:Font, s10 cWhite Normal

    sizelist := "Small|Medium|Large"
    if (statussize = "Small")
        sizelist := "Small||Medium|Large"
    else if (statussize = "Medium")
        sizelist := "Small|Medium||Large"
    else
        sizelist := "Small|Medium|Large||"

    Gui, Display:Add, DropDownList, x15 y40 w200 vsizeselect, %sizelist%

    Gui, Display:Font, s11 cWhite Bold
    Gui, Display:Add, Text, x15 y80, Indicator Position:
    Gui, Display:Font, s10 cWhite Normal

    poslist := "Top Left|Top Right|Bottom Left|Bottom Right"
    if (statuspos = "Top Left")
        poslist := "Top Left||Top Right|Bottom Left|Bottom Right"
    else if (statuspos = "Top Right")
        poslist := "Top Left|Top Right||Bottom Left|Bottom Right"
    else if (statuspos = "Bottom Left")
        poslist := "Top Left|Top Right|Bottom Left||Bottom Right"
    else
        poslist := "Top Left|Top Right|Bottom Left|Bottom Right||"

    Gui, Display:Add, DropDownList, x15 y105 w200 vposselect, %poslist%

    Gui, Display:Font, s11 cWhite Bold
    Gui, Display:Add, Text, x15 y145, Toggle Sound:
    Gui, Display:Font, s10 cWhite Normal

    if (beepenabled = 1 or beepenabled = "1")
        beeplist := "On||Off"
    else
        beeplist := "On|Off||"

    Gui, Display:Add, DropDownList, x15 y170 w200 vbeepselect, %beeplist%

    Gui, Display:Font, s11 cWhite Bold
    Gui, Display:Add, Text, x15 y210, Show Indicator:
    Gui, Display:Font, s10 cWhite Normal

    if (statusvisible = 1 or statusvisible = "1")
        vislist := "On||Off"
    else
        vislist := "On|Off||"

    Gui, Display:Add, DropDownList, x15 y235 w200 vvisselect, %vislist%

    Gui, Display:Font, s11 cWhite Bold
    Gui, Display:Add, Text, x15 y275, Toggle Key:
    Gui, Display:Font, s10 c00FF00 Normal, Consolas
    Gui, Display:Add, Text, x15 y300 w200 vtogglekeydisplay, %togglekey%
    Gui, Display:Font, s10 cWhite Normal, Segoe UI
    Gui, Display:Add, Button, x15 y325 w200 h30 vtogglecapturebtn gcapturetogglekey, Click to change toggle key...

    Gui, Display:Add, Button, x15 y370 w95 h30 gapplydisplay, Apply
    Gui, Display:Add, Button, x120 y370 w95 h30 gclosedisplay, Close

    Gui, Display:Show, w230 h415, Display Settings
    return

applydisplay:
    Gui, Display:Submit, NoHide
    statussize := sizeselect
    statuspos := posselect
    if (beepselect = "On")
        beepenabled := 1
    else
        beepenabled := 0
    if (visselect = "On")
        statusvisible := 1
    else
        statusvisible := 0
    if (newtogglekey != "" and newtogglekey != togglekey)
    {
        Hotkey, %togglekey%, togglemacro, Off
        togglekey := newtogglekey
        Hotkey, %togglekey%, togglemacro, On
        newtogglekey := ""
    }
    savesettings()
    buildstatusbox()
    if (statusvisible = 1 or statusvisible = "1")
    {
        if (togglekeys)
        {
            Gui, Status:Color, 00FF00
            GuiControl, Status:, statustext, ON
        }
        else
        {
            Gui, Status:Color, FF0000
            GuiControl, Status:, statustext, OFF
        }
        Gui, Status:Show, NoActivate
    }
    return

closedisplay:
    Gui, Display:Destroy
    return

global newtogglekey := ""

capturetogglekey:
    GuiControl, Display:, togglecapturebtn, Press any key now...
    ih := InputHook("L0 T5")
    ih.KeyOpt("{All}", "E")
    ih.Start()
    ih.Wait()
    if (ih.EndKey != "")
    {
        captured := ih.EndKey
        conflictfound := false
        for index, key in keylist
        {
            if (key = captured)
            {
                conflictfound := true
                break
            }
        }
        if (conflictfound)
        {
            GuiControl, Display:, togglecapturebtn, Click to change toggle key...
            forcealwaysontop()
            MsgBox, 48, Conflict, That key is in your active keys list. Remove it first.
            return
        }
        if (captured = "F10" or captured = "F12")
        {
            GuiControl, Display:, togglecapturebtn, Click to change toggle key...
            forcealwaysontop()
            MsgBox, 48, Reserved, F10 and F12 are reserved for settings and exit.
            return
        }
        newtogglekey := captured
        GuiControl, Display:, togglekeydisplay, %captured%
        GuiControl, Display:, togglecapturebtn, Click to change toggle key...
    }
    else
    {
        GuiControl, Display:, togglecapturebtn, Click to change toggle key...
    }
    return

displayguiclose:
    Gui, Display:Destroy
    return

addkey:
    Gui, Settings:Submit, NoHide
    newkey := Trim(newkeyinput)
    if (newkey != "")
    {
        if (newkey = togglekey)
        {
            forcealwaysontop()
            MsgBox, 48, Conflict, That key is your toggle key. Change it in Display Settings first.
            return
        }
        isdupe := false
        for index, key in keylist
        {
            if (key = newkey)
            {
                isdupe := true
                break
            }
        }
        if (!isdupe)
        {
            keylist.Push(newkey)
            GoSub, showsettingsgui
        }
        else
        {
            forcealwaysontop()
            MsgBox, 48, Duplicate, That key is already in the list.
        }
    }
    return

removekey:
    Gui, Settings:Default
    rownum := LV_GetNext(0, "Focused")
    if (rownum > 0 and rownum <= keylist.Length())
    {
        newlist := []
        for index, key in keylist
        {
            if (index != rownum)
                newlist.Push(key)
        }
        keylist := newlist
        GoSub, showsettingsgui
    }
    return

clearallkeys:
    forcealwaysontop()
    MsgBox, 36, Confirm, Are you sure you want to clear all keys?
    IfMsgBox Yes
    {
        keylist := []
        GoSub, showsettingsgui
    }
    return

quickadd1:
    quickaddkeys(["1","2","3","4","5"])
    GoSub, showsettingsgui
    return

quickadd2:
    quickaddkeys(["6","7","8","9","0"])
    GoSub, showsettingsgui
    return

quickadd3:
    quickaddkeys(["Q","W","E","R"])
    GoSub, showsettingsgui
    return

quickadd4:
    quickaddkeys(["Z","X","C","V"])
    GoSub, showsettingsgui
    return

addlclick:
    quickaddkeys(["LButton"])
    GoSub, showsettingsgui
    return

addlrclick:
    quickaddkeys(["RButton"])
    GoSub, showsettingsgui
    return

addmclick:
    quickaddkeys(["MButton"])
    GoSub, showsettingsgui
    return

quickaddkeys(keys)
{
    global keylist, togglekey
    for index, newkey in keys
    {
        if (newkey = togglekey)
            continue
        isdupe := false
        for i, existingkey in keylist
        {
            if (existingkey = newkey)
            {
                isdupe := true
                break
            }
        }
        if (!isdupe)
            keylist.Push(newkey)
    }
}

capturekey:
    GuiControl, Settings:, capturebtn, Press any key or click...
    capturedkey := ""
    capturewait := true
    Hotkey, ~LButton, capturemouse, On
    Hotkey, ~RButton, capturemouse, On
    Hotkey, ~MButton, capturemouse, On
    ih := InputHook("L1 T5")
    ih.Start()
    ih.Wait()
    Hotkey, ~LButton, capturemouse, Off
    Hotkey, ~RButton, capturemouse, Off
    Hotkey, ~MButton, capturemouse, Off
    if (capturedkey = "")
    {
        if (ih.Input != "")
            capturedkey := ih.Input
        else if (ih.EndKey != "")
            capturedkey := ih.EndKey
    }
    if (capturedkey != "")
    {
        if (capturedkey = togglekey)
        {
            GuiControl, Settings:, capturebtn, Click then press a key...
            forcealwaysontop()
            MsgBox, 48, Conflict, That key is your toggle key.
            return
        }
        isdupe := false
        for index, key in keylist
        {
            if (key = capturedkey)
            {
                isdupe := true
                break
            }
        }
        if (!isdupe)
        {
            keylist.Push(capturedkey)
            GoSub, showsettingsgui
        }
        else
        {
            GuiControl, Settings:, capturebtn, Click then press a key...
            forcealwaysontop()
            MsgBox, 48, Duplicate, That key is already in the list.
        }
    }
    else
    {
        GuiControl, Settings:, capturebtn, Click then press a key...
    }
    return

capturemouse:
    mousebtn := A_ThisHotkey
    mousebtn := StrReplace(mousebtn, "~", "")
    capturedkey := mousebtn
    ih.Stop()
    return

importnow:
    importoldscripts()
    GoSub, showsettingsgui
    forcealwaysontop()
    MsgBox, 64, Import, Finished scanning imports folder.
    return

saveprofile:
    Gui, Settings:Submit, NoHide
    saveas := selectedprofile
    if (saveas = "" or saveas = "Select a profile...")
        saveas := profilename

    saveprofiletofile(saveas)
    profilename := saveas
    savelastprofile(saveas)
    SoundBeep 600, 50
    SoundBeep 800, 50
    GoSub, showsettingsgui
    return

newprofile:
    forcealwaysontop()
    InputBox, newname, New Profile, Enter a name for the new profile:
    if (ErrorLevel = 0 and newname != "")
    {
        profilename := newname
        saveprofiletofile(newname)
        savelastprofile(newname)
        GoSub, showsettingsgui
    }
    return

renameprofile:
    Gui, Settings:Submit, NoHide
    torename := selectedprofile
    if (torename = "" or torename = "Select a profile...")
        return

    forcealwaysontop()
    InputBox, newname, Rename Profile, Enter new name for "%torename%":
    if (ErrorLevel = 0 and newname != "" and newname != torename)
    {
        oldpath := profiledir . "\" . torename . ".ini"
        newpath := profiledir . "\" . newname . ".ini"

        if FileExist(newpath)
        {
            forcealwaysontop()
            MsgBox, 48, Error, A profile named "%newname%" already exists.
            return
        }

        FileMove, %oldpath%, %newpath%
        if (profilename = torename)
        {
            profilename := newname
            savelastprofile(newname)
        }
        GoSub, showsettingsgui
    }
    return

deleteprofile:
    Gui, Settings:Submit, NoHide
    todelete := selectedprofile
    if (todelete = "" or todelete = "Select a profile...")
        return

    forcealwaysontop()
    MsgBox, 36, Confirm, Delete profile "%todelete%"?
    IfMsgBox Yes
    {
        filepath := profiledir . "\" . todelete . ".ini"
        FileDelete, %filepath%
        if (profilename = todelete)
        {
            profilename := "Default"
            keylist := []
            selectedmacro := "None"
        }
        GoSub, showsettingsgui
    }
    return

profilechanged:
    Gui, Settings:Submit, NoHide
    if (selectedprofile != "" and selectedprofile != "Select a profile...")
    {
        loadprofilefromfile(selectedprofile)
        profilename := selectedprofile
        savelastprofile(selectedprofile)
        GoSub, showsettingsgui
    }
    return

saveprofiletofile(name)
{
    global keylist, profiledir, selectedmacro
    filepath := profiledir . "\" . name . ".ini"
    FileDelete, %filepath%

    keystring := ""
    for index, key in keylist
    {
        if (keystring != "")
            keystring .= ","
        keystring .= key
    }

    IniWrite, %keystring%, %filepath%, Settings, Keys
    IniWrite, %selectedmacro%, %filepath%, Settings, Macro
}

loadprofilefromfile(name)
{
    global keylist, profiledir, selectedmacro
    filepath := profiledir . "\" . name . ".ini"

    IniRead, keystring, %filepath%, Settings, Keys, %A_Space%
    IniRead, selectedmacro, %filepath%, Settings, Macro, None
    
    if (selectedmacro = "ERROR" or selectedmacro = "")
        selectedmacro := "None"
    
    keylist := []

    if (keystring != "")
    {
        Loop, Parse, keystring, `,
        {
            keylist.Push(A_LoopField)
        }
    }
}

getprofilelist()
{
    global profiledir, profilename
    list := ""
    Loop, Files, %profiledir%\*.ini
    {
        name := RegExReplace(A_LoopFileName, "\.ini$")
        if (list != "")
            list .= "|"
        if (name = profilename)
            list .= name . "||"
        else
            list .= name
    }
    if (list = "")
        list := "No profiles saved"
    return list
}

savelastprofile(name)
{
    global profiledir
    filepath := profiledir . "\__lastprofile.txt"
    FileDelete, %filepath%
    FileAppend, %name%, %filepath%
}

loadlastprofile(defaultkeys)
{
    global profiledir, profilename, keylist, selectedmacro
    filepath := profiledir . "\__lastprofile.txt"

    FileRead, lastname, %filepath%
    if (ErrorLevel = 0 and lastname != "")
    {
        profilename := Trim(lastname)
        profilepath := profiledir . "\" . profilename . ".ini"
        if FileExist(profilepath)
        {
            loadprofilefromfile(profilename)
            return
        }
    }

    profilename := "Default"
    keylist := []
    selectedmacro := "None"
    for index, key in defaultkeys
    {
        keylist.Push(key)
    }
    saveprofiletofile("Default")
    savelastprofile("Default")
}

importoldscripts()
{
    global importdir, profiledir

    Loop, Files, %importdir%\*.ahk
    {
        scriptpath := A_LoopFileFullPath
        pname := RegExReplace(A_LoopFileName, "\.ahk$")

        profilepath := profiledir . "\" . pname . ".ini"
        if FileExist(profilepath)
            continue

        FileRead, scriptcontent, %scriptpath%
        if (ErrorLevel != 0)
            continue

        extractedkeys := []
        pos := 1

        while (pos := RegExMatch(scriptcontent, "GetKeyState\(""([^""]+)""", match, pos))
        {
            foundkey := match1
            isdupe := false
            for i, existing in extractedkeys
            {
                if (existing = foundkey)
                {
                    isdupe := true
                    break
                }
            }
            if (!isdupe)
                extractedkeys.Push(foundkey)
            pos += StrLen(match)
        }

        if (extractedkeys.Length() > 0)
        {
            keystring := ""
            for index, key in extractedkeys
            {
                if (keystring != "")
                    keystring .= ","
                keystring .= key
            }
            IniWrite, %keystring%, %profilepath%, Settings, Keys
            IniWrite, None, %profilepath%, Settings, Macro

            processeddir := importdir . "\processed"
            FileCreateDir, %processeddir%
            FileMove, %scriptpath%, %processeddir%\%A_LoopFileName%, 1
        }
    }
}

forcealwaysontop()
{
    SetTimer, makeontop, -10
}

makeontop:
    WinSet, AlwaysOnTop, On, A
    return

settingsguiclose:
    Gui, Settings:Destroy
    return
