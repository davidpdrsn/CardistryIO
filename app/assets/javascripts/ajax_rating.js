$(document).ready(function() {
  $(".send-ratings > .button_to").submit(function() {
    var valuesToSubmit = $(this).serialize();
    $.ajax({
      type: "POST",
      url: $(this).attr("action"),
      data: valuesToSubmit,
    }).success(function(response) {
      console.log("success", response);
    });

    return false;
  })
});