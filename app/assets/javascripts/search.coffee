addBehavior "toggle-search", (e) ->
  e.preventDefault()
  $(".header-search").toggle()
  $(".header-search input[type=text]").focus()
