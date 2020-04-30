(defsystem :utils
  :author "Atabey Kaygun (atabey_kaygun@hotmail.com)"
  :description "A collection of utility functions I use regularly."
  :licence "BSD"
  :version "1.0"
  :depends-on (:cl-ppcre :uiop)
  :components ((:file "lazy")
               (:file "clojure" :depends-on ("lazy"))
               (:file "misc" :depends-on ("clojure"))
               (:file "data" :depends-on ("misc"))))

(defpackage :utils
   (:use :common-lisp :asdf :cl-ppcre :uiop))
