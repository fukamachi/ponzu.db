# PonzuDB - O/R Mapper for Common Lisp

PonzuDB is an O/R Mapper for Common lisp, based on CLSQL.

## Usage

    (deftable person ()
      ((id
        :db-kind :key
        :type integer)
       (name
        :type string
        :initform ""
        :accessor name)))
    
    (let ((me (make-instance 'person)))
      (setf (name me) "Eitarow Fukamachi")
      (save me))
    
    (fetch person :first)
    ;;=> #<PERSON #x3020015CABBD>

## Schema Definition

## Find Records

## New Records

## Delete Records

## Functions
### Table

* deftable
* create
* fetch

### Record

* save
* destroy
* attributes

## Author

* Eitarow Fukamachi

## Copyright

Copyright (c) 2011 Eitarow Fukamachi

## License

Licensed under the LLGPL License.
