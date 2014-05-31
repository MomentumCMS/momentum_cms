//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require tinymce-jquery
//= require vendor/bootstrap
//= require vendor/select2
//= require vendor/jquery.nested-sortable
//= require_tree ../../vendor/ace
//= require vendor/emmet
//= require momentum_cms/admin/util/ace
//= require momentum_cms/admin/util/select2
//= require momentum_cms/admin/util/tinymce
//= require momentum_cms/admin/menus/form
//= require momentum_cms/admin/views/page
//= require momentum_cms/admin/views/document
//= require_self

$(function () {
  $('[data-toggle="tooltip"]').tooltip();

  $(document).on('focus', ':input', function () {
    $(this).attr('autocomplete', 'off');
  });
});