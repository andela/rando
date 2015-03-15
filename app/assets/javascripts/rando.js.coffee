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
  return
return