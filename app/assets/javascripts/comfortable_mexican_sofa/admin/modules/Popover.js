define(['jquery', 'DoughBaseComponent', 'Collapsable'], function($, DoughBaseComponent, Collapsable) {

  'use strict';

  var Popover,
      defaultConfig = {
        direction: 'top',
        halign: true,
        valign: true
      };

  Popover = function($el, config) {
    Popover.baseConstructor.call(this, $el, config, defaultConfig);
    this.$trigger.find('[data-dough-collapsable-icon]').remove();
  };

  /**
   * Inherit from base module, for shared methods and interface
   */
  DoughBaseComponent.extend(Popover, Collapsable);

  Popover.prototype.init = function() {
    Popover.superclass.init.call(this);

    var resize,
        _this = this;

    this.handleResize = $.proxy(this.handleResize, this);
    this.$target.css({
      position: 'absolute'
    });

    $(window).on('resize', function() {
      clearTimeout(resize);
      resize = setTimeout(_this.handleResize, 100);
    });
  };

  Popover.prototype.handleResize = function() {
    this.updatePosition();
  };

  Popover.prototype.toggle = function() {
    Popover.superclass.toggle.call(this);
    this.updatePosition();
  };

  Popover.prototype.updatePosition = function() {
    this.$target.css(this.calculateOffsetFromAnchor(this.config.direction));
  };

  Popover.prototype.centerAlignTargetToTrigger = function(pos, direction) {
    return pos - this.getElementCenterPosition(this.$target)[direction] + this.getElementCenterPosition(this.$trigger)[direction];
  };

  Popover.prototype.calculateOffsetFromAnchor = function(direction) {
    var dispatch;

    dispatch = {
      top: function() {
        var left = this.getElementBoundaries(this.$trigger).left;

        if(this.config.halign) {
          left = this.centerAlignTargetToTrigger(left, 'horizontal');
        }
        if(left < 0) {
          left = 0;
        }
        return {
          left: left,
          top: this.getElementBoundaries(this.$trigger).bottom - this.$trigger.outerHeight() - this.$target.outerHeight()
        };
      },

      bottom: function() {
        var left = this.getElementBoundaries(this.$trigger).left;

        if(this.config.halign) {
          left = this.centerAlignTargetToTrigger(left, 'horizontal');
        }
        if(left < 0) {
          left = 0;
        }
        return {
          left: left,
          top: this.getElementBoundaries(this.$trigger).bottom
        };
      },

      left: function() {
        var top = this.getElementBoundaries(this.$trigger).top;

        if(this.config.valign) {
          top = this.centerAlignTargetToTrigger(top, 'vertical');
        }
        return {
          right: $('body').width() - this.getElementBoundaries(this.$trigger).left,
          top: top
        };
      },

      right: function() {
        var top = this.getElementBoundaries(this.$trigger).top;

        if(this.config.valign) {
          top = this.centerAlignTargetToTrigger(top, 'vertical');
        }
        return {
          left: this.getElementBoundaries(this.$trigger).left + this.$trigger.outerWidth(),
          top: top
        };
      }
    };
    return $.proxy((dispatch[direction] || dispatch.right), this)();
  };

  Popover.prototype.getElementBoundaries = function($el) {
    return {
      top: Math.round($el.position().top),
      bottom: Math.round($el.position().top + $el.outerHeight()),
      left: Math.round($el.position().left),
      right: Math.round($el.position().left + $el.outerWidth())
    };
  };

  Popover.prototype.getElementCenterPosition = function($el) {
    return {
      horizontal: $el.outerWidth() / 2,
      vertical: $el.outerHeight() / 2
    };
  };

  return Popover;
});
