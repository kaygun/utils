(in-package :utils)

(defclass seq ()
  ((iterator :accessor iterator
             :initarg :iterator)
   (extractor :accessor extractor
              :initarg :extractor)))

(defmethod pull ((xs seq) head)
  (funcall (extractor xs) head))

(defmethod next ((xs seq) head)
  (funcall (iterator xs) head))

(defmethod take (n (xs seq) head)
  (do* ((i (1- n) (1- i))
        (h head (next xs h))
        (res (list (pull xs head)) (cons (pull xs h) res)))
       ((zerop i) res)))

(defmethod until (pred (xs seq) head)
  (do* ((h head (next xs h)))
       ((funcall pred (pull xs h)) h)))

(defmethod lmap (fn (xs seq))
  (make-instance 'seq
                 :iterator (iterator xs)
                 :extractor (lambda (h) (funcall fn (pull xs h)))))

(defmethod lfilter (pred (xs seq))
  (make-instance 'seq
                 :iterator (lambda (h) (until pred xs (next xs h)))
                 :extractor (extractor xs)))

(defmethod lreduce (reducer init halt (xs seq) head)
  (reduce reducer
          (until (lambda (x) (equal x halt)) xs head)
          :initial-value init))

(defun lazy-seq (file fn)
  (make-instance 'seq
                 :iterator (lambda (h) (read-line file h))
                 :extractor fn))

