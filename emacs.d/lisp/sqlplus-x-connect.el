(require 'sqlplus)
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
     (concat (nth (position 'sqlplus-x-service sqlplus-x-columns) cur-row) ".sqp"))))

(global-set-key [f4] 'sqlplus-x-connect)
