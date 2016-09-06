timelineBlocks = -> $(".timeline-block")
timelinePagination = -> $(".timeline-pagination")
offset = 0.9

hideBlocks = (blocks, headlines, offset) ->
  blocks.each ->
    console.log 'block hidden'
    $(this).offset().top > $(window).scrollTop() + $(window).height() * offset and $(this).find('.timeline-block-image, .timeline-content').addClass('is-hidden')

  headlines.each ->
    console.log 'headline hidden'
    $(this).offset().top > $(window).scrollTop() + $(window).height() * offset and $(this).addClass('is-hidden')

showBlocks = (blocks, headlines, offset) ->
  blocks.each ->
    $(this).offset().top <= $(window).scrollTop() + $(window).height() * offset and $(this).find('.timeline-block-image').hasClass('is-hidden') and $(this).find('.timeline-block-image, .timeline-content, .timeline-pagination').removeClass('is-hidden').addClass('bounce-in')

  headlines.each ->
    $(this).offset().top <= $(window).scrollTop() + $(window).height() * offset and $(this).hasClass('is-hidden') and $(this).removeClass('is-hidden').addClass('bounce-in')

document.addEventListener "turbolinks:load", ->
  hideBlocks(timelineBlocks(), timelinePagination(), offset)

# on scolling, show/animate timeline blocks when enter the viewport
$(window).on 'scroll', ->
  if !window.requestAnimationFrame then setTimeout((->
    showBlocks timelineBlocks(), timelinePagination(), offset
  ), 100) else window.requestAnimationFrame((->
    showBlocks timelineBlocks(), timelinePagination(), offset
  ))
