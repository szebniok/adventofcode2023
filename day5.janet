(def input (with [f (file/open "day5input.txt")] (file/read f :all)))

(def [seeds & maps]
  (peg/match ~{:seeds (* "seeds:" (group (some (* " " (number :d+)))))
               :map-entry (group (repeat 3 (* :s (number :d+))))
               :map (group (* :s+ (<- :a+) "-to-" (<- :a+) " map:" (some :map-entry)))
               :main (* :seeds (some :map))} input))

(defn get-location [number &opt current-category]
  (default current-category "seed")
  (if (= current-category "location") number
      (let [[_ next-category & entries] (find |(= (0 $) current-category) maps)
            relevant-entry (find (fn [[dest from span]] (<= from number (dec (+ from span)))) entries)
            next-number (if-let [[dest from _] relevant-entry] (+ dest (- number from)) number)]
        (get-location next-number next-category))))
(print (min ;(map get-location seeds)))

# 2 star
(defn get-location-range [lo hi]
  (let [result-lo (get-location lo)
        result-hi (get-location hi)
        span (- hi lo)
        mi (+ lo (math/floor (/ span 2)))]
    (if (= (- result-hi result-lo) span) result-lo
        (min (get-location-range lo mi) (get-location-range (inc mi) hi)))))
(print (min ;(map |(get-location-range (0 $) (+ ;$)) (partition 2 seeds))))