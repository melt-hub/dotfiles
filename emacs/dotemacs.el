; dotemacs.el

;; ====================| STARTUP |====================

(message "[CIRO]: Yo melt!")

; temporally extend garbage collector's threshold
(setq gc-cons-threshold 100000000)
(message "[CIRO]: Increasing garbage collecting threshold...")
(add-hook 'after-init-hook
	  (lambda () (setq gc-cons-threshold 800000)))
(message "[CIRO]: Decreasing garbage collecting threshold...")

; set path variables
(defvar os-packages-path "~/dotfiles/emacs/packages/")
(defvar org-dir-path "~/zk/")

; automatically follow symlinks
(setq vc-follow-symlinks t)

; set character encoding system
(prefer-coding-system 'utf-8-unix)

; display pinentry prompts in minibuffer
(setq epa-pinentry-mode 'loopback)

; do not shoew startup screen
(setq inhibit-startup-screen t)

; always display inline images
(setq org-startup-with-inline-images t)

; load use-package
(add-to-list 'load-path (concat os-packages-path "use-package/"))

; --------------- automodes for specific languages ---------------
; ----- Lisp Dialects -----
; racket
(add-to-list 'auto-mode-alist '("\\.rkt\\'"  . racket-mode))
; scheme
(add-to-list 'auto-mode-alist '("\\.ss\\'"   . scheme-mode))
; common lisp
(add-to-list 'auto-mode-alist '("\\.cl\\'"   . common-lisp-mode))

; ----- Prolog ----- 
(add-to-list 'auto-mode-alist
	'("\\.pl\\'" . prolog-mode))
; NOTE: temporally disabling per-mode because i never use it
(setq auto-mode-alist
  (rassq-delete-all 'perl-mode auto-mode-alist))
; --------------- end automodes for specific languages ---------------

;; ====================| END STARTUP |====================

;; ====================| GENERAL |====================

; --------------- modeline ----------
; display line number
(setq line-number-mode t)

; display column number
(column-number-mode t)

; display time
(display-time)

; disable bell
(setq ring-bell-function (quote ignore))

; disable scroll bar
(scroll-bar-mode -1)

; disable menu bar
(menu-bar-mode -1)

; disable tool bar
(tool-bar-mode 0)
; --------------- end modeline ----------

; --------------- spacing/indentation ---------------
; visual newline for very long lines
(global-visual-line-mode t)

; auto newline after 80 columns
(setq-default fill-column 80)

; use auto fill in text-mode and prog-mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'prog-mode-hook 'turn-on-auto-fill)

; tab is set to two spaces
(setq-default tab-width 2)

; disable real tabs for spaces
(setq-default indent-tabs-mode nil)

; indentation is two spaces for the following languages:
(setq-default c-basic-offset 2)
(setq-default lisp-indent-offset 2)

; autoindent after '\n', '\b' and '}'
(setq-default electric-indent-chars '(?\n ?\^? ?\}))

; set zoom at +1
(add-hook 'find-file-hook
  (lambda ()
    (text-scale-set 1)))

;; ; enables line number visualization in source files
;; (global-display-line-numbers-mode t)
;; (dolist (mode '(org-mode-hook
;; 		term-mode-hook
;; 		shell-mode-hook
;; 		eshell-mode-hook
;; 		eshell-mode-hook))
;;   (add-hook mode (lambda () (display-line-numbers-mode 0))))
; --------------- end spacing/indentation ---------------

;; ====================| END GENERAL |====================

;; ====================| PACKAGES |====================

; built-in Emacs's package manager configuration and remote archives setting
(use-package package
  :config
  (setq package-archive-priorities
	'(("melpa-stable" . 2)
 	  ("MELPA" . 1)
 	  ("gnu" . 0)))
   (setq package-archives
 	'(("melpa-stable" . "https://stable.melpa.org/packages/")
 	  ("MELPA" . "https://melpa.org/packages/")
 	  ("gnu" . "https://elpa.gnu.org/packages/"))))

; using 'package' to initialize 'use-package'
(package-initialize)
(require 'use-package)

; --------------- lisp developement  ---------------

; SLIME setup
(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "sbcl")
  (slime-setup '(slime-fancy)))

; provides file-contextual autocompletion
(use-package slime-company
  :ensure t
  :after (slime company)
  :config
  (setq slime-company-completion 'fuzzy))

; better syntax highlighting for Common Lisp
(use-package lisp-extra-font-lock
  :ensure t
  :config
  (lisp-extra-font-lock-global-mode 1))

; better syntax highlighting for Racket
(use-package racket-mode
  :ensure t)

; better syntax highlighting for Emacs Lisp
(use-package highlight-defined
  :ensure t
  :hook (emacs-lisp-mode . highlight-defined-mode))

; --------------- end lisp developement  ---------------

; --------------- pdf viewing ---------------

; advanced PDF viewer
(use-package pdf-tools
 :ensure t
 :magic ("%PDF" . pdf-view-mode)
 :config
 ; compile and install automatically
 (pdf-tools-install)

 ; use scaling
 (setq pdf-view-use-scaling t)
 ; fit window width
 (setq-default pdf-view-display-size 'fit-width)
 ; dark mode colors
 (setq pdf-view-midnight-colors '("#b2b2b2" . "#292B2E"))

 ; automaticclly enable nightmode and annotations
 (add-hook 'pdf-view-mode-hook
           (lambda ()
             (pdf-annot-minor-mode)
             (pdf-view-midnight-minor-mode)
             (pdf-links-minor-mode)
             (pdf-outline-minor-mode)))

 ; hotkeys
 (define-key
  pdf-view-mode-map (kbd "H") 'pdf-annot-add-highlight-markup-annotation)
 (define-key
  pdf-view-mode-map (kbd "U") 'pdf-annot-add-underline-markup-annotation)
 (define-key
  pdf-view-mode-map (kbd "D") 'pdf-annot-add-strikeout-markup-annotation)
 (define-key
  pdf-view-mode-map (kbd "C-=") 'pdf-view-enlarge)
 (define-key
  pdf-view-mode-map (kbd "C--") 'pdf-view-shrink)
 (define-key
  pdf-view-mode-map (kbd "0") 'pdf-view-scale-reset)
 (define-key
  pdf-view-mode-map (kbd "M") 'pdf-view-midnight-minor-mode))

; keeps track of the last page visited in a PDF
(use-package pdf-view-restore
  :ensure t
  :after pdf-tools
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode)
  (setq pdf-view-restore-filename
	(expand-file-name ".pdf-view-restore" user-emacs-directory)))

; --------------- end pdf viewing ---------------

; org-roam setup
(use-package org-roam
    :ensure t
    :custom
    (org-roam-directory org-dir-path)
    (org-roam-completion-everywhere t)
    :bind
    (("C-c n l" . org-roam-buffer-toggle)
     ("C-c n f" . org-roam-node-find)
     ("C-c n i" . org-roam-node-insert)
     :map org-mode-map
     ("C-M-i" . completion-at-point))
    :config
    (org-roam-setup)
    (setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)
        ("r" "dream" plain "%?"
         :target (file+head "dreams/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+filetags: :dream:\n\n:PROPERTIES:\n:created: %<%Y-%m-%d %H:%M>\n:END:\n")
         :unnarrowed t))))

(use-package org-roam-ui
  :ensure t
  :after org-roam
  :config
  ; sync emacs theme with the graph
  (setq org-roam-ui-sync-theme t)
  ; keep the graph focused on the current buffer
  (setq org-roam-ui-follow t)
  ; update the graph on save
  (setq org-roam-ui-update-on-save t)
  ; open the graph in the browser on startup
  (setq org-roam-ui-open-on-start t))

; --------------- fuzzy finding and completion ---------------



;; ; ui incremental completion framework
;; (use-package helm
;;   :ensure t
;;   :demand t
;;   :bind
;;   (("M-x"     . helm-M-x)
;;    ("C-x C-f" . helm-find-files)
;;    ("C-x b"   . helm-mini)
;;    ("M-y"     . helm-show-kill-ring)
;;    ("C-x C-r" . helm-recentf))
;;   :config
;;   (helm-mode 1)
;;   (setq helm-split-window-in-side-p t)
;;   (setq helm-autoresize-mode t)
;;   (setq helm-M-x-fuzzy-match t)
;;   (setq helm-buffers-fuzzy-matching t)
;;   (setq helm-recentf-fuzzy-match t))

;; ; org-roam integration
;; (use-package helm-org-roam
;;   :ensure t
;;   :after (helm org-roam))

;; ; --------------- ivy ---------------
;; ; lighter ui incremental completion framework
;; (use-package ivy
;;   :ensure t
;;   :config
;;   (ivy-mode 1)
;;   (setq ivy-use-virtual-buffers t)
;;   (setq ivy-count-format "(%d/%d) ")
;;   (setq ivy-re-builders-alist
;;         '((t . ivy--regex-fuzzy))))
;; ;  --------------- end ivy ---------------

;; ; wraps ivy functionalities providing a smoother experience
;; (use-package counsel
;;   :after ivy
;;   :config
;;   (counsel-mode 1)
;;   :bind
;;   (("M-x"     . counsel-M-x)
;;    ("C-x C-f" . counsel-find-file)
;;    ("C-h f"   . counsel-describe-function)
;;    ("C-h v"   . counsel-describe-variable)))

; --------------- end fuzzy finding and completion ---------------

; --------------- password management ---------------

; wrapper package for Unix standard password manager
(use-package pass
  :ensure t
  :after password-store)

; clear clipboard after 15s
(setq password-store-time-before-clipboard-restore 15)

; official emacs's pass binding
(use-package password-store
  :ensure t)

; emacs's built-in system for credential management
(use-package auth-source-pass
  :config
  (auth-source-pass-enable))

(use-package pinentry
  :ensure t
  :config
  (setenv "EMACS" "t")
  (pinentry-start))

; --------------- end password management ---------------

(use-package magit
  :ensure t
  :bind
  (("C-x g"   . magit-status)
   ("C-x M-g" . magit-dispatch))
  :config
  ; uses auth-source-pass for authentication
  (setq magit-process-find-password-functions
        '(magit-process-password-auth-source)))

;; =========================| LATEX |====================

; the best emacs latex environment
; (use-package tex
;  :ensure auctex
;  :config
;  (setq-default TeX-master nil)
;  (setq TeX-parse-self t)
;  (setq TeX-auto-save t))

; auto latex rendering (like obsidian)
(use-package org-fragtog
  :ensure t
  :hook (org-mode . org-fragtog-mode))

;; =========================| END LATEX |====================

; --------------- sql developement ---------------
(use-package sql
  :config
  ; default dbms
  (setq sql-product 'mysql)

  ; connection profiles
  (setq sql-connection-alist
    '((mysql-melt
       (sql-product  'mysql)
       (sql-server   "127.0.0.1")
       (sql-port     3306)
       (sql-user     "melt")
       (sql-password (auth-source-pass-get 'secret "mysql/melt"))
       (sql-database ""))
      (mysql-root
       (sql-product  'mysql)
       (sql-server   "127.0.0.1")
       (sql-port     3306)
       (sql-user     "root")
       (sql-password (auth-source-pass-get 'secret "mysql/root"))
       (sql-database ""))))

  ; enable syntax highlighting in sql buffers
  (add-hook 'sql-mode-hook
    (lambda ()
      (sql-set-product 'mysql)))

  ; prevent visual-line-mode from breaking table formatting
  (add-hook 'sql-interactive-mode-hook
    (lambda ()
      (toggle-truncate-lines t)))

  ; force table printing in ascii, disable buffering
  (setq sql-mysql-options '("--table" "--unbuffered")))

; auto uppercasing keywords
(use-package sqlup-mode
  :ensure t
  :hook
  ((sql-mode . sqlup-mode)
    (sql-interactive-mode . sqlup-mode))
  :config
  ; upcasing blacklist
  (add-to-list 'sqlup-blacklist "name"))

; smart indentation for SQL
(use-package sql-indent
  :ensure t
  :hook (sql-mode . sqlind-minor-mode))

; --------------- end sql development ---------------

(use-package ada-mode
  :ensure t)

;; ====================| END PACKAGES |====================

;; ====================| THEMING |====================

; spacemacs theme
(use-package spacemacs-theme
  :ensure t
  :defer t
  :init
  (load-theme 'spacemacs-dark t))

;; ; doom-themes
;; (use-package doom-themes
;;   :ensure t
;;   :config
;;   (load-theme 'doom-gruvbox t))

;; ; ef themes
;; (use-package ef-themes
;;   :ensure t)

; cool beacon animation when switching through buffers
(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))

; nerd-icons
(use-package nerd-icons
  :ensure t)

; cool modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

; nyan cat animated buffer position indicator
(use-package nyan-mode
  :ensure t
  :config
  (nyan-mode))

;; ====================| END THEMING |====================

;; ====================| ORG MODE |====================

; org mode configuration
(use-package org
  :config

  ; agenda files pointers
  (setq org-agenda-files
    (list (expand-file-name "agenda.org" org-dir-path)))
	
  ; prevent emacs from inserting a newline '\n' when using 'M-RET' to generate
  ; a new list item.
  (setq org-blank-before-new-entry
    '((heading . nil) (plain-list-item . nil)))
  
  ; agenda keybind
  (global-set-key (kbd "C-c a") 'org-agenda)
  
  ; hides markup characters
  (setq org-hide-emphasis-markers t)

  ; latex rendering scaling  
  (setq org-format-latex-options
    (plist-put org-format-latex-options :scale 1.1))

  ; fixed dpi
  ; (setq org-format-latex-options
  ;  (plist-put org-format-latex-options :dpi 120))

  ; latex aligning
  (setq org-format-latex-options
    (plist-put org-format-latex-options :justify 'center))

  ; compile latex code into SVG files
  (setq org-preview-latex-default-process 'dvisvgm)

  ; auto preview latex in whole buffer
  ;; (add-hook 'org-mode-hook
  ;;   (lambda ()
  ;;     (org-latex-preview '(16))))

  ; support for TikZ and advanced TikZ graphs in latex preview
  (setq org-format-latex-header
    (concat org-format-latex-header
      "\n\\usepackage{clrscode3e}"      
      "\n\\usepackage{tikz}"
      "\n\\usepackage{pgfplots}"
      "\n\\usepackage{forest}"
      "\n\\usetikzlibrary{positioning, calc, arrows.meta,"
      "shapes.multipart, automata, matrix, intersections}"          
      "\n\\usepgfplotslibrary{fillbetween, statistics}"
      "\n\\pgfplotsset{compat=newest}"))
  
  ; support for TikZ and advanced TikZ graphs in latex export
  (setq org-latex-packages-alist
    '(("" "clrscode3e" t)
       ("" "tikz" t)
       ("" "pgfplots" t)
       ("" "forest" t))))

;; ====================| END ORG MODE |====================

;; ====================| MY FUNCTIONS |====================

; my/tangle dotfiles
;
; this function autotangles the org config file
(defun my/tangle-dotfiles ()
  (when (equal (buffer-file-name)
	       (expand-file-name "~/dotfiles/emacs/dotemacs.org"))
    (org-babel-tangle)
    (message "[CIRO]: Org Configuration file tangled!")))

(add-hook 'after-save-hook #'my/tangle-dotfiles)

(defun my/org-center-latex ()
  (dolist (ov (overlays-in (point-min) (point-max)))
    (when (and (eq (overlay-get ov 'org-overlay-type) 'org-latex-overlay)
      (my/org-latex-block-p ov))
      (overlay-put ov
        'before-string
        (propertize " " 'display (my/build-space ov))))))

(defun my/build-space (overlay)
  `(space :align-to (- center ,(/ (my/get-image-width-px overlay)
                                   2
                                   (frame-char-width)))))

(defun my/get-image-width-px (overlay)
  (car (image-size (overlay-get overlay 'display) t)))

(defun my/org-latex-block-p (overlay)
  (let ((text (buffer-substring-no-properties
                (overlay-start overlay)
                (overlay-end overlay))))
    (or (string-match-p "\\`\\s-*\\$\\$" text)
        (string-match-p "\\`\\s-*\\\\\\[" text)
        (string-match-p "\\`\\s-*\\\\begin{" text))))

;; (add-hook 'org-mode-hook
;;   (lambda ()
;;     (add-hook 'after-save-hook #'my/org-center-latex nil t)))

(advice-add 'org-latex-preview :after
  (lambda (&rest _) (my/org-center-latex)))

(defun my/loop-invariant ()
  "Insert a loop invariant proof structure."
  (interactive)
  (insert "+ *Initialization*:\n"
          "+ *Maintenance*:\n"
          "+ *Termination*:\n"))

(defun my/each-half-hour-between (start end)
  (interactive "nStart (hour): \nnEnd (hour): ")
  (let ((steps (* (- end start) 2)))
  (dotimes (i (+ steps 1))
  (insert (format "| %02d:%02d | |\n"
    (+ start (/ i 2))
    (* 30 (mod i 2)))))))

(defun my/latex-switch-scaling ()
  "Toggle LaTeX preview scaling between 1.1 and 1.8."
  (interactive)
  (let* ((current (plist-get org-format-latex-options :scale))
          (next (if (< current 1.5) 1.8 1.1)))
    (setq org-format-latex-options
      (plist-put org-format-latex-options :scale next))
    (execute-kbd-macro (kbd "C-u C-u C-c C-x C-l"))
    (message "[CIRO]: LaTeX scaling set to %.1f" next)))

;; ====================| END MY FUNCTIONS |====================

; end dotemacs.el
