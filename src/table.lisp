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
           :fetch
           :fetch-one
           :fetch-all
           :fetch-by-sql))

(enable-sql-reader-syntax)

(defclass <ponzu-db-table> (standard-db-class) ())

(defun fetch (table ids-or-key &key where order offset limit group-by)
  (etypecase ids-or-key
    (keyword (ecase ids-or-key
               (:first (select :from table :limit 1 :offset offset))
               (:all (select :from table))))
    (number
     (select [*]
             :from (sql-expression :table table)
             :where
             (if where
                 [and [= [id] ids-or-key] where]
                 [= [id] ids-or-key])))
    (cons (select [*]
                  :from (sql-expression :table table)
                  :where
                  (if where
                      [and [in [id] ids-or-key] where]
                      [in [id] ids-or-key])))))

(defmacro deftable (class supers slots &optional cl-options)
  `(prog1
     (clsql:def-view-class ,class ,(cons '<ponzu-db-record> supers)
      ,slots
      ,@(if (find :metaclass `,cl-options :key #'car)
            `,cl-options
            (cons '(:metaclass <ponzu-db-table>) `,cl-options)))
     (unless (table-exists-p ',class)
       (create-view-from-class ',class))))
