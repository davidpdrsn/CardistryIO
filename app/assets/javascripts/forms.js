$(document).ready(function() {
  function setUsedClass(element) {
    if (element.val())
      element.addClass('input-field-used');
    else
      element.removeClass('input-field-used');
  }

  $('input, textarea').each(function() {
    setUsedClass($(this));
  });

  $('input, textarea').blur(function() {
    setUsedClass($(this));
  });
});