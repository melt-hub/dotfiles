;; ~/.emacs-mobile-tui.el --- Visual and dashboard configuration

;; Assistant name
(defvar my/assistant "CIRO"
  "Name of the Emacs assistant.")

;; Default text scale zoom for the mobile dashboard
(defvar my/dashboard-zoom 2
  "Default text scale zoom for the mobile dashboard.")

(defun my/get-greeting ()
  "Return an appropriate greeting based on the current hour."
  (let ((hour (string-to-number (format-time-string "%H")))
        (prefix (concat "[" my/assistant "]:")))
    (cond
     ((and (>= hour 4)  (< hour 7))
      (concat prefix " Sei già sveglio o ancora sveglio?"))
     ((and (>= hour 7)  (< hour 12))
      (concat prefix " Buongiorno " my/org-author "!"))
     ((and (>= hour 12) (< hour 18))
      (concat prefix " Buon pomeriggio " my/org-author "!"))
     ((and (>= hour 18) (< hour 24))
      (concat prefix " Buona sera " my/org-author "!"))
     (t
      (concat prefix " Vatt a dorme " my/org-author "!")))))

(defun my/insert-centered (string &optional face)
  "Insert STRING centered horizontally in current window, with optional FACE."
  (let* ((width (window-width))
         (len (length string))
         (pad (max 0 (/ (- width len) 2))))
    (insert (make-string pad ?\s))
    (if face
        (insert (propertize string 'face face))
      (insert string))
    (insert "\n")))

(defun my/open-recent-file (button)
  "Open the file associated with the clicked button."
  (find-file (button-get button 'path)))

(defun my/dashboard ()
  "Create a lightweight native dashboard buffer with recent files."
  (interactive)
  (let ((buf (get-buffer-create "*Dashboard*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        ;; Set the text scale zoom
        (text-scale-set my/dashboard-zoom)
        
        (insert "\n")
        ;; Centered Brain ASCII Art (using fixed padding to preserve alignment)
        (let* ((art (list "      _---~~(~~-_."
                          "    _{        )   )"
                          "  ,   ) -~~- ( ,-' )_"
                          " (  `-,_..`., )-- '_,)"
                          "( ` _)  (  -~( -_ `,  }"
                          "(_-  _  ~_-~~~~`,  ,' )"
                          "  `~ -^(    __;-,((()))"
                          "        ~~~~ {_ -_(())"
                          (concat "               `" "\\" "  }")
                          "                 { }"))
               (width (window-width))
               ;; The maximum line length of the ASCII art is 25 chars
               (pad (max 0 (/ (- width 25) 2))))
          (dolist (line art)
            (insert (make-string pad ?\s))
            (insert (propertize line 'face 'font-lock-keyword-face))
            (insert "\n")))
        
        (insert "\n")
        ;; Centered dynamic greeting
        (my/insert-centered (my/get-greeting) 'bold)
        
        ;; Centered Emacs startup initialization time
        (my/insert-centered
         (concat "System loaded in " (emacs-init-time)) 'shadow)
        (insert "\n")
        
        ;; Left-aligned but cleanly indented recent files list
        (insert "  ")
        (insert (propertize "Recent Files:"
                            'face 'font-lock-variable-name-face))
        (insert "\n")
        
        ;; List up to 8 recent files with the brain icon (filenames only)
        (if recentf-list
            (let ((count 0))
              (dolist (file recentf-list)
                (when (< count 4)
                  (let ((file-name (file-name-nondirectory file)))
                    (insert "    ")
                    ;; Brain icon (udb82 udc91) in magenta
                    (insert (propertize "󰧑" 'face 'font-lock-keyword-face))
                    (insert "  ")
                    (insert-button file-name
                                   'action 'my/open-recent-file
                                   'path file
                                   'follow-link t
                                   'help-echo (concat "Open: " file))
                    (insert "\n")
                    (setq count (1+ count))))))
          (insert "    No recent files found.\n"))
        
        (insert "\n")
        ;; Cohesive, left-aligned and centered action items block
        (let* ((width (window-width))
               ;; The maximum length of the menu options is 27 characters
               (menu-pad (max 0 (/ (- width 27) 2))))
          (insert (make-string menu-pad ?\s))
          (insert (propertize "[d]   Capture Dream"
                              'face 'font-lock-string-face))
          (insert "\n")
          (insert (make-string menu-pad ?\s))
          (insert (propertize "[s]   Capture Scrap"
                              'face 'font-lock-string-face))
          (insert "\n")
          (insert (make-string menu-pad ?\s))
          (insert (propertize "[u]   Capture Uni Note"
                              'face 'font-lock-string-face))
          (insert "\n")
          (insert (make-string menu-pad ?\s))
          (insert (propertize "[i]   Capture Book Index"
                              'face 'font-lock-string-face))
          (insert "\n")
          (insert (make-string menu-pad ?\s))
          (insert (propertize "[q]   Exit Dashboard"
                              'face 'font-lock-string-face))
          (insert "\n"))
        
        ;; Setup keybindings for the dashboard
        (special-mode)
        (let ((map (make-sparse-keymap)))
          (set-keymap-parent map special-mode-map)
          (define-key map (kbd "d") 'my/dream)
          (define-key map (kbd "s") 'my/scrap)
          (define-key map (kbd "u") 'my/uni)
          (define-key map (kbd "i") 'my/index)
          (define-key map (kbd "q") (lambda ()
                                      (interactive)
                                      (kill-current-buffer)
                                      (save-buffers-kill-terminal)))
          (define-key map (kbd "RET") 'push-button)
          (use-local-map map))
        
        ;; Force the cursor to start at the very top of the dashboard
        (goto-char (point-min))
        (setq buffer-read-only t)))
    (switch-to-buffer buf)))