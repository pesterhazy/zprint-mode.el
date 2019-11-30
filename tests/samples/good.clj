(defn page-state-ui []
  (case (:page-state @!state)
    :loading [loading-ui]
    :loaded (let [children (r/children (r/current-component))] (assert (= 1 (count children))) (first children))
    :failed [:div ":-("] nil nil))
