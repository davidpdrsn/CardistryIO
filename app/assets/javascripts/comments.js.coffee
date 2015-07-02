# TODO: Move to helpers file
addBehavior = (key, f) ->
  $(document).on "click", "[data-behavior~=#{key}]", f

$ ->
  addBehavior "show-comment-form", ->
    $(".add_comment_form").removeClass("hide")
