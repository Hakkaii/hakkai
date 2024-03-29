# utils

window.Hakkai =
  tagFieldError: (elem, errors) ->
    elem.parent().find('.field-error').remove()
    errors = errors.join '. ' if errors.join
    elem.after("<div class='field-error'>#{errors}</div>")

  tagFormError: (elem, prefix, errors) ->
    elem = $ elem
    elem.find('.field-error').remove()
    prefix = "#" + prefix unless /^\#/.test prefix
    prefix = prefix + "_" unless /_$/.test prefix
    if errors.base
      elem.prepend "<div class='field-error'>#{errors.base}</div>"
    for field, info of errors
      info = info.join ". "
      elem.find(prefix + field).after "<div class='field-error'>#{info}</div>"
    elem.find('.submit').removeAttr('disabled')

  setNotice: (text) ->
    $('div.notice').replaceWith("<div class='notice'>" + text + "</div>")
    setTimeout (-> $('.notice').fadeOut 1500), 2500

  # showTip() and hideTip() are for hover tooltip [title] enchancement
  #   from http://onehackoranother.com/projects/jquery/tipsy/
  # modified for live and simplified

  # function for dom binding
  showTip: ->
    self = $ @
    # we don't use the 'title' attr, use data-title instead
    # because we have to remove title from being shown
    # and then the live mouseleave event will be broken because elem has no [title]
    title = self.data('title')

    # build tip dom
    return unless title
    tip = self.data('active.tipsy')
    unless tip
      tip = $("<div class='tipsy' style='position:absolute;z-index:100000;'><div class='tipsy-inner'></div></div>")
      tip.find('.tipsy-inner').text(title)
      self.data('active.tipsy', tip)
      tip.appendTo(document.body)
    tip.css(top: 0, left: 0)

    # config pos and do auto gravity if data-title-gravity is not set
    pos = $.extend({}, self.offset(), {width: @offsetWidth, height: @offsetHeight})
    actualWidth = tip[0].offsetWidth
    actualHeight = tip[0].offsetHeight
    # NOTE: gravity == north means the earth is on top and the tip is shown on top side
    gravity = self.data('title-gravity')
    unless gravity
      # default: use auto gravity
      gravity =
        if self.offset().top > ($(document).scrollTop() + $(window).height() / 2)
          's'
        else
          'n'
    switch gravity.charAt(0)
      when 'n'
        tip.css(top: pos.top + pos.height, left: pos.left + pos.width / 2 - actualWidth / 2).addClass('tipsy-north')
      when 's'
        tip.css(top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2).addClass('tipsy-south')
      when 'e'
        tip.css(top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth).addClass('tipsy-east')
      when 'w'
        tip.css(top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width).addClass('tipsy-west')
    undefined

  # function for dom binding
  hideTip: ->
    tip = $(@).data('active.tipsy')
    $(@).removeData('active.tipsy')
    tip.remove() if tip
    undefined

  toggleNav: ->
    nav = $ '#nav'
    if nav.hasClass 'nav-up'
      fromDeg = -16
      toDeg = 0
      fromClass = 'nav-up'
      toClass = 'nav-down'
    else
      fromDeg = 0
      toDeg = -16
      fromClass = 'nav-down'
      toClass = 'nav-up'

    # browser vendor prefix detect
    transform = Modernizr.prefixed 'transform'
    transform = transform.replace(/([A-Z])/g, (str, m1) ->
      '-' + m1.toLowerCase()
    ).replace(/^ms-/,'-ms-')
    vendorPrefix = transform.replace('transform', '')

    # rotate nav bar
    Hakkai.animate fromDeg, toDeg, 6, (deg, isLast) ->
      nav.css(transform, "rotate(#{deg}deg)")
      if isLast
        nav.removeClass fromClass
        nav.addClass toClass
        img = nav.find '.toggle img'
        img.attr 'src', img.data(fromClass)

    # rotate new-post gradient
    newPost = $ '#tools .new-post'
    Hakkai.animate (-90 - fromDeg), (-90 - toDeg), 6, (deg, isLast) ->
      newPost.css 'background', vendorPrefix + "linear-gradient(#{deg}deg, #AAA 5%, #999 18%, #959595 22%, #555 24%, black 45%,#444 80%)"

  # len: frame count
  animate: (fromDeg, toDeg, len, stepper) ->
    step = (toDeg - fromDeg) / len
    degs = (fromDeg + step * i for i in [0...len])
    i = 0
    timer = setInterval (->
      if i < degs.length
        stepper(degs[i], false)
        i++
      else
        stepper(toDeg, true)
        clearInterval(timer)
    ), 40
