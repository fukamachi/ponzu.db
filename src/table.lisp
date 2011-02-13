(ponzu.db.util:namespace ponzu.db.table
  (:use :cl)
  (:import-from :clsql
                :enable-sql-reader-syntax
                :create-view-from-class
                :select
                :sql-expression
                :table-exists-p)
  (:import-from :clsql-sys :standard-db-class)
  (:import-from :ponzu.db.record
                :<ponzu-db-record>
                :save)
  (:export :<ponzu-db-table>
           :deftable
           :create
           :fetch))

(enable-sql-reader-syntax)

(defclass <ponzu-db-table> (standard-db-class) ())

(defun create (table &rest initargs)
  (let ((new-instance (apply #'make-instance table initargs)))
    (save new-instance)
    new-instance))

(defun fetch (table ids-or-key &key where order offset limit group-by)
  (etypecase ids-or-key
    (keyword (ecase ids-or-key
               (:first (car (select table :limit 1 :offset offset :flatp t)))
               (:all (select table :flatp t))))
    (number
     (car (select table
                  :where
                  (if where
                      [and [= [id] ids-or-key] where]
                      [= [id] ids-or-key])
                  :flatp t)))
    (cons (select table
                  :where
                  (if where
                      [and [in [id] ids-or-key] where]
                      [in [id] ids-or-key])
                  :flatp t))))

(defmacro deftable (class supers slots &optional cl-options)
  `(prog1
     (clsql:def-view-class ,class ,(cons '<ponzu-db-record> supers)
      ,slots
      ,@(if (find :metaclass `,cl-options :key #'car)
            `,cl-options
            (cons '(:metaclass <ponzu-db-table>) `,cl-options)))
     (unless (table-exists-p ',class)
       (create-view-from-class ',class))))
