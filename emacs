(require 'package)

(add-to-list 'load-path (concat (getenv "HOME") ".emacs.d/lisp"))

;; Add MELPA
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))

;; Initalize packages
(package-initialize)

;; Load variables from .zshrc (PATH, etc.)
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-ghc-show-info t)
 '(custom-safe-themes
   (quote
    ("f41ecd2c34a9347aeec0a187a87f9668fa8efb843b2606b6d5d92a653abe2439" default)))
 '(package-selected-packages
   (quote
    (neotree rjsx-mode web-mode markdown-mode rhtml-mode rspec-mode ruby-test-mode alchemist exec-path-from-shell go-eldoc go-rename dockerfile-mode company-quickhelp company-ghci company-ghc org-tree-slide docker-compose-mode go-mode exwm go-autocomplete ruby-tools haskell-mode groovy-mode klere-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; THEME
(load-theme 'exotica t)

;; Line and column number
(global-linum-mode t)
(setq column-number-mode t)

;; Remove startup messsage
(setq inhibit-startup-message t)

;; Remove scratch mesage
(setq initial-scratch-message nil)

;; Don't save backup files
(setq make-backup-files nil)

;; Saves list of recent used files
(recentf-mode 1)

;; List of recent files
(global-set-key (kbd "<f7>") 'recentf-open-files)

;; Hide menu bar
(menu-bar-mode -1)

;; Hide tool bar
(tool-bar-mode -1)

;; Hide scroll bar
(scroll-bar-mode -1)

;;
(toggle-frame-maximized)

;; Show time
(display-time-mode 1)

(ido-mode 0)
(setq ido-everywhere t)
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
(setq ido-create-new-buffer 'always)
(setq ido-file-extension-order '(".org" ".txt" ".csv"))
(electric-indent-mode 1)
(ido-grid-mode 1)

;; ORG mode bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda() (org-bullets-mode 1)))

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;;
(require 'iedit)
(require 'highlight-indent-guides)
(add-hook 'groovy-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'column)

;; HASKELL
(require 'company-ghci)
(push 'company-ghci company-backends)
(add-hook 'haskell-mode-hook 'company-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
;;; To get completions in the REPL
(add-hook 'haskell-interactive-mode-hook 'company-mode)
(put 'downcase-region 'disabled nil)

(company-quickhelp-mode)

;; GO
;;Load Go-specific language syntax
;;For gocode use https://github.com/mdempsky/gocode

(setenv "GOPATH" (concat (getenv "HOME") "/workspace/go"))

;;Custom Compile Command
(defun go-mode-setup ()
  (linum-mode 1)
  (go-eldoc-setup)
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (local-set-key (kbd "M-.") 'godef-jump)
  (setq compile-command "echo Building... && go build -v && echo Testing... && go test -v && echo Linter... && golint")
  (setq compilation-read-command nil)
  ;;  (define-key (current-local-map) "\C-c\C-c" 'compile)
  (local-set-key (kbd "M-,") 'compile))
(add-hook 'go-mode-hook 'go-mode-setup)

;;Load auto-complete
(require 'go-autocomplete)
(require 'auto-complete-config)
(ac-config-default)

;;Go rename

(require 'go-rename)

;;Configure golint
(add-to-list 'load-path (concat (getenv "HOME")  "/workspace/go/src/golang.org/x/lint/misc/emacs"))
(require 'golint)

;;Smaller compilation buffer
(setq compilation-window-height 14)
(defun my-compilation-hook ()
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
        (let* ((w (split-window-vertically))
               (h (window-height w)))
          (select-window w)
          (switch-to-buffer "*compilation*")
          (shrink-window (- h compilation-window-height)))))))
(add-hook 'compilation-mode-hook 'my-compilation-hook)

;;Other Key bindings
(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)

;;Compilation autoscroll
(setq compilation-scroll-output t)

;; File tree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

;; HTML
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; JS
(require 'rjsx-mode)
(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
