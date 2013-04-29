# todo checksum
window.Profile =
  ready: (callback) ->
    profile = window.localStorage.getItem 'hakkai'
    if profile
      Profile.data = $.parseJSON profile
      callback()
    else
      $.get '/user/profile', (data) ->
        window.localStorage.setItem 'hakkai', data
        Profile.data = $.parseJSON profile
        callback()
