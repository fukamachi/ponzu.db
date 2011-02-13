(ponzu.db.util:namespace ponzu.db-test
  (:use :cl
        :cl-test-more
        :clsql
        :ponzu.db.table
        :ponzu.db.record))

(plan nil)

(defvar *db* nil)
(setf *db*
      (clsql:connect `(,(namestring
                         (asdf:system-relative-pathname (asdf:find-system :ponzu.db) "t/test.db")))
       :database-type :sqlite3
       :if-exists :old))

(drop-table 'person :if-does-not-exist :ignore)

(deftable person ()
  ((id
    :db-kind :key
    :db-constraints (:not-null :unique)
    :type integer
    :initform 1)
   (name
    :type string
    :initform "")))

(is (fetch 'person 1) nil "table is empty")

(diag "insert new record")
(let ((me (make-instance 'person)))
  (setf (slot-value me 'name) "Eitarow Fukamachi")
  (save me))
(let ((rec (fetch 'person :first)))
  (is-type rec 'person)
  (is (slot-value rec 'name) "Eitarow Fukamachi" "inserted record"))

(diag "fetch with conditions")
(isnt (fetch 'person :first :conditions '(:name "Eitarow Fukamachi")) nil)

(diag "fetch with where")
(isnt (fetch 'person :first :where "name = \"Eitarow Fukamachi\"") nil)

(diag "update record")
(let ((rec (fetch 'person :first)))
  (setf (slot-value rec 'name) "Tomohiro Matsuyama")
  (save rec))
(let ((rec (fetch 'person :first)))
  (is-type rec 'person)
  (is (slot-value rec 'name) "Tomohiro Matsuyama" "updated"))

(diag "delete")
(destroy (fetch 'person :first))
(is (fetch 'person :first) nil "destroy")

(clsql:disconnect)

(finalize)
