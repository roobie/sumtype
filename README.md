# sumtype
A macro for Janet for creating sum types.

A sum type is a word in type theory for a tagged union. Using one of these
enable us to define a type that can have `n` distinct shapes, which we can
operate on by e.g. pattern `match`ing on the data.

It is useful for expressing things like the `Maybe` type and even some data
structures, like linked lists and trees.

## Example

### Maybe

```janet
(import sumtype)
(sumtype/declare maybe
                  [just a]
                  [nothing])

(def v0 (nothing))
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
```

### Tree

```janet
(sumtype/declare
  tree
  [leaf]
  [node v left right])

(def my-tree
  (node
    1 (node
      2 (node
          3 (leaf) (node 4 (leaf) (leaf)))
      (leaf))))
(pp my-tree)

(defn walk [tree func]
  (match tree
    [:leaf] nil
    [:node v left right] (do
                            (func v)
                            (walk left func)
                            (walk right func))))

(walk my-tree (fn [a] (printf "%d, " a)))
```
