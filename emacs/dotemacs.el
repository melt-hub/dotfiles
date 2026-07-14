;;; dotemacs.el
;;; ====================| MELT's EMACS CONFIGURATION |===============

;; ====================| STARTUP |====================

(message "[CIRO]: Yo melt!")

;; Set directory paths
(defvar os-packages-path "~/dotfiles/emacs/packages/")
(defvar org-dir-path "~/zk/")

;; Custom variables
(defvar my/org-university "Università di Milano Bicocca"
  "Default university for scientific papers.")

(defvar my/org-email "melt@campus.unimib.it"
  "Default email address for academic exports.")

(defvar my/org-author "melt"
  "Default author for scientific papers.")

(defvar my/temp-dir (expand-file-name ".tmp/" user-emacs-directory)
  "Central directory for Emacs temporary files.")

;; Automatically follow file symlinks
(setq vc-follow-symlinks t)

;; Set default character encoding system
(prefer-coding-system 'utf-8-unix)

;; Direct pinentry prompts to the minibuffer
(setq epa-pinentry-mode 'loopback)

;; Suppress startup screen display
(setq inhibit-startup-screen t)

;; Always display inline images by default
(setq org-startup-with-inline-images t)

;; Load use-package path
(add-to-list 'load-path (concat os-packages-path "use-package/"))

;; --------------- automodes for specific languages ---------------
    ;; Lisp Dialects
    (add-to-list 'auto-mode-alist '("\\.rkt\\'"  . racket-mode))
    (add-to-list 'auto-mode-alist '("\\.ss\\'"   . scheme-mode))
    (add-to-list 'auto-mode-alist '("\\.cl\\'"   . common-lisp-mode))

    ;; Prolog
    (add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode))

    ;; Rofi, Sway/Swaylock e file RC generici
    (add-to-list 'auto-mode-alist '("\\.rasi\\'" . css-mode))
    (add-to-list 'auto-mode-alist '("config\\'" . conf-mode))
    (add-to-list 'auto-mode-alist '("\\.*rc\\'" . conf-mode))

    ;; Temporarily disable default perl-mode association for .pl files
    (setq auto-mode-alist
      (rassq-delete-all 'perl-mode auto-mode-alist))
;; --------------- end automodes for specific languages ---------------

;; ====================| END STARTUP |====================

;; ====================| GENERAL |====================

;; --------------- modeline ----------
;; Display line numbers in status bar
(setq line-number-mode t)

;; Display column numbers in status bar
(column-number-mode t)

;; Enable system time display
(display-time)

;; Disable audible bell notifications
(setq ring-bell-function 'ignore)

;; --------------- end modeline ----------

;; --------------- spacing/indentation ---------------
;; Control newline insertions at end of files
(setq require-final-newline nil)
(setq mode-require-final-newline nil)

;; Remove trailing whitespaces and empty lines on save
(add-hook 'before-save-hook
          (lambda ()
            (save-excursion
              (goto-char (point-max))
              (skip-chars-backward " \t\n\r")
              (delete-region (point) (point-max)))))

;; Enable visual line wrap globally
(global-visual-line-mode t)

;; Set default column limit for text filling
(setq-default fill-column 80)

;; Enable automatic wrapping in text and programming buffers
(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'prog-mode-hook 'turn-on-auto-fill)

;; Use two spaces instead of hard tabs
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

;; Set relative offsets for C and Lisp dialects
(setq-default c-basic-offset 2)
(setq-default lisp-indent-offset 2)

;; Specify characters triggering automatic indentation
(setq-default electric-indent-chars '(?\n ?\^? ?\}))

;; Increase default text size on file opening
(add-hook 'find-file-hook
  (lambda ()
    (text-scale-set 1)))

;; Prevent native graphical dialogs and file selection windows
    (setq use-dialog-box nil)
    (setq use-file-dialog nil)

    ;; Disable context menus triggered by mouse clicks
    (setq context-menu-mode nil)

    ;; Disable popup menus triggered by clicking major or minor modes in the modeline
    (setq mode-line-major-mode-keymap nil)
    (setq mode-line-minor-mode-keymap nil)

;; --------------- end spacing/indentation ---------------

;; ====================| END GENERAL |====================

;; Ensure the main temp directory exists
(unless (file-exists-p my/temp-dir)
  (make-directory my/temp-dir t))

;; Backups (file.org~) - Includes full path to avoid collisions
(setq backup-directory-alist
      `((".*" . ,(expand-file-name "backups/" my/temp-dir))))
(setq backup-by-copying t)    ; Backup by copying to preserve symlinks
(setq version-control t)      ; Use numbered backups (.~1~, .~2~, etc.)
(setq kept-old-versions 2)    ; Keep the original version
(setq kept-new-versions 5)    ; Keep the 5 most recent versions
(setq delete-old-versions t)  ; Silently delete excess backups

;; Auto-saves (#file.org#)
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" my/temp-dir) t)))
(setq auto-save-list-file-prefix
      (expand-file-name "auto-save-list/.saves-" my/temp-dir))

;; Lock files (.#file.org) - Requires Emacs 28+
(when (boundp 'lock-file-name-transforms)
  (setq lock-file-name-transforms
        `((".*" ,(expand-file-name "locks/" my/temp-dir) t))))

;; Initialize subdirectories
(dolist (dir '("backups" "auto-save" "locks" "auto-save-list"))
  (let ((path (expand-file-name dir my/temp-dir)))
    (unless (file-exists-p path)
      (make-directory path t))))

;; Use y/n instead of yes/no globally (Emacs 28+)
(setq use-short-answers t)

;; Confirm Emacs exit with a quick y/n prompt
(setq confirm-kill-emacs 'y-or-n-p)

;; Ensure 's' (save) is always an option in buffer-related prompts
(setq save-some-buffers-default-predicate 'save-some-buffers-root)

;; ====================| PACKAGES |====================

;; Remote ELPA and MELPA archives configuration
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

;; Setup statistics tracking and load use-package engine
(setq use-package-compute-statistics t)
(package-initialize)
(require 'use-package)

;; Gestione automatica e ottimizzata del Garbage Collector
(use-package gcmh
  :ensure t
  :init
  ;; Imposta la soglia a 16MB durante l'uso attivo (valore equilibrato)
  (setq gcmh-high-cons-threshold (* 16 1024 1024)
        ;; Avvia la pulizia della memoria dopo 15 secondi di inattività
        gcmh-idle-delay 15)
  :config
  (gcmh-mode 1))

;; Fix safe theme validation issues for Emacs 29+
(setq custom-safe-themes t)
(setq warning-minimum-level :error)

;; change 'load-theme' value to change theme

;; emacs built in themes
(use-package emacs
  :init
  (let ((inhibit-message t)
        (warning-minimum-level :emergency))
    (load-theme 'modus-vivendi t)))

;; spacemacs dark
;; (use-package spacemacs-theme
;;   :ensure t
;;   :defer t
;;   :init
;;   (let ((inhibit-message t)
;;         (warning-minimum-level :emergency))
;;     (load-theme 'spacemacs-dark t)))

;; ef themes
;; (use-package ef-themes
;;   :ensure t
;;   :defer t
;;   :init
;;   (let ((inhibit-message t)
;;         (warning-minimum-level :emergency))
;;     (load-theme 'ef-trio-dark t)))

(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))

(use-package nerd-icons
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; (use-package nyan-mode
;;   :ensure t
;;   :config
;;   (nyan-mode))

(use-package dashboard
  :ensure t
  :init (recentf-mode 1)
  :config
  (dashboard-setup-startup-hook)

  ;; Specify custom branding banner
  (setq dashboard-startup-banner "~/pics/other/spacemacs-logo-padded.png")
  (setq dashboard-banner-logo-title "[CIRO]: Welcome back melt!")

  ;; Display standard sections
  (setq dashboard-items '((recents  . 10)))

  ;; Fine-tune visual options
  (setq dashboard-set-heading-icons nil)
  (setq dashboard-set-file-icons t)
  (setq dashboard-icon-type 'nerd-icons)

  ;; Center content alignment
  (setq dashboard-center-content t)
  (setq dashboard-section-gap 2)
  (setq dashboard-set-footer t)

  ;; Custom buffer interactions
  (add-hook 'dashboard-mode-hook
            (lambda ()
              (local-set-key (kbd "q") 'quit-window)
              (setq buffer-read-only t)))

  (message "[CIRO]: Dashboard is ready."))

;; --------------- git integration ---------------
(use-package magit
  :ensure t
  :defer t
  :bind
  (("C-x g"   . magit-status)
   ("C-x M-g" . magit-dispatch))
  :config
  ;; Retrieve credentials using auth-source
  (setq magit-process-find-password-functions
        '(magit-process-password-auth-source)))
;; --------------- end git integration ---------------

(use-package cc-mode
  :ensure nil
  :bind (:map c-mode-map
              ("C-c C-c" . compile)
         :map c++-mode-map
              ("C-c C-c" . compile))
  :config
  (setq-default c-basic-offset 4))

(use-package prolog
  :ensure nil
  :mode ("\\.pl\\'" . prolog-mode)
  :config
  (setq prolog-program-name "swipl")
  (setq prolog-system 'swi))

(use-package java-mode
  :ensure nil
  :bind (:map java-mode-map
              ("C-c C-c" . compile))
  :config
  (setq-default java-basic-offset 4))

(use-package js
  :ensure nil
  :mode ("\\.js\\'" . js-mode)
  :bind (:map js-mode-map
              ("C-c C-c" . compile))
  :config
  (setq js-indent-level 2))

(use-package julia-mode
  :ensure t)

;; Adds a proper CLI REPL for Julia
(use-package julia-repl
  :ensure t
  :hook (julia-mode . julia-repl-mode))

(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :bind (:map python-mode-map
              ("C-c C-c" . python-shell-send-buffer)
              ("C-c C-z" . run-python))
  :config
  (setq python-shell-interpreter "python3"))

(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'")

(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode)
  :config
  ;; The prefix automatically enables sub-keys (b, r, t, c, etc.)
  (setq cargo-minor-mode-key-prefix (kbd "C-c C-k"))
  (setq cargo-process--command-flags '("--color" "always")))

;; Project-specific terminal shortcut
(with-eval-after-load 'rust-mode
  (define-key rust-mode-map (kbd "C-c C-v") #'vterm))

;; --------------- lisp developement  ---------------

;; Core environment setup
(use-package slime
  :ensure t
  :commands (slime slime-mode)
  :config
  (setq inferior-lisp-program "sbcl")
  (slime-setup '(slime-fancy)))

;; Complete-at-point suggestions via Company
(use-package slime-company
  :ensure t
  :after (slime company)
  :config
  (setq slime-company-completion 'fuzzy))

(use-package lisp-extra-font-lock
  :ensure t
  :hook (lisp-mode . lisp-extra-font-lock-mode)
  :config
  (lisp-extra-font-lock-global-mode 1))

(use-package racket-mode
  :ensure t
  :mode "\\.rkt\\'")

(use-package highlight-defined
  :ensure t
  :hook (emacs-lisp-mode . highlight-defined-mode))

;; --------------- end lisp developement  ---------------

;; --------------- sql developement ---------------
(use-package sql
  :config
  ;; Assign primary engine dialect
  (setq sql-product 'mysql)

  ;; Declare active profiles mapping credentials to auth-source
  (setq sql-connection-alist
    '((mysql-melt
       (sql-product  'mysql)
       (sql-server   "127.0.0.1")
       (sql-port     3306)
       (sql-user     "melt")
       (sql-password
        (auth-source-pass-get 'secret "mysql/melt"))
       (sql-database ""))
      (mysql-root
       (sql-product  'mysql)
       (sql-server   "127.0.0.1")
       (sql-port     3306)
       (sql-user     "root")
       (sql-password
        (auth-source-pass-get 'secret "mysql/root"))
       (sql-database ""))))

  ;; Set buffer options
  (add-hook 'sql-mode-hook
    (lambda ()
      (sql-set-product 'mysql)
      ;; Use simple indentation copying previous line spacing
      (setq-local indent-line-function 'indent-relative)
      (electric-indent-local-mode -1)))

  ;; Truncate layout inside interactive shells to preserve ASCII table width
  (add-hook 'sql-interactive-mode-hook
    (lambda ()
      (toggle-truncate-lines t)))

  ;; Force standard ASCII formatting
  (setq sql-mysql-options '("--table" "--unbuffered")))

;; Automatic capitalization utility for SQL keywords
(use-package sqlup-mode
  :defer t
  :hook
  ((sql-mode . sqlup-mode)
   (sql-interactive-mode . sqlup-mode))
  :config
  ;; Specify exclusion blacklist
  (add-to-list 'sqlup-blacklist "name"))
;; --------------- end sql development ---------------

;; --------------- latex ---------------

(use-package org-fragtog
  :ensure t
  :hook (org-mode . org-fragtog-mode)
  :config
  (setq org-preview-latex-image-directory
      (concat temporary-file-directory "ltximg/")))

;; --------------- end latex ---------------

;; --------------- pdf viewing ---------------

(use-package pdf-tools
 :ensure t
 :magic ("%PDF" . pdf-view-mode)
 :config
 ;; Trigger backend installation
 (pdf-tools-install)

 ;; Scale to window width
 (setq pdf-view-use-scaling t)
 (setq-default pdf-view-display-size 'fit-width)
 ;; (setq pdf-view-midnight-colors '("#b2b2b2" . "#292B2E"))
 (setq pdf-view-midnight-colors '("#ffffff" . "#121212"))

 ;; Enable night mode and annotator hook automatically
 (add-hook 'pdf-view-mode-hook
           (lambda ()
             (pdf-annot-minor-mode)
             (pdf-view-midnight-minor-mode)
             (pdf-links-minor-mode)
             (pdf-outline-minor-mode)))

 ;; Bind operational shortcut keys
 (define-key pdf-view-mode-map (kbd "H")
   'pdf-annot-add-highlight-markup-annotation)
 (define-key pdf-view-mode-map (kbd "U")
   'pdf-annot-add-underline-markup-annotation)
 (define-key pdf-view-mode-map (kbd "D")
   'pdf-annot-add-strikeout-markup-annotation)
 (define-key pdf-view-mode-map (kbd "C-=")
   'pdf-view-enlarge)
 (define-key pdf-view-mode-map (kbd "C--")
   'pdf-view-shrink)
 (define-key pdf-view-mode-map (kbd "0")
   'pdf-view-scale-reset)
 (define-key pdf-view-mode-map (kbd "M")
   'pdf-view-midnight-minor-mode))

(use-package pdf-view-restore
  :ensure t
  :after pdf-tools
  :hook (pdf-view-mode . pdf-view-restore-mode)
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode)
  (setq pdf-view-restore-filename
        (expand-file-name ".pdf-view-restore"
                          user-emacs-directory)))

;; --------------- end pdf viewing ---------------

(use-package org
  :defer t
  :bind (("C-c a" . org-agenda) ("C-c c" . org-capture))
  :config
  (add-to-list 'org-structure-template-alist '("L" . "latex"))
  (add-to-list 'org-src-lang-modes '("latex" . LaTeX))

  (let ((agenda-path "/home/melt/zk/agenda/agenda.org"))
    (setq org-agenda-files (list agenda-path))
    (setq org-log-done 'time)
    (setq org-log-into-drawer t)

    (setq org-tag-alist
          '((:startgroup)
            ("call" . ?c) ("appo" . ?a) ("bday" . ?b) 
            ("proj" . ?p) ("task" . ?k)
            (:endgroup)))

    (setq org-agenda-custom-commands
          '(("p" "Project Overview" tags-todo "+proj")))

    (setq org-capture-templates
          `(("t" "todo [Inbox]" entry (file+headline ,agenda-path "Inbox")
             "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:" :empty-lines 1)
            ("r" "reminder" entry 
             (file+headline ,agenda-path "Tasks & Appointments")
             ,(concat "* %^{Description} :rem:\n%^t\n:PROPERTIES:\n"
                      ":CONTACT: %^{Who}\n:LOCATION: %^{Where}\n"
                ":CREATED: %U\n:END:")
              :empty-lines 1)
            ("k" "task" entry
             (file+headline ,agenda-path "Tasks & Appointments")
             ,(concat "* TODO %^{Description} :task:\nSCHEDULED: %^t\n"
                      ":PROPERTIES:\n:CONTACT: %^{Who}\n"
                      ":LOCATION: %^{Where}\n:CREATED: %U\n:END:")
             :empty-lines 1)
            ("c" "call" entry 
             (file+headline ,agenda-path "Tasks & Appointments")
             ,(concat "* TODO %^{Name} :call:\nSCHEDULED: %^t\n"
                      ":PROPERTIES:\n:CONTACT: %\\1\n:CREATED: %U\n:END:")
             :empty-lines 1)
            ("b" "birthday" entry 
             (file+headline ,agenda-path "Birthdays & Recurrences")
             ,(concat "* Compleanno %^{Who} :bday:\n"
                      "%(concat \"<\" (org-read-date) \" +1y>\")")
             :empty-lines 1)
            ("p" "project" entry (file+headline ,agenda-path "Projects")
             ,(concat "* TODO %^{Project Name} [%] :proj:\nDEADLINE: %^t\n"
                      ":PROPERTIES:\n:CREATED: %U\n:END:\n- [ ] %?")
             :empty-lines 1))))

  (setq org-blank-before-new-entry '((heading . t) (plain-list-item . nil)))
  (setq org-use-property-inheritance t)
  (setq org-hide-emphasis-markers t)
  (setq org-tags-column 0)
  (setq org-agenda-tags-column 0)

  ;; Latex math display
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.1))
  (setq org-format-latex-options
        (plist-put org-format-latex-options :justify 'center))
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-format-latex-options
        (plist-put org-format-latex-options :background "Transparent"))

  ;; Custom Latex package for equation previews (renders buffers correctly)
  (setq org-format-latex-header
        (concat org-format-latex-header "\n\\usepackage{melt-setup}"))

  ;; Remove default geometry to avoid conflicts with custom margins
  (setq org-latex-default-packages-alist
        (assoc-delete-all "geometry" org-latex-default-packages-alist))

  ;; Custom default Latex packages
  (setq org-latex-packages-alist
        '(("margin=1in" "geometry" t)
          ("" "parskip" t)
          ("" "melt-setup" t)))

  ;; Set global author variables to resolve "immediate" metadata issue
  (setq user-full-name "melt")
  (setq user-login-name "melt")

  ;; Ensure images are centered by default
  (setq org-latex-images-centered t)

  ;; Custom minimal class for CS papers (uses external cs-paper-template.sty)
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
                 '("cs-paper"
                   "\\documentclass[11pt]{article}
[DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]
\\usepackage{cs-paper-template}"
                   ("\\section{%s}" . "\\section*{%s}")
                   ("\\subsection{%s}" . "\\subsection*{%s}")
                   ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                   ("\\paragraph{%s}" . "\\paragraph*{%s}")))))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (expand-file-name "~/zk"))
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (setq org-roam-capture-templates
          `(("u" "uni")
            ("uu" "uni" plain "%?"
             :target (file+head "uni/${slug}.org"
                                ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                         ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                         "#+title: ${title}\n#+author: melt\n"
                                         "#+filetags: :uni:"))
             :unnarrowed t)
            ("ui" "index" plain "%?"
             :target (file+head "uni/${slug}.org"
                                ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                         ":created: %<%Y-%m-%d %H:%M>\n"
                                         ":BOOK_TITLE: %^{Book Title}\n:END:\n"
                                         "#+title: ${title}\n#+author: melt\n"
                                         "#+filetags: :uni:index:"))
             :unnarrowed t)
            ("up" "paper" plain "%?"
             :target (file+head "uni/papers/${slug}.org"
                                ,(concat ":PROPERTIES:\n"
                                         ":ID: %(org-id-new)\n"
                                         ":created: %<%Y-%m-%d %H:%M>\n"
                                         ":END:\n"
                                         "#+title: ${title}\n"
                                         "#+author: " my/org-author "\n"
                                         "#+email: " my/org-email "\n"
                                         "#+latex_class: cs-paper\n"
                                         "#+latex_header: \\author{"
                                         my/org-author
                                         "\\thanks{Equal contribution.}}\n"
                                         "#+latex_header: \\affil{"
                                         my/org-university
                                         " \\\\ \\texttt{" my/org-email "}}\n"
                                         "#+filetags: :paper:\n\n"
                                         "#+options: toc:t\n\n"
                                         "#+begin_abstract\n"
                                         "This is the abstract. [fn:1]\n"
                                         "#+end_abstract\n\n"
                                         "* Introduction\n\n"
                                         "The paper starts here.\n\n"
                                         "* Bibliography\n\n"
                                         "[fn:1] Footnote example.\n"))
             :unnarrowed t)
            ("d" "dream")
            ("dd" "dream" plain "%?"
             :target (file+head "dreams/${slug}.org"
                                ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                         ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                         "#+title: ${title}\n#+author: melt\n"
                                         "#+filetags: :dream:"))
             :unnarrowed t)
            ("dp" "person" plain "%?"
             :target (file+head "dreams/${slug}.org"
                                ,(concat ":PROPERTIES:\n"
                                         ":ID: %(org-id-new)\n"
                                         ":created: %<%Y-%m-%d %H:%M>\n"
                                         ":END:\n"
                                         "#+title: ${title}\n"
                                         "#+filetags: :person:\n\n"
                                         "* Dreams featuring ${title}\n"))
             :unnarrowed t)
            ("s" "scrap" plain "%?"
             :target (file+head "scraps/${slug}.org"
                                ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                         ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                         "#+title: ${title}\n#+author: melt\n"
                                         "#+filetags: :scrap:"))
             :unnarrowed t)))
  (org-roam-setup))

(use-package org-roam-ui
  :ensure t
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t)
  (setq org-roam-ui-follow t)
  (setq org-roam-ui-update-on-save t)
  (setq org-roam-ui-open-on-start t))

;; --------------- password management ---------------
(use-package pass
  :ensure t
  :defer t
  :commands (pass)
  :after password-store)

;; Clear clipboard history automatically after 15 seconds
(setq password-store-time-before-clipboard-restore 15)

(use-package password-store
  :ensure t
  :defer t)

(use-package auth-source-pass
  :config
  (auth-source-pass-enable))

(use-package pinentry
  :ensure t
  :config
  (setenv "EMACS" "t")
  (pinentry-start))
;; --------------- end password management ---------------

(use-package vterm
  :ensure t
  :bind ("C-c v" . vterm)
  :custom
  (vterm-max-scrollback 10000)
  :config
  ;; Standard yank (paste) bindings
  (define-key vterm-mode-map (kbd "C-y") #'vterm-yank)
  (define-key vterm-mode-map (kbd "M-y") #'vterm-yank-pop))

;; --------------- multimedia (emms) ---------------
(use-package emms
  :ensure t
  :defer t
  :bind
  (("C-c e p" . emms-playlist-mode-go)
   ("C-c e l" . emms-play-file))  
  :config
  (require 'emms-setup)
  (emms-all)
  (emms-default-players)

  ;; Use MPV as standard backend
  (setq emms-player-list '(emms-player-mpv))

  ;; Declare standard source path
  (setq emms-source-file-default-directory "~/clips/")

  ;; Assign active media keys
  (global-set-key (kbd "C-c e p") 'emms-playlist-mode-go)
  (global-set-key (kbd "C-c e l") 'emms-play-file))
;; --------------- end multimedia ------------------

;; ====================| END PACKAGES |====================

;; ====================| MY FUNCTIONS |====================

(defun my/tangle-dotfiles ()
  "Compile Org dotfiles automatically on save."
  (when (equal (buffer-file-name)
               (expand-file-name "~/dotfiles/emacs/dotemacs.org"))
    (org-babel-tangle)
    (message "[CIRO]: Org Configuration file tangled!")))

(add-hook 'after-save-hook #'my/tangle-dotfiles)

(defun my/org-center-latex ()
  "Position and center inline LaTeX preview overlays in current buffer."
  (dolist (ov (overlays-in (point-min) (point-max)))
    (when (and (eq (overlay-get ov 'org-overlay-type) 'org-latex-overlay)
               (my/org-latex-block-p ov))
      (overlay-put ov
                   'before-string
                   (propertize " " 'display (my/build-space ov))))))

(defun my/build-space (overlay)
  "Construct empty margin space width mapping coordinates."
  `(space :align-to (- center ,(/ (my/get-image-width-px overlay)
                                   2
                                   (frame-char-width)))))

(defun my/get-image-width-px (overlay)
  "Retrieve pixel width of the target overlay."
  (car (image-size (overlay-get overlay 'display) t)))

(defun my/org-latex-block-p (overlay)
  "Verify if target overlay represents a LaTeX equation block."
  (let ((text (buffer-substring-no-properties
                (overlay-start overlay)
                (overlay-end overlay))))
    (or (string-match-p "\\`\\s-*\\$\\$" text)
        (string-match-p "\\`\\s-*\\\\\\[" text)
        (string-match-p "\\`\\s-*\\\\begin{" text))))

(advice-add 'org-latex-preview :after
  (lambda (&rest _) (my/org-center-latex)))

(defun my/latex-switch-scaling ()
  "Toggle LaTeX preview scaling between 1.1 and 1.8."
  (interactive)
  (let* ((current (plist-get org-format-latex-options :scale))
         (next (if (< current 1.5) 1.8 1.1)))
    (setq org-format-latex-options
          (plist-put org-format-latex-options :scale next))
    (execute-kbd-macro (kbd "C-u C-u C-c C-x C-l"))
    (message "[CIRO]: LaTeX scaling set to %.1f" next)))

(defun my/org-export-output-directory (orig-fun extension
                                       &optional subtreep pub-dir)
  "Redirect export output to an 'export/' subdirectory."
  (unless pub-dir
    (let ((base-dir (file-name-directory (buffer-file-name))))
      (setq pub-dir (expand-file-name "export/" base-dir))
      (unless (file-exists-p pub-dir)
        (make-directory pub-dir t))))
  (let ((output-file (apply orig-fun extension subtreep (list pub-dir))))
    (message "[CIRO]: Exporting to %s" output-file)
    output-file))

;; Apply advice to redirect export
(advice-add 'org-export-output-file-name
            :around #'my/org-export-output-directory)

;; Configure LaTeX cleanup
(setq org-latex-remove-logfiles t)
(setq org-latex-logfiles-extensions
      '("aux" "idx" "log" "out" "toc" "nav" "snm"
        "vrb" "fls" "fdb_latexmk" "blg" "bbl"))

(defun my/debug-log (format-string &rest args)
  "Log ARGS formatted by FORMAT-STRING into the *dreams-indexing* buffer."
  (let ((buf (get-buffer-create "*dreams-indexing*")))
    (with-current-buffer buf
      (save-excursion
        (goto-char (point-max))
        (let ((inhibit-read-only t))
          (insert (concat (format-time-string "[%H:%M:%S] ")
                          (apply #'format format-string args)
                          "\n")))))))

(defun my/find-file-for-id (id)
  "Find the file path for the given ID using Org-Roam, Org-Id, or local search."
  (let (file)
    (my/debug-log "Finding file for ID: %s" id)
    ;; Try Org-Roam database first
    (when (fboundp 'org-roam-node-from-id)
      (let ((node (org-roam-node-from-id id)))
        (setq file (when node (org-roam-node-file node)))
        (when file (my/debug-log "Found via Org-Roam: %s" file))))
    ;; Try Org-Id fallback
    (unless file
      (setq file (car (org-id-find id)))
      (when file (my/debug-log "Found via Org-Id: %s" file)))
    ;; Try local directory search (crucial for mobile offline sync)
    (unless file
      (let ((dir (file-name-directory buffer-file-name)))
        (when dir
          (let ((files (directory-files dir t "\\.org$")))
            (dolist (f files)
              (unless file
                (with-current-buffer (find-file-noselect f)
                  (save-excursion
                    (goto-char (point-min))
                    (when (re-search-forward
                           (concat "^:ID:[ \t]*" (regexp-quote id) "$")
                           nil t)
                      (setq file f)
                      (my/debug-log "Found via local search: %s" f))))))))))
    (unless file
      (my/debug-log "ERROR: Could not find file for ID: %s" id))
    file))

(defun my/is-person-node (node-id)
  "Check if the node with NODE-ID is a person node."
  (my/debug-log "Checking if ID is a person node: %s" node-id)
  (let* ((file (my/find-file-for-id node-id))
         is-person)
    (when file
      (my/debug-log "Checking file contents directly: %s" file)
      (with-current-buffer (find-file-noselect file)
        (save-excursion
          (goto-char (point-min))
          (let ((found (re-search-forward
                        "^#\\+filetags:[ \t]*.*person" nil t)))
            (if found
                (progn
                  (my/debug-log "Match found in file content: %s"
                                (match-string 0))
                  (setq is-person t))
              (my/debug-log "No 'person' tag match in file content"))))))
    is-person))

(defun my/get-node-title (node-id)
  "Get the title of the node with NODE-ID."
  (let ((file (my/find-file-for-id node-id)))
    (when file
      (with-current-buffer (find-file-noselect file)
        (save-excursion
          (goto-char (point-min))
          (when (re-search-forward "^#\\+title:[ \t]*\\(.*\\)$" nil t)
            (string-trim (match-string 1))))))))

(defun my/append-link-under-headings (file-path year month link-str)
  "Open FILE-PATH and append LINK-STR under Year and Month headings."
  (my/debug-log "Appending link to central index: %s" file-path)
  (with-current-buffer (find-file-noselect file-path)
    (save-excursion
      (goto-char (point-min))
      (let ((year-heading (concat "* " year))
            (month-heading (concat "** " year "-" month)))
        ;; Find or create Year heading
        (if (re-search-forward
             (concat "^" (regexp-quote year-heading) "$") nil t)
            (progn
              (my/debug-log "Found Year heading: %s" year-heading)
              (org-end-of-subtree t t))
          (my/debug-log "Creating Year heading: %s" year-heading)
          (goto-char (point-max))
          (unless (bolp) (insert "\n"))
          (insert "\n" year-heading "\n"))

        ;; Search within this subtree for the Month heading
        (goto-char (point-min))
        (if (re-search-forward
             (concat "^" (regexp-quote year-heading) "$") nil t)
            (let ((end-of-year (save-excursion
                                 (org-end-of-subtree t t) (point))))
              (if (re-search-forward
                   (concat "^" (regexp-quote month-heading) "$")
                   end-of-year t)
                  (let ((end-of-month (save-excursion
                                        (org-end-of-subtree t t) (point))))
                    (my/debug-log "Found Month heading: %s" month-heading)
                    (goto-char (match-beginning 0))
                    (if (re-search-forward
                         (regexp-quote link-str) end-of-month t)
                        (my/debug-log "Duplicate link detected, skipping")
                      (my/debug-log "Inserting link under month heading")
                      (goto-char end-of-month)
                      (unless (bolp) (insert "\n"))
                      (insert "  " link-str "\n")))
                (my/debug-log "Creating Month heading: %s" month-heading)
                (goto-char end-of-year)
                (unless (bolp) (insert "\n"))
                (insert "\n" month-heading "\n\n  " link-str "\n")))
          (my/debug-log "ERROR: Failed to find Year heading subtree")
          (goto-char (point-max))
          (insert "\n" year-heading "\n"
                  month-heading "\n\n  " link-str "\n"))))
(save-buffer)))

(defun my/append-link-to-person-file (file-path person-title link-str)
  "Open FILE-PATH of a person and append LINK-STR under its only heading."
  (my/debug-log "Appending link to person file: %s" file-path)
  (with-current-buffer (find-file-noselect file-path)
    (save-excursion
      (goto-char (point-min))
      ;; Find the first level-1 heading (independent of its actual text)
      (if (re-search-forward "^\\* " nil t)
          (let ((end-of-subtree (save-excursion
                                  (org-end-of-subtree t t) (point))))
            (my/debug-log "Found first level-1 heading")
            (goto-char (match-beginning 0))
            (if (re-search-forward
                 (regexp-quote link-str) end-of-subtree t)
                (my/debug-log
                 "Duplicate link detected in person file, skipping")
              (my/debug-log "Inserting link under heading")
              (goto-char end-of-subtree)
              (unless (bolp) (insert "\n"))
              (insert "  " link-str "\n")))
        (my/debug-log "No heading found in person file, appending to end")
        (goto-char (point-max))
        (unless (bolp) (insert "\n"))
        (unless (re-search-backward (regexp-quote link-str) nil t)
          (goto-char (point-max))
          (insert "\n* Dreams featuring " person-title "\n\n  "
                  link-str "\n"))))
    (save-buffer)))

(defun my/org-roam-index-dream-on-save ()
  "Hook function to index the current dream node upon saving."
  (my/debug-log "Save hook triggered for: %s" (buffer-file-name))
  (when (and (derived-mode-p 'org-mode)
             buffer-file-name
             (save-excursion
               (goto-char (point-min))
               (re-search-forward "^#\\+filetags:[ \t]*:dream:" nil t)))
    (my/debug-log "Confirmed file is a dream node")
    (let (title id date)
      (save-excursion
        (goto-char (point-min))
        (when (re-search-forward "^#\\+title:[ \t]*\\(.*\\)$" nil t)
          (setq title (string-trim (match-string 1))))
        (goto-char (point-min))
        (when (re-search-forward "^:ID:[ \t]*\\(.*\\)$" nil t)
          (setq id (string-trim (match-string 1))))
        (goto-char (point-min))
        (when (re-search-forward
               "^:created:[ \t]*\\([0-9]\\{4\\}\\)-\\([0-9]\\{2\\}\\)" nil t)
          (setq date (list (match-string 1) (match-string 2)))))

      (my/debug-log "Metadata extracted:")
      (my/debug-log " - ID: %s" id)
      (my/debug-log " - Title: %s" title)
      (my/debug-log " - Date: %s" date)

      (unless id
        (setq id (org-id-get-create))
        (my/debug-log "Created missing ID: %s" id))

      ;; Exclude the central index file from auto-indexing itself
      (unless (or (null id)
                  (string= id "947ffe5d-e75f-4f99-8c17-82fe190ca665"))
        (unless date
          (setq date (list (format-time-string "%Y")
                           (format-time-string "%m"))))

        (let* ((year (car date))
               (month (cadr date))
               (link-str (concat "[[id:" id "][" title "]]"))
               (linked-ids
                (save-excursion
                  (goto-char (point-min))
                  (let (ids)
                    (while (re-search-forward "\\[\\[id:\\([^]]*\\)\\]" nil t)
                      (push (match-string 1) ids))
                    (delete-dups ids)))))

          (my/debug-log "Found linked IDs: %s" linked-ids)

          ;; Update central dreams index (using your specific ID)
          (let* ((dreams-file (my/find-file-for-id
                               "947ffe5d-e75f-4f99-8c17-82fe190ca665")))
            (if dreams-file
                (my/append-link-under-headings
                 dreams-file year month link-str)
              (my/debug-log "ERROR: Could not find dreams.org index file")))

          ;; Update person registers (only for person nodes)
          (dolist (linked-id linked-ids)
            (unless (string= linked-id "947ffe5d-e75f-4f99-8c17-82fe190ca665")
              (my/debug-log "Processing linked ID: %s" linked-id)
              (if (my/is-person-node linked-id)
                  (let ((file (my/find-file-for-id linked-id))
                        (person-title (my/get-node-title linked-id)))
                    (if file
                        (my/append-link-to-person-file
                         file person-title link-str)
                      (my/debug-log "ERROR: File for person ID %s not found"
                                    linked-id)))
                (my/debug-log "ID %s is not a person node, skipping"
                              linked-id)))))))))

;; Automate indexing every time you save an Org file on mobile or PC
(add-hook 'after-save-hook #'my/org-roam-index-dream-on-save)

;; ====================| END MY FUNCTIONS |====================

;;; ====================| END MELT's EMACS CONFIGURATION |===============
;;; end dotemacs.el
