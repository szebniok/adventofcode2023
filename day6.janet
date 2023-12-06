(def input (with [f (file/open "day6input.txt")] (file/read f :all)))

(def [time dist]
  (peg/match ~{:numbers (group (some (* (number :d+) :s*)))
               :main (repeat 2 (* (some (if-not :d 1)) :numbers))} input))

(defn star1 [time dist]
  (let [deltasqr (math/sqrt (- (* time time) (* 4 dist)))
        x1 (+ (/ (- time deltasqr) 2) 0.001)
        x2 (- (/ (+ time deltasqr) 2) 0.001)]
    (- (math/floor x2) (math/ceil x1) -1)))
(print (product (map star1 time dist)))
# 2 star
(print (star1 (scan-number (string ;time)) (scan-number (string ;dist))))