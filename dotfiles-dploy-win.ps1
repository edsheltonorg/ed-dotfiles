# run as admin -or- user must be granted symlink permissions & re-login.

# DO NOT include SSH, GNUPG, OPENVPN, or other dirs that may contain secrets.
# ALWAYS check for personal information in config files before pushing to a SVN.

# Check if path is symlinked, if not then delete / create dir to desired path.
function PathAndLink {
    param (
        # real system config path
        [string]$cpath,
        # dotfile path
        [string]$dpath
    )
    $symtest = get-item $cpath -ErrorAction SilentlyContinue
    if (!($symtest)) {
        $dir = split-path $cpath
        echo "'$cpath' not found! Creating '$dir' path and symlinking '$dpath'"
        mkdir -Force $dir > $null
        dploy link $dpath $cpath
    }
    elseif (($symtest.LinkType -eq "SymbolicLink") -eq $false) {
        $input = Read-Host "'$cpath' is real and exists! Delete? (y/n)"
        switch ($input) {
            y {
                rm -Recurse -Force $cpath
                dploy link $dpath $cpath
            }
            Default {}
        }
    }
    else {
        echo "'$cpath' already symlinked!"
    }
}

# folder containing real dotfiles
$d_dir = "$PSScriptRoot"

# vscodium
$c_vscodium = "$env:APPDATA\VSCodium"
$d_vscodium = "$d_dir\VSCodium"

PathAndLink `
    "$c_vscodium\User\snippets\" `
    "$d_vscodium\User\snippets\"
PathAndLink `
    "$c_vscodium\User\keybindings.json" `
    "$d_vscodium\User\keybindings.json"
PathAndLink `
    "$c_vscodium\User\settings.json" `
    "$d_vscodium\User\settings.json"
PathAndLink `
    "$c_vscodium\User\tasks.json" `
    "$d_vscodium\User\tasks.json"
PathAndLink `
    "$c_vscodium\User\PSScriptAnalyzerSettings.psd1" `
    "$d_vscodium\User\PSScriptAnalyzerSettings.psd1"

# mpvnet
$c_mpvnet = "$env:APPDATA\mpv.net"
$d_mpvnet = "$d_dir\mpv.net"

PathAndLink `
    "$c_mpvnet\input.conf" `
    "$d_mpvnet\input.conf"

PathAndLink `
    "$c_mpvnet\mpv.conf" `
    "$d_mpvnet\mpv.conf"

# powershell config
$c_powershell = "$HOME\Documents\WindowsPowerShell"
$d_powershell = "$d_dir\WindowsPowerShell"

PathAndLink `
    "$c_powershell\Microsoft.Powershell_profile.ps1" `
    "$d_powershell\Microsoft.Powershell_profile.ps1"

PathAndLink `
    "$c_powershell\Microsoft.VSCode_profile.ps1" `
    "$d_powershell\Microsoft.VSCode_profile.ps1"


# nvim
$c_nvim = "$env:LOCALAPPDATA\nvim"
$d_nvim = "$d_dir\nvim"

PathAndLink `
    "$c_nvim\init.vim" `
    "$d_nvim\init.vim"

PathAndLink `
    "$c_nvim\colors" `
    "$d_nvim\colors"

PathAndLink `
    "$c_nvim\spell" `
    "$d_nvim\spell"

# emacs
$c_emacs = "$env:APPDATA\.emacs.d"
$d_emacs = "$d_dir\emacs"

PathAndLink `
    "$c_emacs\emojis" `
    "$d_emacs\emojis"
PathAndLink `
    "$c_emacs\lisp" `
    "$d_emacs\lisp"
PathAndLink `
    "$c_emacs\snippets" `
    "$d_emacs\snippets"
PathAndLink `
    "$c_emacs\abbrev_defs" `
    "$d_emacs\abbrev_defs"
PathAndLink `
    "$c_emacs\init.el" `
    "$d_emacs\init.el"

# gpodder
$c_gpodder = "${ENV:ProgramFiles(x86)}\gPodder"
$d_gpodder = "$d_dir\gpodder"

PathAndLink `
    "$c_gpodder\etc\gtk-3.0\settings.ini" `
    "$d_gpodder\settings.ini"

PathAndLink `
    "$HOME\Documents\gPodder\Settings.json" `
    "$d_gpodder\Settings.json"

# xournalpp
$c_xournalpp = "$ENV:ProgramFiles\Xournal++"
$d_xournalpp = "$d_dir\xournalpp"

PathAndLink `
    "$c_xournalpp\etc\gtk-3.0\settings.ini" `
    "$d_xournalpp\settings.ini"

# autohotkey
$c_ahk = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$d_ahk = "$d_dir\ahk"

PathAndLink `
    "$c_ahk\binds.ahk" `
    "$d_ahk\binds.ahk"

# windows terminal
$c_wt = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe"
$d_wt = "$d_dir\wt"

PathAndLink `
    "$c_wt\LocalState" `
    "$d_wt"
