(defmacro declare
  "This macro creates one constructor binding and one type predicate binding for
  each type supplied to it.\n\n"
  [type & forms]
  (def bindings @[])
  (each form forms
    (def name (in form 0))
    (def arg (get form 1))

    (if (nil? arg)
      (array/push bindings
                  ~(defn ,name []
                     [,(keyword name) nil :type ',type]))
      (array/push bindings
                  ~(defn ,name [a]
                     (when (nil? a)
                       (error "A sum type with value requires a non-nil argument."))
                     [,(keyword name) a :type ',type ])))

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
