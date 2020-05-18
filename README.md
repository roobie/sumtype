# sumtype
A macro for Janet for creating sum types

## Example

```janet
(import sumtype)

# Create the maybe sum type, of which instances can be either
# just <a value>, or
# nothing
(sumtype/declare maybe
                 [just a]
                 [nothing])

(def v0 (nothing))
(def v1 (just 1))

(assert (true? (maybe? v0)))
(assert (true? (nothing? v0)))
(assert (true? (just? v1)))

# Sum types that boxes a value requires a non-nil argument
(var c 0)
(try
  (just nil) # should signal an error
  ((err)
    (set c 1)))
(assert (= c 1))

# We can pattern match to determine what to do
(match v0 # is nothing, so will print "v0: <nothing>"
  {:just x} (printf "v0: %d" x)
  {:nothing _} (print "v0: <nothing>"))

# v1 is just a, so will print "v1: 1"
(match v1
  {:just x} (printf "v1: %d" x)
  {:nothing _} (print "v1: <nothing>"))
```
