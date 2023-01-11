#w::Run, "C:\Program Files\Mozilla Firefox\firefox.exe"
#e::Run explorer.exe "D:\"
#+e::Run explorer.exe "C:\Users\ed\"

; Disabling Numpad
*Numpad0::Return
*Numpad1::Return
*Numpad2::Return
*Numpad3::Return
*Numpad4::Return
*Numpad5::Return
*Numpad6::Return
*Numpad7::Return
*Numpad8::Return
*Numpad9::Return
*NumpadDot::Return
*NumpadDiv::Return
*NumpadMult::Return
*NumpadAdd::Return
*NumpadSub::Return
*NumpadEnter::Return
*NumpadIns::Return
*NumpadDown::Return
*NumpadLeft::Return
*NumpadClear::Return
*NumpadRight::Return
*NumpadUp::Return
*NumpadDel::Return
*NumpadPgUp::Return
*NumpadPgDn::Return
*NumpadHome::Return
*NumpadEnd::Return

; set caps to ctrl
CapsLock::Ctrl

; keep window on top
^SPACE:: Winset, Alwaysontop, , A

; unbind right alt for use in custom keybinds listed below
Ralt::return

; add duplicate functionality on ralt
>!BackSpace::Send {BackSpace}
>!Enter::Send {Enter}
>!Space::Send {Space}

; ijkl send arrow keys on ralt (Ctrl+Shift+Alt can misbehave, beware!)
>!i::Send {Up}
>!j::Send {Left}
>!k::Send {Down}
>!l::Send {Right}
+>!i::Send +{Up}
+>!j::Send +{Left}
+>!k::Send +{Down}
+>!l::Send +{Right}
^>!i::Send ^{Up}
^>!j::Send ^{Left}
^>!k::Send ^{Down}
^>!l::Send ^{Right}
^+>!i::Send ^+{Up}
^+>!j::Send ^+{Left}
^+>!k::Send ^+{Down}
^+>!l::Send ^+{Right}

; num row send shift form on ralt
>!1::Send {!}
+>!1::Send {!}
>!2::Send {@}
+>!2::Send {@}
>!3::Send {#}
+>!3::Send {#}
>!4::Send {$}
+>!4::Send {$}
>!5::Send {`%}
+>!5::Send {`%}
>!6::Send {^}
+>!6::Send {^}
>!7::Send {&}
+>!7::Send {&}
>!8::Send {*}
+>!8::Send {*}
>!9::Send {(}
+>!9::Send {(}
>!0::Send {)}
+>!0::Send {)}

; send shifted versions of certain symbols on ralt
>!`;::Send {:}
+>!`;::Send {:}
>!`::Send {~}
+>!`::Send {~}

; mnemonics for certain keys
>!q::send {?} ; question
+>!q::send {?}
>!e::send {=} ; equals
+>!e::send {=}
>!r::Send {=}
+>!r::Send {=}
>!t::Send {~} ; tilde
+>!t::Send {~}
>!y::Send {$} ; yen
+>!y::Send {$}
>!p::Send {`%} ; percent
+>!p::Send {`%}

>!a::Send {@} ; at
+>!a::Send {@}
>!s::Send {&} ; ampersand (1 off A)
+>!s::Send {&}
>!d::Send {-} ; dash
+>!d::Send {-}
>!g::Send {``} ; grave
+>!g::Send {``}
>!h::Send {#} ; hashtag
+>!h::Send {#}
>!c::Send {^} ; caret
+>!c::Send {^}

; uo send ()
>!u::Send {(}
+>!u::Send {(}
>!o::Send {)}
+>!o::Send {)}

; m,./ sends <[]> on ralt
>!m::Send {[}
+>!m::Send +{[}
>!,::Send {]}
+>!,::Send +{]}
>!n::Send {<}
+>!n::Send {<}
>!.::Send {>}
+>!.::Send {>}

; Right Shift sends -_+= on shift+ralt modifiers
RShift::Send {-}
+RShift::Send +{-}
>!RShift::Send {+}
+>!RShift::Send {=}

;; messes w/ syntax of file; other mnemonics
>![::Send {+} ; plus (1 off p)
+>![::Send {+}
>!]::Send {*} ; multiply (1 off plus)
+>!]::Send {*}
>!\::Send {/} ; divide (1 off multiple & on slash)
+>!\::Send {/}
