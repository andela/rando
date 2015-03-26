flashCallback = (_this) ->
  $('.flash').fadeOut()
  return

$('document').ready ->
  $('.datepicker').pickadate
    formatSubmit: 'yyyy/mm/dd'
    hiddenName: true
    min: 1
    max: 30

  $('#check-all').on 'click', ->
    $('.ra-error').html('')
    checkboxes = $('.check-box')
    checkboxes.prop 'checked', !checkboxes.prop('checked')
    return

  $('.flash').bind 'click', (e) ->
    flashCallback()
    return
  setTimeout flashCallback, 3000
  return