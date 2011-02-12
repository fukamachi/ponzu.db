(ponzu.db.util:namespace ponzu.db.table
  (:use :cl
        :closer-mop)
  (:export :<ponzu.db.table>
           :find))

(defclass <ponzu.db.table> (clsql-sys::standard-db-class) ())

#-(or clisp allegro)
(defmethod c2mop:validate-superclass ((class <ponzu.db.table>)
                                      (super standard-class))
  t)

(defmethod allocate-instance ((class <ponzu.db.table>) &key)
  (let ((new-instance (call-next-method)))
    ;; TODO: CREATE TABLE
    ))

(defmethod find ((table <ponzu.db.table>) &rest args)
  )
