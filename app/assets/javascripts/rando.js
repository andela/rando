$('document').ready(function() {
    $('.datepicker').pickadate({
        formatSubmit: 'yyyy/mm/dd',
        hiddenName: true,
        min: 1,
        max: 31
    })
});