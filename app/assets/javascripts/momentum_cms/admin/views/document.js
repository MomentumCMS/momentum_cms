var DocumentView;

DocumentView = (function () {

  //-- Initializer ----------------------------------------------------------
  function DocumentView(options) {
    this.$el = $(options.el);
    this.bindEvents();
  }

  //-- Utilities ------------------------------------------------------------
  DocumentView.prototype.$ = function (selector) {
    return this.$el.find(selector);
  };

  //-- Properties -----------------------------------------------------------
  DocumentView.prototype.fieldsUrl = function () {
    return this.$el.data('fields-url');
  };

  DocumentView.prototype.documentId = function () {
    return this.$el.data('document-id');
  };

  //-- Methods --------------------------------------------------------------
  DocumentView.prototype.bindEvents = function () {
    this.$el.on('change', '.document-template-select', $.proxy(this.fetchContentBlocks, this));
  };

  DocumentView.prototype.fetchContentBlocks = function (e) {
    var reqData = {blue_print_id: $(e.currentTarget).val()};
    if (this.documentId() !== '') {
      reqData.document_id = this.documentId();
    }
    var request = $.get(this.fieldsUrl(), reqData);
    request.then(function (res) {
      $('.momentum-cms-fields').empty();
      $(res).find('.ajax-fields').appendTo('.momentum-cms-fields');
    });
    request.fail(function (xhr) {
      alert('there was a problem loading the content fields');
    });
    request.complete(function(){
      tinymce_init();
    });
  };

  return DocumentView;

})();

$(document).ready(function () {
  if ($('.momentum-cms-document-view').length > 0) {
    window.DocumentView = new DocumentView({el: ('.momentum-cms-document-view')});
  }
});