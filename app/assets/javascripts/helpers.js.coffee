window.addBehavior = (key, f) ->
  $(document).on "click", "[data-behavior~=#{key}]", f

window.flip = (f) -> (x, y) -> f(y, x)
