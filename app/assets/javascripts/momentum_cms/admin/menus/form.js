$(function () {

  if ($('body.momentum-cms-admin-menus-edit, body.momentum-cms-admin-menus-update, body.momentum-cms-admin-menus-new, body.momentum-cms-admin-menus-create').length) {

    var ol = $('ol.ui-nested-sortable');

    function bind_ui_nested_sortable() {
      ol.nestedSortable({
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

    function createLiNode(data) {
      var display = $("<div />").html(data.label);
      var li = $("<li />")
        .html(display)
        .attr('data-label', data.label)
        .attr('data-linkable-type', data.linkable_type)
        .attr('data-linkable-id', data.linkable_id)
        .attr('id', "list-" + data.id.valueOf());
      return li;
    }

    function buildUnsavedList(json, list) {
      if ($.isArray(json)) {
        $.each(json, function (key, value) {
          buildUnsavedList(value, list);
        });
        return;
      }
      if (json) {
        var li = createLiNode(json);

        if (json.children && json.children.length) {
          var sublist = $("<ol/>");
          buildUnsavedList(json.children, sublist)
          li.append(sublist);
        }
        list.append(li)
      }
    }

    // New list....
    if (ol.find('li').length == 0) {
      var menu_json = $('.cms-admin-site-menus-json').val()
      if (menu_json) {
        var json = JSON.parse(menu_json);
        buildUnsavedList(json, ol);
      }
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
            results.push({id: element.id, text: element.label, label: element.label, type: 'MomentumCms::Page' })
          });
          return {results: results};
        }
      }
    });

    $('.momentum-cms-menu-add-page').click(function (e) {
      e.preventDefault();

      var data = $('.momentum-cms-pages-select').select2('data');
      if (data) {
        var li = createLiNode(data);
        $('ol.ui-nested-sortable').append(li);
      }
    });

    $('.momentum-cms-menu-submit').click(function () {
      var hierarchy = $('ol.ui-nested-sortable').nestedSortable('toHierarchy', {startDepthCount: 0});
      $('.cms-admin-site-menus-json').val(JSON.stringify(hierarchy))
    });
  }

});
