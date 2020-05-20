(defmacro declare
  "This macro creates one constructor binding and one type predicate binding for
  each type supplied to it.\n\n"
  [type & forms]
  (def bindings @[])
  (each form forms
    (def name (in form 0))
    (def args (array/slice form 1))

    (if (= 0 (length args))
      (array/push bindings
                  ~(defn ,name []
                     [,(keyword name) nil :type ',type]))
      (array/push bindings
                  ~(defn ,name [& stuff]
                     (each item stuff
                       (when (nil? item)
                         (error "A sum type with value(s) requires a non-nil argument.")))
                     [,(keyword name) ;stuff :type ',type ])))

    (array/push bindings
                ~(defn ,(symbol (string name) "?") [a]
                   (= ,(keyword name) (get a 0)))))

  (array/push bindings ~(defn ,(symbol (string type) "?") [a]
                          (= ',type (get a 3))))
  bindings)

(defn isa? [type instance]
  "Test wheter the object `instance` is of the symbol `type`."
  (and
    (= :type (get instance 2))
    (= type (get instance 3))))
