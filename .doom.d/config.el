;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Gergely Attila Halacsy"
      user-mail-address "gergely.halacsy@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;;(setq doom-font (font-spec :family "Mononoki Nerd Font Mono" :size 15))
;;(setq doom-font (font-spec :family "Fira Mono" :size 15))
;;(unless (find-font doom-font)
  ;;(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 15)))
;;(setq doom-font (font-spec :family "Iosevka" :size 16))
; (setq doom-font (font-spec :family "InputMonoCompressed Medium" :size 19))
;;(setq doom-variable-pitch-font (font-spec :family "Libre Baskerville" :size 14))
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)


;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;;
(setq projectile-project-search-path '("~/work" "~/Documents"))
(setq explicit-shell-file-name "/bin/bash")
(setq shell-file-name "bash")
(setq source-directory "~/programs/emacs/src")


;; Save and backup
;;
(setq create-lockfiles nil)
(setq auto-save-timeout 9)
(add-hook 'focus-out-hook 'do-auto-save)
(add-hook 'auto-save-hook 'full-auto-save)

;; Custom commands
;;
;;
(shell-command "setxkbmap -option 'ctrl:ralt_rctrl'")
(shell-command "setxkbmap -option 'caps:swapescape'")
(shell-command "xrandr --output DVI-D-0 --output HDMI-1 ---rotate normal -output HDMI-0 --same-as DVI-D-0")
;; (shell-command "xrandr --output DVI-D-0 --output HDMI-1 --rotate inverted --output HDMI-0 --same-as DVI-D-0")

;; Company
(setq company-idle-delay 0.1)

;; Tabbing
;;
;;
;;(use-package! awesome-tab
;;:config
;;(awesome-tab-mode t)
;;(setq awesome-tab-style 'slant)
;; winum users can use `winum-select-window-by-number' directly.
;;(defun my-select-window-by-number (win-id)
  ;;"Use `ace-window' to select the window by using window index.
;;WIN-ID : Window index."
  ;;(let ((wnd (nth (- win-id 1) (aw-window-list))))
    ;;(if wnd
        ;;(aw-switch-to-window wnd)
      ;;(message "No such window."))))
;;
;;(defun my-select-window ()
  ;;(interactive)
  ;;(let* ((event last-input-event)
         ;;(key (make-vector 1 event))
         ;;(key-desc (key-description key)))
    ;;(my-select-window-by-number
     ;;(string-to-number (car (nreverse (split-string key-desc "-")))))))
;;)
(load! "+org")
(load! "+functions")
