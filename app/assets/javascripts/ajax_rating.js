$(document).ready(function() {
  $(".rate-button").click(function() {
    $(this).addClass("loading");
    var valuesToSubmit = $(".rating-widget-form").serialize();
    var that = $(this);

    $.ajax({
      type: "POST",
      url: $(".rating-widget-form").attr("action"),
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