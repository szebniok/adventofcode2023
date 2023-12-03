(def input (with [f (file/open "day3input.txt")] (file/read f :all)))

(def grid-peg
  (peg/compile ~{:part (group (* (line) (column) (number :d+) (column)))
                 :symbol (if-not (+ "." :d :s) (group (* (line) (column) (<- 1))))
                 :main (any (+ :part :symbol "." :s))}))

(def parsed-elements (peg/match grid-peg input))

(var coords-to-parts @{})
(each elem parsed-elements
  (match elem
    [line from value to] (for x from to
                              (update coords-to-parts [x line]
                                      |(array/push (or $ @[]) value)))))

(var result 0)
(each elem parsed-elements
  (match elem
    [_ _ _ _] nil
    [line column s]
    (+= result
        (-> (catseq [y :range-to [(- line 1) (+ line 1)]
                      x :range-to [(- column 1) (+ column 1)]
                      :let [around (get coords-to-parts [x y])]
                      :unless (nil? around)]
               around) (frequencies) (keys) (sum)))))
(print result)

# 2 star
(set result 0)
(each elem parsed-elements
  (match elem
    [_ _ _ _] nil
    [line column "*"]
    (+= result 
        (-> (catseq [y :range-to [(- line 1) (+ line 1)]
                 x :range-to [(- column 1) (+ column 1)]
                 :let [around (get coords-to-parts [x y])]
                 :unless (nil? around)]
          around) (frequencies) (keys) (|(if (= (length $) 2) (product $) 0)))
        )))
(print result)