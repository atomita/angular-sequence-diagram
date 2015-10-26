
require?("angular")
require?("js-sequence-diagrams")

angular = global?.angular || window?.angular
Diagram = global?.Diagram || window?.Diagram


seq = angular.module "atSequenceDiagram", []


baseoption =
	theme: "simple"


render = (sequence_code, option = {})->
	option = angular.extend {}, baseoption, option

	# createElementしただけのelementだと、drawSVG時に文字位置等がおかしくなるため、document上のelementを使う
	rendering_area = document.getElementById('at-sequence-diagram-rendering-area')
	if not rendering_area?
		rendering_area = angular.element("<div id='at-sequence-diagram-rendering-area' style='height:0px; overflow:hidden'></div>")[0]
		body = document.getElementsByTagName("body")[0]
		body.appendChild rendering_area
	$rendering_area = angular.element rendering_area
	$rendering_area.html ""

	diagram = Diagram.parse sequence_code
	diagram.drawSVG rendering_area, option
	$rendering_area.html()


draw = (sequence_code, output_element, option = {})->
	$elm = angular.element output_element
	svg = render sequence_code, option
	$elm.html svg
	return


directive_link = (scope, element, attrs)->
	draw attrs.sequenceDiagram or element.text(), element, attrs


language_directive_link = -> return


seq.provider "sequenceDiagram", ()->
	@option = (opt)->
		baseoption = angular.extend baseoption, opt
		@

	@extendElement = ()->
		angular.element.prototype.sequence = (option = {})->
			angular.forEach @, (elm)->
				$elm = angular.element elm
				sequence_code = unescape $elm.text()
				draw sequence_code, $elm, option
		@

	@enableLanguageDirective = ->
		language_directive_link = directive_link
		@

	@$get = ($_sce)->
		"render": render
		"draw": draw

	return


seq.directive "sequenceDiagram", ->
	{
		restrict: "E"
		scope: true
		transclude: true
		replace: true
		template: "<div ng-bind-html=\"diagram\" class=\"at-sequence-diagram\"></div>"
		controller: [
			"$scope"
			"$element"
			"$attrs"
			"$transclude"
			"$sce"
			($scope, $element, $attrs, $transclude, $sce)->
				diagram = render $attrs.sequenceDiagram or $transclude().text(), $attrs
				$scope.diagram = $sce.trustAsHtml diagram
		]
	}
seq.directive "sequenceDiagram", ->
	{
		restrict: "A"
		template: ""
		link: directive_link
	}


seq.directive "languageSequence", ->
	{
		restrict: "C"
		template: ""
		link: language_directive_link
	}
