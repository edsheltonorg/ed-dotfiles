Function Prompt { 'PS-VSC \' + "$pwd".Split('\')[-1] + '> ' }
Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord