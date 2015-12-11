(defpackage :utils
   (:use :common-lisp :asdf :cl-ppcre)
   (:export :->> :-> :lreduce :lmap :lfilter
            :merge-with :lazy-seq :take :until
            :entropy :transpose))

(in-package :utils)

(defsystem :utils
  :author "Atabey Kaygun (atabey_kaygun@hotmail.com)"
  :description "A very rudimentary functional lazy sequence library"
  :licence "BSD"
  :version "1.0"
  :components ((:file "lazy")
               (:file "clojure" :depends-on ("lazy"))
               (:file "data" :depends-on ("lazy" "clojure")))
  :depends-on (:cl-ppcre))
