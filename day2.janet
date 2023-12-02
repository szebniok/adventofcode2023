(defn possible? [[color count]] (<= count (case color :red 12 :green 13 :blue 14)))

(defn parse-cube [str]
  (let [@[str-count color] (string/split " " str)]
    [(keyword color) (scan-number str-count)]))

(def games
  (peg/compile ~{:cube (* " " (/ (<- (* :d+ " " :a+)) ,parse-cube) (? (+ "," ";")))
                 :main (* "Game " (/ (<- :d+) ,scan-number) ":" (some :cube) :s*)}))

(defn star1 [line] (let [[id & rest] (peg/match games line)] (if (all possible? rest) id 0)))

(var result 0)
(with [f (file/open "day2input.txt")]
      (loop [line :iterate (file/read f :line)]
        (+= result (star1 line))))
(print result)

# 2 star 
(defn power [draws]
  (let [biggest @{:red 0 :green 0 :blue 0}]
    (each [color count] draws (update biggest color |(max $ count)))
    (* (get biggest :red) (get biggest :green) (get biggest :blue))))

(defn star2 [line] (let [[_ & rest] (peg/match games line)] (power rest)))

(set result 0)
(with [f (file/open "day2input.txt")]
      (loop [line :iterate (file/read f :line)]
        (+= result (star2 line))))
(print result)