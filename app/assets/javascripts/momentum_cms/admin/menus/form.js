$(function () {

  if ($('body.momentum-cms-admin-menus-edit, body.momentum-cms-admin-menus-new').length) {


    function bind_ui_nested_sortable() {
      $('ol.ui-nested-sortable').nestedSortable({
        forcePlaceholderSize: true,
        handle: 'div',
        helper: 'clone',
        items: 'li',
        opacity: .6,
        placeholder: 'placeholder',
        revert: 250,
        tabSize: 25,
        tolerance: 'pointer',
        toleranceElement: '> div'
      });
    }

    bind_ui_nested_sortable();
    
    $('.momentum-cms-pages-select').select2({
      placeholder: "Search for a Page",
      minimumInputLength: 1,
      ajax: {
        url: $('.momentum-cms-pages-select').attr('data-remote-url'),
        data: function (term, page) {
          return {
            q: term,
            page_limit: 10
          };
        },
        results: function (data, page) { // parse the results into the format expected by Select2.
          var results = [];
          $(data).each(function (index, element) {
            results.push({id: element.id, text: element.label, type: 'MomentumCms::Page' })
          });
          return {results: results};
        }
      }
    });

    $('.momentum-cms-menu-add-page').click(function (e) {
      e.preventDefault();

      var data = $('.momentum-cms-pages-select').select2('data')

      if (data) {
        var html = "<li id=\"list-" + data.id + "\"><div>" + data.text + "</div></li>"
        $('ol.ui-nested-sortable').append(html);
        bind_ui_nested_sortable();


      }
    });


    $('.momentum-cms-menu-submit').click(function () {
      var hierarchy = $('ol.ui-nested-sortable').nestedSortable('toHierarchy', {startDepthCount: 0});
      $('.cms-admin-site-menus-json').val(JSON.stringify(hierarchy))
    });
  }

});
