(in-package :utils)

(defparameter natural
  (make-instance 'seq 
                 :iterator (lambda (h) (cons (1+ (car h)) h))
                 :extractor #'car))

(defun primep (n)
  (not (or (evenp n)
           (let ((m (truncate (sqrt n))))
             (do ((i 3 (+ i 2)))
                 ((or (zerop (mod n i)) (> i m)) (<= i m)))))))

(defun next-prime (n)
  (if (evenp n)
      (next-prime (1+ n))
      (do ((i (+ 2 n) (+ 2 i)))
          ((primep i) i))))

(defun run-all-tests ()
   (and (equal (take 10 (lfilter #'primep natural) '(2)))
          (reverse '(2 3 5 7 11 13 17 19 23 29))
        (equal (take 10 (lmap (lambda (x) (* x x)) 
                                       (lfilter #'evenp natural '(0))))
               (reverse '(0 1 4 9 16 25 36 49 64 81)))))

