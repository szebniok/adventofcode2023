(def input (with [f (file/open "day9input.txt")] (file/read f :all)))

(def readings
  (peg/match ~{:history (group (* (some (* (number (* (opt "-") :d+)) (opt " "))) :s*))
               :main (some :history)} input))

(defn make-diffs [[newest & rest]]
  (if (all zero? newest) [newest ;rest]
      (make-diffs [(catseq [i :range [0 (dec (length newest))]] (- (newest (inc i)) (newest i)))
                   newest ;rest])))

(defn star1 [reading]
  (sum (map last (make-diffs [reading]))))
(print (sum (map star1 readings)))
# 2 star
(defn star2 [reading]
  (reduce2 |(- $1 $0) (map first (make-diffs [reading]))))
(print (sum (map star2 readings)))

