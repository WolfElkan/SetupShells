echo "Please enter your name:"
read author

echo "Please enter your email:"
read email

echo "Please enter a name for the project:"
read project

mkdir $project
cd $project

	touch bower.json
	echo "{\n  \"name\": \"$project\",\n  \"authors\": [\n    \"$author <$email>\"\n  ],\n  \"description\": \"\",\n  \"main\": \"\",\n  \"license\": \"MIT\",\n  \"homepage\": \"\",\n  \"ignore\": [\n    \"**/.*\",\n    \"node_modules\",\n    \"bower_components\",\n    \"test\",\n    \"tests\"\n  ]\n}" >> bower.json
	bower install angular angular-route --save
	npm init -y
	npm install express --save

	mkdir client
	cd client

		mkdir partials
		cd partials

			touch partial0.html
			echo "<h1>Partial Zero</h1>" >> partial0.html

		cd ..

		touch index.html
		echo "<!DOCTYPE html>\n<html ng-app='app'>\n\t<head>\n\t\t<title>ls</title>\n\t\t<script type=\"text/javascript\" src=\"angular/angular.js\"></script>\n\t\t<script type=\"text/javascript\" src=\"angular-route/angular-route.js\"></script>\n\t\t<script type=\"text/javascript\">\n\t\t\t\n\t\tvar app = angular.module('app', ['ngRoute'])\n\t\tapp.config(function(\$routeProvider) {\n\t\t\t\$routeProvider.when('/',{\n\t\t\t\ttemplateUrl: 'partials/partial0.html'\n\t\t\t})\n\t\t\t\$routeProvider.otherwise({\n\t\t\t\tredirectTo: '/'\n\t\t\t})\n\t\t})\n\n\t\t</script>\n\t</head>\n\n\t<body>\n\t<h1 ng-if=\"false\">Error: Cannot Run Angular</h1>\n\t<div ng-view>\n\t\t<!-- Partials load here -->\n\t</div>\n\t<a href=\"#!/\">Partial 0</a>\n\t</body>\n</html>" >> index.html
	
	cd ..

	touch server.js
	echo "var express = require('express')\nvar app = express()\nvar path = require('path')\n\napp.use(express.static(path.join(__dirname, './client')));\napp.use(express.static(path.join(__dirname, './bower_components')));\n\nvar port = process.env.PORT || 8000\napp.listen(port, function() {\n\tconsole.log('Running at LOCALHOST: 127.0.0.1:'+port)\n})" >> server.js
