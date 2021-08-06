;; config file
;; welcome to my init.el! I recently refactored my messy config to something more manageable, which happens to be what you're looking at. The main differences between this and my old-config are the use-package calls I've tried my hardest to work with for better OS compatibility && general organization (Bootstrap > General > Packages)

;; WHAT MAY BREAK AND WORKAROUNDS
;; When using m-x 'eval-buffer' to refresh changes, the numbering and borders will get out of sync. This is easily worked around by refreshing the config w/ revert-buffer (safe version custom bound to C-c r (won't let you refresh unsaved work, unsafe version on C-c R))

;; BOOTSTRAP
;; establishes where emacs can get packages, fixes minor problems, and forces use-package on boot

;; these are CURRENTLY broken packages that I ':ensure t' will not download correctly as of 26.1 2019-10-11
(setq package-list
	  '(evil-visualstar))
(package-install-selected-packages)

;; undo-tree not downloading correctly b/c unsigned package, this fixes it for affected versions of emacs
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; load-path for installing packages manually, I use it for undo-tree to fix some errors
;; (add-to-list 'load-path "~/.emacs.d/lisp/youtube-dl-emacs/youtube-dl")
;;(load "undo-tree/undo-tree")

;; DANGEROUS OPTION, TURNS OFF SIGNATURE ON PACKAGES, ONLY UNCOMMENT IF YOU KNOW WHAT YOU'RE DOING
;; (setq package-check-signature nil)

;; list of extra repos to be loaded besides gnu ELPA. You can look through them all w/ 'M-x list-packages'
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t) ;; where most useful packages are maintained
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t) ;; org is included in ELPA default repo, but this is a newer version
(when (< emacs-major-version 24) (add-to-list 'package-archives ("gnu" . "https://elpa.gnu.org/packages/"))) ;; default repo added if version is too old
(package-initialize)

;; bootstrap use-package, solves chicken-and-egg issue w/ starting use-package on blank install
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;; use-package is made to cleanly configure programs, I'll explain how to use it as we go
(require 'use-package)

;; PATHS
;; adding paths for operating systems that have trouble finding programs

;; windows path, MAKE SURE TO ESCAPE '\' w/ '\\'
(when (eq system-type 'windows-nt)
  (add-to-list 'exec-path "C:\\bin\\mpv\\mpv.exe")

  ;; hunspell
  (setq ispell-program-name "C:\\bin\\hunspell\\bin\\hunspell.exe"))
  ;; "en_US" is key to lookup in `ispell-local-dictionary-alist`. Please note it will be passed as default value to hunspell CLI `-d` option if you don't manually setup `-d` in `ispell-local-dictionary-alist`
  (setq ispell-local-dictionary "en_US")
  (setq ispell-local-dictionary-alist
	  '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)))

;; WINDOWS FIXES
;; Windows has some oddities that require a few specific options

;; fix encoding errors that happen when copying and pasting from websites
(setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
(set-language-environment 'utf-8)
(set-keyboard-coding-system 'utf-8-mac) ; For old Carbon emacs on OS X only
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system
  (if (eq system-type 'windows-nt)
      'utf-16-le  ;; https://rufflewind.com/2014-07-20/pasting-unicode-in-emacs-on-windows
    'utf-8))
(prefer-coding-system 'utf-8)

;; turn off annoying notification noise
(when (eq system-type 'windows-nt)
  (setq visible-bell 1))

;; make emacs start in Users folder
(when (eq system-type 'windows-nt)
  (setq default-directory "C:\\Users\\ed"))

;; ;; make emacs start in Users folder if above doesn't work
;; (when (eq system-type 'windows-nt)
;;   (defun jpk/emacs-startup-hook ()
;;     (cd "C:\\Users"))
;;   (add-hook 'emacs-startup-hook #'jpk/emacs-startup-hook))

;; WSL Fixes
;; WSL, just like Windows, has some annoyances

;; if using an x window displayer from wsl to windows, emacs has issues displaying. These options seem to fix it, specifically the last one
(setq frame-resize-pixelwise t)
(setq default-frame-alist
  (append default-frame-alist '((inhibit-double-buffering . t))))
(modify-frame-parameters nil '((inhibit-double-buffering . t)))

;; GENERAL
;; basic built-in configurations

;; insensitive completions, makes finding files and buffers faster
(setq completion-ignore-case t)

;; ;; when changes are made to an unmodified buffer, it will auto-refresh. Modified buffers will not be effected. Good for auto-updating or global replacing variables in a project that you have open in different buffers.
;; (global-auto-revert-mode t)

;; Disable cursor blinking (annoying to me, especially PDFs)
(blink-cursor-mode -1)

;; set fill-column size (this will be the column the bars visually break at (or literally if the selection below is uncommented)
(setq-default fill-column 80)

;; word wraps around line instead of characters
;;(global-visual-line-mode 1) ; I avoid global b/c visual-line-mode hinders things like tab completion hints for large folders or things like eww
(add-hook 'text-mode-hook 'visual-line-mode 1)
(add-hook 'prog-mode-hook 'visual-line-mode 1)

;; ;; this mode automatically enforces the fill-column and will break the columns. Realize that this WILL make the format stay on copy && paste
;; (add-hook 'text-mode-hook 'auto-fill-mode)
;; (add-hook 'prog-mode-hook 'auto-fill-mode)

;; disable homescreen
(setq inhibit-splash-screen t)

;; hide tool-bar (copy-paste)
(tool-bar-mode -1)

;; hide menu-bar (file-help); I personally prefer leaving this on to quickly do an esoteric action like weaving a document or customizing fonts quickly, for some reason keeps gap in gui tiling on XFCE, should probably switch to tiling manager at some point
;;(menu-bar-mode -1)

;; ;; save session on exit config
;; (desktop-save-mode 1)
;; (setq desktop-path '("~/.emacs.d/"))
;; (setq desktop-dirname "~/.emacs.d/")
;; (setq desktop-base-file-name "emacs-desktop")

;; ;; remove desktop after it's been read
;; (add-hook 'desktop-after-read-hook
;; 	  '(lambda ()
;; 	     ;; desktop-remove clears desktop-dirname
;; 	     (setq desktop-dirname-tmp desktop-dirname)
;; 	     (desktop-remove)
;; 	     (setq desktop-dirname desktop-dirname-tmp)))
;; (defun saved-session ()
;;   (file-exists-p (concat desktop-dirname "/" desktop-base-file-name)))

;; ;; use session-restore to restore the desktop manually
;; (defun session-restore ()
;;   "Restore a saved emacs session."
;;   (interactive)
;;   (if (saved-session)
;;       (desktop-read)
;;     (message "No desktop found.")))

;; ;; use session-save to save the desktop manually
;; (defun session-save ()
;;   "Save an emacs session."
;;   (interactive)
;;   (if (saved-session)
;;       (if (y-or-n-p "Overwrite existing desktop? ")
;; 	  (desktop-save-in-desktop-dir)
;; 	(message "Session not saved."))
;;   (desktop-save-in-desktop-dir)))

;; ;; ask user whether to restore desktop at start-up
;; (add-hook 'after-init-hook
;; 	  '(lambda ()
;; 	     (if (saved-session)
;; 		 (if (y-or-n-p "Restore desktop? ")
;; 		     (session-restore)))))

;; change "yes or no" to "y or n" for entry
(defalias 'yes-or-no-p 'y-or-n-p)

;; when closing emacs on last buffer, confirm exit
;; need to implement this function for evil-quit
(setq confirm-kill-emacs 'y-or-n-p)

;; auto confirm save on compile
(setq compilation-ask-about-save nil)

;; Save History of files, buffers, and etc...
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring
        last-kbd-macro
        kmacro-ring
        shell-command-history
        Info-history-list
        register-alist))
(savehist-mode 1)

;; Backup Directory; Backups usually in same directory as file w/ ~ appended. New behavior moves to inside user folder
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs.d/emacs-backups/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;; add garbage collection when not focused
(add-hook 'focus-out-hook #'garbage-collect)

;; reduces lag on long line
(setq-default bidi-display-reordering 'left-to-right)

;; ;; requires so-long DISABLE IF ON EMACS 27 SINCE BUILT IN
;; (when (require 'so-long nil :noerror)
;;   (global-so-long-mode 1))

;; remember cursor position, for emacs 25.1 or later
(save-place-mode 1)

;; use mouse-cursor even in terminal-emulator
(when (eq window-system nil)
    (xterm-mouse-mode t))

;; enable line numbering && display lines relative to cursor position
(when (version<= "26.0.50" emacs-version)
  (add-hook 'text-mode-hook 'display-line-numbers-mode)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode))

;; ;; old way to display lines
;; (setq display-line-numbers 'relative)

;; line number to relative location for easier vim movement
(setq display-line-numbers (quote relative))
(setq display-line-numbers-type (quote relative))

;; (add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; terminals display incorrectly with line numbering on (try running top)
(add-hook 'term-mode-hook (lambda () (display-line-numbers-mode -1)))

;; scroll four lines at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(4 ((shift) . 4)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)

;; scroll 6 lines when moving up page with keyboard
(setq scroll-step 6)

;; highlights parens when you're over one
(setq show-paren-delay 0)
(show-paren-mode 1)

;; use mouse ctrl+scroll wheel to zoom in and out
(global-set-key [C-mouse-4] 'text-scale-increase)
(global-set-key [C-mouse-5] 'text-scale-decrease)

;; fix full-screen button not working, normally set to f11
(global-set-key (kbd "s-F") 'toggle-frame-fullscreen) ;; note the capitol f, when you use set a keybind in KDE (and presumptiously anywhere else in your GUI) your OS will eat it before Emacs can read it

;; move between windows chronologically w/o having to use 'c-x o'. NOTE! I tried to put it on 'C-j' but term modes still ate my inputs. It turns out that terminals are extra picky about what they choose to recognize for legacy reasons, and the official way is to bind it to a C-c / C-x key or use an used modifier like C-;
(global-set-key (kbd "C-;") 'other-window)
(bind-key "C-;" 'other-window) ;; sometimes flyspell overwrites C-; behavior, to fix use bind-key package built-in to use-package

;; sometimes emacs still eats inputs so I bind it to 'C-:' as well
(global-set-key (kbd "C-:") 'other-window)
(bind-key "C-:" 'other-window) ;; sometimes flyspell overwrites C-; behavior, to fix use bind-key package built-in to use-package

;; more ergo bindings for terminals that don't play nice w/ C-; / C-:
(global-set-key (kbd "C-c j") 'other-window)
(bind-key "C-c j" 'other-window)
(global-set-key (kbd "C-c C-j") 'other-window)
(bind-key "C-c C-j" 'other-window)

;; precisely move between windows instead of using 'c-x o' so much, default is S-arrows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; custom mode-line, removes le bloat
(setq-default mode-line-format
 (quote
  (#("-" 0 1
     (help-echo
     "mouse-1: select window, mouse-2: delete others ..."))
   mode-line-mule-info
   mode-line-modified
   mode-line-frame-identification
   " "
   mode-line-buffer-identification
   " "
   (:eval (substring
           (system-name) 0 (string-match "\\..+" (system-name))))
   ":"
   default-directory
   #(" " 0 1
     (help-echo
      "mouse-1: select window, mouse-2: delete others ..."))
   global-mode-string
   #("   %[(" 0 6
     (help-echo
      "mouse-1: select window, mouse-2: delete others ..."))
   (:eval (mode-line-mode-name))
   mode-line-process
   minor-mode-alist
   #("%n" 0 2 (help-echo "mouse-2: widen" local-map (keymap ...)))
   ")%] "
   ;;   "-%-"
   )))

;; display time in 24hr format and always display it on mode-line
(setq display-time-24hr-format t)
(setq display-time-format "  %H:%M  %Y-%m-%d  ")
(display-time-mode 1)

;; add battery % left on mode-line, very nice for TTY / broken DE/WM on laptop
(display-battery-mode 1)

;; when using C-x 2 && C-x 3, move to said buffer immediately
(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

;; focus on buffer menu automatically
(define-key global-map [remap list-buffers] 'buffer-menu-other-window)

;; focus on help menu automatically
(setq help-window-select t)

;; script to swap left/right or top/bottom window splits INSIDE a split
(defun window-toggle-split-direction ()
  "Switch window split from horizontally to vertically, or vice versa.
i.e. change right window to bottom, or change bottom window to right."
  (interactive)
  (require 'windmove)
  (let ((done))
    (dolist (dirs '((right . down) (down . right)))
      (unless done
        (let* ((win (selected-window))
               (nextdir (car dirs))
               (neighbour-dir (cdr dirs))
               (next-win (windmove-find-other-window nextdir win))
               (neighbour1 (windmove-find-other-window neighbour-dir win))
               (neighbour2 (if next-win (with-selected-window next-win
                                          (windmove-find-other-window neighbour-dir next-win)))))
          ;;(message "win: %s\nnext-win: %s\nneighbour1: %s\nneighbour2:%s" win next-win neighbour1 neighbour2)
          (setq done (and (eq neighbour1 neighbour2)
                          (not (eq (minibuffer-window) next-win))))
          (if done
              (let* ((other-buf (window-buffer next-win)))
                (delete-window next-win)
                (if (eq nextdir 'right)
                    (split-window-vertically)
                  (split-window-horizontally))
                (set-window-buffer (windmove-find-other-window neighbour-dir) other-buf))))))))
;; I don't use 'C-x 5' so use window-toggle-split-direction instead
(global-set-key (kbd "C-x 5") 'window-toggle-split-direction)

;; These binds are for moving emacs windows
(global-set-key (kbd "S-C-h") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-l") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-j") 'shrink-window)
(global-set-key (kbd "S-C-k") 'enlarge-window)
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; IF ANYTHING IS GOING TO BREAK UNDER MY GENERAL CONFIG IT'S PROBABLY THIS, ADJUST BASED OFF OF PERSONAL PREFERENCE AND WHAT YOU HAVE INSTALLED

;; Change font based off of OS OLD
;; (when (eq system-type 'gnu/linux)
;;   (set-default-font "DejaVu Sans Mono 9")
;;   (setq default-frame-alist '((font . "DejaVu Sans Mono 9"))))
;; (when (eq system-type 'windows-nt)
;;   (set-default-font "Consolas 10")
;;   (setq default-frame-alist '((font . "Consolas 10"))))

;; Change font based off of OS NEW
(when (eq system-type 'gnu/linux)
  (set-face-font 'default "DejaVu Sans Mono 9")
  (set-face-font 'variable-pitch "DejaVu Sans Book 11")
  (setq default-frame-alist '((font . "DejaVu Sans Mono 9")))
  (copy-face 'default 'fixed-pitch))
(when (eq system-type 'windows-nt)
  (set-face-font 'default "Consolas 10")
  (set-face-font 'variable-pitch "Segoe UI Semibold-10")
  (setq default-frame-alist '((font . "Consolas 10")))
  (copy-face 'default 'fixed-pitch))

;; Set the fonts to format correctly
;(add-hook 'text-mode-hook 'fixed-pitch-mode)
;(add-hook 'dired-mode-hook 'fixed-pitch-mode)
;(add-hook 'calendar-mode-hook 'fixed-pitch-mode)
;(add-hook 'org-agenda-mode-hook 'fixed-pitch-mode)
;(add-hook 'shell-mode-hook 'fixed-pitch-mode)
;(add-hook 'eshell-mode-hook 'fixed-pitch-mode)
;(add-hook 'bs-mode-hook 'fixed-pitch-mode)
;(add-hook 'w3m-mode-hook 'variable-pitch-mode)
;(add-hook 'org-mode-hook 'variable-pitch-mode)
(add-hook 'eww-mode-hook 'variable-pitch-mode)

;; some helpful keys to move between modes in case something gets messed up, note that a little below this is a function called "novel-reading" that changes variable-pitch and line spacing, although it doesn't toggle line numbering
(bind-key "C-c l" 'display-line-numbers-mode)
(bind-key "C-c p" 'variable-pitch-mode)

;; reload / refresh a file (show changes in file live as well, reverting history / undo-tree still work to immediately recover info but be careful!)
(bind-key "C-c R" 'revert-buffer)

;; launch ansi-term environment. NOTE!! You might need to fix this depending on your environment, I set this initially w/ debian. To quickly find your path, launch ansi-term and see what emacs defaults to. NOTE!! if you want to run zsh instead, just change the path
(global-set-key (kbd "C-c RET") (lambda () (interactive) (split-and-follow-horizontally) (ansi-term "/bin/bash")))

;; kill terminal buffer on 'exit'
(defadvice term-handle-exit
  (after term-kill-buffer-on-exit activate)
(kill-buffer-and-window))

;; same as above, except launches new eshells instead. Eshell will always work no matter what OS or environment you're in, at the cost of being slightly abnormal. You'll need to test if it works for you, but its better than nothing
(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

(global-set-key (kbd "C-c <C-return>") (lambda () (interactive) (split-and-follow-horizontally) (eshell-new)))

;; kill eshell on exit
(defun eshell-close-on-exit ()
  (when (not (one-window-p))
    (delete-window)))
(advice-add 'eshell-life-is-too-much :after 'eshell-close-on-exit)

;; adds sane tab-completion to eshell by swapping pcomplete w/ bash-like complete
(add-hook 'eshell-mode-hook
  (lambda ()
    (bind-key "<tab>" 'completion-at-point eshell-mode-map)))

;; if you happen to like the default behavior, here is a script to clean it up
(defun delete-completion-window-buffer (&optional output)
  (interactive)
  (dolist (win (window-list))
    (when (string= (buffer-name (window-buffer win)) "*Completions*")
      (delete-window win)
      (kill-buffer "*Completions*")))
  output)
(add-hook 'comint-preoutput-filter-functions 'delete-completion-window-buffer)

;; I'm looking for a similar
;; command that actually clears shell
(defun clear-shell ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))
(add-hook 'shell-mode-hook (lambda () (define-key shell-mode-map (kbd "C-l") 'clear-shell)))

;; USER-DEFINED
;; These are built in, but depending on how old your emacs version is it may not work properly. As such I try to reduce headache w/ use-package

;; YvesBaumes' revert-buffer no-confirm unless modified shortcut (global-set-key
(global-set-key
  (kbd "C-c r")
  (lambda (&optional force-reverting)
    "Interactive call to revert-buffer. Ignoring the auto-save
 file and not requesting for confirmation. When the current buffer
 is modified, the command refuses to revert it, unless you specify
 the optional argument: force-reverting to true."
    (interactive "P")
    ;;(message "force-reverting value is %s" force-reverting)
    (if (or force-reverting (not (buffer-modified-p)))
        (revert-buffer :ignore-auto :noconfirm)
      (error "The buffer has been modified"))))

;; Sacha Chua's typing speed calculator
(defun wpm-timer ()
  "Quick keyboard timer."
  (interactive)
  (insert "GO\n")
  (run-with-timer 3 nil (lambda () (insert "\n")))  ; for warmup
  (run-with-timer 15 nil (lambda () ; 12 seconds + the 3-second warmup
                           (let ((col (- (point) (line-beginning-position))))
                             (insert (format " | %d | \n" col)))
                           )))
(local-set-key (kbd "<f7>") 'sacha/timer-go)

;; Xah's line spacing toggle
(defun xah-toggle-line-spacing ()
  "Toggle line spacing between no extra space to extra half line height.
URL `http://ergoemacs.org/emacs/emacs_toggle_line_spacing.html'
Version 2017-06-02"
  (interactive)
  (if line-spacing
      (setq line-spacing nil)
    (setq line-spacing 0.4))
  (redraw-frame (selected-frame)))

;; turn both line spacing && variable pitch on at the same time, at some point I mean to add line numbering as well (don't know why 'display-line-numbers-mode doesn't toggle correctly), but it might be best to keep them separate.
(defun novel-reading ()
  (interactive)
  (xah-toggle-line-spacing)
  (variable-pitch-mode)
  (display-line-numbers-mode )) ;; not working and I don't know why
(bind-key "C-c n" 'novel-reading)


;; unfill filled text
(defun unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the reverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column 90002000))
    (fill-paragraph nil)))

(defun unfill-region (start end)
  "Replace newline chars in region by single spaces.
This command does the reverse of `fill-region'."
  (interactive "r")
  (let ((fill-column 90002000))
    (fill-region start end)))


;; Xah's upcase sentence script, fixes visual selection including after periods and new lines
(defun xah-upcase-sentence ()
  "Upcase first letters of sentences of current text block or selection.

URL `http://ergoemacs.org/emacs/emacs_upcase_sentence.html'
Version 2019-06-21"
  (interactive)
  (let ($p1 $p2)
    (if (region-active-p)
        (setq $p1 (region-beginning) $p2 (region-end))
      (save-excursion
        (if (re-search-backward "\n[ \t]*\n" nil "move")
            (progn
              (setq $p1 (point))
              (re-search-forward "\n[ \t]*\n"))
          (setq $p1 (point)))
        (progn
          (re-search-forward "\n[ \t]*\n" nil "move")
          (setq $p2 (point)))))
    (save-excursion
      (save-restriction
        (narrow-to-region $p1 $p2)
        (let ((case-fold-search nil))
          (goto-char (point-min))
          (while (re-search-forward "\\. \\{1,2\\}\\([a-z]\\)" nil "move") ; after period
            (upcase-region (match-beginning 1) (match-end 1))
            ;; (overlay-put (make-overlay (match-beginning 1) (match-end 1)) 'face '((t :background "red" :foreground "white")))
            (overlay-put (make-overlay (match-beginning 1) (match-end 1)) 'face 'highlight))

          ;;  new line after period
          (goto-char (point-min))
          (while (re-search-forward "\\. ?\n *\\([a-z]\\)" nil "move")
            (upcase-region (match-beginning 1) (match-end 1))
            (overlay-put (make-overlay (match-beginning 1) (match-end 1)) 'face 'highlight))

          ;; after a blank line, after a bullet, or beginning of buffer
          (goto-char (point-min))
          (while (re-search-forward "\\(\\`\\|• \\|\n\n\\)\\([a-z]\\)" nil "move")
            (upcase-region (match-beginning 2) (match-end 2))
            (overlay-put (make-overlay (match-beginning 2) (match-end 2)) 'face 'highlight))

          ;; CUSTOM ADDITION, after asterisk, hypen, newline w/ space
          (goto-char (point-min))
          (while (re-search-forward "\\(! \\|? \\)\\([a-z]\\)" nil "move")
            (upcase-region (match-beginning 2) (match-end 2))
            (overlay-put (make-overlay (match-beginning 2) (match-end 2)) 'face 'highlight))

          ;; CUSTOM ADDITION, after asterisk, hypen, newline w/ space
          (goto-char (point-min))
          (while (re-search-forward "\\(* \\|- \\|\n\\)\\([a-z]\\)" nil "move")
            (upcase-region (match-beginning 2) (match-end 2))
            (overlay-put (make-overlay (match-beginning 2) (match-end 2)) 'face 'highlight))

          ;; for HTML. first letter after tag
          (goto-char (point-min))
          (while (re-search-forward "\\(<p>\n?\\|<li>\\|<td>\n?\\|<figcaption>\n?\\)\\([a-z]\\)" nil "move")
            (upcase-region (match-beginning 2) (match-end 2))
            (overlay-put (make-overlay (match-beginning 2) (match-end 2)) 'face 'highlight))

          (goto-char (point-min)))))))

;; bind key to upcase region
(bind-key "C-c U" 'xah-upcase-sentence)


;; ispell online lookup to wiktionary
(defun lookup-word (word)
  (interactive (list (save-excursion (car (ispell-get-word nil)))))
  (browse-url (format "http://en.wiktionary.org/wiki/%s" word)))
(bind-key "C-c w" 'lookup-word)

;; ;;
;; (set-window-fringes nil 0 0)
;; (set-face-attribute 'vertical-border
;;                     nil
;;                     :foreground "#282a2e")

;; Spellchecking
(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))

(eval-after-load "flyspell" ;; This mode allows RMB to fix wrong words
  '(progn
     (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
     (define-key flyspell-mouse-map [mouse-3] #'undefined)))

;; Endless Parentheses' autocorrect script, will save to .emacs.d/abbrev_defs on close
(defun endless/simple-get-word ()
  (car-safe (save-excursion (ispell-get-word nil))))

(defun endless/ispell-word-then-abbrev (p)
  "Call `ispell-word', then create an abbrev for it.
With prefix P, create local abbrev. Otherwise it will
be global.
If there's nothing wrong with the word at point, keep
looking for a typo until the beginning of buffer. You can
skip typos you don't want to fix with `SPC', and you can
abort completely with `C-g'."
  (interactive "P")
  (let (bef aft)
    (save-excursion
      (while (if (setq bef (endless/simple-get-word))
                 ;; Word was corrected or used quit.
                 (if (ispell-word nil 'quiet)
                     nil ; End the loop.
                   ;; Also end if we reach `bob'.
                   (not (bobp)))
               ;; If there's no word at point, keep looking
               ;; until `bob'.
               (not (bobp)))
        (backward-word)
        (backward-char))
      (setq aft (endless/simple-get-word)))
    (if (and aft bef (not (equal aft bef)))
        (let ((aft (downcase aft))
              (bef (downcase bef)))
          (define-abbrev
            (if p local-abbrev-table global-abbrev-table)
            bef aft)
          (message "\"%s\" now expands to \"%s\" %sally"
                   bef aft (if p "loc" "glob")))
      (user-error "No typo at or before point"))))

(setq save-abbrevs 'silently)
(setq-default abbrev-mode t)

;; disable abbrev-mode in minibuffers
(defun conditionally-disable-abbrev ()
  ""
  (if (string-match "evil-command-window-mode-" (format "%s" this-command))
      (abbrev-mode -1)))

(add-hook 'minibuffer-setup-hook 'conditionally-disable-abbrev)
(add-hook 'minibuffer-exit-hook (lambda () (abbrev-mode 1)))

(use-package flyspell
  :init
  (setq flyspell-auto-correct-binding "^F")) ;; for some reason this doesn't respect my 'C-;' map so I rebound it

;; command to describe lisp under cursor
(defun describe-foo-at-point ()
  "Show the documentation of the Elisp function and variable near point.
This checks in turn:
-- for a function name where point is
-- for a variable name where point is
-- for a surrounding function call
"
  (interactive)
  (let (sym)
    ;; sigh, function-at-point is too clever.  we want only the first half.
    (cond ((setq sym (ignore-errors
                       (with-syntax-table emacs-lisp-mode-syntax-table
                         (save-excursion
                           (or (not (zerop (skip-syntax-backward "_w")))
                               (eq (char-syntax (char-after (point))) ?w)
                               (eq (char-syntax (char-after (point))) ?_)
                               (forward-sexp -1))
                           (skip-chars-forward "`'")
	                   (let ((obj (read (current-buffer))))
                             (and (symbolp obj) (fboundp obj) obj))))))
           (describe-function sym))
          ((setq sym (variable-at-point)) (describe-variable sym))
          ;; now let it operate fully -- i.e. also check the
          ;; surrounding sexp for a function call.
          ((setq sym (function-at-point)) (describe-function sym)))))

;; bind f1 and variants to different lookups
(define-key emacs-lisp-mode-map [(f1)] 'describe-foo-at-point)
(define-key emacs-lisp-mode-map [(control f1)] 'describe-function)
(define-key emacs-lisp-mode-map [(shift f1)] 'describe-variable)


;; DIRED
(use-package dired
  :init
  ;; copy marks / files to other dired split if open
  (setq dired-dwim-target t)
  ;; sets alphabetical folders then files structure
  (when (eq system-type 'gnu/linux)
    (setq dired-listing-switches "-alhF --group-directories-first"))
  ;; emacs uses native ls versions, then elisp's ls if unavailable
  (when (eq system-type 'windows-nt)
    (setq dired-listing-switches "-alhF")
    (setq ls-lisp-dirs-first t))
  ;; refreshes when file is modified
  (add-hook 'dired-mode-hook 'auto-revert-mode)
  ;; move file to trash
  (setq delete-by-moving-to-trash t)
  :bind (:map dired-mode-map
	      ("C-n" . dired-create-directory)
	      ("M-k" . dired-up-directory)))

;; ORG
(use-package org
  :init
  ;; YOU'LL WANT TO CHANGE THIS TO WHATEVER YOU USE
  (setq org-agenda-files '("~/doc-infinite/" "~/doc-wiki/"))
  (setq org-directory "~/doc-wiki/")
  (setq org-startup-folded "showall")
  (setq org-cycle-separator-lines -1)
  (setq org-todo-keywords
  	'((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
  (defun endless/export-audio-link (path desc format)
    "Export org audio links to html."
    (cl-case format
      (html (format "<audio src=\"%s\">%s</audio>" path (or desc "")))
      (latex (format "(HOW DO I EXPORT AUDIO TO LATEX? \"%s\")" path))))
  (require 'org-attach)
  (org-add-link-type "audio" #'ignore #'endless/export-audio-link)
  (setq org-link-abbrev-alist '(("att" . org-attach-expand-link)))
  ;; PDFs visited in Org-mode are opened in Evince (and other file extensions are handled according to the defaults)
  (add-hook 'org-mode-hook
        '(lambda ()
           (setq org-file-apps
             '((auto-mode . emacs)
               ("\\.mm\\'" . default)
               ("\\.x?html?\\'" . default)
               ("\\.pdf\\'" . default)
	       ("\\.png\\'" . "kolourpaint %s")
	       ("\\.jpg\\'" . "kolourpaint %s")))))
)


;; PACKAGES
;; these are loaded in through repos primarily and will break you emacs config if not downloaded. It's smarter to run this after general Emacs configs in case something goes wrong

;; allows to hide modes on your mode-line
(use-package diminish ;; loads in package undo-tree if it's available on your system, note that this doesn't START a package, rather loads it as an option to start. This is useful b/c emacs breaks if you give it commands such as the ones below w/o it being available for your system (wrong emacs version / OS / misbehaving script)
  :ensure t ;; forces program to be installed
  :init ;; used to configure a program before it's loaded
  (diminish 'eldoc-mode) ;; this is the standard way to diminish a mode. You can also rename it w/ '(diminish '<mode> "<name>")'
  (diminish 'abbrev-mode "Abv")
  (diminish 'flyspell-mode)
  (diminish 'yas-minor-mode))


;; ;; program to hold onto window configuration in daemon / client
;; (use-package workgroups2
  ;; :ensure t
  ;; :init
  ;; (workgroups-mode 1)
  ;; (setq wg-prefix-key (kbd "C-c a")))

;; adds powershell to possible terminals, and a ps1 syntax highlight scheme
(use-package powershell
  :ensure t)

;; package that allows text to appear at fill-column size instead of literally breaking them this is a test as well
(use-package visual-fill-column
  :ensure t
  :init
  (add-hook 'visual-line-mode-hook #'visual-fill-column-mode))

;; favorite theme, feel free to turn off or replace
(use-package hc-zenburn-theme
  :ensure t
  :init
  (load-theme 'hc-zenburn t)
  (custom-set-faces '(fringe ((t (:background "gray19" :foreground "#DCDCCC")))))
  (global-hl-line-mode 1)
  ;; highlight active window
  (defun highlight-selected-window ()
    "Highlight selected window with a different background color."
    (walk-windows (lambda (w)
                    (unless (eq w (selected-window))
                      (with-current-buffer (window-buffer w)
                        (buffer-face-set '(:background "#383838"))))))
    (buffer-face-set 'default))
  (add-hook 'buffer-list-update-hook 'highlight-selected-window)
  ;; hide vertical broader when scroll bar isn't enabled
  (set-face-foreground 'vertical-border (face-background 'default)))

;; djvu file support, needs to have djview installed on your system
(use-package djvu
  :ensure t)

;; allows dired to become more extensible
(use-package dired-hacks-utils
  :ensure t
  :init)

;; different file extensions are colored differently
(use-package dired-rainbow
  :after dired-hacks-utils
  :ensure t
  :init
  (eval-after-load 'dired '(require 'dired-rainbow))
  ;; define files and color them, both ways seen below do the same thing
  (defconst dired-audio-files-extensions
          '("mp3" "MP3" "ogg" "OGG" "flac" "FLAC" "wav" "WAV" "opus" "OPUS" "aac" "AAC" "alac" "ALAC" "m4a" "M4A" "ape" "APE")
          "Dired Audio files extensions")
  (dired-rainbow-define audio "#329EE8" dired-audio-files-extensions)

  (defconst dired-video-files-extensions
          '("vob" "VOB" "mkv" "MKV" "mpe" "mpg" "MPG" "mp4" "MP4" "ts" "TS" "m2ts" "M2TS" "avi" "AVI" "mov" "MOV" "wmv" "asf" "m2v" "m4v" "mpeg" "MPEG" "tp" "webm")
          "Dired Video files extensions")
  (dired-rainbow-define video "#B3CCFF" dired-video-files-extensions)

  (defconst dired-archive-files-extensions
          '("7z" "7Z" "zip" "ZIP" "a" "ar" "tar" "TAR" "tgz" "TGZ" "tbz" "TBZ" "txz" "TXZ" "tar.gz" "TAR.GZ" "tar.bz2" "TAR.BZ2" "tar.xz" "TAR.XZ" "gz" "GZ" "lz" "LZ" "lzma" "LZMA" "bz2" "BZ2" "xz" "XZ" "ace" "ACE" "s7z" "S7Z" "apk" "APK" "dmg" "DMG" "jar" "JAR" "pea" "PEA" "rar" "RAR" "tlz" "TLZ")
          "Dired Archive files extensions")
  (dired-rainbow-define archive "#00ff99" dired-archive-files-extensions)

  (defconst dired-executable-files-extensions
          '("exe" "EXE" "jar" "JAR" "ps1" "PS1" "sh" "SH" "cmd" "CMD" "csh" "CSH" "bat" "BAT" "app" "APP" "wsf" "WSF" "vbs" "VBS" "ins" "INS" "inf" "INF" "ksh" "KSH" "osx" "OSX" "run" "RUN" "vb" "VB" "ahk" "AHK")
          "Dired Executable files extensions")
  (dired-rainbow-define executable "#B3CCFF" dired-executable-files-extensions)

  ;; note that i haven't been able to get regex to work for
  (defconst dired-config-files-extensions
          '("conf" "CONF" "rc" "RC" "presets" "preset" "ini" "INI" "cfg" "CFG" "opt" "OPT")
          "Dired Config files extensions")
  (dired-rainbow-define config "#040404" dired-config-files-extensions)

  (defconst dired-plain-text-files-extensions
          '("txt" "TXT" "rtf" "RTF" "text" "TEXT" "1st" "1ST" "me" "ME" "ans" "ANS" "unx" "UNX" "description")
          "Dired Plain-Text files extensions")
  (dired-rainbow-define plain-text "#00ff99" dired-plain-text-files-extensions)

  (defconst dired-markup-files-extensions
          '("tex" "TEX" "TeX" "md" "MD" "rmd" "RMD" "man" "MAN" "mom" "MOM" "ms" "MS" "tmac" "TMAC" "mm" "MM" "me" "ME" "rst" "RST")
          "Dired Markup files extensions")
  (dired-rainbow-define markup "#00ff99" dired-markup-files-extensions)

  (defconst dired-office-files-extensions
          '("doc" "DOC" "docx" "DOCX" "odt" "ODT" "mps" "MPS" "ott" "OTT" "abw" "ABW" "wps" "WPS" "lwp" "LWP" "xy3" "XY3" "xyp" "XYP" "xyw" "XYW" "wpa" "WPA" "wpd" "WPD" "lp2" "LP2" "gdoc" "GDOC" "pdb" "PDB" "ods" "ODS")
          "Dired Office files extensions")
  (dired-rainbow-define office "#00ff99" dired-office-files-extensions)

  (defconst dired-disk-image-extensions
          '("vdi" "VDI" "vmdk" "VMDK" "vhd" "VHD" "hdd" "HDD" "qcow" "QCOW" "qed" "QED" "sav" "SAV")
          "Dired Disk-Image files extensions")
  (dired-rainbow-define disk-image "#00ff99" dired-disk-image-extensions)

  ;; ;; this is for emulation files, but I want to make a system for game image files, save file, and module files. That's going to take a while because I don't have a large archive on hand
  ;; (defconst dired-emulation-files-extensions
  ;;         '("mbz" "tap" "smd" "gba" "smc" "nes" "z64" "dms" "pie" "nds" "g64" "n64" "ggs" "dat" "dgz" "gcz" "gb" "pp" "fig" "atr" "st" "s19" "ups" "ttp" "mdr" "tzx" "m64" "chd" "pj" "snap" "gbc" "d64" "zx" "sfc" "68k" "v64" "fdi" "df7" "zs2" )
  ;;         "Dired Emulation files extensions")
  ;; (dired-rainbow-define emulation "#00ff99" dired-emulation-files-extensions)

  (dired-rainbow-define firmware "#00ff99" ("rom" "ROM" "efi" "EFI" "fw" "FW" "vxd" "VXD" "cgz" "CGZ" "vga" "VGA" "dev" "DEV" "rmt" "RMT" "mi4" "MI4" "rfw" "RFW" "sbn" "SBN" "bin" "BIN" "ipod" "IPOD" "scap" "SCAP" "chk" "CHK" "firm" "FIRM" "ta" "TA" "drv" "DRV"))

  (dired-rainbow-define image "#ff4b4b" ("jpg" "png" "jpeg" "gif" "jpeg" "bmp" "webp"))
  (dired-rainbow-define disk "#ff4b4b" ("iso" "ISO" "img" "IMG" "image" "IMAGE"))
  (dired-rainbow-define sourcefile "#3F82FD" ("el" "groovy" "gradle" "py" "c" "cc" "h" "java" "pl" "rb"))
  (dired-rainbow-define package "#3F82FD" ("msi" "MSI" "apk" "APK" "deb" "DEB" "rpm" "RPM"))
  (dired-rainbow-define html "#4e9a06" ("htm" "html" "xhtml"))
  (dired-rainbow-define xml "DarkGreen" ("xml" "xsd" "xsl" "xslt" "wsdl"))
  (dired-rainbow-define book "LightBlue" ("mobi" "epub" "azw" "azw3" "iba" "pdf" "PDF" "djvu" "DJVU" "LRS" "lrs" "inf" "prc" "opf" "cbr" "cbz" "cb7" "cbt" "cba"))
  (dired-rainbow-define encrypted "LightBlue" ("gpg" "pgp" "kdbx" "pub"))
  (dired-rainbow-define checksum "LightBlue" ("md5" "MD5" "sha256" "sha512" "crc" "sfv" "SFV" "sha1"))
  (dired-rainbow-define org "LightBlue" ("org"))
  (dired-rainbow-define file-manager "LightBlue" ("directory"))


  (dired-rainbow-define-chmod executable-unix "Green" "-.*x.*")

  (dired-rainbow-define log (:inherit default :italic t) ".*\\.log"))



;; ranger-like dired package
(use-package dired-ranger
  :after dired-hacks-utils
  :ensure t
  :init)

;; allows subtrees to be opened instead of the default open a new buffer
(use-package dired-subtree
  :after dired-hacks-utils
  :ensure t
  :init
  :bind (:map dired-mode-map
            ("i" . dired-subtree-insert)
            (";" . dired-subtree-remove)
            ("<tab>" . dired-subtree-toggle)
            ("<backtab>" . dired-subtree-cycle)))

;; allows nested files to appear w/ path to folder activated in
(use-package dired-collapse
  :after dired-hacks-utils
  :ensure t
  :init)

;; filters whatever you're looking for live
(use-package dired-narrow
  :after dired-hacks-utils
  :ensure t
  :init)

;; TO INSTALL ON SYSTEM, USE 'm-x all-the-icons-install-fonts', this is a font package for neo-tree
(when (eq system-type 'gnu/linux)
  (use-package all-the-icons
    :ensure t))

;; makes all-the-icons work for dired
(when (eq system-type 'gnu/linux)
  (use-package all-the-icons-dired
    :after all-the-icons
    :ensure t
    :init
    (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)))

;; add emoji support to all modes
(use-package emojify
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-emojify-mode))

;; Projectile
(use-package projectile
  :ensure t
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode 1))

;; a nice nerd-tree substitute
(use-package neo-tree
  :disabled ;; I find dired && buffers to be a much more extensible system, feel free to turn on
  :ensure t
  :init
  (setq neo-window-fixed-size t)
  (neo-window-width 30)
  ;; NeoTree can't afford the space lost w/ line numbering, so it is disabled
  (add-hook 'neo-after-create-hook (lambda (&optional dummy) (display-line-numbers-mode -1)))
  (setq neo-theme 'icons)
  (setq-default neo-show-hidden-files t)
  :bind
  ("[f8]" . neotree-toggle))

;; quickly move frames
(use-package transpose-frame
  :ensure t
  :bind
  ("C-x 4" . transpose-frame)
  ("C-x 6" . rotate-frame-clockwise)
  ("C-x 7" . flip-frame)
  ("C-x 9" . flop-frame)) ;; left out 8 because its used for inserting ANSI characters

;; allows virtual workspaces not unlike most operating systems
(use-package eyebrowse
  :ensure t
  :init
  (eyebrowse-mode t)
  (setq eyebrowse-new-workspace t)
  :bind
  ("M-1" . eyebrowse-switch-to-window-config-1)
  ("M-2" . eyebrowse-switch-to-window-config-2)
  ("M-3" . eyebrowse-switch-to-window-config-3)
  ("M-4" . eyebrowse-switch-to-window-config-4)
  ("M-5" . eyebrowse-switch-to-window-config-5))

;; ;; move screen without having to reach the limits of the display. A built-in less smooth way is in my config under GENERAL if you prefer, just ':disabled' it
(use-package smooth-scrolling
  :ensure t
  :init
  (smooth-scrolling-mode 1))

;; ;; while smooth scrolling is on this value will be overwritten. This is the default way to 'smooth' scroll in emacs. I leave it on for packages that don't work with it (so far only nov mode for reading epub)
(setq-default scroll-margin 10)

(use-package rainbow-mode
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'rainbow-mode)
  (add-hook 'text-mode-hook 'rainbow-mode))

;; each layer of delimiters '{' '[' '(' has a different color. The initial theme sucks for HC-Zenburn so I changed it. One can change my edits in 'm-x customize-mode' and searching 'rainbow'
(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'text-mode-hook 'rainbow-delimiters-mode)
  (custom-set-faces
   '(rainbow-delimiters-depth-1-face ((t (:foreground "pale turquoise"))))
   '(rainbow-delimiters-depth-2-face ((t (:foreground "spring green"))))
   '(rainbow-delimiters-depth-3-face ((t (:foreground "gold"))))
   '(rainbow-delimiters-depth-4-face ((t (:foreground "violet"))))
   '(rainbow-delimiters-depth-5-face ((t (:foreground "deep sky blue"))))
   '(rainbow-delimiters-depth-6-face ((t (:foreground "green yellow"))))
   '(rainbow-delimiters-depth-7-face ((t (:foreground "DarkOrange3"))))
   '(rainbow-delimiters-depth-8-face ((t (:foreground "CadetBlue3"))))
   '(rainbow-delimiters-depth-9-face ((t (:foreground "yellow3"))))
   '(rainbow-delimiters-unmatched-face ((t (:inherit rainbow-delimiters-base-face :foreground "orange red"))))))

(use-package emojify
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-emojify-mode))

;; allows copy and paste structures depending on mode and populate variables quickly
(use-package yasnippet
  :ensure t
  :diminish
  :init
  (yas-global-mode 1)
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  ; load latex snippets into org-mode
  (defun my-org-latex-yas ()
    "Activate org and LaTeX yas expansion in org-mode buffers."
    (yas-minor-mode)
    (yas-activate-extra-mode 'latex-mode))
  (add-hook 'org-mode-hook #'my-org-latex-yas)
  :bind
  ("C-c y" . yas-insert-snippet))

;; replacement for normal minibuffer searching, instead lists all options and you start dwindling down options based on what you type instead of tabbing. I find this useful because it remembers your most recent actions and helps you find commands you kind of remember
(use-package helm
  :ensure t
  :init
  (require 'helm-config)
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("C-x r b" . helm-filtered-bookmarks))

;; fuzzy finder extension to helm
(use-package helm-flx
  :ensure t
  :init
  (setq helm-flx-for-helm-find-files t)
  (setq helm-flx-for-helm-locate t)
  (helm-flx-mode 1))

;; org fuzzy finder for all text inside specified folder
(use-package helm-org-rifle
  :ensure t
  :init
  (setq helm-org-rifle-show-path t)
  :bind
  ("C-c f" . helm-org-rifle-org-directory))
;; extensible interactive mode. I like using this for searching my active buffers instead of fuzzy searching
(use-package ido
  :ensure t
  :init
  (setq ido-separator "\n")
  (ido-mode 1))

;; so-long mode, it's built-in on emacs 27, but as of 20191107 you can't download from ELPA and load in manually if on lower version. You can save this page as so-long.el and put in loading path https://git.savannah.nongnu.org/cgit/so-long.git/plain/so-long.el
(use-package so-long
  :load-path "~/.emacs.d/lisp/so-long/"
  :init
  ;; (global-so-long-mode 1)
  ;; use this if below emacs 27 to speedup debugging EDIT APPEARS TO NOT WORK AND MESSES UP INIT
  ;; (add-hook 'debugger-mode-hook 'so-long-minor-mode)
  ;; ;; use this if on emacs 27 to speedup debugging
  ;; (add-hook 'backtrace-mode-hook 'so-long-minor-mode)
  )

;; rss reader for emacs
(use-package elfeed
  :ensure t
  :init
  ;; update elfeed on initial launch and updates every 3 hours. Adjust to however you want. NOTE! emacs uses seconds as the variable place, do look at emacs 'timers' documentation for more options or exact timings
  (add-hook 'elfeed-search-mode-hook (lambda () (run-at-time 0 (* 60 60 6) 'elfeed-update)))
  ;; update every
  ;; ambrevar's open in MPV script
  (defun elfeed-play-with-mpv ()
    "Play entry link with mpv."
    (interactive)
    (let ((entry (if (eq major-mode 'elfeed-show-mode) elfeed-show-entry (elfeed-search-selected :single)))
          (quality-arg "")
          (quality-val (completing-read "Max height resolution (0 for unlimited): " '("0" "480" "720") nil nil)))
      (setq quality-val (string-to-number quality-val))
      (message "Opening %s with height≤%s with mpv..." (elfeed-entry-link entry) quality-val)
      (when (< 0 quality-val)
        (setq quality-arg (format "--ytdl-format=[height<=?%s]" quality-val)))
      (start-process "elfeed-mpv" nil "mpv" quality-arg (elfeed-entry-link entry))))

  ;; ambrevar's open in MPVNET script
  (defun elfeed-play-with-mpvnet ()
    "Play entry link with mpvnet."
    (interactive)
    (let ((entry (if (eq major-mode 'elfeed-show-mode) elfeed-show-entry (elfeed-search-selected :single)))
          (quality-arg "")
          (quality-val (completing-read "Max height resolution (0 for unlimited): " '("0" "480" "720") nil nil)))
      (setq quality-val (string-to-number quality-val))
      (message "Opening %s with height≤%s with mpvnet..." (elfeed-entry-link entry) quality-val)
      (when (< 0 quality-val)
        (setq quality-arg (format "--ytdl-format=[height<=?%s]" quality-val)))
      (start-process "elfeed-mpvnet" nil "mpvnet.exe" quality-arg (elfeed-entry-link entry))))

  :bind (("C-c e" . elfeed)
	 :map elfeed-search-mode-map
	 ("C-c v" . elfeed-play-with-mpv)
	 ("C-c V" . elfeed-play-with-mpvnet)))

;; skeeto's youtube-dl download manager, you will need to download it from https://github.com/skeeto/youtube-dl-emacs. BY DEFAULT you will need to launch 'youtube-dl-list' for the download manager to become active. Since its a major mode and not a normal global mode, I hacked around it as seen in my addition
(use-package youtube-dl
  :load-path "~/.emacs.d/lisp/youtube-dl-emacs/"
  :init
  (setq youtube-dl-directory "~/lan-youtube/")

  (defun elfeed-show-youtube-dl ()
    "Download the current entry with youtube-dl."
    (interactive)
    (pop-to-buffer (youtube-dl (elfeed-entry-link elfeed-show-entry))))

  (cl-defun elfeed-search-youtube-dl (&key slow)
    "Download the current entry with youtube-dl."
    (interactive)
    (let ((entries (elfeed-search-selected)))
      (dolist (entry entries)
        (if (null (youtube-dl (elfeed-entry-link entry)
                              :title (elfeed-entry-title entry)
                              :slow slow))
            (message "Entry is not a YouTube link!")
          (message "Downloading %s" (elfeed-entry-title entry)))
        (elfeed-untag entry 'unread)
        (elfeed-search-update-entry entry)
	(unless (use-region-p) (forward-line)))))

  ;; ADDITION when opening elfeed, it launches youtube-dl-list which enables downloading, and promptly closes it (since it auto-windows and focuses)
  (defun elfeed-youtube-dl-autolaunch ()
    (interactive)
    (youtube-dl-list)
    (delete-window))
  (add-hook 'elfeed-search-mode-hook 'elfeed-youtube-dl-autolaunch)
  :bind
  ("C-c d" . elfeed-search-youtube-dl) ;; this download entries on elfeed
  ("C-c L" . youtube-dl-list) ;; this opens your manager
  ("C-c D" . (lambda () (interactive) (dired "~/lan-youtube/")))) ;; this is a quick bookmark to the downloads folder, use 'W' to open in default player

;; allows two major modes, which is needed for working with rmd/rmarkdown files. One needs to run markdown && ESS at the same time so quality of life quick editing and compiling to xyz work in tandem
(use-package polymode
  :diminish
  :ensure t)

;; R support
(use-package ess
  :diminish
  :ensure t)

;; polymode R support
(use-package poly-R
  :diminish
  :ensure t)

;; markdown support
(use-package markdown-mode
  :diminish
  :ensure t)

;; polymode markdown support
(use-package poly-markdown
  :diminish
  :ensure t)

;; latex support
(use-package auctex
  :defer t ;; for some reason auctex breaks emacs if you don't force a lazy-load.
  :ensure t
  :init
  ;; Use pdf-tools to open PDF files
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-source-correlate-start-server t)
  ;; Update PDF buffers after successful LaTeX runs
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer)
  (setq TeX-save-query nil))

;; view large files, emacs has glaring issues with dealing with large files and this mode fixes it when analyzing it
(use-package vlf
  :ensure t)

;; media streaming frontend for emacs that includes standalone players, mpd support, audio livestreaming, tag management, and more
(use-package emms
  :ensure t
  :init
  (require 'emms-setup)
  (emms-standard)
  (emms-default-players)
  ;; emms music browsing directory
  (setq emms-source-file-default-directory "~/arc-music/music-library/")
  ;; emms streaming backend set to MPV
  (require 'emms-stream-info)
  (setq emms-stream-info-backend 'mpv))

;; allows for vim-like undo/redo as well as saving for cross-session use, dependency for evil. Has issue w/ unsigned package and needs fix listed up top, apparently new versions of emacs solve this but its broken on 26.1
(use-package undo-tree
  :ensure t
  :diminish ;; shows up as 'Undo-Tree' in modeline. Calling ':diminish <name of mode(s)>' will hide it
  :init
  (setq undo-tree-auto-save-history t) ;; basic option format, 'M-x customize-mode' is a GUI version of this. t for true, nil for false
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (global-undo-tree-mode 1));; actually starts undo-tree. All emacs programs are started this way as "modes". Some are automatically smart enough to start, but most you'll have to call like this. Later on

;; vim-like keys main package, requires modular pieces to really feel like vim
(use-package evil
  :after undo-tree ;; allows a chain of programs to be skipped if one isn't downloaded or lazy loaded, or if a certain config needs to be overwritten
  :ensure t
  :init
  (setq evil-want-integration t) ;; Optional b/c default, these 2 lines are for evil-collection integration w/ use-package
  (setq evil-want-keybinding nil)
  (setq-default evil-cross-lines t)
  (setq evil-scroll-count 8)
  :bind (:map evil-normal-state-map
	      ("SPC" . evil-toggle-fold)
	      ("J" . evil-scroll-down)
	      ("K" . evil-scroll-up)
	      ("C-t" . flyspell-buffer)
	      ("C-f" . endless/ispell-word-then-abbrev)
	      ("H" . evil-backward-paragraph)
	      ("L" . evil-forward-paragraph)
	      ("C-n" . nil) ;; messes w/ my dired-create-directory bind
	 :map evil-insert-state-map
	      ("C-t" . flyspell-buffer)
	      ("C-f" . endless/ispell-word-then-abbrev))
  :config ;; used to configure a program after its loaded. There is no difference between config/init for normally started programs like this, but for autoloaded/lazyloaded programs this will configure AFTER its loaded
  (evil-mode 1))

;; allows vim-like keys for most major programs
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; evil-surround, allows words to be surrounded with motions w/ w/e, like 'word' to '<em>word</em>', as well as paragraphs/blocks
(use-package evil-surround
  :ensure t
  :init
  (setq-default evil-surround-pairs-alist
   (quote
    ((40 "( " . " )")
     (91 "[ " . " ]")
     (123 "{ " . " }")
     (41 "(" . ")")
     (93 "[" . "]")
     (125 "{" . "}")
     (35 "#{" . "}")
     (115 "#+BEGIN_SRC" . "#+END_SRC")
     (66 "{" . "}")
     (59 ";" . ";")
     (39 "'" . "'")
     (62 "<" . ">")
     (116 . evil-surround-read-tag)
     (60 . evil-surround-read-tag)
     (102 . evil-surround-function))))
  :config
  (global-evil-surround-mode 1))

;; evil-visualstar, search specific visual selection forward / backwards w/ * && #
(use-package evil-visualstar
  :ensure t
  :after evil
  :init
  (global-evil-visualstar-mode 1)
  (setq evil-visualstar/persistent t))

;; evil-exchange, exchange two motions with each other w/ gx (or cancel w/ gX)
(use-package evil-exchange
  :ensure t
  :after evil
  :init
  (evil-exchange-install))

;; evil-commentary, comments whatever element w/ gc<motion>
(use-package evil-commentary
  :ensure t
  :after evil
  :diminish ;; shows up as 's-/' normally
  :config
  (evil-commentary-mode 1))

;; evil-org package. used over org-evil package b/c no dependencies and not made by a brony lol
(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; allows kj/jk to escape instead of bad-ergo 'C-[' / 'Esc'
(use-package evil-escape
  :after evil
  :ensure t
  :diminish ;; show as 'jk'
  :init
  :config
  (setq evil-escape-key-sequence "jk")
  (setq evil-escape-unordered-key-sequence "true")
  (evil-escape-mode 1))

;; replaces default vim 'f' behavior w/ a more powerful 2 character search
(use-package evil-snipe
  ;;:disabled
  :after evil
  :ensure t
  :init
  ;; these show all possible options in buffer and ignore case, you might need to change depending on size of files working with
  (setq evil-snipe-auto-scroll nil)
  (setq evil-snipe-repeat-scope (quote whole-buffer))
  (setq evil-snipe-scope (quote whole-buffer))
  (setq evil-snipe-smart-case t)
  ;; It seems evil-snipe-override-mode causes problems in Magit buffers, to fix this:
  (add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode)
  ;; I like to rebind f to function as evil-snipe, although S still works. It can't cycle w/ f/F, but ;/, && s/S still work
  :bind (:map evil-normal-state-map
         ("f" . evil-snipe-s)
	 ("F" . evil-snipe-S)
	 :map evil-operator-state-map
	 ("f" . evil-snipe-s)
	 ("F" . evil-snipe-S)
	 ("x" . nil)
	 ("X" . nil)
	 :map evil-motion-state-map
	 ("f" . evil-snipe-s)
	 ("F" . evil-snipe-S)
	 ("t" . nil)
	 ("T" . nil))
  :config
  (evil-snipe-mode 1)
  (evil-snipe-override-mode 1))

;; evil-lion, alligns test elements w/ gl or gL
(use-package evil-lion
  :after evil
  :ensure t
  :bind (:map evil-normal-state-map
         ("g l " . evil-lion-left)
         ("g L " . evil-lion-right)
         :map evil-visual-state-map
         ("g l " . evil-lion-left)
         ("g L " . evil-lion-right)))

;; NOTE! YOU MUST MANUALLY INSTALL THIS PROGRAM FROM 'list-package', ':ensure t' IS BROKEN AS IT ONLY DOWNLOADS ONE FILE INSTEAD OF ALL OF THEM AS OF 26.1 2019-10-11 ON DEBIAN
;; program that mimics % for more than just delimitters
(use-package evil-matchit
  :after evil
  :init
  ;; I like to assign these to t, because evil-snipe already does everything i want for f/t && % is tricky to reach
  (setq evilmi-shortcut "t")
  ;; small fix to allow motions to work
  :bind (:map evil-motion-state-map
	     ("t" . evilmi-jump-items))
  :config
  (global-evil-matchit-mode 1))

;; powerful PDF tool for viewing and editing PDF that replaces the built in viewer
;; YOU NEED TO INSTALL YOUR OS'S VERSION OF PDFTOOLS FOLLOWING THE GITHUB PAGE https://github.com/politza/pdf-tools
(use-package pdf-tools
  :ensure t
  :init
  ;; make sure pdftools is installed for emacs
  (add-hook 'doc-view-mode-hook 'pdf-tools-install)
  ;; set midnight color theme
  (setq pdf-view-midnight-colors (quote ("ivory" . "gray20")))
  (setq midnight-mode t)
  (add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode)
  ;; kill blinking cursor problem highlighting PDF
  (evil-set-initial-state 'pdf-view-mode 'emacs)
  (add-hook 'pdf-view-mode-hook
    (lambda ()
      (set (make-local-variable 'blink-cursor-mode) (list nil))))
  ;; revert focus back to code when compiling
  (defadvice TeX-command-run-all (after jump-back activate)
    (other-window 1))
  ;; disable cursor from being around PDFtools in emacs 27
  (add-hook 'pdf-view-mode-hook
    (lambda ()
      (set (make-local-variable 'evil-evilified-state-cursor) (list nil))))
  ;; disable cursor in pdf-view
  (add-hook 'pdf-view-mode-hook
    (lambda ()
      (set (make-local-variable 'evil-normal-state-cursor) (list nil)))))

;; epub reader for emacs, you could already read epub by finding the contents xhtml, but this is a prettier package. You'll need an unzip program in your path and emacs compiled w/ libxml2 support
(use-package nov
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  ;; ;; the below text was causing buffers to move around wildly when launching m-x and eval-buffer. Instead use the alternative I'm using
  ;;   (setq nov-text-width t)
  ;;   (setq visual-fill-column-center-text t)
  ;;   (add-hook 'nov-mode-hook 'visual-line-mode)
  ;;   (add-hook 'nov-mode-hook 'visual-fill-column-mode))
  (setq nov-text-width 80)
  ;; ;; NOTE! Smooth-scrolling only works going up the file, so I have scroll-margin set to ten and enabled. It'll be choppy but usable
  )

;; sublime-like scrolling, minimap, and decorations. Of this package I find useful is the
(use-package sublimity
  ;;:disabled
  :ensure t
  :init
  ;; ;; scroll package, at end of buffer it will smooth scroll. I didn't like it EXCEPT for large JK movement, as it smoothly scrolled. However, this is negated by its strange global movement behavior of freaking out
  ;; (require 'sublimity-scroll)
  ;; (setq sublimity-scroll-weight 10
  ;;     sublimity-scroll-drift-length 20)
  (require 'sublimity-attractive)
  (setq sublimity-attractive-centering-width nil)
  ;; ;; the map is really buggy and slows down my computer, although its really cool
  ;;(require 'sublimity-map)
  ;; ;; if you really want to try the minimap, uncomment these lines. Do note that its really laggy, you'll want to make it to pop up instead of persistently hang
  ;;(require 'sublimity-map)
  ;;(setq sublimity-map-size 20)
  ;;(setq sublimity-map-fraction 0.3)
  ;;(setq sublimity-map-text-scale -7)
  ;;(add-hook 'sublimity-map-setup-hook
    ;;(lambda ()
      ;;(setq buffer-face-mode-face '(:family "Monospace"))
      ;;(buffer-face-mode)))
  ;;(remove-hook sublimity--pre-command-functions 'sublimity-map--delete-window) ;; Do not delete minimap on "pre-command-hook"
  ;; ;; Add the deletion of the minimap to the "post-command-hook" (Important: this places it *before* the other command in there which should be sublimity-map-show)
  ;;(add-hook 'sublimity--post-command-functions 'sublimity-map--delete-window)
  ;;(sublimity-map-set-delay nil)
  ;;(sublimity-mode 1)
  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elfeed-feeds
   '("http://www.youtube.com/feeds/videos.xml?channel_id=UCNqFXwI5gNcyxt2c1zTQAKw" "http://www.youtube.com/feeds/videos.xml?channel_id=UClq42foiSgl7sSpLupnugGA" "http://www.youtube.com/feeds/videos.xml?channel_id=UC4BZtFgtCuHUt0p8J-XENiA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCi7gbnBGIxB6k0K8Bgdt8nA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCEfFUaIkjbI06PhALdcXNVA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCfGXUYprWpc26VK2KgzD40A" "http://www.youtube.com/feeds/videos.xml?channel_id=UCx0ZQDIzJGUhmL4Wlq3q7XA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCcck1Zdvdt5aML_O32Y_Adg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCSqyKubmwPrg3ZayK8KE-kA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCNXvxXpDJXp-mZu3pFMzYHQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCvwpfEaOOnn4beRGXvLpNRg" "http://www.youtube.com/feeds/videos.xml?channel_id=UC4xKdmAXFh4ACyhpiQ_3qBw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCgIlmfJhLLBwTYvL4r-2hhg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCv2LNRhF34_v1VNC08ZuooA" "http://www.youtube.com/feeds/videos.xml?channel_id=UClRwC5Vc8HrB6vGx6Ti-lhA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCy0tKL1T7wFoYcxCe0xjN6Q" "http://www.youtube.com/feeds/videos.xml?channel_id=UClIFqsmxnwVNNlsvjH1D1Aw" "http://www.youtube.com/feeds/videos.xml?channel_id=UC5SuCSt-r84nspgm_rA8k9Q" "http://www.youtube.com/feeds/videos.xml?channel_id=UC7eWRnOTyqua812sDXGqiqw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCNTqu16j3F6RbtHZI-3untg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCDPujMbho9Nq-iB7aTJsMUQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCnq1w-56tAvMdDup-CL6Vtg" "http://www.youtube.com/feeds/videos.xml?channel_id=UC-f76NUQN5M-Z0cd0MOP5xw" "http://www.youtube.com/feeds/videos.xml?channel_id=UC9_z6CkrSkNbjqp8S7mn2bw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCDKJdFer1phQI95UinPZehw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCKTehwyGCKF-b2wo0RKwrcg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCtM5z2gkrGRuWd0JQMx76qA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCnkp4xDOwqqJD7sSM3xdUiQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCd6EFsVsqGhASiz6g1KifUQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCI8iQa1hv7oV_Z8D35vVuSg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCef0TWni8ghLcJphdmDBoxw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCsojCyeOSuw4Odm6MyBXLmg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCVGo3S_AANY-UQdJ6VLwGXw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCYO_jab_esuFRV4b17AJtAw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCbxQcz9k0NRRuy0ukgQTDQQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UC2DjFE7Xf11URZqWBigcVOQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UChBJtu4BhT8b8t9Qe9R-EZg" "http://www.youtube.com/feeds/videos.xml?channel_id=UC5I2hjZYiW9gZPVkvzM8_Cw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCDkJEEIifDzR_2K2p9tnwYQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCvrLvII5oxSWEMEkszrxXEA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCT5y7BAocgM-PeXpVCvyG4g" "http://www.youtube.com/feeds/videos.xml?channel_id=UCUQo7nzH1sXVpzL92VesANw" "http://www.youtube.com/feeds/videos.xml?channel_id=UC1IQIspOkCeV3WnYm32SBFQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCLEoyoOKZK0idGqSc6Pi23w" "http://www.youtube.com/feeds/videos.xml?channel_id=UCnbvPS_rXp4PC21PG2k1UVg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCoxcjq-8xIDTYp3uz647V5A" "http://www.youtube.com/feeds/videos.xml?channel_id=UC3jdnIP2u5hCJpVZ-TuDrCg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCVik6mzTCurdJmvdj5dCa7A" "http://www.youtube.com/feeds/videos.xml?channel_id=UCbiGcwDWZjz05njNPrJU7jA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCcAy1o8VUCkdowxRYbc0XRw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCcTt3O4_IW5gnA0c58eXshg" "http://www.youtube.com/feeds/videos.xml?channel_id=UC3bosUr3WlKYm4sBaLs-Adw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCkf4VIqu3Acnfzuk3kRIFwA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCTSRIY3GLFYIpkR2QwyeklA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCb4RFFBZEztOW77onViqoDA" "http://www.youtube.com/feeds/videos.xml?channel_id=UC7Ucs42FZy3uYzjrqzOIHsw" "http://www.youtube.com/feeds/videos.xml?channel_id=UC8uT9cgJorJPWu7ITLGo9Ww" "http://www.youtube.com/feeds/videos.xml?channel_id=UCBNG0osIBAprVcZZ3ic84vw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCVo63lbKHjC04KqYhwSZ_Pg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCUkRj4qoT1bsWpE_C8lZYoQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UC4nJnJ-HO5vVbGlJ14rf5yg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCMmA0XxraDP7ZVbv4eY3Omg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCW6J17hZ_Vgr6cQgd_kHt5A" "http://www.youtube.com/feeds/videos.xml?channel_id=UCYZtp0YIxYOipX15v_h_jnA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCtUbO6rBht0daVIOGML3c8w" "http://www.youtube.com/feeds/videos.xml?channel_id=UCE1jXbVAGJQEORz9nZqb5bQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCLx053rWZxCiYWsBETgdKrQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCMTk_R_Y49jvq-HQXDmKI0Q" "http://www.youtube.com/feeds/videos.xml?channel_id=UCO8DQrSp5yEP937qNqTooOw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCD6VugMZKRhSyzWEWA9W2fg" "http://www.youtube.com/feeds/videos.xml?channel_id=UC8Q7XEy86Q7T-3kNpNjYgwA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCJ6q9Ie29ajGqKApbLqfBOg" "http://www.youtube.com/feeds/videos.xml?channel_id=UClcE-kVhqyiHCcjYwcpfj9w" "http://www.youtube.com/feeds/videos.xml?channel_id=UC0ZTPkdxlAKf-V33tqXwi3Q" "http://www.youtube.com/feeds/videos.xml?channel_id=UCO51Z4c1R8EPHZioGwgBmDw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCq6VFHwMzcMXbuKyG7SQYIg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCSdma21fnJzgmPodhC9SJ3g" "http://www.youtube.com/feeds/videos.xml?channel_id=UCQMyhrt92_8XM0KgZH6VnRg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCBa659QWEk1AI4Tg--mrJ2A" "http://www.youtube.com/feeds/videos.xml?channel_id=UCi_7cmJQ_Fsk3j2hAUruGBg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCIyZiiHXIH7KkqfaDvBmG-Q" "http://www.youtube.com/feeds/videos.xml?channel_id=UCd0ZD4iCXRXf18p3cA7EQfg" "http://www.youtube.com/feeds/videos.xml?channel_id=UC3s0BtrBJpwNDaflRSoiieQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCEKJKJ3FO-9SFv5x5BzyxhQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCXa6sE6cKXcQ97vI0Emn1XA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCqbkm47qBxDj-P3lI9voIAw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCK09g6gYGMvU-0x1VCF1hgA" "http://www.youtube.com/feeds/videos.xml?channel_id=UC2eYFnH61tmytImy1mTYvhA" "http://www.youtube.com/feeds/videos.xml?channel_id=UC9Tn-atYOt8qZP-oqui7bhw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCsvn_Po0SmunchJYOWpOxMg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCgrLKsyPcIYRA0sPwEK7p2w" "http://www.youtube.com/feeds/videos.xml?channel_id=UC2h0XzEzrlOpzu-Tvk5J4lA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCRlICXvO4XR4HMeEB9JjDlA" "http://www.youtube.com/feeds/videos.xml?channel_id=UC9-y-6csu5WGm29I7JiwpnA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCGJq0eQZoFSwgcqgxIE9MHw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCntBLn2xskJWKqMV40BqKJA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCo1pShh6dtg-T_ZZkgi_JDQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCl2mFZoRqjw_ELax4Yisf6w" "http://www.youtube.com/feeds/videos.xml?channel_id=UCJ31aJo8U-ZaRnZ4Y27so_Q" "http://www.youtube.com/feeds/videos.xml?channel_id=UCF-Khq6jc5yo-QHKPMZe5dQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCMIj-wEiKIcGAcLoBO2ciQQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UC-Q4WBqNtMF_2GbIsGjic4A" "http://www.youtube.com/feeds/videos.xml?channel_id=UClzNJ7y2Q6wY0tEOzE6EM9Q" "http://www.youtube.com/feeds/videos.xml?channel_id=UC64UiPJwM_e9AqAd7RiD7JA" "http://www.youtube.com/feeds/videos.xml?channel_id=UC0vBXGSyV14uvJ4hECDOl0Q" "http://www.youtube.com/feeds/videos.xml?channel_id=UCWMybbiNZwNOhCXEzROahtw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCtGoikgbxP4F3rgI9PldI9g" "http://www.youtube.com/feeds/videos.xml?channel_id=UCYDnJiF0_RqSjkjvjRbG1tA" "http://www.youtube.com/feeds/videos.xml?channel_id=UC42c56Y49_Tqxluk2PLpmyg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCrTNhL_yO3tPTdQ5XgmmWjA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCN3Jj2sU9LNFQplsjsdxdrw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCSlFKVc8tufJ6gSzxk7v4vQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCFg9-S0cfu3UvBYuSNFT9hQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCfYbb7nga6-icsFWWgS-kWw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCBJycsmduvYEL83R_U4JriQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCXuqSBlHAE6Xw-yeJA0Tunw" "http://www.youtube.com/feeds/videos.xml?channel_id=UC4w1YQAJMWOz4qtxinq55LQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCOWcZ6Wicl-1N34H0zZe38w" "http://www.youtube.com/feeds/videos.xml?channel_id=UCJVdNvvuvOnthuWVQjYff2w" "http://www.youtube.com/feeds/videos.xml?channel_id=UC2_KC8lshtCyiLApy27raYw" "http://www.youtube.com/feeds/videos.xml?channel_id=UCdJdEguB1F1CiYe7OEi3SBg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCR1D15p_vdP3HkrH8wgjQRw" "http://www.youtube.com/feeds/videos.xml?channel_id=UC-tsNNJ3yIW98MtPH6PWFAQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UC4USoIAL9qcsx5nCZV_QRnA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCAgoEUwn-LQy0fTyUxMngag" "http://www.youtube.com/feeds/videos.xml?channel_id=UCggHoXaj8BQHIiPmOxezeWA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCZzR7tqZKAXWT8uOi-RHuVA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCimiUgDLbi6P17BdaCZpVbg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCOZfpWD7SM5t1Mmk0_aJdfw" "http://www.youtube.com/feeds/videos.xml?channel_id=UC9PBzalIcEQCsiIkq36PyUA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCVYamHliCI9rw1tHR1xbkfw" "http://www.youtube.com/feeds/videos.xml?channel_id=UC455p7ts9lh8IWi5zuf_8tQ" "http://www.youtube.com/feeds/videos.xml?channel_id=UCNoWYv_t2w2_MSf5hJ9_ZXg" "http://www.youtube.com/feeds/videos.xml?channel_id=UCT7njg__VOy3n-SvXemDHvg" "http://www.youtube.com/feeds/videos.xml?channel_id=UC4QZ_LsYcvcq7qOsOhpAX4A" "http://www.youtube.com/feeds/videos.xml?channel_id=UCJ1DXJuVkrvdeCCJ87Bci3g" "http://www.youtube.com/feeds/videos.xml?channel_id=UC2C_jShtL725hvbm1arSV9w" "http://www.youtube.com/feeds/videos.xml?channel_id=UCU3oAyhHDXjgbxazqOEG2UA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCXGgrKt94gR6lmN4aN3mYTg" "http://www.youtube.com/feeds/videos.xml?channel_id=UC9kMnSZQd53hE-1sb1f9sdA" "http://www.youtube.com/feeds/videos.xml?channel_id=UCGLKDeQf13NtSbx-49fHq4g"))
 '(fringe ((t (:background "gray19" :foreground "#DCDCCC"))))
 '(helm-minibuffer-history-key "M-p")
 '(line-number-mode nil)
 '(package-selected-packages
   '(rainbow-mode emojify workgroups2 powershell yasnippet vlf visual-fill-column use-package transpose-frame sublimity smooth-scrolling rainbow-delimiters projectile poly-R pdf-tools nov helm-org-rifle helm-flx hc-zenburn-theme eyebrowse evil-visualstar evil-surround evil-snipe evil-org evil-matchit evil-lion evil-exchange evil-escape evil-commentary evil-collection ess emms elfeed djvu dired-subtree dired-ranger dired-rainbow dired-narrow dired-collapse diminish auctex all-the-icons-dired))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "pale turquoise"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "spring green"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "gold"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "violet"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "green yellow"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "DarkOrange3"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "CadetBlue3"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "yellow3"))))
 '(rainbow-delimiters-unmatched-face
   ((t
     (:inherit rainbow-delimiters-base-face :foreground "orange red")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fringe ((t (:background "gray19" :foreground "#DCDCCC"))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "pale turquoise"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "spring green"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "gold"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "violet"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "green yellow"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "DarkOrange3"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "CadetBlue3"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "yellow3"))))
 '(rainbow-delimiters-unmatched-face ((t (:inherit rainbow-delimiters-base-face :foreground "orange red")))))
