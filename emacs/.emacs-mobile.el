;; ~/.emacs-mobile.el --- Lightweight mobile capturing configuration

;; Disable unused graphical elements to maximize speed and screen space
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; General settings to decrease startup latency
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Load only Org-mode and Org-id (no heavy external database packages)
(require 'org)
(require 'org-id)
(require 'recentf)

;; Enable built-in recent files tracking
(recentf-mode 1)

;; Load the visual and dashboard interface configuration
(load "~/.emacs-mobile-ui.el" t)

;; Force Emacs to show the custom dashboard as the default startup screen
(setq initial-buffer-choice
      (lambda ()
        (my/dashboard)
        (get-buffer "*Dashboard*")))

(defun my/dream ()
  "Create a new dream node compatible with Org-Roam."
  (interactive)
  ;; Force the dashboard to render in the background before the prompt
  (my/dashboard)
  (redisplay)
  (let* ((title (read-string "Dream Title: "))
         ;; Sanitize the title for the filename
         (slug-1 (replace-regexp-in-string " " "-" title))
         (slug-2 (replace-regexp-in-string "[^a-zA-Z0-9-]" "" slug-1))
         (slug (downcase slug-2))
         (time-str (format-time-string "%Y%m%d%H%M%S"))
         (created-str (format-time-string "%Y-%m-%d %H:%M"))
         (filename (expand-file-name
                    (concat "/storage/emulated/0/Documents/dreams/"
                            time-str "-" slug ".org")))
         (uuid (org-id-new)))
    ;; Create and open the file
    (find-file filename)
    ;; Insert the node template
    (insert (concat ":PROPERTIES:\n"
                    ":ID: " uuid "\n"
                    ":created: " created-str "\n"
                    ":END:\n"
                    "#+title: " title "\n"
                    "#+author: melt\n"
                    "#+filetags: :dream:\n\n"))
    ;; Save immediately to register the ID
    (save-buffer)))

(defun my/scrap ()
  "Create a new scrap node compatible with Org-Roam."
  (interactive)
  ;; Force the dashboard to render in the background before the prompt
  (my/dashboard)
  (redisplay)
  (let* ((title (read-string "Scrap Title: "))
         ;; Sanitize the title for the filename
         (slug-1 (replace-regexp-in-string " " "-" title))
         (slug-2 (replace-regexp-in-string "[^a-zA-Z0-9-]" "" slug-1))
         (slug (downcase slug-2))
         (time-str (format-time-string "%Y%m%d%H%M%S"))
         (created-str (format-time-string "%Y-%m-%d %H:%M"))
         (filename (expand-file-name
                    (concat "/storage/emulated/0/Documents/scraps/"
                            time-str "-" slug ".org")))
         (uuid (org-id-new)))
    ;; Create and open the file
    (find-file filename)
    ;; Insert the node template
    (insert (concat ":PROPERTIES:\n"
                    ":ID: " uuid "\n"
                    ":created: " created-str "\n"
                    ":END:\n"
                    "#+title: " title "\n"
                    "#+author: melt\n"
                    "#+filetags: :scrap:\n\n"))
    ;; Save immediately to register the ID
    (save-buffer)))