(function() {
  var Diagram, angular, baseoption, directive_link, draw, language_directive_link, render, seq;

  if (typeof require === "function") {
    require("angular");
  }

  if (typeof require === "function") {
    require("js-sequence-diagrams");
  }

  angular = (typeof global !== "undefined" && global !== null ? global.angular : void 0) || (typeof window !== "undefined" && window !== null ? window.angular : void 0);

  Diagram = (typeof global !== "undefined" && global !== null ? global.Diagram : void 0) || (typeof window !== "undefined" && window !== null ? window.Diagram : void 0);

  seq = angular.module("atSequenceDiagram", []);

  baseoption = {
    theme: "simple"
  };

  render = function(sequence_code, option) {
    var $rendering_area, body, diagram, rendering_area;
    if (option == null) {
      option = {};
    }
    option = angular.extend({}, baseoption, option);
    rendering_area = document.getElementById('at-sequence-diagram-rendering-area');
    if (rendering_area == null) {
      rendering_area = angular.element("<div id='at-sequence-diagram-rendering-area' style='height:0px; overflow:hidden'></div>")[0];
      body = document.getElementsByTagName("body")[0];
      body.appendChild(rendering_area);
    }
    $rendering_area = angular.element(rendering_area);
    $rendering_area.html("");
    diagram = Diagram.parse(sequence_code);
    diagram.drawSVG(rendering_area, option);
    return $rendering_area.html();
  };

  draw = function(sequence_code, output_element, option) {
    var $elm, svg;
    if (option == null) {
      option = {};
    }
    $elm = angular.element(output_element);
    svg = render(sequence_code, option);
    $elm.html(svg);
  };

  directive_link = function(scope, element, attrs) {
    return draw(attrs.sequenceDiagram || element.text(), element, attrs);
  };

  language_directive_link = function() {};

  seq.provider("sequenceDiagram", function() {
    this.option = function(opt) {
      baseoption = angular.extend(baseoption, opt);
      return this;
    };
    this.extendElement = function() {
      angular.element.prototype.sequence = function(option) {
        if (option == null) {
          option = {};
        }
        return angular.forEach(this, function(elm) {
          var $elm, sequence_code;
          $elm = angular.element(elm);
          sequence_code = unescape($elm.text());
          return draw(sequence_code, $elm, option);
        });
      };
      return this;
    };
    this.enableLanguageDirective = function() {
      language_directive_link = directive_link;
      return this;
    };
    this.$get = function($_sce) {
      return {
        "render": render,
        "draw": draw
      };
    };
  });

  seq.directive("sequenceDiagram", function() {
    return {
      restrict: "E",
      scope: true,
      transclude: true,
      replace: true,
      template: "<div ng-bind-html=\"diagram\" class=\"at-sequence-diagram\"></div>",
      controller: [
        "$scope", "$element", "$attrs", "$transclude", "$sce", function($scope, $element, $attrs, $transclude, $sce) {
          var diagram;
          diagram = render($attrs.sequenceDiagram || $transclude().text(), $attrs);
          return $scope.diagram = $sce.trustAsHtml(diagram);
        }
      ]
    };
  });

  seq.directive("sequenceDiagram", function() {
    return {
      restrict: "A",
      template: "",
      link: directive_link
    };
  });

  seq.directive("languageSequence", function() {
    return {
      restrict: "C",
      template: "",
      link: language_directive_link
    };
  });

}).call(this);
