$(document).ready(function() {
  $(".rate-button").click(function() {
    var valuesToSubmit = $(".rating-widget-form").serialize();
    var that = $(this);
    var buttonText = $(this).text();

    $.ajax({
      type: "POST",
      url: $(".rating-widget-form").attr("action"),
      data: valuesToSubmit
    })
    .success(function() {
      $(that).addClass("success");
      $(that).text("Rating counted");

      /*setTimeout(function() {
        $(that).text(buttonText);
        $(that).removeClass("success");
        $(that).addClass("active");
      }, 2500); */
    });

    return false;
  })
});