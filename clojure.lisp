(in-package :utils)

(defun merge-with (fn alist)
  (let (res)
    (dolist (current alist res)
      (let ((val (cdr (assoc (car current) res :test #'equal))))
        (if (null val)
            (push current res)
            (rplacd (assoc (car current) res :test #'equal)
                    (funcall fn val (cdr current))))))))

(defmacro ->> (x &rest forms)
  (dolist (f forms x)
    (if (listp f)
        (setf x (append f (list x)))
        (setf x (list f x)))))

(defmacro -> (x &rest forms)
  (dolist (f forms x)
    (if (listp f)
        (setf x (append (list (car f) x) (cdr f)))
        (setf x (list f x))))) 

(defun concurrent-map (fs xs)
  (mapcar (lambda (x) (mapcar (lambda (f) (funcall f x))
                              fs))
          xs))

(defun concurrent-reduce (rs inits xs)
  (mapcar (lambda (r i) (reduce r xs :initial-value i))
          rs inits))

