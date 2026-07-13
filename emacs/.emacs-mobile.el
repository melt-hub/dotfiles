;; ~/.emacs-mobile.el --- Core mobile configuration with native Org-Roam

;; Disable unused graphical elements to maximize speed and screen space
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; General settings to decrease startup latency
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Prevent automatic split screens globally on mobile
(setq pop-up-windows nil)

;; Load high-contrast dark theme modus-vivendi (built-in)
(load-theme 'modus-vivendi t)

;; Add Termux TeX Live binary directory to Emacs PATH and exec-path
(let ((texlive-bin "/data/data/com.termux/files/usr/bin/texlive"))
  (when (file-directory-p texlive-bin)
    (add-to-list 'exec-path texlive-bin)
    (setenv "PATH" (concat texlive-bin ":" (getenv "PATH")))))

;; Initialize package manager and use-package on Termux
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

;; Academic identity variables used in capture templates
(defvar my/org-university "Università di Milano Bicocca"
  "Default university for scientific papers.")

(defvar my/org-email "melt@campus.unimib.it"
  "Default email address for academic exports.")

(defvar my/org-author "melt"
  "Default author name for academic and general exports.")

;; Configure Org
(use-package org
  :defer t
  :config
  (setq org-latex-images-centered t)
  ;; Force capture buffer to open full screen (no split screen on mobile)
  (add-hook 'org-capture-mode-hook #'delete-other-windows))

;; Configure Org-Roam with built-in SQLite engine
(use-package org-roam
  :demand t
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :custom
  (org-roam-directory "/storage/emulated/0/Documents")
  (org-roam-database-connector 'sqlite-builtin)
  :config
  (setq org-roam-capture-templates
        `(("u" "uni")
          ("uu" "uni" plain "%?"
           :target (file+head "uni/%<%Y%m%d%H%M%S>-${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                       "#+title: ${title}\n"
                                       "#+author: " my/org-author "\n"
                                       "#+filetags: :uni:"))
           :unnarrowed t)
          ("ui" "index" plain "%?"
           :target (file+head "uni/%<%Y%m%d%H%M%S>-${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n"
                                       ":BOOK_TITLE: %^{Book Title}\n"
                                       ":PDF_PATH: %^{PDF Path}\n:END:\n"
                                       "#+title: ${title}\n"
                                       "#+author: " my/org-author "\n"
                                       "#+filetags: :uni:index:"))
           :unnarrowed t)
          ("up" "paper" plain "%?"
           :target (file+head "uni/papers/%<%Y%m%d%H%M%S>-${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
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
                                       "* Abstract\n%?\n"
                                       "* Introduction\n\n"
                                       "* Bibliography\n"))
           :unnarrowed t)
          ("d" "dream")
          ("dd" "dream" plain "%?"
           :target (file+head "dreams/%<%Y%m%d%H%M%S>-${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                       "#+title: ${title}\n"
                                       "#+author: " my/org-author "\n"
                                       "#+filetags: :dream:"))
           :unnarrowed t)
          ("dp" "person" plain "%?"
           :target (file+head "dreams/%<%Y%m%d%H%M%S>-${slug}.org"
                              ,(concat ":PROPERTIES:\n"
                                       ":ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n"
                                       ":END:\n"
                                       "#+title: ${title}\n"
                                       "#+filetags: :person:\n\n"
                                       "* Dreams featuring ${title}\n"))
           :unnarrowed t)
          ("s" "scrap" plain "%?"
           :target (file+head "scraps/%<%Y%m%d%H%M%S>-${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                       "#+title: ${title}\n"
                                       "#+author: " my/org-author "\n"
                                       "#+filetags: :scrap:"))
           :unnarrowed t)))
  (org-roam-db-autosync-mode))

;; Load built-in recentf-mode
(require 'recentf)
(recentf-mode 1)

;; Unified indexing log function writing to *dreams-indexing*
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

;; Load the visual and dashboard interface configuration
(load "~/.emacs-mobile-tui.el" t)

(defun my/find-capture-buffer ()
  "Find any active capture buffer currently in Emacs memory."
  (let (found)
    (dolist (buf (buffer-list))
      (when (string-prefix-p "CAPTURE-" (buffer-name buf))
        (setq found buf)))
    found))

;; Force Emacs to show the custom dashboard as the default startup screen
(setq initial-buffer-choice
      (lambda ()
        (or (my/find-capture-buffer)
            (progn
              (my/dashboard)
              (get-buffer "*Dashboard*")))))

;; Shared Lisp indexing procedures for Org-Roam nodes
(defun my/find-file-for-id (id)
  "Find the file path for the given ID using Org-Roam, Org-Id, or local search."
  (let (file)
    (my/debug-log "Finding file for ID: %s" id)
    ;; 1. Try Org-Roam database first
    (when (fboundp 'org-roam-node-from-id)
      (let ((node (org-roam-node-from-id id)))
        (setq file (when node (org-roam-node-file node)))
        (when file (my/debug-log "Found via Org-Roam: %s" file))))
    ;; 2. Try Org-Id fallback
    (unless file
      (setq file (car (org-id-find id))))
    ;; 3. Try local directory search (crucial for mobile offline sync)
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
                           (concat "^:ID:[ \t]*" (regexp-quote id) "$") nil t)
                      (setq file f)
                      (my/debug-log "Found via local search: %s" f))))))))))
    (unless file
      (my/debug-log "ERROR: Could not find file for ID: %s" id))
    file))

(defun my/is-person-node (node-id)
  "Check if the node with NODE-ID is a person node."
  (my/debug-log "Checking if ID is a person node: %s" node-id)
  (let* ((node (when (fboundp 'org-roam-node-from-id)
                 (org-roam-node-from-id node-id)))
         (tags (when node (org-roam-node-tags node)))
         (file (my/find-file-for-id node-id))
         (has-tag (member "person" tags))
         is-person)
    (if has-tag
        (progn
          (my/debug-log "Tag 'person' found in Org-Roam DB cache")
          (setq is-person t))
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
                (my/debug-log "No 'person' tag match in file content")))))))
    is-person))

(defun my/get-node-title (node-id)
  "Get the title of the node with NODE-ID."
  (let* ((node (when (fboundp 'org-roam-node-from-id)
                 (org-roam-node-from-id node-id)))
         (title (when node (org-roam-node-title node)))
         (file (my/find-file-for-id node-id)))
    (or title
        (when file
          (with-current-buffer (find-file-noselect file)
            (save-excursion
              (goto-char (point-min))
              (re-search-forward "^#\\+title:[ \t]*\\(.*\\)$" nil t)
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
                   (concat "^" (regexp-quote month-heading) "$") end-of-year t)
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
          
          ;; 1. Update central dreams index (using your specific ID)
          (let* ((dreams-file (my/find-file-for-id
                               "947ffe5d-e75f-4f99-8c17-82fe190ca665")))
            (if dreams-file
                (my/append-link-under-headings
                 dreams-file year month link-str)
              (my/debug-log "ERROR: Could not find dreams.org index file")))
          
          ;; 2. Update person registers (only for person nodes)
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

;; Interactive capturing bridge commands
(defun my/dream ()
  "Launch native Org-Roam capture for a dream node."
  (interactive)
  (my/dashboard)
  (redisplay)
  (org-roam-capture nil "dd"))

(defun my/scrap ()
  "Launch native Org-Roam capture for a scrap node."
  (interactive)
  (my/dashboard)
  (redisplay)
  (org-roam-capture nil "s"))

(defun my/uni ()
  "Launch native Org-Roam capture for a uni note."
  (interactive)
  (my/dashboard)
  (redisplay)
  (org-roam-capture nil "uu"))

(defun my/index ()
  "Launch native Org-Roam capture for a book index."
  (interactive)
  (my/dashboard)
  (redisplay)
  (org-roam-capture nil "ui"))