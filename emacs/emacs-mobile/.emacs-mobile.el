;; ~/.emacs-mobile.el --- Core mobile configuration with native Org-Roam

;; ----- Academic Identity and Assistant Variables -----

(defvar my/assistant "CIRO"
  "Name of the Emacs assistant.")

(defvar my/org-author "melt"
  "Default author name for academic and general exports.")

(defvar my/org-university "Università di Milano Bicocca"
  "Default university for scientific papers.")

(defvar my/org-email "melt@campus.unimib.it"
  "Default email address for academic exports.")

(defun my/say (text &rest args)
  "Display a colored assistant log message."
  (apply #'message
         (concat (propertize (concat "[" my/assistant "]")
                             'face 'font-lock-keyword-face)
                 ": " text)
         args))

(my/say "Mobile environment initializing...")

;; --------------- Basic Startup Settings ---------------

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

;; Show line and column number in the mode-line
(line-number-mode 1)
(column-number-mode 1)

;; Auto newline when exceeding 80 columns
(setq-default fill-column 80)
(add-hook 'text-mode-hook #'auto-fill-mode)
(add-hook 'prog-mode-hook #'auto-fill-mode)

;; Load high-contrast dark theme modus-vivendi (built-in)
(load-theme 'modus-vivendi t)

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

;;;; =========================================================================
;;;; 3. Package Configurations (Org & Org-Roam)
;;;; =========================================================================

;; Configure Org
(use-package org
  :defer t
  :config
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
           :target (file+head "uni/${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                       "#+title: ${title}\n"
                                       "#+author: " my/org-author "\n"
                                       "#+filetags: :uni:"))
           :unnarrowed t)
          ("ui" "index" plain "%?"
           :target (file+head "uni/${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n"
                                       ":BOOK_TITLE: %^{Book Title}\n"
                                       ":PDF_PATH: %^{PDF Path}\n:END:\n"
                                       "#+title: ${title}\n"
                                       "#+author: " my/org-author "\n"
                                       "#+filetags: :uni:index:"))
           :unnarrowed t)
          ("up" "paper" plain "%?"
           :target (file+head "uni/papers/${slug}.org"
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
           :target (file+head "dreams/${slug}.org"
                              ,(concat ":PROPERTIES:\n:ID: %(org-id-new)\n"
                                       ":created: %<%Y-%m-%d %H:%M>\n:END:\n"
                                       "#+title: ${title}\n"
                                       "#+author: " my/org-author "\n"
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
                                       "#+title: ${title}\n"
                                       "#+author: " my/org-author "\n"
                                       "#+filetags: :scrap:"))
           :unnarrowed t)))
  (org-roam-db-autosync-mode))

;; Load built-in recentf-mode
(require 'recentf)
(recentf-mode 1)

;; Configure Password Store (pass)
(use-package password-store
  :ensure t
  :defer t
  :config
  (setq password-store-directory
    "/storage/emulated/0/Documents/.password-store")
  (my/say "Password-store core loaded."))

(use-package pass
  :ensure t
  :defer t
  :commands (pass)
  :after password-store
  :config
  (my/say "Password-store (pass) interface ready."))

;; ----------- Dashboard Startup Configuration --------------

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

;; Refresh the dashboard once startup is fully complete, so the
;; init time it shows is the final, accurate value instead of the
;; partial value available while initial-buffer-choice still runs
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (get-buffer "*Dashboard*")
              (my/dashboard))))

;; --------------- Automated Dream Indexing ---------------

;; --- logging foundation ---

(defvar my/dreams-log-buffer "*dreams-indexing*"
  "Name of the buffer used for dreams indexing logs.")

(defun my/setup-dreams-log-buffer (buf)
  "Set up font-lock keywords for the dreams log BUF."
  (with-current-buffer buf
    (unless (local-variable-p 'font-lock-defaults)
      (setq font-lock-defaults
            '((("\\[[0-9]\\{2\\}:[0-9]\\{2\\}:[0-9]\\{2\\}\\]"
                . 'shadow)
               ("\\(/[^ \n\t]+\\|~/[^ \n\t]+\\)"
                . 'font-lock-variable-name-face)
               ("ERROR" . 'font-lock-warning-face)
               ("Confirmed" . 'font-lock-string-face)
               ("Starting" . 'font-lock-function-name-face)
               ("completed" . 'font-lock-string-face))))
      (font-lock-mode 1))))

(defun my/debug-log (format-string &rest args)
  "Log ARGS formatted by FORMAT-STRING into the *dreams-indexing* buffer."
  (let ((buf (get-buffer-create "*dreams-indexing*")))
    (my/setup-dreams-log-buffer buf)
    (with-current-buffer buf
      (save-excursion
        (goto-char (point-max))
        (let ((inhibit-read-only t))
          (insert (concat (format-time-string "[%H:%M:%S] ")
                          (apply #'format format-string args)
                          "\n")))))))

;; --- node resolution and lookup ---

(defun my/find-file-for-id (id)
  "Find the file path for the given ID using Org-Roam, Org-Id, or local search."
  (let (file)
    ;; try Org-Roam database first
    (when (fboundp 'org-roam-node-from-id)
      (let ((node (org-roam-node-from-id id)))
        (setq file (when node (org-roam-node-file node)))))
    ;; try Org-Id fallback
    (unless file
      (require 'org-id nil t)
      (when (fboundp 'org-id-find)
        (setq file (car (org-id-find id)))))
    ;; try local directory search (crucial for mobile offline sync)
    (unless file
      (let ((dir (and buffer-file-name
                      (file-name-directory buffer-file-name))))
        (when dir
          (let ((files (directory-files dir t "\\.org$")))
            (dolist (f files)
              (unless file
                (with-current-buffer (find-file-noselect f)
                  (save-excursion
                    (goto-char (point-min))
                    (when (re-search-forward
                           (concat "^:ID:[ \t]*" (regexp-quote id) "$") nil t)
                      (setq file f))))))))))
    file))

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
              (when (re-search-forward
                     "^#\\+title:[ \t]*\\(.*\\)$" nil t)
                (string-trim (match-string 1)))))))))

;; --- node metadata and validation ---

(defun my/extract-dream-metadata ()
  "Extract metadata from the current dream buffer.
Create a new Org-Id if it is missing.
Return a list of the form (ID TITLE (YEAR MONTH))."
  (save-excursion
    (goto-char (point-min))
    (let (title id date)
      (when (re-search-forward "^#\\+title:[ \t]*\\(.*\\)$" nil t)
        (setq title (string-trim (match-string 1))))
      (goto-char (point-min))
      (if (re-search-forward "^:ID:[ \t]*\\(.*\\)$" nil t)
          (setq id (string-trim (match-string 1)))
        (setq id (org-id-get-create)))
      (goto-char (point-min))
      (when (re-search-forward
             "^:created:[ \t]*\\([0-9]\\{4\\}\\)-\\([0-9]\\{2\\}\\)" nil t)
        (setq date (list (match-string 1) (match-string 2))))
      (list id title date))))

(defun my/get-linked-ids ()
  "Find all Org-Id links in the current buffer.
Return a list of unique ID strings."
  (save-excursion
    (goto-char (point-min))
    (let (ids)
      (while (re-search-forward "\\[\\[id:\\([^]]*\\)\\]" nil t)
        (push (match-string 1) ids))
      (delete-dups ids))))

(defun my/is-person-node (node-id)
  "Check if the node with NODE-ID is a person node."
  (let* ((node (when (fboundp 'org-roam-node-from-id)
                 (org-roam-node-from-id node-id)))
         (tags (when node (org-roam-node-tags node)))
         (file (my/find-file-for-id node-id))
         (has-tag (member "person" tags))
         is-person)
    (if has-tag
        (setq is-person t)
      (when file
        (with-current-buffer (find-file-noselect file)
          (save-excursion
            (goto-char (point-min))
            (when (re-search-forward
                   "^#\\+filetags:.*\\<person\\>" nil t)
              (setq is-person t))))))
    is-person))

;; --- org file modification ---

(defun my/append-link-under-headings (file-path year month link-str)
  "Open FILE-PATH and append LINK-STR under Year and Month headings."
  (with-current-buffer (find-file-noselect file-path)
    (save-excursion
      (goto-char (point-min))
      (let ((year-heading (concat "* " year))
            (month-heading (concat "** " year "-" month)))
        ;; find or create Year heading
        (if (re-search-forward
             (concat "^" (regexp-quote year-heading) "$") nil t)
            (org-end-of-subtree t t)
          (goto-char (point-max))
          (unless (bolp) (insert "\n"))
          (insert "\n" year-heading "\n"))

        ;; search within this subtree for the Month heading
        (goto-char (point-min))
        (if (re-search-forward
             (concat "^" (regexp-quote year-heading) "$") nil t)
            (let ((end-of-year (save-excursion
                                 (org-end-of-subtree t t) (point))))
              (if (re-search-forward
                   (concat "^" (regexp-quote month-heading) "$") end-of-year t)
                  (let ((end-of-month (save-excursion
                                        (org-end-of-subtree t t) (point))))
                    (goto-char (match-beginning 0))
                    (if (re-search-forward
                         (regexp-quote link-str) end-of-month t)
                        (setq status 'duplicate)
                      (goto-char end-of-month)
                      (unless (bolp) (insert "\n"))
                      (insert "  " link-str "\n")))
                (goto-char end-of-year)
                (unless (bolp) (insert "\n"))
                (insert "\n" month-heading "\n\n  " link-str "\n")))
          (goto-char (point-max))
          (insert "\n" year-heading "\n"
                  month-heading "\n\n  " link-str "\n"))))
    (save-buffer)))

(defun my/append-link-to-person-file (file-path person-title link-str)
  "Open FILE-PATH of a person and append LINK-STR under its only heading."
  (with-current-buffer (find-file-noselect file-path)
    (save-excursion
      (goto-char (point-min))
      ;; find the first level-1 heading (independent of its actual text)
      (if (re-search-forward "^\\* " nil t)
          (let ((end-of-subtree (save-excursion
                                  (org-end-of-subtree t t) (point))))
            (goto-char (match-beginning 0))
            (if (re-search-forward
                 (regexp-quote link-str) end-of-subtree t)
                (setq status 'duplicate)
              (goto-char end-of-subtree)
              (unless (bolp) (insert "\n"))
              (insert "  " link-str "\n")
              (setq status 'inserted)))
        (goto-char (point-max))
        (unless (bolp) (insert "\n"))
        (unless (re-search-backward (regexp-quote link-str) nil t)
          (goto-char (point-max))
          (insert "\n* Dreams featuring " person-title "\n\n  "
                  link-str "\n")
          (setq status 'created-heading-and-inserted)))
      (save-buffer)
      (or status 'duplicate))))

;; --- orchestration and save Hook ---

(defun my/process-linked-person-id (linked-id link-str)
  "Process a single LINKED-ID if it is a person node, appending LINK-STR.
Return a status symbol indicating the outcome."
  (unless (string= linked-id "947ffe5d-e75f-4f99-8c17-82fe190ca665")
    (if (my/is-person-node linked-id)
        (let ((file (my/find-file-for-id linked-id))
              (person-title (my/get-node-title linked-id)))
          (if file
              (progn
                (my/append-link-to-person-file
                 file person-title link-str)
                'processed)
            'file-not-found))
      'not-person-node)))

(defun my/process-dream-indexing (id title date linked-ids)
  "Index a dream with ID, TITLE, and DATE, linking it to LINKED-IDS.
Return 'ok or 'missing-index-file."
  (if (or (null id)
          (string= id "947ffe5d-e75f-4f99-8c17-82fe190ca665"))
      'ignored-node
    (let* ((year (or (car date) (format-time-string "%Y")))
           (month (or (cadr date) (format-time-string "%m")))
           (link-str (concat "[[id:" id "][" title "]]"))
           (dreams-file (my/find-file-for-id
                         "947ffe5d-e75f-4f99-8c17-82fe190ca665")))
      (if (null dreams-file)
          'missing-index-file
        (progn
          (my/append-link-under-headings
           dreams-file year month link-str)
          (dolist (linked-id linked-ids)
            (my/process-linked-person-id linked-id link-str))
          'ok)))))

(defun my/org-roam-index-dream-on-save ()
  "Hook function to index the current dream node upon saving."
  (when (and (derived-mode-p 'org-mode)
             buffer-file-name
             ;; prevent the central index from self-indexing
             (not (string-suffix-p "dreams.org" buffer-file-name))
             (save-excursion
               (goto-char (point-min))
               (re-search-forward "^#\\+filetags:.*\\<dream\\>" nil t)))
    (condition-case err
        (let* ((metadata (my/extract-dream-metadata))
               (id (car metadata))
               (title (cadr metadata))
               (date (caddr metadata))
               (linked-ids (my/get-linked-ids)))
          (my/process-dream-indexing id title date linked-ids))
      (error
       (my/debug-log "ERROR in save hook: %s"
                     (error-message-string err))))))

;; --- decoupled logging Advices ---

(defun my/log-find-file-advice (orig-fun id &rest args)
  "Log the start and outcome of `my/find-file-for-id'."
  (my/debug-log "Finding file for ID: %s" id)
  (let ((file (apply orig-fun id args)))
    (if file
        (my/debug-log "Found file: %s" file)
      (my/debug-log "ERROR: Could not find file for ID: %s" id))
    file))

(defun my/log-is-person-node-advice (orig-fun node-id &rest args)
  "Log the check for person node status of NODE-ID."
  (my/debug-log "Checking if ID is a person node: %s" node-id)
  (let* ((node (when (fboundp 'org-roam-node-from-id)
                 (org-roam-node-from-id node-id)))
         (tags (when node (org-roam-node-tags node)))
         (has-tag (member "person" tags))
         (is-person (apply orig-fun node-id args)))
    (if has-tag
        (my/debug-log "Tag 'person' found in Org-Roam DB cache")
      (my/debug-log "Checked file contents directly"))
    (my/debug-log "Person check result for %s: %s"
                  node-id (if is-person "YES" "NO"))
    is-person))

(defun my/log-append-link-under-headings
    (orig-fun file-path year month link-str &rest args)
  "Log the operations performed by `my/append-link-under-headings'."
  (my/debug-log "Appending link to central index: %s" file-path)
  (let ((status (apply orig-fun file-path year month link-str args)))
    (pcase status
      ('duplicate
       (my/debug-log
        "Duplicate link detected in central index, skipping"))
      ('inserted
       (my/debug-log "Inserting link under month heading"))
      ('created-year
       (my/debug-log "Created Year heading and appended link"))
      ('created-month
       (my/debug-log "Created Month heading and appended link"))
      ('error-year-subtree
       (my/debug-log "ERROR: Failed to find Year heading subtree"))
      (_
       (my/debug-log
        "Unknown status during index update: %s" status)))
    status))

(defun my/log-append-link-to-person-file
    (orig-fun file-path person-title link-str &rest args)
  "Log the operations performed by `my/append-link-to-person-file'."
  (my/debug-log "Appending link to person file: %s" file-path)
  (let ((status (apply orig-fun file-path person-title link-str args)))
    (pcase status
      ('duplicate
       (my/debug-log "Duplicate link in person file, skipping"))
      ('inserted
       (my/debug-log "Inserting link under person file heading"))
      ('created-heading-and-inserted
       (my/debug-log
        "Created missing person heading and appended link"))
      (_
       (my/debug-log
        "Unknown status during person update: %s" status)))
    status))

(defun my/log-extract-metadata-advice (orig-fun &rest args)
  "Log metadata extracted by `my/extract-dream-metadata'."
  (let* ((had-id (save-excursion
                   (goto-char (point-min))
                   (re-search-forward "^:ID:" nil t)))
         (res (apply orig-fun args))
         (id (car res)))
    (my/debug-log "Metadata extracted:")
    (unless had-id
      (my/debug-log " - Created missing ID: %s" id))
    (my/debug-log " - ID: %s" id)
    (my/debug-log " - Title: %s" (cadr res))
    (my/debug-log " - Date: %s" (caddr res))
    res))

(defun my/log-process-linked-person-advice
    (orig-fun linked-id link-str &rest args)
  "Log the processing of a LINKED-ID."
  (my/debug-log "Processing linked ID: %s" linked-id)
  (let ((res (apply orig-fun linked-id link-str args)))
    (pcase res
      ('file-not-found
       (my/debug-log "ERROR: File for person ID %s not found"
                     linked-id))
      ('not-person-node
       (my/debug-log "ID %s is not a person node, skipping"
                     linked-id))
      (_ nil))
    res))

(defun my/log-process-indexing-advice
    (orig-fun id title date linked-ids &rest args)
  "Log the dream indexing process."
  (my/debug-log "Starting dream indexing for ID: %s" id)
  (my/debug-log "Found linked IDs:")
  (dolist (linked-id linked-ids)
    (unless (string= linked-id "947ffe5d-e75f-4f99-8c17-82fe190ca665")
      (let ((person-title (my/get-node-title linked-id)))
        (my/debug-log " - ID: %s" linked-id)
        (my/debug-log " - Title: %s" (or person-title "Unknown"))
        (my/debug-log "---"))))
  (let ((res (apply orig-fun id title date linked-ids args)))
    (pcase res
      ('missing-index-file
       (my/debug-log "ERROR: Could not find dreams.org index file"))
      ('ignored-node
       (my/debug-log "Ignored index node matching exclusion rules"))
      ('ok
       (my/debug-log
        "Indexing completed successfully for ID: %s" id)))
    res))

(defun my/log-save-hook-advice (orig-fun &rest args)
  "Log trigger and completion of the save hook."
  (when (and (derived-mode-p 'org-mode)
             buffer-file-name)
    (my/debug-log "Save hook triggered for: %s" buffer-file-name)
    (when (and (not (string-suffix-p "dreams.org" buffer-file-name))
               (save-excursion
                 (goto-char (point-min))
                 (re-search-forward "^#\\+filetags:.*\\<dream\\>" nil t)))
      (my/debug-log "Confirmed file is a dream node")))
  (apply orig-fun args))

;; --- hook and advice registrations ---

(advice-add 'my/find-file-for-id
            :around #'my/log-find-file-advice)
(advice-add 'my/is-person-node
            :around #'my/log-is-person-node-advice)
(advice-add 'my/append-link-under-headings
            :around #'my/log-append-link-under-headings)
(advice-add 'my/append-link-to-person-file
            :around #'my/log-append-link-to-person-file)
(advice-add 'my/extract-dream-metadata
            :around #'my/log-extract-metadata-advice)
(advice-add 'my/process-linked-person-id
            :around #'my/log-process-linked-person-advice)
(advice-add 'my/process-dream-indexing
            :around #'my/log-process-indexing-advice)
(advice-add 'my/org-roam-index-dream-on-save
            :around #'my/log-save-hook-advice)

;; register the auto-indexing hook
(add-hook 'after-save-hook #'my/org-roam-index-dream-on-save)

;; --------------- Capturing Bridge Commands ---------------

;; interactive capturing bridge commands
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

(my/say "Mobile environment loaded successfully.")