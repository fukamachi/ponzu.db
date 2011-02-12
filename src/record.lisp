(ponzu.db.util:namespace ponzu.db.record
  (:use :cl)
  (:export :<ponzu.db.record>
           :save))

(defclass <ponzu.db.record> () ())

(defmethod save ((this <ponzu.db.record>)))
