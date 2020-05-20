# sumtype
A macro for Janet for creating sum types

## Example

```janet
(import sumtype)
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
```
