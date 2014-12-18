Angular Sequence Diagram
================

This is a module for using [js-sequence-diagrams](http://bramp.github.io/js-sequence-diagrams/) on AngularJS.

## example

```js
// app.js

var app = angular.module("app", ["atSequenceDiagram"]);

// using provider.
app.config(["sequenceDiagramProvider", "$sceProvider", function(sequenceProvider, $sceProvider){
	// set common option.
	sequenceProvider.option({theme: "hand"});

	// enable language-sequence directive.
	sequenceProvider.enableLanguageDirective();
}]);


// using on controller.
app.controller("ctrl", ["$scope", "sequenceDiagram", "$sce", function($scope, sequence, $sce){
	$scope.svg = $sce.trustAsHtml(sequence.render("A->B: Does something"));
}])
```

```html
<!doctype html>
<html ng-app="app">
	<head>
		<script src="bower_components/underscore/underscore-min.js"></script>
		<script src="bower_components/raphael/raphael-min.js"></script>
		<script src="bower_components/js-sequence-diagrams/build/sequence-diagram-min.js"></script>
		<script src="bower_components/angular/angular.js"></script>
		<script src="angular-sequence-diagram.js"></script>
		<script src="app.js"></script>
	</head>
	<body>
		<!-- using on controller. -->
		<div ng-controller="ctrl">
			<div ng-bind-html="svg"></div>
		</div>

		<!-- using directive by element. -->
		<sequence-diagram>
			A->B: E
			A->B: Does something
		</sequence-diagram>

		<!-- using directive by attribute. -->
		<div sequence-diagram>
			A->B: A
		</div>

		<!-- using directive by attribute with value. -->
		<div ng-init="code='a->b: does something'" sequence-diagram="{{code}}">
		</div>

		<!-- using directive by class "language-sequence". -->
		<pre><code class="language-sequence">
			A->B: C
			A->B: Does something
		</code></pre>
	</body>
</html>
```


