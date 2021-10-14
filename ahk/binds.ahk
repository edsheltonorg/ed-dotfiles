; normal bind section
; ---

CapsLock::Ctrl
Ralt::return

#w::Run, "C:\Program Files\Mozilla Firefox\firefox.exe"
#e::Run explorer.exe "D:\"
#+e::Run explorer.exe "C:\Users\ed\"

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

>!e::Send {=}
+>!e::Send {=}
>!r::Send {=}
+>!r::Send {=}
>!y::Send {$}
+>!y::Send {$}
>!u::Send {(}
+>!u::Send {(}
>!o::Send {)}
+>!o::Send {)}
>!p::Send {`%}
+>!p::Send {`%}

>!a::Send {@}
+>!a::Send {@}
>!s::Send {&}
+>!s::Send {&}
>!f::Send {$}
+>!f::Send {$}
>!g::Send {``}
+>!g::Send {``}
>!h::Send {#}
+>!h::Send {#}
>!`;::Send {:}
+>!`;::Send {:}

>!z::Send {~}
+>!z::Send {~}
>!c::Send {^}
+>!c::Send {^}
>!n::Send {<}
+>!n::Send {<}
>!.::Send {>}
+>!.::Send {>}

>!m::Send {[}
+>!m::Send +{[}
>!,::Send {]}
+>!,::Send +{]}

RShift::Send {-}
+RShift::Send +{-}
>!RShift::Send {+}
+>!RShift::Send {=}
