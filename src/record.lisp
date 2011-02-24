#|
  This file is a part of PonzuDB package.
  URL: http://github.com/fukamachi/ponzu.db
  Copyright (c) 2011 Eitarow Fukamachi <e.arrows@gmail.com>

  PonzuDB is freely distributable under the LLGPL License.
|#

#|
  Ponzu.Db.Record
  Functions for database records.

  Author: Eitarow Fukamachi (e.arrows@gmail.com)
|#

(ponzu.db.util:namespace ponzu.db.record
  (:use :cl)
  (:import-from :clsql
                :update-records-from-instance
                :delete-instance-records))

(cl-annot:enable-annot-syntax)

@export
(defclass <ponzu-db-record> () ()
  (:documentation "Class for table instances, represents database record."))

@export
(defmethod save ((this <ponzu-db-record>))
  "Save this instance and reflect slot values to database."
  (update-records-from-instance this))

@export
(defmethod destroy ((this <ponzu-db-record>))
  "Delete this instance from the database.
I want to use `delete' for this name, but it is already used in very famous package :p."
  (delete-instance-records this))

@export
(defmethod attributes ((this <ponzu-db-record>))
  "Return a list of slot names."
  (list-attributes this))
