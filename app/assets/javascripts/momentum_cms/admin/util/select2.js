$(function () {
  $.each($('select.select'), function (index, value) {
    $(value).select2();
  });
});
