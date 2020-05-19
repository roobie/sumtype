(defmacro declare
  [type-name & forms]
  (def bindings @[])
  (each form forms
    (def name (in form 0))
    (def arg (get form 1))

    (if (nil? arg)
      (array/push bindings
                  ~(defn ,name []
                     [,(keyword name) nil :type ',type-name]))
      (array/push bindings
                  ~(defn ,name [a]
                     (when (nil? a)
                       (error "A sum type with value requires a non-nil argument."))
                     [,(keyword name) a :type ',type-name ])))

    (array/push bindings
                ~(defn ,(symbol (string name) "?") [a]
                   (= ,(keyword name) (get a 0)))))

  (array/push bindings ~(defn ,(symbol (string type-name) "?") [a]
                          (= ',type-name (get a 3))))
  bindings)

(defn isa? [type instance]
  (and
    (= :type (get instance 2))
    (= type (get instance 3))))
