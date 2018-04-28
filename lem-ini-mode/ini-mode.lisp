(defpackage :lem-ini-mode
  (:use :cl :lem :lem.language-mode)
  (:export :ini-mode
           :*ini-mode-hook*))
(in-package :lem-ini-mode)

(defvar *ini-mode-hook* '())

(defun make-tmlanguage-ini ()
  (make-tmlanguage
   :patterns 
   (make-tm-patterns
    (make-tm-region '(:sequence "[")
                    '(:sequence "]")
                    :name 'syntax-function-name-attribute))))

(defvar *ini-syntax-table* 
  (let ((table (make-syntax-table
                :space-chars '(#\space #\tab #\newline)
                :line-comment-string ";"))
        (tmlanguage (make-tmlanguage-ini)))
    (set-syntax-parser table tmlanguage)
    table))

(define-major-mode ini-mode language-mode
    (:name "ini"
     :keymap *ini-mode-keymap*
     :syntax-table *ini-syntax-table*)
  (setf (variable-value 'enable-syntax-highlight) t
        (variable-value 'line-comment) ";"
        (variable-value 'insertion-line-comment) "; "
        (variable-value 'beginning-of-defun-function) 'beginning-of-section
        (variable-value 'end-of-defun-function) 'end-of-section)
  (run-hooks *ini-mode-hook*))

(defun beginning-of-section (point n)
  (loop :repeat n :do (search-backward-regexp point "^\\[")))

(defun end-of-section (point n)
;; FIXME
  (loop :repeat n
        :do (search-forward-regexp point "^\\[")))

(pushnew (cons "\\.ini$" 'ini-mode) *auto-mode-alist* :test #'equal)
