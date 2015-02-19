define([
  'jquery',
  'DoughBaseComponent'
], function (
  $,
  DoughBaseComponent
) {
  'use strict';

  var ElementFilterProto,
      defaultConfig = {
        componentName: 'ElementFilter',
        selectors: {
          activeClass: 'is-active',
          trigger: '[data-dough-element-filter-trigger]',
          target: '[data-dough-element-filter-target]'
        },
        uiEvents: {}
      };

  function ElementFilter($el, config) {
    ElementFilter.baseConstructor.call(this, $el, config, defaultConfig);
    this.$trigger = this.$el;
    this.$target = $('[data-dough-element-filter-target="' + this.$trigger.attr('data-dough-element-filter-trigger') + '"]');
    this._setFilterableItems();
    this._handleClick = $.proxy(this._handleClick, this);
  }

  DoughBaseComponent.extend(ElementFilter);

  ElementFilterProto = ElementFilter.prototype;

  ElementFilterProto.init = function(initialised) {
    this._setupEventListeners();
    this._initialisedSuccess(initialised);
  };

  ElementFilterProto._setupEventListeners = function() {
    $('body').on('click touchend', defaultConfig.selectors.trigger, this._handleClick);
  };

  ElementFilterProto._handleClick = function() {
    this.toggle();
  };

  ElementFilterProto._setFilterableItems = function() {
    this.$filterableItems = this.$target.children().filter('[data-dough-element-filter-item="true"]');
  };

  ElementFilterProto.toggle = function() {
    this._setFilterableItems();
    this.$filterableItems.toggleClass(this.config.selectors.activeClass);
  };

  return ElementFilter;
});
