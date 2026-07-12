;; ~/.emacs-mobile-ui.el --- Visual and dashboard configuration

;; Load high-contrast dark theme modus-vivendi (built-in)
(load-theme 'modus-vivendi t)

;; Default text scale zoom for the mobile dashboard
(defvar my/dashboard-zoom 2
  "Default text scale zoom for the mobile dashboard.")

(defun my/get-greeting ()
  "Return an appropriate greeting based on the current hour."
  (let ((hour (string-to-number (format-time-string "%H"))))
    (cond
     ((and (>= hour 5) (< hour 12)) "Good morning")
     ((and (>= hour 12) (< hour 18)) "Good afternoon")
     ((and (>= hour 18) (< hour 22)) "Good evening")
     (t "Good night"))))

(defun my/insert-centered (string &optional face)
  "Insert STRING centered horizontally in the current window, with optional FACE."
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
        (my/insert-centered
         (concat "[CIRO] " (my/get-greeting) " melt!") 'bold)
        (insert "\n")
        
        ;; Left-aligned but cleanly indented recent files list
        (insert "  ")
        (insert (propertize "Recent Files: (r)"
                            'face 'font-lock-variable-name-face))
        (insert "\n")
        
        ;; List up to 10 recent files with corresponding icons
        (if recentf-list
            (let ((count 0))
              (dolist (file recentf-list)
                (when (< count 10)
                  (let* ((abbrev-path (abbreviate-file-name file))
                         (is-dream (string-match-p "/dreams/" file))
                         ;; Brain icon for dreams, pencil for scraps
                         (icon (cond (is-dream "󰧑")
                                     ((string-match-p "/scraps/" file) "")
                                     (t "")))
                         (icon-face (if is-dream
                                        'font-lock-keyword-face
                                      'font-lock-string-face)))
                    (insert "    ")
                    (insert (propertize icon 'face icon-face))
                    (insert "  ")
                    (insert-button abbrev-path
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
               ;; The maximum length of the menu options is 23 characters
               (menu-pad (max 0 (/ (- width 23) 2))))
          (insert (make-string menu-pad ?\s))
          (insert (propertize "[d]   Capture Dream"
                              'face 'font-lock-string-face))
          (insert "\n")
          (insert (make-string menu-pad ?\s))
          (insert (propertize "[s]   Capture Scrap"
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
          (define-key map (kbd "q") 'kill-current-buffer)
          (define-key map (kbd "RET") 'push-button)
          (use-local-map map))
        (setq buffer-read-only t)))
    (switch-to-buffer buf)))