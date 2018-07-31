
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp/")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (angular-mode monokai-theme ## edbi find-file-in-project hydra corral gradle-mode groovy-imports groovy-mode neotree))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(require 'package)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(require 'corral)
(global-set-key (kbd "M-9") 'corral-parentheses-backward)
(global-set-key (kbd "M-[") 'corral-brackets-backward)
(global-set-key (kbd "M-{") 'corral-braces-backward)
(global-set-key (kbd "M-\"") 'corral-double-quotes-backward)

(require 'iso-transl)
(require 'edbi)
(setq sql-oracle-program "/home/rsali/instantclient10_1/sqlplus")
(add-hook 'sql-interactive-mode-hook
	  (lambda()
	    (toggle-truncate-lines t)))

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(setq sql-connection-alist
      '((qa (sql-product 'oracle)
	    (sql-port 1531)
	    (sql-server "oracle-edreal-qa")
	    (sql-user "callcentertools_uno_own")
	    (sql-password "qauno")
	    (sql-database "qa_db"))))
(load-theme 'monokai t)

;;; Set up for Oracle
(let ((tns-admin (shell-command-to-string ". ~/.zshrc; echo -n $TNS_ADMIN")))
  (if tns-admin
      (setenv "TNS_ADMIN" tns-admin))
  )
(let ((oracle-home (shell-command-to-string ". ~/.zshrc; echo -n $ORACLE_HOME")))
  (if oracle-home
      (setenv "ORACLE_HOME" oracle-home))
  (setenv "PATH" (concat (getenv "PATH")
                         (concat ":" oracle-home)))
  (setenv "LD_LIBRARY_PATH" oracle-home)
  (add-to-list 'exec-path oracle-home)
)

(require 'sqlplus)
    (add-to-list 'auto-mode-alist '("\\.sqp\\'" . sqlplus-mode))

(global-linum-mode t)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(recentf-mode 1)
(global-set-key (kbd "<f7>") 'recentf-open-files)

(require 'org-table)
(defvar sqlplus-x-columns '(sqlplus-x-service sqlplus-x-user sqlplus-x-pwd))
(defun sqlplus-x-connect ()
  "Build a connection string and make a connection. The point must be in an org-mode table.
Columns of the table must correspond to the `sqlplus-x-columns' variable."
  (interactive)
  (org-table-force-dataline)
  (let
      ((cur-row (nth (org-table-current-dline) (org-table-to-lisp)))
       (is-user-selected (= (org-table-current-column) (+ 1 (position 'sqlplus-x-user sqlplus-x-columns)))))
    (sqlplus
     (format
      "%s/%s@%s"
      (if is-user-selected
          (thing-at-point 'symbol)
        (nth (position 'sqlplus-x-user sqlplus-x-columns) cur-row))
      (nth (position 'sqlplus-x-pwd sqlplus-x-columns) cur-row)
      (nth (position 'sqlplus-x-service sqlplus-x-columns) cur-row))
     (concat (nth (position 'sqlplus-x-service sqlplus-x-columns) cur-row) ".sqp")
     )
    ))

(defun myConnect()
  (interactive)
  (org-table-force-dataline)
  (setq cur-line (nth (+ (org-table-current-dline) 1) (org-table-to-lisp)))
  (setq svc (nth 0 cur-line))
  (setq usr (nth 1 cur-line))
  (setq pwd (nth 2 cur-line))
  (setq connection-string (format "%s/%s@%s" usr pwd svc))
  (sqlplus connection-string "SQL input")
  )
(global-set-key [f4] 'myConnect)
