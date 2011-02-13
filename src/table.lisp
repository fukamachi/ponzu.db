#|
  This file is a part of PonzuDB package.
  URL: http://github.com/fukamachi/ponzu.db
  Copyright (c) 2011 Eitarow Fukamachi <e.arrows@gmail.com>

  PonzuDB is freely distributable under the LLGPL License.
|#

#|
  Ponzu.Db.Table
  Functions for database tables.

  Author: Eitarow Fukamachi (e.arrows@gmail.com)
|#

(ponzu.db.util:namespace ponzu.db.table
  (:use :cl)
  (:import-from :clsql
                :enable-sql-reader-syntax
                :create-view-from-class
                :select
                :sql-expression
                :sql-operator
                :table-exists-p)
  (:import-from :clsql-sys :standard-db-class)
  (:import-from :ponzu.db.record
                :<ponzu-db-record>
                :save)
  (:export :<ponzu-db-table>
           :deftable
           :create-instance
           :fetch))

(enable-sql-reader-syntax)

(defclass <ponzu-db-table> (clsql-sys::standard-db-class) ()
  (:documentation "Metaclass for database tables."))

(defun create-instance (table &rest initargs)
  "Same as `make-instance' except for calling `save' it then.

Example:
  (create-instance 'person :name \"Eitarow Fukamachi\")"
  (let ((new-instance (apply #'make-instance table initargs)))
    (save new-instance)
    new-instance))

(defun fetch (table ids-or-key
              &key where conditions order offset limit group-by)
  "Find records from `table' and return it.
`ids-or-key' must be :first, :all, or a number, represents primary key, or the list.

Example:
  ;; Fetch a record, id=1.
  (fetch 'person 1)
  ;; Fetch records, country=jp
  (fetch 'person :conditions '(:country \"jp\"))"
  (etypecase ids-or-key
    (keyword (ecase ids-or-key
               (:first (car (select table :limit 1 :offset offset :flatp t)))
               (:all (select table :flatp t))))
    (number
     (car (select table
                  :where
                  (cond
                    ((and where conditions)
                     [and [= [id] ids-or-key] where (normalize-conditions conditions)])
                    (where [and [= [id] ids-or-key] where])
                    (conditions [and [= [id] ids-or-key] (normalize-conditions conditions)])
                    (t [= [id] ids-or-key]))
                  :flatp t)))
    (cons (select table
                  :where
                  (if where
                      [and [in [id] ids-or-key] where]
                      [in [id] ids-or-key])
                  :flatp t))))

(defmacro deftable (class supers slots &optional cl-options)
  "Define a table schema. This is just a wrapper of `clsql:def-view-class',
so, see CLSQL documentation to get more informations.
<http://clsql.b9.com/manual/def-view-class.html>"
  `(prog1
     (clsql:def-view-class ,class ,(cons '<ponzu-db-record> supers)
      ,slots
      ,@(if (find :metaclass `,cl-options :key #'car)
            `,cl-options
            (cons '(:metaclass <ponzu-db-table>) `,cl-options)))
     (unless (table-exists-p ',class)
       (create-view-from-class ',class))))

(defun normalize-conditions (conditions)
  `(,(sql-operator 'and)
     ,@(loop for (k v) on conditions by #'cddr
             collect [= (sql-expression 'argument k) v])))
