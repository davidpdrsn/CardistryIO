commentForm = -> $(".add_comment_form")

addBehavior "show-comment-form", (e) ->
  e.preventDefault()
  commentForm().toggleClass "hide"

insertValueAndFocus = (input, value) ->
  input.focus()
  input.val("")
  input.val(value)

addBehavior "reply-to-comment", (event) ->
  event.preventDefault()
  authorUsername = $(this).parents("[data-comment-author]").attr("data-comment-author")
  commentForm().removeClass("hide")
  input = commentForm().find("textarea")
  insertValueAndFocus(input, "@#{authorUsername} ")
