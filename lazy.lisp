(in-package :utils)

(defclass seq ()
  ((iterator :accessor iterator
             :initarg :iterator)
   (extractor :accessor extractor
              :initarg :extractor)))

(defmethod take (n (xs seq) &optional (head nil) (term nil))
  (do* ((i (1- n) (1- i))
        (res (list (funcall (extractor xs) head))
             (cons (funcall (extractor xs) h) res))
        (h (funcall (iterator xs) head)
           (funcall (iterator xs) h)))
       ((or (zerop i) (equal h term)) (reverse (cdr res)))))

(defmethod until (pred (xs seq) head)
  (do* ((h head (funcall (iterator xs) h)))
       ((funcall pred (funcall (extractor xs) h)) h)))

(defmethod lmap (fn (xs seq))
  (make-instance 'seq
                 :iterator (iterator xs)
                 :extractor (lambda (h) (funcall fn (funcall (extractor xs) h)))))

(defmethod lfilter (pred (xs seq))
  (make-instance 'seq
                 :iterator (lambda (h) (until pred xs (funcall (iterator xs) h)))
                 :extractor (extractor xs)))

(defmethod lreduce (reducer init (xs seq) &optional (head nil) (term nil))
  (reduce reducer
          (take 0 xs head term)
          :initial-value init))

(defun lazy-seq (file fn &optional (term nil))
  (make-instance 'seq
                 :iterator (lambda (h) (read-line file term))
                 :extractor (lambda (h) (funcall fn (read-line file term)))))

