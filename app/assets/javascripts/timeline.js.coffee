jQuery(document).ready ($) ->
  timelineBlocks = $(".timeline-block")
  timelineHeadlines = $(".timeline-headline")
  offset = 0.9
  #hide timeline blocks which are outside the viewport

  hideBlocks = (blocks, headlines, offset) ->
    blocks.each ->
      console.log 'block hidden'
      $(this).offset().top > $(window).scrollTop() + $(window).height() * offset and $(this).find('.timeline-block-image, .timeline-content').addClass('is-hidden')
      return

    headlines.each ->
      console.log 'headline hidden'
      $(this).offset().top > $(window).scrollTop() + $(window).height() * offset and $(this).addClass('is-hidden')
      return
    return

  showBlocks = (blocks, headlines, offset) ->
    blocks.each ->
      $(this).offset().top <= $(window).scrollTop() + $(window).height() * offset and $(this).find('.timeline-block-image').hasClass('is-hidden') and $(this).find('.timeline-block-image, .timeline-content, .timeline-headline').removeClass('is-hidden').addClass('bounce-in')
      return

    headlines.each ->
      $(this).offset().top <= $(window).scrollTop() + $(window).height() * offset and $(this).hasClass('is-hidden') and $(this).removeClass('is-hidden').addClass('bounce-in')
      return
    return

  hideBlocks timelineBlocks, timelineHeadlines, offset
  #on scolling, show/animate timeline blocks when enter the viewport
  $(window).on 'scroll', ->
    if !window.requestAnimationFrame then setTimeout((->
      showBlocks timelineBlocks, timelineHeadlines, offset
      return
    ), 100) else window.requestAnimationFrame((->
      showBlocks timelineBlocks, timelineHeadlines, offset
      return
    ))
    return
  return