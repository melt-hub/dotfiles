;;; dotemacs.el
;;; ====================| MELT's EMACS CONFIGURATION |===============

;; ====================| STARTUP |====================

(message "[CIRO]: Yo melt!")

;; Set directory paths
(defvar os-packages-path "~/dotfiles/emacs/packages/")
(defvar org-dir-path "~/zk/")

(defvar my/org-university "Università di Milano Bicocca"
  "Default university for scientific papers.")

(defvar my/org-email "melt@campus.unimib.it"
  "Default email address for academic exports.")

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

(use-package nyan-mode
  :ensure t
  :config
  (nyan-mode))

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

;; --------------- rust development ---------------
;; Major mode for editing Rust source code
(use-package rust-mode
  :ensure t
  :mode "\\.rs\\'")

;; Compiler and dependency manager interaction
(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode)
  :config
  (setq cargo-minor-mode-key-prefix (kbd "C-c C-k"))
  (setq cargo-process--command-flags '("--color" "always")))

;; High-performance terminal emulator inside Emacs
(use-package vterm
  :ensure t
  :config
  (setq vterm-max-scrollback 10000))

;; Manual shortcut bindings for compilation and terminal tasks
(with-eval-after-load 'rust-mode
  (define-key rust-mode-map (kbd "C-c C-k b") 'cargo-process-build)
  (define-key rust-mode-map (kbd "C-c C-k r") 'cargo-process-run)
  (define-key rust-mode-map (kbd "C-c C-k t") 'cargo-process-test)
  (define-key rust-mode-map (kbd "C-c C-k c") 'cargo-process-check)
  (define-key rust-mode-map (kbd "C-c C-v") 'vterm))
;; --------------- end rust development ---------------

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

;; (use-package tex
;;  :ensure auctex
;;  :config
;;  (setq-default TeX-master nil)
;;  (setq TeX-parse-self t)
;;  (setq TeX-auto-save t))

(use-package org-fragtog
  :ensure t
  :hook (org-mode . org-fragtog-mode))

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
          `(("t" "Todo [Inbox]" entry (file+headline ,agenda-path "Inbox")
             "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:" :empty-lines 1)
            ("a" "Appointment" entry 
             (file+headline ,agenda-path "Tasks & Appointments")
             ,(concat "* %^{Description} :appo:\n%^t\n:PROPERTIES:\n"
                      ":CONTACT: %^{Who}\n:LOCATION: %^{Where}\n"
                      ":CREATED: %U\n:END:") :empty-lines 1)
            ("k" "Task" entry
             (file+headline ,agenda-path "Tasks & Appointments")
             ,(concat "* TODO %^{Description} :task:\nSCHEDULED: %^t\n"
                      ":PROPERTIES:\n:CONTACT: %^{Who}\n"
                      ":LOCATION: %^{Where}\n:CREATED: %U\n:END:")
             :empty-lines 1)
            ("c" "Call" entry 
             (file+headline ,agenda-path "Tasks & Appointments")
             ,(concat "* TODO %^{Name} :call:\nSCHEDULED: %^t\n"
                      ":PROPERTIES:\n:CONTACT: %\\1\n:CREATED: %U\n:END:")
             :empty-lines 1)
            ("b" "Birthday" entry 
             (file+headline ,agenda-path "Birthdays & Recurrences")
             ,(concat "* Compleanno %^{Who} :bday:\n"
                      "%(concat \"<\" (org-read-date) \" +1y>\")")
             :empty-lines 1)
            ("p" "Project" entry (file+headline ,agenda-path "Projects")
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

  ;; Custom minimal class for CS papers (uses external cs-paper-style.sty)
  (with-eval-after-load 'ox-latex
    (add-to-list 'org-latex-classes
                 '("cs-paper"
                   "\\documentclass[11pt]{article}
[DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]
\\usepackage{cs-paper-style}"
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
        `(("d" "default (uni)" plain "%?"
           :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                       "#+title: ${title}\n#+author: melt\n"
                                       "#+filetags: :uni:"))
           :unnarrowed t)
          ("s" "scrap" plain "%?"
           :target (file+head "scraps/%<%Y%m%d%H%M%S>-${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                       "#+title: ${title}\n#+author: melt\n"
                                       "#+filetags: :scrap:"))
           :unnarrowed t)
          ("r" "dream" plain "%?"
           :target (file+head "dreams/%<%Y%m%d%H%M%S>-${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                       "#+title: ${title}\n#+author: melt\n"
                                       "#+filetags: :dream:"))
           :unnarrowed t)
          ("p" "paper" plain "%?"
           :target (file+head "papers/%<%Y%m%d%H%M%S>-${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                       "#+title: ${title}\n"
                                       "#+author: melt\n"
                                       "#+email: " my/org-email "\n"
                                       "#+latex_class: cs-paper\n"
                                       "#+latex_header: \\author{melt}\n"
                                       "#+latex_header: \\affil{"
                                       my/org-university
                                       " \\\\ \\texttt{" my/org-email "}}\n"
                                       "#+filetags: :paper:\n\n"
                                       "#+begin_abstract\n"
                                       "%?\n"
                                       "#+end_abstract\n\n"
                                       "* Introduction\n\n"
                                       "* Bibliography\n"))
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

;; ====================| END MY FUNCTIONS |====================

;;; ====================| END MELT's EMACS CONFIGURATION |===============
;;; end dotemacs.el
