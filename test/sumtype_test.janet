(import ../sumtype)

(do
  (sumtype/declare maybe
                   [just a]
                   [nothing])

  (def v0 nothing)
  (def v1 (just 1))

  (assert (true? (maybe? v0)))
  (assert (true? (nothing? v0)))
  (assert (true? (just? v1)))

  (def [ok err] (protect
                 (just nil))) # should signal an error
  (assert (not ok))

  (assert (match v0
            [:just x] (error "unreachable")
            [:nothing] :ok))

  (assert (match v1
            [:just x] :ok
            [:nothing] (error "unreachable")))

  (defn maybe-map [m f]
    (match m
      [:just x] (just (f x))
      [:nothing] (nothing)))

  (-> (just 1)
      (maybe-map (fn [n] (+ n 1)))
      (match [:just x] x)
      (= 2)
      (assert "should have been incremented"))
  )

(do
  (sumtype/declare result
                   [ok a]
                   [err e])

  (def v0 (err "Some error"))
  (def v1 (ok 100))

  # (pp v0)
  # (pp v1)

  (assert (true? (result? v0)))
  (assert (true? (err? v0)))
  (assert (true? (ok? v1)))

  (var c 0)
  (defn do-stuff [i r]
    (match r
      [:ok v] (set c 11)
      [:err e] (set c 22)))

  (do-stuff "v0" v0)
  (assert (= c 22))
  (do-stuff "v1" v1)
  (assert (= c 11))
  )

(do
  (sumtype/declare
   tree
   [leaf]
   [node v left right])

  (def my-tree
    (node
     1 (node
        2 (node
           3 leaf (node 4 leaf leaf))
        leaf)))

  (printf "%N" my-tree)

  (defn walk [tree func]
    (match tree
      [:leaf] nil
      [:node v left right] (do
                             (func v)
                             (walk left func)
                             (walk right func))))

  (var acc @[])
  (walk my-tree (fn [a] (array/push acc a)))
  (assert (deep= acc @[1 2 3 4]))
  )
