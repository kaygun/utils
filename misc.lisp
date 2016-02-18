(in-package :utils)

(defun slurp (filename)
  (with-open-file (input filename :direction :input)
    (do* ((line (read-line input nil) (read-line input nil))
          (res line (concatenate 'string res " " line)))
         ((null line) res))))

(defun concurrent-map (fs xs)
  (mapcar (lambda (x) (mapcar (lambda (f) (funcall f x))
                              fs))
          xs))

(defun concurrent-reduce (rs inits xs)
  (mapcar (lambda (r i) (reduce r xs :initial-value i))
          rs inits))


(defun write-dot (G filename &optional (directed nil))
  (progn 
     (with-open-file (dot-file (format nil "~A.dot" filename) 
 			       :direction :output 
			       :if-exists :supersede
			       :if-does-not-exist :create)
       (if directed
 	   (format dot-file "digraph G {~% node[shape=circle];~% ~{ ~{\"~A\" -> \"~A\"; ~} ~% ~} ~%}~%" G)
	   (format dot-file "graph G {~% node[shape=circle]; ~% ~{ ~{\"~A\" -- \"~A\"; ~} ~% ~} }~%" G)))
     (uiop:run-program 
          (format nil "dot -T png -o ~A.png ~:*~A.dot" filename))
     (format nil "![](~a.png)~%" filename)))


(defun data-plot (filename &optional (title ""))
  (let ((command (format nil "set terminal png; ~
                              set output '~a.png'; ~
                              plot '~:*~a.csv' with lines title '~a`; " filename title)))
    (uiop:run-program (format nil "gnuplot -e \"~a\"" command))
    (format nil "![](~a.png)~%" filename)))


(defun r-command (command)
  (cl-ppcre:regex-replace-all
   "\\n"
   (uiop:run-program (format nil "r -e \"~a\"" command) :output :string)
   (format nil "~%  ")))
