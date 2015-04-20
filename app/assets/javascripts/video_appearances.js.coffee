flip = (f) -> (x, y) -> f(y, x)

# TODO: Somehow test this
$ ->
  $(document).on "click", ".video-appearances-add", ->
    last = $(this).parents("form").find(".field").last()
    clone = last.clone()
    clone.find("input").each flip((el) -> $(el).val(""))
    last.after(clone)

  $(document).on "click", ".video-appearances-remove", ->
    $(this).parents(".field").remove()
