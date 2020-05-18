(import sumtype)
(do
  (sumtype/declare maybe
                   [just a]
                   [nothing])

  (def v0 (nothing))
  (def v1 (just 1))

  # (pp v0)
  # (pp v1)

  (assert (true? (maybe? v0)))
  (assert (true? (nothing? v0)))
  (assert (true? (just? v1)))

  (var c 0)
  (try
    (just nil) # should signal an error
    ((err)
     (set c 1)))
  (assert (= c 1))

  (match v0
    {:just x} (printf "v0: %d" x)
    {:nothing _} (print "v0: <nothing>"))

  (match v1
    {:just x} (printf "v1: %d" x)
    {:nothing _} (print "v1: <nothing>"))
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

  (defn do-stuff [i r]
    (match r
      {:ok v} (print (string "OK: " i " " v))
      {:err e} (print (string "ERR: " i " " e))))

  (do-stuff "v0" v0)
  (do-stuff "v1" v1)
  )
