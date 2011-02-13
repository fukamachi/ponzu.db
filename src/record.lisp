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
                :delete-instance-records)
  (:export :<ponzu.db.record>
           :save
           :destroy
           :attributes))

(defclass <ponzu-db-record> () ()
  (:documentation "Class for table instances, represents database record."))

(defmethod save ((this <ponzu-db-record>))
  "Save this instance and reflect slot values to database."
  (update-records-from-instance this))

(defmethod destroy ((this <ponzu-db-record>))
  "Delete this instance from the database."
  (delete-instance-records this))

(defmethod attributes ((this <ponzu-db-table>))
  "Return a list of slot names."
  (list-attributes this))
