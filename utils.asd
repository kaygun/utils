(defpackage :utils
   (:use :common-lisp :asdf :cl-ppcre)
   (:export :all))

(in-package :utils)

(defsystem :utils
  :author "Atabey Kaygun (atabey_kaygun@hotmail.com)"
  :description "A collection of utility functions I use regularly."
  :licence "BSD"
  :version "1.0"
  :components ((:file "lazy")
               (:file "clojure" :depends-on ("lazy"))
               (:file "misc" :depends-on ("clojure"))
               (:file "data" :depends-on ("misc")))
  :depends-on (:cl-ppcre :uiop))
