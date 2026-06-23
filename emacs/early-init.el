;;; early-init.el --- Early initialization configurations-

;; Temporarily extend garbage collector threshold to reduce overhead during
;; startup
(setq gc-cons-threshold 100000000)

;; Save original file-name-handler-alist and disable it during initialization
(defvar my/file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Restore the original file-name-handler-alist after initialization completes
(add-hook 'after-init-hook
          (lambda ()
            (setq file-name-handler-alist my/file-name-handler-alist-original)))

;; Disable graphical user interface components before rendering the initial
;; frame
(setq menu-bar-mode nil)
(setq tool-bar-mode nil)
(setq scroll-bar-mode nil)

;; Prevent the brief rendering and subsequent hiding of GUI bars on modern frame creation
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)