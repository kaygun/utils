(in-package :utils)

(defun write-dot (G filename &optional (directed nil) (shape "circle") (engine "dot"))
  (progn 
     (with-open-file (dot-file (format nil "~A.dot" filename) 
 			       :direction :output 
			       :if-exists :supersede
			       :if-does-not-exist :create)
       (if directed
 	   (format dot-file "digraph G {~% node[shape=~a];~% ~{ ~{\"~A\" -> \"~A\"; ~} ~% ~} ~%}~%" shape G)
	   (format dot-file "graph G {~% node[shape=~a]; ~% ~{ ~{\"~A\" -- \"~A\"; ~} ~% ~} }~%" shape G)))
     (uiop:run-program 
          (format nil "~a -T png -o ~A.png ~:*~A.dot" engine filename))
     (format nil "![](~a.png)~%" filename)))


(defun data-plot (filename &optional (title ""))
  (let ((command (format nil "set terminal png; ~
                              set output '~a.png'; ~
                              plot '~:*~a.csv' title '~a';" filename title)))
    (uiop:run-program (format nil "gnuplot -e \"~a\"" command))
    (format nil "![](~a.png)~%" filename)))


(defun r-command (command)
  (cl-ppcre:regex-replace-all
   "\\n"
   (uiop:run-program (format nil "r -e \"~a\"" command) :output :string)
   (format nil "~%  ")))
