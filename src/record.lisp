(ponzu.db.util:namespace ponzu.db.record
  (:use :cl)
  (:import-from :clsql
                :update-records-from-instance
                :delete-instance-records)
  (:export :<ponzu.db.record>
           :save
           :destroy))

(defclass <ponzu-db-record> () ())

(defmethod save ((this <ponzu-db-record>))
  (update-records-from-instance this))

(defmethod destroy ((this <ponzu-db-record>))
  (delete-instance-records this))
