(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("f41ecd2c34a9347aeec0a187a87f9668fa8efb843b2606b6d5d92a653abe2439" default)))
 '(package-selected-packages
   (quote
    (org-tree-slide docker-compose-mode go-mode exwm go-autocomplete ruby-tools haskell-mode groovy-mode klere-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(load-theme 'exotica t)
(global-linum-mode t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq make-backup-files nil)
(recentf-mode 1)
(global-set-key (kbd "<f7>") 'recentf-open-files)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(toggle-frame-maximized)
(display-time-mode 1)
(display-battery-mode 1)
(setq column-number-mode t)
(ido-mode 1)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(setq ido-file-extension-order '(".org" ".txt" ".csv"))
(electric-indent-mode 1)
(ido-grid-mode 1)
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda() (org-bullets-mode 1)))
(require 'iedit)
(require 'highlight-indent-guides)
(add-hook 'groovy-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'column)
