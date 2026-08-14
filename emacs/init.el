;;; init.el --- Melt's Emacs Initialization  -*- lexical-binding: t; -*-

;; Register the modules directory in the load path
(add-to-list 'load-path (expand-file-name "modules" user-emacs-directory))

;; Load each module in chronological order
(require 'my-startup)
(require 'my-general)
(require 'my-functions)
(require 'my-packages)
(require 'my-email)

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )