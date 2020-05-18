(defmacro declare
  [type-name & forms]
  (def bindings @[])
  (each form forms
    (def name (in form 0))
    (def arg (get form 1))

    (if (nil? arg)
      (array/push bindings
                  ~(defn ,name []
                     {:type ',type-name ,(keyword name) :void}))
      (array/push bindings
                  ~(defn ,name [a]
                     (when (nil? a)
                       (error "A sum type with value requires a non-nil argument."))
                     {:type ',type-name ,(keyword name) a})))

    (array/push bindings
                ~(defn ,(symbol (string name) "?") [a]
                   (not (nil? (get a ,(keyword name)))))))

  (array/push bindings ~(defn ,(symbol (string type-name) "?") [a]
                          (= ',type-name (get a :type))))
  bindings)

(defn isa? [type instance]
  (= type (get instance :type)))
