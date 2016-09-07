$(document).on "click", ".video-appearances-move-add", (e) ->
  e.preventDefault()
  text = $(this).text()
  label = $(this).parents("label")
  label.find("input").val(text)

$(document).on "click", ".video-appearances-add", ->
  last = $(this).parents("form").find(".field").last()
  clone = last.clone()
  clone.find("input").each flip((el) -> $(el).val(""))
  last.after(clone)

$(document).on "click", ".video-appearances-remove", ->
  $(this).parents(".field").remove()
