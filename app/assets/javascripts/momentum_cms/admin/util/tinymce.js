function tinymce_init() {
  tinyMCE.init({
    selector: 'textarea.tinymce'
  });
}

$(function () {
  tinymce_init();
});