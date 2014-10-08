// Overwrite this file in your application /app/assets/javascripts/comfortable_mexican_sofa/admin/application.js
//= require requirejs/require
//= require require_config
//= require jquery.remotipart

window.CMS.wysiwyg = function() {
  'use strict';
  require([
    'mas-editor',
    'editor-plugin-auto-resize-textarea',
    'word-upload',
    'element-hider',
    'taggle'
  ], function (
    masEditor,
    editorPluginAutoResizeTextarea,
    wordUpload,
    ElementHider,
    Taggle
  ) {
    var markdownEditorContentNode = document.querySelector('.js-markdown-editor-content');

    if(!markdownEditorContentNode) return;

    markdownEditorContentNode.value = markdownEditorContentNode.value.split('\n').map(function(e) {
      return e.trim();
    }).join('\n');

    masEditor.init({
      editorContainer: document.querySelector('.l-editor'),
      cmsFormNode: document.querySelector('#edit_page') || document.querySelector('#new_page'),
      toolbarNode: document.querySelector('.js-toolbar'),
      htmlEditorNode: document.querySelector('.js-html-editor'),
      htmlEditorContentNode: document.querySelector('.js-html-editor-content'),
      markdownEditorNode: document.querySelector('.js-markdown-editor'),
      markdownEditorContentNode: markdownEditorContentNode,
      switchModeTriggerNodes: document.querySelectorAll('.js-switch-mode'),
      editorOptions: {
        editorLibOptions : {
          sanitizer : {
            tags: {
              p: {},
              br: {},
              b: {},
              strong: {},
              i: {},
              strike: {},
              blockquote: {},
              ol: {},
              ul: {},
              li: {},
              a: { href: true },
              h2: {},
              h3: {},
              h4: {},
              h5: {}
            }
          }
        }
      }
    });

    masEditor.editor.use(editorPluginAutoResizeTextarea(markdownEditorContentNode));

    var focusOnTitle = function() {
      var el = document.querySelector('input#page_label');
      el.value = el.value;
    };

    setTimeout(focusOnTitle, 500);

    // Setup Word upload form elements
    wordUpload.init({
      showConfirm: true,
      fileInputNode: document.querySelector('.js-word-upload-file-input'),
      activateFileInputNode: document.querySelector('.js-activate-word-upload-form'),
      wordFormNode: document.querySelector('.js-word-upload-form')
    });

    if(document.querySelector('.js-alert')) {
      new ElementHider({
        mainNode: document.querySelector('.js-alert'),
        closeNode: document.querySelector('.js-close-alert'),
        delay: 3000
      }).init();
    }

    new Taggle(document.querySelector('.js-tags-display'), {
      tags: document.querySelector('.js-tags-input').value.split(/,/igm),
      placeholder: '',
      hiddenInputName: 'tags[]'
    });

  });
};

window.CMS.mirrors = function() {
  'use strict';
  $('#site__mirrors').change(function() {
    window.location = $(this).find('input:checked').data()['value'];
  });
};
