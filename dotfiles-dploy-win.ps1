# run as admin -or- user must be granted symlink permissions & re-login.

# dotfile directory, set to the script's folder.
$d_dir = "$PSScriptRoot"

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
        $uInput = Read-Host "'$cpath' is real and exists! Delete? (y/n)"
        switch ($uInput) {
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

# -- Config -- #

# VSCode
$c_code = "$env:APPDATA\Code"
$d_code = "$d_dir\Code"

PathAndLink `
    "$c_code\User\snippets\" `
    "$d_code\User\snippets\"
PathAndLink `
    "$c_code\User\keybindings.json" `
    "$d_code\User\keybindings.json"
PathAndLink `
    "$c_code\User\settings.json" `
    "$d_code\User\settings.json"
PathAndLink `
    "$c_code\User\tasks.json" `
    "$d_code\User\tasks.json"
PathAndLink `
    "$c_code\User\PSScriptAnalyzerSettings.psd1" `
    "$d_code\User\PSScriptAnalyzerSettings.psd1"

## VSCodium
#$c_vscodium = "$env:APPDATA\VSCodium"
#$d_vscodium = "$d_dir\VSCodium"

#PathAndLink `
    #"$c_vscodium\User\snippets\" `
    #"$d_vscodium\User\snippets\"
#PathAndLink `
    #"$c_vscodium\User\keybindings.json" `
    #"$d_vscodium\User\keybindings.json"
#PathAndLink `
    #"$c_vscodium\User\settings.json" `
    #"$d_vscodium\User\settings.json"
#PathAndLink `
    #"$c_vscodium\User\tasks.json" `
    #"$d_vscodium\User\tasks.json"
#PathAndLink `
    #"$c_vscodium\User\PSScriptAnalyzerSettings.psd1" `
    #"$d_vscodium\User\PSScriptAnalyzerSettings.psd1"

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

# autohotkey
$c_ahk = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
$d_ahk = "$d_dir\ahk"

PathAndLink `
    "$c_ahk\binds.ahk" `
    "$d_ahk\binds.ahk"

# IntelliJ Idea
$c_intellij = "$HOME"
$d_intellij = "$d_dir\intellij"

PathAndLink `
    "$c_intellij\.ideavimrc" `
    "$d_intellij\.ideavimrc"
