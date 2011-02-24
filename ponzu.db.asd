(in-package :cl-user)

(defpackage ponzu.db-asd
  (:use :cl :asdf))

(in-package :ponzu.db-asd)

(defsystem ponzu.db
  :version "1.0"
  :author "Eitarow Fukamachi"
  :license "LLGPL"
  :depends-on (:clsql
               :cl-annot)
  :components ((:module "src"
                :serial t
                :components
                ((:file "util")
                 (:file "record")
                 (:file "table")))))
