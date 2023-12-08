(def input (with [f (file/open "day8input.txt")] (file/read f :all)))

(def [directions nodes-array]
  (peg/match ~{:directions (group (* (some (/ (<- (+ "L" "R")) ,keyword)) :s*))
               :node-name (/ (<- :a+) ,keyword)
               :node (* :node-name " = (" (group (* :node-name ", " :node-name ")" :s*)))
               :main (* :directions (group (some :node)))} input))

(def nodes (struct ;nodes-array))

(defn travel [&opt pos steps]
  (default pos :AAA)
  (default steps 0)
  (if (= pos :ZZZ) steps
      (let [[left right] (nodes pos)
            direction (directions (mod steps (length directions)))]
        (travel (case direction :L left :R right) (inc steps)))))
(print (travel))

# 2 star
(defn travel-2star [pos &opt steps]
  (default steps 0)
  (if (= (last pos) (chr "Z")) steps
      (let [[left right] (nodes pos)
            direction (directions (mod steps (length directions)))]
        (travel-2star (case direction :L left :R right) (inc steps)))))
(print (reduce2 math/lcm (map travel-2star (filter |(= (last $) (chr "A")) (keys nodes)))))