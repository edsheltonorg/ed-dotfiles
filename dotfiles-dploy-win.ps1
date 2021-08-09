# run as admin -or- user must be granted symlink permissions & re-login.

# DO NOT include SSH, GNUPG, OPENVPN, or other dirs that may contain secrets.
# ALWAYS check for personal information in config files before pushing to a SVN.

# folder containing real dotfiles
$d_dir = "$HOME\dotfiles"

# vscodium
$d_vscodium = "$d_dir\VSCodium"
$c_vscodium = "$env:APPDATA\VSCodium"

dploy link `
    "$d_vscodium\User\snippets\" `
    "$c_vscodium\User\snippets\"
dploy link `
    "$d_vscodium\User\keybindings.json" `
    "$c_vscodium\User\keybindings.json"
dploy link `
    "$d_vscodium\User\settings.json" `
    "$c_vscodium\User\settings.json"
dploy link `
    "$d_vscodium\User\tasks.json" `
    "$c_vscodium\User\tasks.json"

# mpvnet
$d_mpvnet = "$d_dir\mpv.net"
$c_mpvnet = "$env:APPDATA\mpv.net"

dploy link `
    "$d_mpvnet\input.conf" `
    "$c_mpvnet\input.conf"
dploy link `
    "$d_mpvnet\mpv.conf" `
    "$c_mpvnet\mpv.conf"

# powershell config
$d_powershell = "$d_dir\WindowsPowerShell"
$c_powershell = "$HOME\Documents\WindowsPowerShell"

dploy link "$d_powershell" "$c_powershell"

# nvim
$d_nvim = "$d_dir\nvim"
$c_nvim = "$env:LOCALAPPDATA\nvim"

dploy link "$d_nvim" "$c_nvim"

# emacs
$d_emacs = "$d_dir\emacs"
$c_emacs = "$env:APPDATA\.emacs.d"

dploy link `
    "$d_emacs\emojis" `
    "$c_emacs\emojis"
dploy link `
    "$d_emacs\lisp" `
    "$c_emacs\lisp"
dploy link `
    "$d_emacs\snippets" `
    "$c_emacs\snippets"
dploy link `
    "$d_emacs\abbrev_defs" `
    "$c_emacs\abbrev_defs"
dploy link `
    "$d_emacs\init.el" `
    "$c_emacs\init.el"

# gpodder
$d_gpodder = "$d_dir\gpodder"
$c_gpodder = "${ENV:ProgramFiles(x86)}\gPodder"

dploy link `
    "$d_gpodder\settings.ini" `
    "$c_gpodder\etc\gtk-3.0\settings.ini"

dploy link `
    "$d_gpodder\Settings.json" `
    "$HOME\Documents\gPodder\Settings.json"

# xournalpp
$d_xournalpp = "$d_dir\xournalpp"
$c_xournalpp = "$ENV:ProgramFiles\Xournal++"

dploy link `
    "$d_xournalpp\settings.ini" `
    "$c_xournalpp\etc\gtk-3.0\settings.ini"

# retroarch
$d_retroarch = "$d_dir\retroarch"
$c_retroarch = "$env:HOMEDRIVE\RetroArch-Win64"

dploy link `
    "$d_retroarch\retroarch.cfg" `
    "$c_retroarch\retroarch.cfg"
dploy link `
    "$d_retroarch\config" `
    "$c_retroarch\config"
dploy link `
    "$d_retroarch\saves" `
    "$c_retroarch\saves"

# autohotkey
$d_ahk = "$d_dir\ahk"
$c_ahk = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"

dploy link `
    "$d_ahk\binds.ahk" `
    "$c_ahk\binds.ahk"

# windows terminal
$d_wt = "$d_dir\wt"
$c_wt = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe"

dploy link `
    "$d_wt" `
    "$c_wt\LocalState"