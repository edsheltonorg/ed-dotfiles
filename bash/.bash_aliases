# --- Youtube-dl --- #
# youtube-dl best video
alias youtube-dl-best-video='youtube-dl --ignore-config -v -f 'bestvideo+bestaudio/best' --prefer-free-formats -i -o "~/land/youtube/videos/%(title)s.%(ext)s" '

# opus song/album
alias youtube-dl-opus-album='youtube-dl --ignore-config -x -v -f 'bestaudio' -o "~/land/youtube/opus-alb/%(autonumber)02d - %(title)s.%(ext)s" --audio-quality 0 --audio-format=opus '
alias youtube-dl-opus='youtube-dl --ignore-config -x -v -f 'bestaudio' -i --output "~/land/youtube/opus/%(title)s.%(ext)s" --audio-quality 0 --audio-format opus '
# mp3 song/album
alias youtube-dl-mp3-album='youtube-dl --ignore-config -x -v -f 'bestaudio' -o "./%(autonumber)02d - %(title)s.%(ext)s" --autonumber-size 2 --audio-quality 0 --audio-format=mp3'
alias youtube-dl-mp3='youtube-dl --ignore-config -x -v -f 'bestaudio' -i --output "./%(title)s.%(ext)s" --audio-quality 0 --audio-format mp3'

# flac song/album
alias youtube-dl-flac-album='youtube-dl --ignore-config -x -v -f 'bestaudio' -o "~/land/youtube/flac-alb/%(autonumber)02d - %(title)s.%(ext)s" --autonumber-size 2 --audio-quality 0 --audio-format=flac'
alias youtube-dl-flac='youtube-dl --ignore-config -x -v -f 'bestaudio' -i --output "~/land/youtube/flac/%(title)s.%(ext)s" --audio-quality 0 --audio-format flac'

# wget aliases
alias wget-list='wget -w 5 -c -i'
alias wget-list-directory='wget -w 5 -c -P ~/lan-wget -i'
alias wget-nocheck-list='wget --no-check-certificate -w 5 -c -i'
alias wget-nocheck-list-directory='wget --no-check-certificate -w 5 -c -P ~/lan-wget -i'
alias wget-recursive='wget -w 5 -m -k --adjust-extensions --page-requisites -np'
alias wget-recursive-directory='wget -w 5 -m -k --adjust-extensions --page-requisites -np -P ~/lan-wget'
alias wget-nocheck-recursive='wget --no-check-certificate -w 5 -m -k --adjust-extensions --page-requisites -np'
alias wget-nocheck-recursive-directory='wget --no-check-certificate -w 5 -m -k --adjust-extensions --page-requisites -np -P ~/lan-wget'

# music aliases
alias midi='a2jmidid -e'

# vim alias to gvim -v to portably fix clipboard issues on fedora/suse
alias "vim"='gvim -v'
alias "vi"='gvim -v'

# emacs-client-connect
alias "emacsclient-normal"='emacsclient -a "" -c'

# emacs open in terminal in case i forget -nw
alias "emacs-terminal"='emacs -nw'
alias "emacsclient-terminal"='emacsclient -a "" -c -nw'

# reload kde plasmashell when it lags out, uses /dev/null to suppress ongoing output of last command when doing more work in terminal
alias "plasmashell-reload"='kquitapp5 plasmashell && kstart5 plasmashell 2&>1 >/dev/null'

# exit w/ misspelling
alias "exi"='exit'

# more portable zenmap
alias "zenmap"='sudo umit'

# kill keepass (or other uncooperating apps)
alias "killall-keepass"='killall -s SIGKILL'

# du shortcut for current dir total size and all files
alias "du-dir"='du -shc -- *'

# df shortcut for current disk
alias "df-current-disk"='df -h .'

# re-run new keybindings
alias "caps-control-commit"='xmodmap -pke > ~/.Xmodmap'
