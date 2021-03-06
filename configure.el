(defvar whizzy-xemacsp (string-match "XEmacs" emacs-version)
  "Non-nil if we are running in the XEmacs environment.")
(defvar all nil)
(setq all
      (cons
       (cons 10 (concat "$(LIBDIR)/" (if whizzy-xemacsp "xemacs" "emacs")))
       all))

(defun add-one (p dir)
  (let* ((files  (directory-files dir t ".*\\.elc?$"))
         (priority  (if (> (length files) 0) p (+ p 10))))
    (message "FILE=%s --> %d" dir priority)
    (cons priority dir)
    ))

(let ((dirs load-path)
      (dir)
      (home (regexp-quote (expand-file-name "~")))
      (one))
  (while (consp dirs)
    (setq dir (expand-file-name (car dirs)))
    (setq one nil)
    (cond
     ((not (file-directory-p dir)) (message one))
     ((string-match "\\(.*/whizzytex\\)" dir)
      (setq one (cons 0  (match-string 1 dir)))
      )
     ((string-match "\\(.*site-lisp\\).*" dir)
      (setq one (add-one 1 (match-string 1 dir)))
      )
     ((string-match "\\(.*xemacs-packages/lisp\\).*" dir)
      (setq one (add-one 2 (match-string 1 dir)))
      )
     ((string-match home dir)
      (setq one (cons 5 dir))
      )
     (t
      (message dir)
      )
     )
    (or
     (null one)
     (member one all)
     (setq all (cons one all)))
    (setq dirs (cdr dirs))
    )
)
(defun compare (first second) (< (car first) (car second)))

(setq all (sort all 'compare))
(defun printall ()
  (while all
    (princ "FOUND:")
    (princ (cdar all))
    (princ "\n")
    (setq all (cdr all)))
  )

