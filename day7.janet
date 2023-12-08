(def input (with [f (file/open "day7input.txt")] (file/read f :all)))

(defn deep-to-tuple [mby-arr]
  (if (array? mby-arr) (tuple ;(map deep-to-tuple mby-arr)) mby-arr))

(def hands (deep-to-tuple
            (peg/match ~{:hand (group (* (group (repeat 5 (/ (<- 1) ,keyword))) " " (number :d+) :s*))
                         :main (some :hand)} input)))

(defn get-type [cards]
  (match (sorted-by (fn [x] [((frequencies cards) x) x]) cards)
    [a a a a a] 6
    [_ a a a a] 5
    [a a b b b] 4
    [_ _ a a a] 3
    [_ a a b b] 2
    [_ _ _ a a] 1
    _ 0))

(defn get-cards-ranks [cards]
  (tuple ;(map |(index-of $ [:2 :3 :4 :5 :6 :7 :8 :9 :T :J :Q :K :A]) cards)))

(defn cmp-hands [[a] [b]]
  (< [(get-type a) (get-cards-ranks a)] [(get-type b) (get-cards-ranks b)]))

(print (sum (map (fn [[_ bid] rank] (* bid rank)) (sorted hands cmp-hands) (range 1 (+ (length hands) 1)))))

# 2 star
(defn get-type-2star [cards]
  (let [cards-without-jokers (filter |(not (= :J $)) cards)]
    (match (sorted-by (fn [x] [((frequencies cards-without-jokers) x) x]) cards-without-jokers)
      # 0 jokers
      [_ _ _ _ _] (get-type cards)
      # 1 joker
      [a a a a] 6
      [_ a a a] 5
      [a a b b] 4
      [_ _ a a] 3
      [_ _ _ _] 1
      # 2 jokers
      [a a a] 6
      [_ a a] 5
      [_ _ _] 3
      # 3 jokers
      [a a] 6
      [_ _] 5
      # 4 or 5 jokers
      _ 6)))

(defn get-cards-ranks-2star [cards]
  (tuple ;(map |(index-of $ [:J :2 :3 :4 :5 :6 :7 :8 :9 :T :Q :K :A]) cards)))

(defn cmp-hands-2star [[a] [b]]
  (< [(get-type-2star a) (get-cards-ranks-2star a)] [(get-type-2star b) (get-cards-ranks-2star b)]))

(print (sum (map (fn [[_ bid] rank] (* bid rank)) (sorted hands cmp-hands-2star) (range 1 (+ (length hands) 1)))))