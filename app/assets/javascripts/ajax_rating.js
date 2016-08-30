$(document).ready(function() {
  $(".rate-button").not($(".disabled")).click(function() {
    $(this).addClass("loading");

    var form = $(this).children("form");
    var valuesToSubmit = form.serialize();
    var that = $(this);
    console.log(valuesToSubmit);

    $.ajax({
      type: "POST",
      url: form.attr("action"),
      data: valuesToSubmit
    })
    .success(function() {
      $(that).removeClass("loading");
      $(that).addClass("success");
      $(that).text("Rating counted");

      $(".rate-button").not(".success").fadeTo("slow", 0.4);
    });

    return false;
  })
});