(in-package :utils)

(defun partial (&rest args)
  (lambda (x) (append args (list x))))

(defun range (a b &optional carry)
  (if (equal a b)
      (reverse carry)
      (range (1+ a) b (cons a carry))))

(defun repeat (a n &optional carry)
  (if (= n 0)
      carry
      (repeat a (1- n) (cons a carry))))

(defun iterate (n fn val &optional carry)
  (if (= n 0)
      (reverse carry)
      (iterate (1- n) fn (funcall fn val) (cons val carry))))

(defun iterate-until (pred fn val &optional carry)
  (let ((next (funcall fn val)))
    (if (funcall pred next)
	(reverse (cons val carry))
	(iterate-until pred fn next (cons val carry)))))

(defun break-at (pred xs &optional carry)
  (cond ((null xs) (values xs (reverse carry)))
	((funcall pred xs) (values (cdr xs) (reverse (cons (car xs) carry))))
	(t (break-at pred (cdr xs) (cons (car xs) carry)))))

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

(defun juxt (&rest fns)
  (lambda (x)
    (mapcar (lambda (f) (funcall f x)) fns)))

(defun merge-with (fn alist)
  (let (res)
    (dolist (current alist res)
      (let ((val (cdr (assoc (car current) res :test #'equal))))
        (if (null val)
            (push current res)
            (rplacd (assoc (car current) res :test #'equal)
                    (funcall fn val (cdr current))))))))

(defun group-by (xs &optional (fn (lambda (x) x)))
  (let (res)
    (dolist (x xs res)
      (let* ((y (funcall fn x))
             (z (cdr (assoc y res))))
        (if (null z)
            (push (cons y (list x)) res)
            (setf (cdr (assoc y res))
                  (cons x z)))))))

(defun take-every (xs m &optional (k 1) res)
  (cond
    ((null xs) (nreverse res))
    ((= k m) (take-every (cdr xs) m 1 (cons (car xs) res)))
    ((< k m) (take-every (cdr xs) m (1+ k) res))))

(defun drop (xs n)
  (if (or (= n 0) xs)
      xs
      (drop (cdr xs) (1- n))))

(defun take (xs n &optional res)
  (if (or (null xs) (< n 1))
      (nreverse res)
      (take (cdr xs) (1- n) (cons (car xs) res))))

(defun frequencies (xs)
  (let ((ys (make-hash-table :test #'equal))
        (res nil))
    (dolist (x xs)
      (let ((r (gethash x ys)))
        (if r
            (incf (gethash x ys))
            (setf (gethash x ys) 0))))
    (maphash (lambda (key val) (push (cons key val) res)) ys)
    res))

(defun slurp (filename)
  (with-open-file (input filename :direction :input)
    (do* ((line (read-line input nil) (read-line input nil))
          (res line (concatenate 'string res " " line)))
         ((null line) res))))

(defun index-of (x xs &optional (i 0))
  (cond ((null xs) nil)
	((equal x (car xs)) i)
	(t (index-of x (cdr xs) (incf i)))))

(defun update (table key val &optional (fn #'cons))
  (multiple-value-bind (x foundp)
      (gethash key table)
    (if foundp
	(setf (gethash key table) (funcall fn val x))
	(setf (gethash key table) val))))
