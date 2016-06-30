$(document).ready ->
  showContentElement = (element) ->
    $('.profile-content').children('div:eq(' + element + ')').addClass('is-visible').show()

  removeActiveClassesExcept = (currentElement) ->
    switch currentElement
      when 0
        $('.profile-nav-items').each ->
          $(this).children('a:eq(1), a:eq(2)').removeClass('is-active')
          return
        $('.profile-content').each ->
          $(this).children('div:eq(1), div:eq(2)').removeClass('is-visible').hide()
          return
      when 1
        $('.profile-nav-items').each ->
          $(this).children('a:eq(0), a:eq(2)').removeClass('is-active')
          return
        $('.profile-content').each ->
          $(this).children('div:eq(0), div:eq(2)').removeClass('is-visible').hide()
          return
      when 2
        $('.profile-nav-items').each ->
          $(this).children('a:eq(0), a:eq(1)').removeClass('is-active')
          return
        $('.profile-content').each ->
          $(this).children('div:eq(0), div:eq(1)').removeClass('is-visible').hide()
          return

  # Show first element on default
  $('.profile-nav-items').each ->
    $(this).children('a:eq(0)').addClass('is-active')
    return
  $('.profile-content').each ->
    $(this).children('div:eq(0)').addClass('is-visible').show()
    return

  # Handle click events for each link
  $('.profile-nav-items').on 'click', 'a:eq(0)', (event) ->
    if !$(this).hasClass('is-active')
      event.preventDefault()
      $(this).addClass('is-active')
      showContentElement(0)
      removeActiveClassesExcept(0)
    else
      event.preventDefault()
    return
  $('.profile-nav-items').on 'click', 'a:eq(1)', (event) ->
    if !$(this).hasClass('is-active')
      event.preventDefault()
      $(this).addClass('is-active')
      showContentElement(1)
      removeActiveClassesExcept(1)
    else
      event.preventDefault()
    return
  $('.profile-nav-items').on 'click', 'a:eq(2)', (event) ->
    if !$(this).hasClass('is-active')
      event.preventDefault()
      $(this).addClass('is-active')
      showContentElement(2)
      removeActiveClassesExcept(2)
    else
      event.preventDefault()
    return
