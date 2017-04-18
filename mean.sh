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
	npm install express mongoose body-parser --save

	mkdir client
	cd client

		mkdir assets
		cd assets

			mkdir factories
			cd factories

				touch factory0.js
				echo "app.factory('factory0',[function() {\n\tvar factory = {}\n\tvar content = []\n\tfactory.new = {}\n\tvar next_id = 1\n\n\tfactory.all = function() {\n\t\treturn content\n\t}\n\n\tfactory.get = function(callback) {\n\t\treturn callback(content)\n\t}\n\n\tfactory.find = function(id) {\n\t\tfor (var i = 0; i < content.length; i++) {\n\t\t\tif (content[i].id == id) {\n\t\t\t\treturn content[i]\n\t\t\t}\n\t\t}\n\t}\n\n\tfactory.add = function() {\n\t\tfactory.new.id = next_id++\n\t\tcontent.push(factory.new)\n\t\tfactory.new = {}\n\t}\n\n\tfactory.delete = function(index) {\n\t\tfor (var i = index; i < content.length; i++) {\n\t\t\tcontent[i] = content[i+1]\n\t\t}\n\t\tcontent.pop()\n\t}\n\n\treturn factory\n}])" >> factory0.js

			cd ..

			mkdir controllers
			cd controllers

				touch controller0.js
				echo "app.controller('controller0',['\$scope','factory0',function(\$scope,factory0) {\n\t\$scope.Zero = factory0\n}])" >> controller0.js

		cd ../..

		mkdir partials
		cd partials

			touch partial0.html
			echo "<h1>Partial Zero</h1>" >> partial0.html

		cd ..

		mkdir static
		cd static

			touch style.css

		cd ..

		touch app.js
		echo "var app = angular.module('app', ['ngRoute'])\n\napp.config(function(\$routeProvider) {\n\t\$routeProvider.when('/',{\n\t\ttemplateUrl: 'partials/partial0.html',\n\t\tcontroller:  'controller0'\n\t})\n\t\$routeProvider.otherwise({\n\t\tredirectTo: '/'\n\t})\n})" >> app.js

		touch index.html
		echo "<!DOCTYPE html>\n<html ng-app='app'>\n\t<head>\n\t\t<title>$project</title>\n\t\t<link rel=\"stylesheet\" type=\"text/css\" href=\"static/style.css\">\n\t\t<script type=\"text/javascript\" src=\"angular/angular.js\"></script>\n\t\t<script type=\"text/javascript\" src=\"angular-route/angular-route.js\"></script>\n\t\t<script src='app.js'></script>\n\t\t<script src='assets/factories/factory0.js'></script>\n\t\t<script src='assets/controllers/controller0.js'></script>\n\t\t<script type=\"text/javascript\">\n\n\t\t\t// Other JavaScript Here\n\n\t\t</script>\n\t</head>\n\t<body>\n\t\t<h1 ng-if=\"false\">Error: Cannot Run Angular</h1>\n\t\t<div ng-view><!-- Partials load here --></div>\n\t\t<a href=\"#!/\">Partial 0</a>\n\t</body>\n</html>" >> index.html

	cd ..

	mkdir server
	cd server

		mkdir config
		cd config

			touch mongoose.js
			echo "" >> mongoose.js

			touch routes.js
			echo "" >> routes.js

		cd ..

		mkdir controllers
		# cd controllers

		mkdir models
		# cd models

	cd ..

	touch server.js
	echo "var mongoose = require('mongoose'),\n\texpress  = require('express'),\n\tbp       = require('body-parser'),\n\tpath     = require('path'),\n\troot     = __dirname,\n\tport     = process.env.PORT || 8000,\n\tapp      = express();\napp.use(express.static(path.join(root, 'client')));\napp.use(express.static(path.join(root, 'bower_components')));\napp.use(bp.json())\napp.listen(port, function() {\n\tconsole.log('Running at LOCALHOST: 127.0.0.1:'+port)\n});" >> server.js

	touch .gitignore
	echo "*.pem\nnode_modules\nbower_components\nlink.txt" >> .gitignore

	echo "\n\tcd $project\n\tnodemon server.js\n"