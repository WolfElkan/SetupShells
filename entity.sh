echo "Please enter an entity name as a singular noun:"
read entity

echo "If the plural of $entity is something other than '"$entity"s', please enter it below.  Otherwise, press enter."
read plural
if [[ "$plural" = "" ]]; then
	plural="$entity""s"
fi

Entity="$(tr '[:lower:]' '[:upper:]' <<< ${entity:0:1})${entity:1}"
Plural="$(tr '[:lower:]' '[:upper:]' <<< ${plural:0:1})${plural:1}"

cd client
	cd assets
		cd controllers

			touch "$Plural"Controller.js
			echo "app.controller('"$Plural"Controller',['\$scope','\$location','\$routeParams','"$Entity"Factory',function(\$scope,\$location,\$routeParams,"$Entity"Factory,) {\n\n\tvar id = \$routeParams.id\n\n\t\$scope."$Entity" = "$Entity"Factory\n\n\t"$Entity"Factory.load( ).then(function(returned) {\n\t\t\$scope."$entity"_index = returned.data."$plural"\n\t})\n\n\t\$scope."$entity"_show = "$Entity"Factory.find(id)\n\n\t\$scope."$entity"_new = {}\n\t\$scope."$entity"_create = function() {\n\t\t"$Entity"Factory.create(\$scope."$entity"_new)\n\t\t\$location.url('/"$plural"')\n\t}\n\n\t\$scope."$entity"_edit = "$Entity"Factory.find(id)\n\t\$scope."$entity"_update = function() {\n\t\t"$Entity"Factory.update(id,\$scope."$entity"_edit)\n\t\t\$location.url('/"$plural"')\n\t}\n\n\t\$scope."$entity"_delete = function(id) {\n\t\t"$Entity"Factory.delete(id)\n\t}\n\n\t\$scope.print = function() {\n\t\t"$Entity"Factory.print( )\n\t}\n\n}])" >> "$plural""Controller.js"

		cd ..

		mkdir factories
		cd factories

			touch "$Entity"Factory.js
			echo "app.factory('"$Entity"Factory',['\$http',function(\$http) {\n\n\tvar factory = {}\n\tvar content = []\n\n\tfunction valid("$entity") {\n\t\treturn true\n\t}\n\n\tfactory.load = function() {\n\t\tvar promise = \$http.get('/"$plural"')\n\t\tpromise.then(function(returned) {\n\t\t\tcontent = returned.data."$plural"\n\t\t})\n\t\treturn promise\n\t}\n\n\tfactory.get = function(callback) {\n\t\tif (typeof(callback) == 'function') {\n\t\t\treturn callback(content)\n\t\t} else {\n\t\t\tthrow new TypeError('Expected Function, got',callback.__proto__.constructor.name)\n\t\t}\n\t}\n\n\tfactory.findex = function(id,key='_id') {\n\t\tfor (var i = 0; i < content.length; i++) {\n\t\t\tif (content[i][key] == id) {\n\t\t\t\treturn i\n\t\t\t}\n\t\t}\n\t}\n\n\tfactory.find = function(id,key='_id') {\n\t\tvar index = factory.findex(id,key)\n\t\treturn content[index]\n\t}\n\n\tfactory.create = function(new_"$entity") {\n\t\tif (valid(new_"$entity")) {\n\t\t\t\$http.post('/"$plural"',new_"$entity").then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tcontent.push(returned.data)\n\t\t\t\t} else {\n\t\t\t\t\t// console.log(returned)\n\t\t\t\t}\n\t\t\t})\n\t\t}\n\t}\n\n\tfactory.update = function(id,patch) {\n\t\tif (valid(patch)) {\n\t\t\t\$http.put('/"$plural"/'+id,{'query':{'_id':id},'patch':patch}).then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tvar index = factory.findex(id)\n\t\t\t\t\tcontent[index] = returned.data\n\t\t\t\t} else {\n\t\t\t\t\t// console.log(returned)\n\t\t\t\t}\n\t\t\t})\n\t\t}\n\t}\n\n\tfactory.delete = function(id) {\n\t\tif (factory.findex(id)+1) {\n\t\t\t\$http.delete('/"$plural"/'+id).then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tvar index = factory.findex(id)\n\t\t\t\t\tfor (var i = index; i < content.length; i++) {\n\t\t\t\t\t\tcontent[i] = content[i+1]\n\t\t\t\t\t}\n\t\t\t\t\tcontent.pop()\n\t\t\t\t} else {\n\t\t\t\t\t// console.log(returned)\n\t\t\t\t}\n\t\t\t})\n\t\t}\n\t}\n\n\tfactory.print = function() {\n\t\tconsole.log(content)\n\t}\n\n\treturn factory\n}])" >> "$Entity"Factory.js

	cd ../..

	mkdir partials
	cd partials

		mkdir $plural
		cd $plural

			touch index.html
			echo "<h1>"$Plural" Index</h1>\n<table>\n\t<thead>\n\t\t<th>Field</th>\n\t\t<th>Actions</th>\n\t</thead>\n\t<tr ng-repeat='"$entity" in "$entity"_index'>\n\t\t<td>{{"$entity".field}}</td>\n\t\t<td>\n\t\t\t<a href='#!/"$plural"/show/{{"$entity"._id}}'>Show</a>\n\t\t\t<a href='#!/"$plural"/edit/{{"$entity"._id}}'>Edit</a>\n\t\t\t<a href='#' ng-click='"$entity"_delete("$entity"._id)'>Delete</a>\n\t\t</td>\n\t</tr>\n</table>\n<button ng-click='print()'>Show All</button>" >> index.html

			touch new.html
			echo "<h1>New "$Entity"</h1>\nField: <input ng-model='"$entity"_new.field'>\n<button ng-click='"$entity"_create( )'>Create</button>" >> new.html

			touch edit.html
			echo "<h1>Edit "$Entity"</h1>\nField: <input ng-model='"$entity"_edit.field'>\n<button ng-click='"$entity"_update( )'>Update</button>" >> edit.html

			touch show.html
			echo "<h1>Show "$Entity"</h1>\n{{"$entity"_show.field}}" >> show.html

	cd ../..

	echo "{//Combine these two blocks before running\n\n\t\$routeProvider.when('/"$plural"',{\n\t\ttemplateUrl : 'partials/"$plural"/index.html',\n\t\tcontroller  : '"$Plural"Controller'\n\t})\n\t\$routeProvider.when('/"$plural"/new',{\n\t\ttemplateUrl : 'partials/"$plural"/new.html',\n\t\tcontroller  : '"$Plural"Controller'\n\t})\n\t\$routeProvider.when('/"$plural"/show/:id',{\n\t\ttemplateUrl : 'partials/"$plural"/show.html',\n\t\tcontroller  : '"$Plural"Controller'\n\t})\n\t\$routeProvider.when('/"$plural"/edit/:id',{\n\t\ttemplateUrl : 'partials/"$plural"/edit.html',\n\t\tcontroller  : '"$Plural"Controller'\n\t})\n\t\$routeProvider.otherwise({\n\t\tredirectTo: '/"$plural"'\n\t})\n})" >> app.js

cd ..

cd server
	cd config

		echo "//Combine these two blocks before running\napp.get('/"$plural"', function(req, res) {\n\t\t"$plural".index(req, res);\n\t});\n\n\tapp.get('/"$plural"/:id', function(req, res) {\n\t\t"$plural".show(req, res);\n\t});\n\n\tapp.post('/"$plural"', function(req, res) {\n\t\t"$plural".create(req, res);\n\t});\n\n\tapp.put('/"$plural"/:id', function(req, res) {\n\t\t"$plural".update(req, res);\n\t});\n\n\tapp.delete('/"$plural"/:id', function(req, res) {\n\t\t"$plural".delete(req, res);\n\t});" >> routes.js

	cd ..

	cd controllers

		touch $plural.js
		echo "var "$Entity" = require('../models/"$entity".js')\n\nvar "$plural" = {}\n\n"$plural".index  = function(request, response) {\n\t"$Entity".find({},function(error,result) {\n\t\tresponse.json({'"$plural"':result})\n\t})\n}\n\n"$plural".show   = function(request, response) {\n\tvar id = request.params.id\n\t"$Entity".find({'_id':id},function(error,result) {\n\t\tresponse.json(result)\n\t})\n}\n\n"$plural".create = function(request,response) {\n\tnew_"$entity" = new "$Entity"({\n\t\tfield   : request.body.field,\n\t\ttemp_id : request.body.temp_id,\n\t})\n\tnew_"$entity".save(function(error,result) {\n\t\tif (error) {\n\t\t\t// console.log(500,error)\n\t\t} else {\n\t\t\t// console.log(201)\n\t\t\tresponse.json(result)\n\t\t}\n\t})\n}\n\n"$plural".update = function(request, response) {\n\tvar id = request.params.id\n\tvar query = request.body.query\n\tvar patch = request.body.patch\n\t"$Entity".update(query,patch,function(error,result) {\n\t\tif (error) {\n\t\t\t// console.log(500,error)\n\t\t} else {\n\t\t\t// console.log(201.5)\n\t\t\tresponse.json(result)\n\t\t}\n\t})\n}\n\n"$plural".delete = function(request, response) {\n\tvar id = request.params.id\n\t"$Entity".remove({'_id':id},function(error,result) {\n\t\tif (error) {\n\t\t\t// console.log(500,error)\n\t\t} else {\n\t\t\t// console.log(201.9)\n\t\t\tresponse.json(result)\n\t\t}\n\t})\n}\n\nmodule.exports = "$plural"" >> $plural.js

	cd ..

	cd models

		touch $entity.js
		echo "var mongoose = require('mongoose')\n\nvar "$Entity"Schema = new mongoose.Schema({\n\tfield   : String,\n\ttemp_id : Number,\n},{\ttimestamps: { \n\t\tcreatedAt: 'created_at', \n\t\tupdatedAt: 'updated_at',\n\t} \n});\n\nmongoose.model('"$Entity"',"$Entity"Schema);\n\nmodule.exports = mongoose.model('"$Entity"');" >> $entity.js

cd ../..

echo "The following files must be rectified before application can be used:\n\n\t/client/app.js\n\t/server/config/routes.js\n"