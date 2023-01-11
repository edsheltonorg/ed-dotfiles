; Adjust Logitech k830 to more familiar function key location

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Browser_Back::F2
Browser_Home::F3
;!Tab::Send {F4}              ;not sensible to remap this
AppsKey::F5
Browser_Search::F6
#d::F7                        ;was show/hide desktop
#Up::F8                       ;was maximize
Launch_Media::F9
Media_Prev::F10
Media_Play_Pause::F11
Media_Next::F12
