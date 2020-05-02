(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
  ;; and `package-pinned-packages`. Most users will not need or want to do this.
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(server-start)

(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(defalias 'yes-or-no-p 'y-or-n-p)

;; (tool-bar-mode -1)
;; (menu-bar-mode -1)
(scroll-bar-mode -1)

;; (setq make-backup-file nil)
;; (setq auto-save-default nil)

;; Theme fixes
;; (set-face-attribute 'default nil :height 120)
;; (set-cursor-color "#ffffff")
;; (set-face-background 'hl-line "#293339")
;; (set-face-foreground 'highlight nil)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Alt+x global-display-line-numbers-mode → show line numbers in all buffers.
;; Alt+x display-line-numbers-mode → show line numbers in current buffer.
(global-display-line-numbers-mode t)

(delete-selection-mode 1)

(global-visual-line-mode 1)

;; https://www.emacswiki.org/emacs/SmoothScrolling
;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

;; (when window-system (global-hl-line-mode t))
(global-hl-line-mode t)

(global-subword-mode 1)

(show-paren-mode 1)
(electric-pair-mode t)
(setq electric-pair-pairs '(
			    (?\{ . ?\})
			    (?\' . ?\')
			    ))

(line-number-mode t)
(column-number-mode t)

(setq disabled-command-function nil)
;; (setq use-package-always-ensure t)

;; https://github.com/hlissner/emacs-doom-themes/issues/166
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  ;;(doom-themes-visual-bell-config)
  
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)
  
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

;; https://github.com/domtronn/all-the-icons.el#installing-fonts
(use-package all-the-icons-dired
  :ensure t)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package multiple-cursors
  :ensure t)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-<") 'mc/mark-next-like-this)
(global-set-key (kbd "C->") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

(use-package emmet-mode
  :ensure t)

(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'html-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)

(when window-system
      (use-package pretty-mode
      :ensure t
      :config
      (global-pretty-mode t)))

(use-package async
  :ensure t
  :init (dired-async-mode 1))

;; Linux only
(use-package dmenu
  :ensure t
  :bind
  ("s-SPC" . 'dmenu))

;; https://github.com/daedreth/UncleDavesEmacs#functions-to-start-processes
;; Functions to start processes / Keybindings to start processes
(defun custom-async-run (name)
  (interactive)
  (start-process name nil name))

(defun custom-launch-calc ()
  (interactive)
  (custom-async-run "calc.exe"))

(global-set-key (kbd "C-ü") 'custom-launch-calc)


(use-package projectile
  :ensure t
  :init
  (projectile-mode 1))

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(use-package dashboard
  :ensure t
  :config
    (dashboard-setup-startup-hook)
    (setq dashboard-items '((recents  . 5)
                            (projects . 5))))

(global-set-key (kbd "C-c C-r") 'recentf-edit-list)
(global-set-key (kbd "C-c C-p") 'projectile-remove-known-project)

(setq display-time-24hr-format t)
(setq display-time-format "%H:%M") ;"%H:%M - %d %B %Y"
(display-time-mode 1)

;; (use-package fancy-battery
;;   :ensure t
;;   :config
;;     (setq fancy-battery-show-percentage t)
;;     (setq battery-update-interval 15)
;;     (if window-system
;;       (fancy-battery-mode)
;;       (display-battery-mode)))

;; (use-package symon
;;   :ensure t
;;   :bind
;;   ("s-h" . symon-mode))

(use-package beacon
  :ensure t
  :config
    (beacon-mode 1))

(use-package ace-window
  :ensure t)

(global-set-key (kbd "M-o") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
;; (setq aw-background nil)

;; https://github.com/daedreth/UncleDavesEmacs#following-window-splits
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

;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-expert t)

;; https://github.com/daedreth/UncleDavesEmacs#close-all-buffers
;; (defun close-all-buffers ()
;;   "Kill all buffers without regard for their origin."
;;   (interactive)
;;   (mapc 'kill-buffer (buffer-list)))
;; (global-set-key (kbd "C-M-s-k") 'close-all-buffers)

(use-package avy
  :ensure t
  :bind
    ("C-c :" . avy-goto-char)
    ("C-c ;" . avy-goto-word-1))


;; https://github.com/daedreth/UncleDavesEmacs#improved-kill-word
(defun daedreth/kill-inner-word ()
  "Kill the entire word your cursor is in.  Equivalent to 'ciw' in vim."
  (interactive)
  (forward-char 1)
  (backward-word)
  (kill-word 1))
(global-set-key (kbd "C-c w k") 'daedreth/kill-inner-word)

 (defun daedreth/copy-whole-word ()
  (interactive)
  (save-excursion
    (forward-char 1)
    (backward-word)
    (kill-word 1)
    (yank)))
(global-set-key (kbd "C-c w c") 'daedreth/copy-whole-word)

(defun daedreth/copy-whole-line ()
  "Copies a line without regard for cursor position."
  (interactive)
  (save-excursion
    (kill-new
     (buffer-substring
      (point-at-bol)
      (point-at-eol)))))
(global-set-key (kbd "C-c l c") 'daedreth/copy-whole-line)

;; (global-set-key (kbd "C-c l k") 'kill-whole-line)


;; https://www.emacswiki.org/emacs/CopyingWholeLines#toc10
;; duplicate current line
(defun duplicate-current-line (&optional n)
  "Duplicate current line, make more than 1 (N) copy given a numeric argument."
  (interactive "p")
  (save-excursion
    (let ((nb (or n 1))
    	  (current-line (thing-at-point 'line)))
      ;; when on last line, insert a newline first
      (when (or (= 1 (forward-line 1)) (eq (point) (point-max)))
    	(insert "\n"))
      
      ;; now insert as many time as requested
      (while (> n 0)
    	(insert current-line)
    	(decf n)))))

(global-set-key (kbd "C-S-d") 'duplicate-current-line)

(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package rainbow-mode
  :ensure t
  :init
  (add-hook 'prog-mode-hook 'rainbow-mode))

(use-package hungry-delete
  :ensure t
  :config
    (global-hungry-delete-mode))

(use-package zzz-to-char
  :ensure t
  :bind ("M-z" . zzz-up-to-char))

(use-package popup-kill-ring
  :ensure t
  :bind ("M-y" . popup-kill-ring))

(use-package yasnippet
  :ensure t
  :config
    (use-package yasnippet-snippets
      :ensure t)
    (yas-reload-all))

(yas-global-mode 1)

(use-package flycheck
  :ensure t)

;; -------------

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3))

(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "SPC") #'company-abort))

;;(add-hook 'emacs-lisp-mode-hook 'yas-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'emacs-lisp-mode-hook 'company-mode)

(use-package magit
  :ensure t
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)
  :bind
  ("M-g" . magit-status))

(use-package sudo-edit
  :ensure t
  :bind
  ("C-c C-s" . sudo-edit))

;; (define-key global-map (kbd "RET") 'newline-and-indent)

;;-----------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(line-number-mode t)
 '(package-selected-packages
   (quote
    (try sudo-edit magit company sublimity yasnippet-snippets yasnippet browse-kill-ring zzz-to-char hungry-delete rainbow-mode beacon ace-window symon fancy-battery dashboard which-key projectile dmenu async pretty-mode all-the-icons-dired doom-modeline doom-themes multiple-cursors use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;-----------------------
