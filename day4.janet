(def input (with [f (file/open "day4input.txt")] (file/read f :all)))

(def games
  (peg/match ~{:numbers (group (some (* (? :s+) (number :d+))))
               :card (group (* "Card" :s+ (number :d+) ": " :numbers " |" :numbers))
               :main (some (* :card (? :s*)))} input))

(defn matching-numbers-count [[id winning ours]]
  (let [winning-map (frequencies winning)]
    (count |(get winning-map $) ours)))
(print (sum (map |(->> $ (matching-numbers-count) (|(- $ 1)) (math/pow 2) (math/floor)) games)))

# 2 star
(def card-copies (frequencies (map 0 games)))
(each [id winning ours] games
  (let [copies (get card-copies id)
        matches (matching-numbers-count [id winning ours])]
    (loop [i :range-to [(+ id 1) (min (length games) (+ id matches))]]
      (update card-copies i |(+ $ copies)))))1
(print (sum (values card-copies)))