(in-package :cl-user)

(defpackage ponzu.db.util
  (:use :cl)
  (:export :namespace
           :get-slots))

(in-package :ponzu.db.util)

(defmacro namespace (name &rest body)
  `(progn
     (in-package :cl-user)
     (defpackage ,(symbol-name name) ,@body)
     (in-package ,(symbol-name name))))

(defun get-slots (object)
  #+openmcl
  (mapcar #'ccl:slot-definition-name
      (#-openmcl-native-threads ccl:class-instance-slots
       #+openmcl-native-threads ccl:class-slots
       (class-of object)))
  #+cmu
  (mapcar #'pcl:slot-definition-name (pcl:class-slots (class-of object)))
  #+sbcl
  (mapcar #'sb-pcl:slot-definition-name (sb-pcl:class-slots (class-of object)))
  #+lispworks
  (mapcar #'hcl:slot-definition-name (hcl:class-slots (class-of object)))
  #+allegro
  (mapcar #'mop:slot-definition-name (mop:class-slots (class-of object)))
  #+sbcl
  (mapcar #'sb-mop:slot-definition-name (sb-mop:class-slots (class-of object)))
  #+clisp
  (mapcar #'clos:slot-definition-name (clos:class-slots (class-of object)))
  #-(or openmcl cmu lispworks allegro sbcl clisp)
  (error "not yet implemented"))
