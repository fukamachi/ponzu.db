(ponzu.db.util:namespace ponzu.db-test
  (:use :cl
        :cl-test-more
        :clsql
        :ponzu.db.table))

(plan nil)

(defvar *db* nil)
(setf *db*
      (clsql:connect `(,(namestring
                         (asdf:system-relative-pathname (asdf:find-system :ponzu.db) "t/test.db")))
       :database-type :sqlite3
       :if-exists :old))

(deftable person ()
  ((id
    :db-kind :key
    :db-constraints (:not-null :unique)
    :type integer)
   (name
    :type string)))

(is (fetch 'person 1) nil)

(finalize)
