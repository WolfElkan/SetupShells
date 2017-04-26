echo "Please enter your name:"
read author
# author="test"
# echo $author

echo "Please enter your email:"
read email
# email="test@example.com"
# echo $email

echo "Please enter a name for the project:"
read project

echo "Please enter an entity name as a singular noun:"
read entity

echo "If the plural of $entity is something other than ""$entity""s, please enter it below.  Otherwise, press enter."
read plural
if [[ "$plural" = "" ]]; then
	plural="$entity""s"
fi

echo "If database name is something other than ""$project"", please enter it below.  Otherwise, press enter."
read dbname
if [[ "$dbname" = "" ]]; then
	dbname="$project"
fi

# echo $entity $plural
Entity="$(tr '[:lower:]' '[:upper:]' <<< ${entity:0:1})${entity:1}"
Plural="$(tr '[:lower:]' '[:upper:]' <<< ${plural:0:1})${plural:1}"

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

				touch "$Entity"Factory.js
				echo "app.factory('"$Entity"Factory',['\$http','\$q',function(\$http,\$q) {\n\n\tvar factory = {}\n\tvar content = []\n\n\tfunction valid("$entity") {\n\t\treturn true\n\t}\n\n\tfactory.all = function() {\n\t\t\$http.get('/"$plural"').then(function(returned) {\n\t\t\tconsole.log(returned)\n\t\t\treturn returned.data."$plural"\n\t\t})\n\t}\n\n\tfactory.get = function(callback) {\n\t\tif (typeof(callback) == 'function') {\n\t\t\treturn callback(content)\n\t\t} else {\n\t\t\tthrow new TypeError('Expected Function, got',callback.__proto__.constructor.name)\n\t\t}\n\t}\n\n\tfactory.findex = function(id,key='_id') {\n\t\tfor (var i = 0; i < content.length; i++) {\n\t\t\tif (content[i][key] == id) {\n\t\t\t\treturn i\n\t\t\t}\n\t\t}\n\t}\n\n\tfactory.find = function(id,key='_id') {\n\t\tvar index = factory.findex(id,key)\n\t\treturn content[index]\n\t}\n\n\tfactory.create = function(new_"$entity") {\n\t\tif (valid(new_"$entity")) {\n\t\t\t\$http.post('/"$plural"',new_"$entity").then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tcontent.push(returned.data)\n\t\t\t\t} else {\n\t\t\t\t\tconsole.log(returned)\n\t\t\t\t}\n\t\t\t})\n\t\t}\n\t}\n\n\tfactory.update = function(id,patch) {\n\t\tif (valid(patch)) {\n\t\t\t\$http.put('/"$plural"',{'query':{'_id':id},'patch':patch}).then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tvar index = factory.findex(id)\n\t\t\t\t\tcontent[index] = returned.data\n\t\t\t\t} else {\n\t\t\t\t\tconsole.log(returned)\n\t\t\t\t}\n\t\t\t})\n\t\t}\n\t}\n\n\tfactory.delete = function(id) {\n\t\tif (findex(id)+1) {\n\t\t\t\$http.delete('/"$plural"/id').then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tvar index = factory.findex(id)\n\t\t\t\t\tfor (var i = index; i < content.length; i++) {\n\t\t\t\t\t\tcontent[i] = content[i+1]\n\t\t\t\t\t}\n\t\t\t\t\tcontent.pop()\n\t\t\t\t} else {\n\t\t\t\t\tconsole.log(returned)\n\t\t\t\t}\n\t\t\t})\n\t\t}\n\t}\n\n\treturn factory\n\n}])" >> "$Entity"Factory.js

			cd ..

			mkdir controllers
			cd controllers

				touch "$plural"_cxr.js
				\n echo "app.controller('"$plural"_cxr',['\$scope','\$location','\$routeParams','"$Entity"Factory',function(\$scope,\$location,\$routeParams,"$Entity"Factory,) {\n\n\t\$scope.$Entity = "$Entity"Factory\n\n\t\$scope."$entity"_index = "$Entity"Factory.all( )\n\t\$scope."$entity"_show = function(_id) {\n\t\treturn "$Entity"Factory.find(_id)\n\t}\n\n\t\$scope."$entity"_new = {}\n\t\$scope."$entity"_create = function() {\n\t\t"$Entity"Factory.create(\$scope."$entity"_new)\n\t\t\$location.url('/"$plural"')\n\t}\n\n\t\$scope."$entity"_edit = {}\n\t\$scope."$entity"_update = function() {\n\t\t"$Entity"Factory.update(\$routeParams.id,\$scope."$entity"_edit = {})\n\t\t\$location.url('/"$plural"')\n\t}\n\n\t\$scope."$entity"_delete = function() {\n\t\t"$Entity"Factory.delete(\$scope.new_"$entity")\n\t}\n}])" >> "$plural""_cxr.js"

		cd ../..

		mkdir partials
		cd partials

			mkdir $plural
			cd $plural

				touch index.html
				echo "<h1>"$Plural" Index</h1>\n<table>\n\t<thead>\n\t\t<th>Object</th>\n\t\t<th>Routes</th>\n\t</thead>\n\t<tr ng-repeat='"$entity" in "$entity"_index'>\n\t\t<td>{{"$entity".field}}</td>\n\t\t<td>\n\t\t\t<a href='"$plural"/show/"$entity"._id'>Show</a>\n\t\t\t<a href='"$plural"/edit/"$entity"._id'>Edit</a>\n\t\t\t<a href='#' ng-click='"$entity"_delete("$entity"._id)'>Delete</a>\n\t\t</td>\n\t</tr>\n</table>" >> index.html

				touch new.html
				echo "<h1>New "$Entity"</h1>\nField: <input ng-model='"$entity"_new.field'>\n<button ng-click='"$entity"_create( )'>Create</button>" >> new.html

				touch edit.html
				echo "<h1>Edit "$Entity"</h1>\nField: <input ng-model='"$entity"_edit.field'>\n<button ng-click='"$entity"_update( )'>Update</button>" >> edit.html

				touch show.html
				echo "<h1>Show "$Entity"</h1>\n{{"$entity"_show}}" >> show.html

		cd ../..

		mkdir static
		cd static

			touch style.css

		cd ..

		touch app.js
		echo "var app = angular.module('app', ['ngRoute'])\n\napp.config(function(\$routeProvider) {\n\t\$routeProvider.when('/"$plural"',{\n\t\ttemplateUrl : 'partials/"$plural"/index.html',\n\t\tcontroller  : '"$plural"_cxr'\n\t})\n\t\$routeProvider.when('/"$plural"/new',{\n\t\ttemplateUrl : 'partials/"$plural"/new.html',\n\t\tcontroller  : '"$plural"_cxr'\n\t})\n\t\$routeProvider.when('/"$plural"/show',{\n\t\ttemplateUrl : 'partials/"$plural"/show.html',\n\t\tcontroller  : '"$plural"_cxr'\n\t})\n\t\$routeProvider.when('/"$plural"/edit',{\n\t\ttemplateUrl : 'partials/"$plural"/edit.html',\n\t\tcontroller  : '"$plural"_cxr'\n\t})\n\t\$routeProvider.otherwise({\n\t\tredirectTo: '/"$plural"'\n\t})\n})" >> app.js

		touch index.html
		echo "<!DOCTYPE html>\n<html ng-app='app'>\n\t<head>\n\t\t<title>$project</title>\n\t\t<link rel=\"stylesheet\" type=\"text/css\" href=\"static/style.css\">\n\t\t<script type=\"text/javascript\" src=\"angular/angular.js\"></script>\n\t\t<script type=\"text/javascript\" src=\"angular-route/angular-route.js\"></script>\n\t\t<script src='app.js'></script>\n\t\t<script src='assets/factories/"$Entity"Factory.js'></script>\n\t\t<script src='assets/controllers/"$plural"_cxr.js'></script>\n\t\t<script type=\"text/javascript\">\n\n\t\t\t// Other JavaScript Here\n\n\t\t</script>\n\t</head>\n\t<body>\n\t\t<h1 ng-if=\"false\">Error: Cannot Run Angular</h1>\n\t\t<div ng-view><!-- Partials load here --></div>\n\t\t<a href='#!/"$plural"'>Home</a>\n\t\t<a href='#!/"$plural"/new'>New</a>\n\t</body>\n</html>" >> index.html

	cd ..

	mkdir server
	cd server

		mkdir config
		cd config

			touch mongoose.js
			echo "// require mongoose\nvar mongoose = require('mongoose');\n\n// configure mongoose promises\nmongoose.Promise = global.Promise;\n\n// require the fs module for loading model files\nvar fs = require('fs');\n\n// require path for getting the models path\nvar path = require('path');\n\n// connect to mongoose!\nmongoose.connect('mongodb://localhost/"$dbname"');\n\n// create a variable that points to the path where all of the models live\nvar models_path = path.join(__dirname, './../models');\n\n// read all of the files in the models_path and require (run) each of the javascript files\nfs.readdirSync(models_path).forEach(function(file) {\n\n\tif (file.indexOf('.js') >= 0) {\n\t\t// require the file (this runs the model file which registers the schema)\n\t\trequire(models_path + '/' + file);\n\t}\n\n});\n\nmodule.exports = mongoose" >> mongoose.js

			touch routes.js
			echo "var "$plural" = require('../controllers/"$plural".js')\n\nmodule.exports = function(app){\n\n\tapp.get('/"$plural"', function(req, res) {\n\t\t"$plural".index(req, res);\n\t});\n\n\tapp.get('/"$plural"/:id', function(req, res) {\n\t\t"$plural".show(req, res);\n\t});\n\n\tapp.post('/"$plural"', function(req, res) {\n\t\t"$plural".create(req, res);\n\t});\n\n\tapp.put('/"$plural"/:id', function(req, res) {\n\t\t"$plural".update(req, res);\n\t});\n\n\tapp.delete('/"$plural"/:id', function(req, res) {\n\t\t"$plural".delete(req, res);\n\t});\n\n}" >> routes.js

		cd ..

		mkdir controllers
		cd controllers

			touch $plural.js
			echo "var "$Entity" = require('../models/"$entity".js')\n\nvar "$plural" = {}\n\n"$plural".index  = function(request, response) {\n\t"$Entity".find({},function(error,result) {\n\t\tresponse.json({'"$plural"':result})\n\t})\n}\n\n"$plural".create = function(request,response) {\n\tnew_"$entity" = new "$Entity"({\n\t\tfield   : request.body.field,\n\t\ttemp_id : request.body.temp_id,\n\t})\n\tnew_"$entity".save(function(error,result) {\n\t\tif (error) {\n\t\t\tconsole.log(500,error)\n\t\t} else {\n\t\t\tconsole.log(201)\n\t\t\t// console.log(result)\n\t\t\tresponse.json(result)\n\t\t}\n\t})\n}\n\n"$plural".update = function(request, response) {\n\tvar query = request.body.query\n\tvar patch = request.body.patch\n\t"$Entity".update(query,patch,function(error,result) {\n\t\tif (error) {\n\t\t\tconsole.log(500,error)\n\t\t} else {\n\t\t\tconsole.log(201.5)\n\t\t\tresponse.json(result)\n\t\t}\n\t})\n}\n\n"$plural".delete = function(request, response) {\n\t"$Entity".remove({'_id':request.body._id},function(error,result) {\n\t\tif (error) {\n\t\t\tconsole.log(500,error)\n\t\t} else {\n\t\t\tconsole.log(201.9)\n\t\t\tresponse.json(result)\n\t\t}\n\t})\n}\n\nmodule.exports = "$plural"" >> $plural.js

		cd ..

		mkdir models
		cd models

			touch $entity.js
			echo "var mongoose = require('mongoose')\n\nvar "$Entity"Schema = new mongoose.Schema({\n\tfield   : String,\n\ttemp_id : Number,\n},{\ttimestamps: { \n\t\tcreatedAt: 'created_at', \n\t\tupdatedAt: 'updated_at',\n\t} \n});\n\nmongoose.model('"$plural"',"$Entity"Schema);\n\nmodule.exports = mongoose.model('"$plural"');" >> $entity.js

		cd ..

	cd ..

	touch server.js
	echo "var\texpress  = require('express'),\n\tbp       = require('body-parser'),\n\tpath     = require('path'),\n\troot     = __dirname,\n\tport     = process.env.PORT || 8000,\n\tapp      = express();\napp.use(express.static(path.join(root, 'client')));\napp.use(express.static(path.join(root, 'bower_components')));\napp.use(bp.json())\nrequire('./server/config/mongoose.js');\nrequire('./server/config/routes.js')(app);\napp.listen(port, function() {\n\tconsole.log('Running at LOCALHOST: 127.0.0.1:'+port)\n});" >> server.js

	touch .gitignore
	echo "*.pem\nnode_modules\nbower_components\nlink.txt" >> .gitignore

	echo "\nnav:\tcd $project\nrun:\tnodemon server.js\ndb :\tuse $dbname\n"
