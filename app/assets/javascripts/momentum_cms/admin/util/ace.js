// Hook up ACE editor to all textareas with data-editor attribute
$(function () {
  $('textarea[data-editor]').each(function () {
    var textarea = $(this);

    var mode = textarea.data('editor');

    var editDiv = $('<div>', {
      position: 'absolute',
      height: textarea.height(),
      'class': textarea.attr('class')
    }).insertBefore(textarea);

    textarea.css('visibility', 'hidden').css('height', '0px');

    ace.require("ace/ext/old_ie");
    ace.require("ace/ext/language_tools");
    ace.require("ace/ext/emmet");

    var editor = ace.edit(editDiv[0]);
    ace.require('ace/ext/settings_menu').init(editor);

    editor.getSession().setValue(textarea.val());
    editor.getSession().setMode("ace/mode/" + mode);
    editor.setTheme("ace/theme/github");

    editor.setAutoScrollEditorIntoView();
    editor.setOption("minLines", 10);
    editor.setOption("maxLines", 50);
    editor.setOption("enableEmmet", true);
    editor.setOptions({
      enableBasicAutocompletion: true,
      enableSnippets: true
    });

    editor.commands.addCommands([
      {
        name: "showSettingsMenu",
        bindKey: {win: "Ctrl-e", mac: "Command-e"},
        exec: function (editor) {
          editor.showSettingsMenu();
        },
        readOnly: true
      }
    ]);

    editor.commands.addCommand({
      name: "showKeyboardShortcuts",
      bindKey: {win: "Ctrl-d", mac: "Command-d"},
      exec: function (editor) {
        ace.config.loadModule("ace/ext/keybinding_menu", function (module) {
          module.init(editor);
          editor.showKeyboardShortcuts()
        })
      }
    });

    // copy back to textarea on form submit...
    textarea.closest('form').submit(function () {
      textarea.val(editor.getSession().getValue());
    })

  });
});