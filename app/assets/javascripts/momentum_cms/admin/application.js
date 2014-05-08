//= require jquery
//= require jquery_ujs
//= require vendor/bootstrap
//= require vendor/select2
//= require_tree ../../vendor/ace
//= require vendor/emmet
//= require momentum_cms/admin/util/ace
//= require_self


$(function () {
  $.each($('select.select'), function (index, value) {
    $(value).select2();
  });
})
