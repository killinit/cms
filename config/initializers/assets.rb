Rails.application.configure do

  config.assets.paths << Rails.root.join('vendor', 'assets', 'bower_components')

# Application Stylesheets
  config.assets.precompile += %w(comfortable_mexican_sofa/admin/basic.css
                                  components-font-awesome/css/font-awesome.css)

# Fonts and images
  config.assets.precompile << /\.(?:png|svg|eot|woff|ttf)$/

# Application JavaScript
  config.assets.precompile += %w(application.js)

# Editor JavaScript
  config.assets.precompile += %w(mas-cms-editor/src/editor.js
                                  mas-cms-editor/src/modules/constants/constants.js
                                  mas-cms-editor/src/modules/config/config.js
                                  mas-cms-editor/src/modules/lib/scribe-wrapper/scribe-wrapper.js
                                  mas-cms-editor/src/modules/lib/source-converter/source-converter.js
                                  mas-cms-editor/src/modules/plugins/editor-sticky-toolbar/editor-sticky-toolbar.js
                                  mas-cms-editor/src/modules/plugins/editor-auto-resize-textarea/editor-auto-resize-textarea.js
                                  comfortable_mexican_sofa/admin/mas-editor.js)

# Vendor JavaScript
  config.assets.precompile += %w(requirejs/require.js
                                  he/he.js
                                  rsvp/rsvp.amd.js
                                  eventsWithPromises/src/eventsWithPromises.js
                                  scribe/scribe.js
                                  scribe-plugin-blockquote-command/scribe-plugin-blockquote-command.js
                                  scribe-plugin-formatter-plain-text-convert-new-lines-to-html/scribe-plugin-formatter-plain-text-convert-new-lines-to-html.js
                                  scribe-plugin-heading-command/scribe-plugin-heading-command.js
                                  scribe-plugin-keyboard-shortcuts/scribe-plugin-keyboard-shortcuts.js
                                  scribe-plugin-link-prompt-command/scribe-plugin-link-prompt-command.js
                                  scribe-plugin-sanitizer/scribe-plugin-sanitizer.js
                                  scribe-plugin-toolbar/scribe-plugin-toolbar.js
                                  marked/lib/marked.js
                                  to-markdown/src/to-markdown.js)

end
