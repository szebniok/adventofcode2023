(def first-last-number
  (peg/compile ~{:no-numbers (* :a* -1)
                 :first-number (* :a* (number :d))
                 :last-number (+ (* (number :d) :no-numbers) (* 1 :last-number))
                 :main (* :first-number (? :last-number))}))

(defn star1 [line]
  (match (peg/match first-last-number line)
    @[first last] (+ (* first 10) last)
    @[single] (+ (* single 10) single)))

(var result 0)
(with [f (file/open "day1input.txt")]
      (loop [line :iterate (file/read f :line)]
        (+= result (star1 (string/trim line)))))
(print result)

# 2 star

(defn spelled-to-number [str] (case str "one" 1 "two" 2 "three" 3 "four" 4 "five" 5 "six" 6 "seven" 7 "eight" 8 "nine" 9))

(def first-last-number-spelled
  (peg/compile ~{:number (+ (number :d) (/ (<- (+ "one" "two" "three" "four" "five" "six" "seven" "eight" "nine")) ,spelled-to-number))
                 :no-numbers (* (any (if-not :number 1)) -1)
                 :first-number (* (any (if-not :number 1)) :number)
                 :last-number (+ (if (> 1 :no-numbers) :number) (* 1 :last-number))
                 :main (* :first-number (? :last-number))}))

(defn star2 [line]
  (match (peg/match first-last-number-spelled line)
    @[first last] (+ (* first 10) last) 
    @[single] (+ (* single 10) single)))

(set result 0)
(with [f (file/open "day1input.txt")]
      (loop [line :iterate (file/read f :line)]
        (+= result (star2 (string/trim line)))))
(print result)