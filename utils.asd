(defpackage :utils
   (:use :common-lisp :asdf :cl-ppcre)
   (:export ->> -> lreduce lmap lfilter
            merge-with group-by lazy-seq seq take until
            entropy transpose write-dot r-command data-plot
            concurrent-map concurrent-reduce))

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
