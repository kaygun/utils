(in-package :utils)

(defun transpose (data)
  (let* ((n (length (car data)))
         (a (loop repeat n collect nil)))
    (mapcar #'reverse
            (reduce (lambda (xs x)
                      (mapcar (lambda (u v) (cons v u)) xs x))
                    data
                    :initial-value a))))

(defun entropy (data)
  (labels ((f (x) (if (or (zerop x) (= x 1))
                      0
                      (* x (log x 2))))
           (g (x y) (- (log x 2) (/ y x))))
    (->> data
         (mapcar (lambda (x) (cons x 1)))
         (merge-with #'+)
         (mapcar #'cdr)
         (concurrent-reduce (list #'+ (lambda (x y) (+ x (f y))))
                            (list 0 0))
         (apply #'g))))

