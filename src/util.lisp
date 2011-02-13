(in-package :cl-user)

(defpackage ponzu.db.util
  (:use :cl)
  (:export :namespace))

(in-package :ponzu.db.util)

(defmacro namespace (name &rest body)
  `(progn
     (in-package :cl-user)
     (defpackage ,(symbol-name name) ,@body)
     (in-package ,(symbol-name name))))
