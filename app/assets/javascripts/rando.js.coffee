$('document').ready ->
  $('.datepicker').pickadate
    formatSubmit: 'yyyy/mm/dd'
    hiddenName: true
    min: 1
    max: 30

  $('#allocate').on 'click', ->
    $('#edit-form').attr 'action', '/users/allocate_money/new'

  $('#edit').on 'click', ->
    $('#edit-form').attr 'action', '/users/roles/edit'

  $('#check-all').on 'click', ->
    $('.ra-error').html('')
    checkboxes = $('.check-box')
    checkboxes.prop 'checked', !checkboxes.prop('checked')
    return
  return
return