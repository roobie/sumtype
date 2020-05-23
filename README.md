# sumtype
A macro for Janet for creating sum types/tagged unions.

A sum type is a word in type theory for a tagged union. Using one of these
enable us to define a type that can have `n` distinct shapes, which we can
operate on by e.g. pattern `match`ing on the data.

It is useful for expressing things like the `Maybe` type and even some data
structures, like linked lists and trees.

## API

Given that the module is imported as `(import sumtype)`, the API is as follows:

- Macro `(sumtype/declare sum-type-name & type-instance-descriptors)`

Where `sum-type-name` is the name of the sum-type, which will be used as a
symbol, and `type-instance-descriptors` are the rest arguments, where each is a
tuple of the form `[type-name & parameters]`. These will be used to define
either the singleton "empty" value or constructors, in the form of functions,
plus type predicates that are the type's name with a trailing "?", as in
`<type-name>?`.

- Function `(isa? type instance)`

Checks whether the supplied `instance` is of the type `type`. `type` is used as
a symbol here.

## Example

### Maybe

```janet
(import sumtype)
(sumtype/declare maybe
                  [just a]
                  [nothing])

# since `nothing` is 0-arity, it is a singleton value.
(def v0 nothing)
# `just` is a constructor accepting one value
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
    (match [:just x] x) # unwrapping, no match here means `nil`
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
          3 leaf (node
                 4 leaf leaf))
      leaf)))

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
