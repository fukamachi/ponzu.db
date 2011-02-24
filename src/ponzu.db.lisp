#|
  This file is a part of PonzuDB package.
  URL: http://github.com/fukamachi/ponzu.db
  Copyright (c) 2011 Eitarow Fukamachi <e.arrows@gmail.com>

  PonzuDB is freely distributable under the LLGPL License.
|#

#|
  Ponzu.Db main package.

  Author: Eitarow Fukamachi (e.arrows@gmail.com)
|#

(ponzu.db.util:namespace ponzu.db
  (:use :cl)
  (:import-from :ponzu.db.table
                :<ponzu-db-table>
                :deftable
                :create-instance
                :fetch)
  (:import-from :ponzu.db.record
                :<ponzu-db-record>
                :save
                :destroy
                :attributes)
  (:export :<ponzu-db-table>
           :deftable
           :create-instance
           :fetch
           :<ponzu-db-record>
           :save
           :destroy
           :attributes))
