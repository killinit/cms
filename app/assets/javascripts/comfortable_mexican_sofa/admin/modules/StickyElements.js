define([
  'jquery',
  'DoughBaseComponent',
  'filament-sticky'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var StickyElementsProto,
      defaultConfig = {
        componentName: 'StickyElements',
        selectors: {
          stickyElement: '[data-dough-sticky-element-target]'
        }
      };

  function StickyElements($el, config) {
    StickyElements.baseConstructor.call(this, $el, config, defaultConfig);
  }

  DoughBaseComponent.extend(StickyElements);

  StickyElementsProto = StickyElements.prototype;

  StickyElementsProto.init = function(initialised) {
    $(this.config.selectors.stickyElement).fixedsticky();
    this._initialisedSuccess(initialised);
  };

  return StickyElements;
});
