# echo "Please enter your name:"
# read author
author="your_name_here"
echo $author

# echo "Please enter your email:"
# read email
email="email@domain.com"
echo $email

echo "Please enter a name for the project:"
read project

echo "Please enter an entity name as a singular noun:"
read entity

echo "If the plural of $entity is something other than '"$entity"s', please enter it below.  Otherwise, press enter."
read plural
if [[ "$plural" = "" ]]; then
	plural="$entity""s"
fi

echo "If database name is something other than '"$project"', please enter it below.  Otherwise, press enter to create the project."
read dbname
if [[ "$dbname" = "" ]]; then
	dbname="$project"
fi

Entity="$(tr '[:lower:]' '[:upper:]' <<< ${entity:0:1})${entity:1}"
Plural="$(tr '[:lower:]' '[:upper:]' <<< ${plural:0:1})${plural:1}"



mkdir $project
cd $project

	touch bower.json
	echo "{\n  \"name\": \"$project\",\n  \"authors\": [\n    \"$author <$email>\"\n  ],\n  \"description\": \"\",\n  \"main\": \"\",\n  \"license\": \"MIT\",\n  \"homepage\": \"\",\n  \"ignore\": [\n    \"**/.*\",\n    \"node_modules\",\n    \"bower_components\",\n    \"test\",\n    \"tests\"\n  ]\n}" >> bower.json
	bower install angular angular-route --save

	npm init -y
	npm install express mongoose body-parser --save

	touch .gitignore
	echo "*.pem\nnode_modules\nbower_components\nlink.txt" >> .gitignore

	touch server.js
	echo "var\texpress  = require('express'),\n\tbp       = require('body-parser'),\n\tpath     = require('path'),\n\troot     = __dirname,\n\tport     = process.env.PORT || 8000,\n\tapp      = express();\napp.use(express.static(path.join(root, 'client')));\napp.use(express.static(path.join(root, 'bower_components')));\napp.use(bp.json())\nrequire('./server/config/mongoose.js');\nrequire('./server/config/routes.js')(app);\napp.listen(port, function() {\n\tconsole.log('Running at LOCALHOST: 127.0.0.1:'+port)\n});" >> server.js

	mkdir client
	cd client

		mkdir assets
		cd assets

			mkdir $Entity
			cd $Entity

				touch Factory.js
				echo "app.factory('"$Entity"Factory',['\$http','\$find','\$valid',function(\$http,\$find,\$valid) {\n\n\tvar factory = {}\n\tvar content = []\n\n\tfactory.get = function(callback) {\n\t\tif (typeof(callback) == 'function') {\n\t\t\tif (content[0]) {\n\t\t\t\treturn callback(content)\n\t\t\t} else {\n\t\t\t\t\$http.get('/"$plural"').then(function(returned) {\n\t\t\t\t\tcontent = returned.data."$plural"\n\t\t\t\t\treturn callback(content)\n\t\t\t\t})\n\t\t\t}\n\t\t} else if (!callback) {\n\t\t\tif (!content[0]) {\n\t\t\t\tvar promise = \$http.get('/"$plural"')\n\t\t\t\tpromise.then(function(returned) {\n\t\t\t\t\tcontent = returned.data."$plural"\n\t\t\t\t})\n\t\t\t\treturn promise\n\t\t\t}\n\t\t} else {\n\t\t\tthrow new TypeError('Expected Function, got',callback.__proto__.constructor.name)\n\t\t}\n\t}\n\n\tfactory.validations = []\n\n\tfactory.create = function(new_"$entity") {\n\t\tif (\$valid.ate(factory,new_"$entity").valid) {\n\t\t\tvar promise = \$http.post('/"$plural"',new_"$entity")\n\t\t\tpromise.then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tcontent.push(returned.data)\n\t\t\t\t} else {\n\t\t\t\t\tconsole.log(returned)\n\t\t\t\t}\n\t\t\t})\n\t\t\treturn promise\n\t\t}\n\t}\n\n\tfactory.update = function(id,patch) {\n\t\tif (\$valid.ate(patch).valid) {\n\t\t\tvar promise = \$http.put('/"$plural"/'+id,{'query':{'_id':id},'patch':patch})\n\t\t\tpromise.then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tvar index = \$find.index(id)\n\t\t\t\t\tcontent[index] = returned.data\n\t\t\t\t} else {\n\t\t\t\t\tconsole.log(returned)\n\t\t\t\t}\n\t\t\t})\n\t\t\treturn promise\n\t\t}\n\t}\n\n\tfactory.delete = function(id) {\n\t\tif (\$find.index(id)+1) {\n\t\t\tvar promise = \$http.delete('/"$plural"/'+id)\n\t\t\tpromise.then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tvar index = \$find.index(id)\n\t\t\t\t\tfor (var i = index; i < content.length; i++) {\n\t\t\t\t\t\tcontent[i] = content[i+1]\n\t\t\t\t\t}\n\t\t\t\t\tcontent.pop()\n\t\t\t\t} else {\n\t\t\t\t\t// console.log(returned)\n\t\t\t\t}\n\t\t\t})\n\t\t\treturn promise\n\t\t}\n\t}\n\n\tfactory.print = function() {\n\t\tif (content.length) {\n\t\t\tconsole.log(content)\n\t\t} else {\n\t\t\tconsole.log('getting content...')\n\t\t\tfactory.get(function(content) {\n\t\t\t\tconsole.log(content)\n\t\t\t})\n\t\t}\n\t}\n\n\treturn factory\n\n}])" >> Factory.js

				mkdir edit
				cd edit

					touch Edit"$Entity".js
					echo "app.controller('Edit"$Entity"',['\$scope','\$location','\$routeParams','\$find','"$Entity"Factory',function(\$scope,\$location,\$routeParams,\$find,"$Entity"Factory,) {\n\n\tvar id = \$routeParams.id\n\n\t"$Entity"Factory.get(function(content) {\n\t\t\$scope."$entity" = \$find.clone(content,id)\n\t})\n\n\t\$scope.update = function() {\n\t\t"$Entity"Factory.update(id,\$scope."$entity").then(function( ) {\n\t\t\t\$location.url('/"$plural"')\n\t\t})\n\t}\n\n\t\$scope.delete = function(id) {\n\t\t"$Entity"Factory.delete(id)\n\t\t\$location.url('/"$plural"')\n\t}\n\n\t\$scope.print = function() {\n\t\tconsole.log(\$scope."$entity")\n\t}\n\n}])" >> Edit"$Entity".js

					touch Edit"$Entity".html
					echo "<h1>Edit "$Entity"</h1>\nField: <input ng-model='"$entity".field'>\n<button ng-click='update()'>Update</button>\n<button ng-click='print()'>Print</button>" >> Edit"$Entity".html

				cd ..

				mkdir index
				cd index

					touch Index"$Entity".js
					echo "app.controller('Index"$Entity"',['\$scope','\$location','"$Entity"Factory',function(\$scope,\$location,"$Entity"Factory,) {\n\n\t"$Entity"Factory.get(function(content) {\n\t\t\$scope."$plural" = content\n\t})\n\n\t\$scope.delete = function(id) {\n\t\t"$Entity"Factory.delete(id)\n\t}\n\n\t\$scope.print = function() {\n\t\t"$Entity"Factory.print( )\n\t}\n\n}])" >> Index"$Entity".js

					touch Index"$Entity".html
					echo "<h1>"$Plural" Index</h1>\n<table>\n\t<thead>\n\t\t<th>Field</th>\n\t\t<th>Actions</th>\n\t</thead>\n\t<tr ng-repeat='"$entity" in "$plural"'>\n\t\t<td>{{"$entity".field}}</td>\n\t\t<td>\n\t\t\t<a href='#!/"$plural"/show/{{"$entity"._id}}'>Show</a>\n\t\t\t<a href='#!/"$plural"/edit/{{"$entity"._id}}'>Edit</a>\n\t\t\t<a href='#' ng-click='delete("$entity"._id)'>Delete</a>\n\t\t</td>\n\t</tr>\n</table>\n<button ng-click='print()'>Show All</button>" >> Index"$Entity".html

				cd ..

				mkdir new
				cd new

					touch New"$Entity".js
					echo "app.controller('New"$Entity"',['\$scope','\$location','\$routeParams','\$valid','"$Entity"Factory',function(\$scope,\$location,\$routeParams,\$valid,"$Entity"Factory,) {\n\n\t\$scope."$entity" = {}\n\n\t\$scope.create = function() {\n\t\t\$scope.errors = {}\n\t\tvar "$entity" = \$scope."$entity"\n\t\tvar obj = \$valid.ate("$Entity"Factory,"$entity")\n\t\tif (obj.valid) {\n\t\t\t"$Entity"Factory.create("$entity").then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\t\$location.url('/"$plural"')\n\t\t\t\t}\n\t\t\t})\n\t\t} else {\n\t\t\t\$valid.blame(\$scope,obj)\n\t\t}\n\t}\n\n\t\$scope.print = function() {\n\t\tconsole.log(\$scope."$entity")\n\t}\n\n}])" >> New"$Entity".js

					touch New"$Entity".html
					echo "<h1>New "$Entity"</h1>\nField: <input ng-model='"$entity".field'>\n<button ng-click='create()'>Create</button>" >> New"$Entity".html

				cd ..

				mkdir show
				cd show

					touch Show"$Entity".js
					echo "app.controller('Show"$Entity"',['\$scope','\$location','\$routeParams','\$find','"$Entity"Factory',function(\$scope,\$location,\$routeParams,\$find,"$Entity"Factory,) {\n\n\tvar id = \$routeParams.id\n\n\t"$Entity"Factory.get(function(content) {\n\t\t\$scope."$entity" = \$find.element(content,id)\n\t})\n\n\t\$scope.delete = function(id) {\n\t\t"$Entity"Factory.delete(id)\n\t}\n\n\t\$scope.print = function() {\n\t\t"$Entity"Factory.print( )\n\t}\n\n}])" >> Show"$Entity".js

					touch Show"$Entity".html
					echo "<h1>Show "$Entity"</h1>\n{{"$entity".field}}" >> Show"$Entity".html

				cd ..

			cd ..

			touch FindService.js
			echo "app.service('\$find',function() {\n\n\tvar service = {}\n\n\tservice.index = function(content,id,key='_id') {\n\t\tfor (var i = 0; i < content.length; i++) {\n\t\t\tif (content[i][key] == id) {\n\t\t\t\treturn i\n\t\t\t}\n\t\t}\n\t}\n\n\tservice.element = function(content,id,key='_id') {\n\t\tvar index = service.index(content,id,key)\n\t\treturn content[index]\n\t}\n\n\tservice.clone = function(content,id,key='_id') {\n\t\tvar element = service.element(content,id,key)\n\t\tvar result = {}\n\t\tfor (k in element) {\n\t\t\tresult[k] = element[k]\n\t\t}\n\t\treturn result\n\t}\n\n\treturn service\n\t\n})" >> FindService.js

			touch ValidService.js
			echo "app.service('\$valid',function() {\n\n\tvar service = {}\n\n\tfunction Validation(field,error) {\n\t\tthis.check = function(form,obj) {\n\t\t\tif (!this.valid(form)) {\n\t\t\t\tobj.errors.push({'field':field,'error':error})\n\t\t\t\tobj.valid = false\n\t\t\t}\n\t\t\treturn obj\n\t\t}\n\t}\n\n\t// Checks whether form data in specified field matches a given regular expression\n\tservice.Regular = function(field,regex,error) {\n\t\tvar self = new Validation(field,error)\n\t\tself.valid = function(form) {\n\t\t\tvar data = form[field] ? form[field] : ''\n\t\t\treturn Boolean(regex.exec(data))\n\t\t}\n\t\treturn self\n\t}\n\n\t// Checks whether form data in two specified fields are the same\n\t// If not, saves error to the main_field\n\tservice.Confirm = function(main_field,conf_field,error) {\n\t\tvar self = new Validation(main_field,error)\n\t\tself.valid = function(form) {\n\t\t\tvar main = form[main_field] ? form[main_field] : ''\n\t\t\tvar conf = form[conf_field] ? form[conf_field] : ''\n\t\t\treturn main == conf\n\t\t}\n\t\treturn self\n\t}\n\n\t// Private method called by the Blacklist and Whitelist methods\n\tfunction List(field,array,error,color) {\n\t\tvar self = new Validation(field,error)\n\t\tself.valid = function(form) {\n\t\t\tvar result = !color\n\t\t\tfor (var i = 0; i < array.length; i++) {\n\t\t\t\tif (form[field] == array[i]) {\n\t\t\t\t\tresult = color\n\t\t\t\t\tbreak\n\t\t\t\t}\n\t\t\t}\n\t\t\treturn result\n\t\t}\n\t\treturn self\n\t}\n\n\t// Checks to make sure that form data is NOT a member of a given array\n\tservice.Blacklist = function(field,black,error) {\n\t\treturn new List(field,black,error,false)\n\t}\n\n\t// Checks to make sure that form data IS a member of a given array\n\tservice.Whitelist = function(field,white,error) {\n\t\treturn new List(field,white,error,true)\n\t}\n\n\t// Uses a callback to check data. Note that the error parameter is 2nd, not 3rd.\n\tservice.Custom = function(field,error,callback) {\n\t\tvar self = new Validation(field,error)\n\t\tself.valid = function(form) {\n\t\t\treturn Boolean(callback(form))\n\t\t}\n\t\treturn self\n\t}\n\n\tservice.Compare = function(field,limit,error,lt,eq,gt) {\n\t\tvar self = new Validation(field,error)\n\t\tself.valid = function(form) {\n\t\t\tvar data = Number(form[field])\n\t\t\tlimit = Number(limit)\n\t\t\tif (data == limit) {\n\t\t\t\treturn Boolean(eq)\n\t\t\t} else if (data < limit) {\n\t\t\t\treturn Boolean(lt)\n\t\t\t} else if (data > limit) {\n\t\t\t\treturn Boolean(gt)\n\t\t\t} else {\n\t\t\t\treturn true\n\t\t\t}\n\t\t}\n\t\treturn self\n\t}\n\n\n\t// Checks all given validations.  Returns error object\n\tservice.ate = function(factory,form) {\n\t\tvar validations = factory.validations\n\t\tif (!validations || !validations[0]) {\n\t\t\treturn {valid:true,errors:[]}\n\t\t}\n\t\tvar obj = {valid:true,errors:[]}\n\t\tfor (var i = 0; i < validations.length; i++) {\n\t\t\tobj = validations[i].check(form,obj)\n\t\t}\n\t\treturn obj\n\t}\n\n\t// Displays errors from error object in scope\n\tservice.blame = function(\$scope,obj,form='errors') {\n\t\t\$scope[form] = {}\n\t\tvar errors = obj.errors\n\t\tfor (var i = 0; i < errors.length; i++) {\n\t\t\tvar error = errors[i]\n\t\t\tvar field = error.field\n\t\t\t\$scope[form][field] = \$scope[form][field] ? \$scope[form][field] : ''\n\t\t\t\$scope[form][field] += ' ' + error.error\n\t\t}\n\t}\n\n\treturn service\n\n})" >> ValidService.js

		cd ..

		mkdir static
		cd static

			touch style.css

		cd ..

		touch app.js
		echo "var app = angular.module('app', ['ngRoute'])\n\napp.config(function(\$routeProvider) {\n\t\$routeProvider.when('/"$plural"/edit/:id',{\n\t\ttemplateUrl : 'assets/"$Entity"/edit/Edit"$Entity".html',\n\t\tcontroller  : 'Edit"$Entity"'\n\t})\n\t\$routeProvider.when('/"$plural"',{\n\t\ttemplateUrl : 'assets/"$Entity"/index/Index"$Entity".html',\n\t\tcontroller  : 'Index"$Entity"'\n\t})\n\t\$routeProvider.when('/"$plural"/new',{\n\t\ttemplateUrl : 'assets/"$Entity"/new/New"$Entity".html',\n\t\tcontroller  : 'New"$Entity"'\n\t})\n\t\$routeProvider.when('/"$plural"/show/:id',{\n\t\ttemplateUrl : 'assets/"$Entity"/show/Show"$Entity".html',\n\t\tcontroller  : 'Show"$Entity"'\n\t})\n\t\$routeProvider.otherwise({\n\t\tredirectTo: '/"$plural"'\n\t})\n})" >> app.js

		touch index.html
		echo "<!DOCTYPE html>\n<html ng-app='app'>\n\t<head>\n\t\t<title>"$project"</title>\n\t\t<link rel='stylesheet' type='text/css' href='static/style.css'>\n\t\t<script type='text/javascript' src='angular/angular.js'></script>\n\t\t<script type='text/javascript' src='angular-route/angular-route.js'></script>\n\t\t<script src='app.js'></script>\n\t\t<script src='assets/"$Entity"/Factory.js'></script>\n\t\t<script src='assets/"$Entity"/edit/Edit"$Entity".js'></script>\n\t\t<script src='assets/"$Entity"/index/Index"$Entity".js'></script>\n\t\t<script src='assets/"$Entity"/new/New"$Entity".js'></script>\n\t\t<script src='assets/"$Entity"/show/Show"$Entity".js'></script>\n\t\t<script src='assets/ValidService.js'></script>\n\t\t<script src='assets/FindService.js'></script>\n\t</head>\n\t<body>\n\t\t<h1 ng-if='false'>Error: Cannot Run Angular</h1>\n\t\t<div ng-view><!-- Partials load here --></div>\n\t\t<a href='#!/"$plural"'>Home</a>\n\t\t<a href='#!/"$plural"/new'>New</a>\n\t</body>\n</html>" >> index.html

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
			echo "\nvar "$Entity" = require('../models/"$entity".js')\n\nvar "$plural" = {}\n\n"$plural".index  = function(request, response) {\n\t"$Entity".find({},function(error,result) {\n\t\tresponse.json({'"$plural"':result})\n\t})\n}\n\n"$plural".show = function(request, response) {\n\tvar id = request.params.id\n\t"$Entity".find({'_id':id},function(error,result) {\n\t\tresponse.json(result)\n\t})\n}\n\n"$plural".create = function(request,response) {\n\tnew_"$entity" = new "$Entity"({\n\t\tfield   : request.body.field,\n\t\ttemp_id : request.body.temp_id,\n\t})\n\tnew_"$entity".save(function(error,result) {\n\t\tif (error) {\n\t\t\t// console.log(500,error)\n\t\t} else {\n\t\t\t// console.log(201)\n\t\t\tresponse.json(result)\n\t\t}\n\t})\n}\n\n"$plural".update = function(request, response) {\n\tvar id    = request.params.id\n\tvar query = request.body.query\n\tvar patch = request.body.patch\n\t"$Entity".findOne(query,function(error,found_"$entity") {\n\t\tif (error) {\n\t\t\tresponse.json(error)\n\t\t} else {\n\t\t\tfor (key in patch) {\n\t\t\t\tfound_"$entity"[key] = patch[key]\n\t\t\t}\n\t\t\tfound_"$entity".save(function(error,saved_"$entity") {\n\t\t\t\tresponse.json(saved_"$entity")\n\t\t\t})\n\t\t}\n\t})\n}\n\n"$plural".delete = function(request, response) {\n\tvar id = request.params.id\n\t"$Entity".remove({'_id':id},function(error,result) {\n\t\tif (error) {\n\t\t\t// console.log(500,error)\n\t\t} else {\n\t\t\t// console.log(201.9)\n\t\t\tresponse.json(result)\n\t\t}\n\t})\n}\n\nmodule.exports = "$plural"" >> $plural.js

		cd ..

		mkdir models
		cd models

			touch $entity.js
			echo "var mongoose = require('mongoose')\n\nvar "$Entity"Schema = new mongoose.Schema({\n\tfield : String,\n},{\ttimestamps: { \n\t\tcreatedAt: 'created_at', \n\t\tupdatedAt: 'updated_at',\n\t} \n});\n\nmongoose.model('"$Entity"',"$Entity"Schema);\n\nmodule.exports = mongoose.model('"$Entity"');" >> $entity.js

cd ../../..

echo "\nnav:\tcd $project\nrun:\tnodemon server.js\ndb :\tuse $dbname\n"