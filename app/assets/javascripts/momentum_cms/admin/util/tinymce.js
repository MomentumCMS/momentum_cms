function tinymce_init() {
  tinyMCE.init({
    selector: 'textarea.tinymce',
    skin: 'light',
    menubar: false,
    statusbar: false
  });
}

$(function () {
  tinymce_init();
});