(in-package :cl-user)

(defpackage ponzu.db-test-asd
  (:use :cl :asdf))

(in-package :ponzu.db-test-asd)

(defsystem ponzu.db-test
  :depends-on (:ponzu.db
               :cl-test-more)
  :components ((:module "t"
                :serial t
                :components
                ((:file "core")))))
