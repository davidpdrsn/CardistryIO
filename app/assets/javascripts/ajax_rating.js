$(document).on("click", ".rate-button:not(.disabled)", function() {
  $(this).addClass("loading");

  var form = $(this).children("form");
  var valuesToSubmit = form.serialize();
  var that = $(this);

  $.ajax({
    type: "POST",
    url: form.attr("action"),
    data: valuesToSubmit
  })
  .success(function(partial) {
    $(that)
      .removeClass("loading")
      .addClass("success")
      .text("Rating counted");

    $(".rate-button")
      .not(".success")
      .fadeTo("slow", 0.4);

    $(".current-rating").replaceWith(partial);
  })
  .error(function() {
    $(".rate-button").removeClass("error");

    $(that)
      .removeClass("loading")
      .addClass("error")
      .text("Try again");
  });

  return false;
});
