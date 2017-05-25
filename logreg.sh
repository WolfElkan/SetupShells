bower install angular angular-route angular-cookies --save

npm install express mongoose body-parser bcrypt --save

cd client
	cd assets
		cd controllers

			touch UsersController.js
			echo "app.controller('UsersController',['\$scope','\$location','\$cookies','UserFactory',function(\$scope,\$location,\$cookies,UserFactory,) {\n\n\tconsole.log('UsersController')\n\n\t\$scope.user_log = {}\n\t\$scope.login = function() {\n\t\tconsole.log('cxr: login')\n\t\tUserFactory.login(\$scope.user_log).then(function(returned) {\n\t\t\tconsole.log(returned.data)\n\t\t\tif (returned.data.account) {\n\t\t\t\tif (returned.data.success) {\n\t\t\t\t\tconsole.log('cxr: password correct')\n\t\t\t\t\t\$cookies.put('user_id',returned.data.user_id)\n\t\t\t\t\t// \$cookies.put('sescode',returned.data.sescode)\n\t\t\t\t\t\$location.url('/')\n\t\t\t\t} else {\n\t\t\t\t\tconsole.log('cxr: password incorrect')\n\t\t\t\t}\n\t\t\t} else {\n\t\t\t\tconsole.log('cxr: no account')\n\t\t\t}\n\t\t})\n\t\t\$scope.user_log = {}\n\t}\n\n\t\$scope.user_reg = {}\n\t\$scope.register = function() {\n\t\tconsole.log('cxr: register')\n\t\tUserFactory.register(\$scope.user_reg).then(function(returned) {\n\t\t\tconsole.log('cxr:',returned)\n\t\t})\n\t\t\$location.url('/users')\n\t\t\$scope.user_reg = {}\n\t}\n\n\t\$scope.user_index = UserFactory.all()\n\tUserFactory.load().then(function(returned) {\n\t\t\$scope.user_index = returned.data.users\n\t})\n\n\t\$scope.logout = function() {\n\t\tconsole.log('cxr: logging out...')\n\t\t\t\$cookies.remove('user_id')\n\t\t\t// \$cookies.remove('sescode')\n\t\t\tconsole.log(\$cookies.get('user_id'))\n\t\t\t\$location.url('/')\n\t}\n\n\t\$scope.isbcrypt = function(pw) {\n\t\tvar bcrypt = /^\\\$2[ay]?\\\$\\d{2}\\\$[./0-9A-Za-z]{53}\$/\n\t\treturn Boolean(bcrypt.exec(pw))\n\t}\n\n\t\$scope.user_delete = function(id) {\n\t\tUserFactory.delete(id)\n\t}\n\n\t\$scope.print = function() {\n\t\t\n\t}\n\n}])" >> users"Controller.js"

		cd ..

		cd factories

			touch UserFactory.js
			echo "app.factory('UserFactory',['\$http',function(\$http) {\n\n\tvar factory = {}\n\tvar content = []\n\n\tfactory.login = function(user) {\n\t\tconsole.log('fac: login')\n\t\tuser.action = 'login'\n\t\treturn \$http.post('/users',user)\n\t}\n\n\tfactory.register = function(new_user) {\n\t\tconsole.log('fac: register')\n\t\tif (valid(new_user)) {\n\t\t\tnew_user.action = 'register'\n\t\t\treturn \$http.post('/users',new_user)\n\t\t}\n\t}\n\n\tfunction valid(user) {\n\t\treturn true\n\t}\n\n\tfactory.all = function() {\n\t\treturn content\n\t}\n\n\tfactory.load = function() {\n\t\tvar promise = \$http.get('/users')\n\t\tconsole.log('fac: load')\n\t\tpromise.then(function(returned) {\n\t\t\tcontent = returned.data.users\n\t\t})\n\t\treturn promise\n\t}\n\n\tfactory.get = function(callback) {\n\t\tif (typeof(callback) == 'function') {\n\t\t\treturn callback(content)\n\t\t} else {\n\t\t\tthrow new TypeError('Expected Function, got',callback.__proto__.constructor.name)\n\t\t}\n\t}\n\n\tfactory.findex = function(id,key='_id') {\n\t\tfor (var i = 0; i < content.length; i++) {\n\t\t\tif (content[i][key] == id) {\n\t\t\t\treturn i\n\t\t\t}\n\t\t}\n\t}\n\n\tfactory.find = function(id,key='_id') {\n\t\tvar index = factory.findex(id,key)\n\t\treturn content[index]\n\t}\n\n\tfactory.update = function(id,patch) {\n\t\tif (valid(patch)) {\n\t\t\t\$http.put('/users/'+id,{'query':{'_id':id},'patch':patch}).then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tvar index = factory.findex(id)\n\t\t\t\t\tcontent[index] = returned.data\n\t\t\t\t} else {\n\t\t\t\t\tconsole.log('fac:',returned)\n\t\t\t\t}\n\t\t\t})\n\t\t}\n\t}\n\n\tfactory.delete = function(id) {\n\t\tif (factory.findex(id)+1) {\n\t\t\t\$http.delete('/users/'+id).then(function(returned) {\n\t\t\t\tif (returned.status == 200) {\n\t\t\t\t\tvar index = factory.findex(id)\n\t\t\t\t\tfor (var i = index; i < content.length; i++) {\n\t\t\t\t\t\tcontent[i] = content[i+1]\n\t\t\t\t\t}\n\t\t\t\t\tcontent.pop()\n\t\t\t\t} else {\n\t\t\t\t\tconsole.log('fac:',returned)\n\t\t\t\t}\n\t\t\t})\n\t\t}\n\t}\n\n\tfactory.print = function() {\n\t\tconsole.log('fac:',content)\n\t}\n\n\treturn factory\n\n}])" >> UserFactory.js

	cd ../..

	cd partials

		touch home.html
		echo "<h1>Welcome Home!</h1>\n<a href='#' ng-click='logout()'>Logout</a>" >> home.html

		mkdir "users"
		cd "users"

			touch entrance.html
			echo "<div>\n\t<h1>Register:</h1>\n\t<table>\n\t\t<tr>\n\t\t\t<td>Username:</td>\n\t\t\t<td><input type='text' ng-model='user_reg.username'></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>Password:</td>\n\t\t\t<td><input type='password' ng-model='user_reg.password'></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>Confirm Password:</td>\n\t\t\t<td><input type='password' ng-model='user_reg.pw_conf'></td>\n\t\t</tr>\n\t</table>\n\t<button ng-click='register()'>Register</button>\n</div>\n<div>\n\t<h1>Log In:</h1>\n\t<table>\n\t\t<tr>\n\t\t\t<td>Username:</td>\n\t\t\t<td><input type='text' ng-model='user_log.username'></td>\n\t\t</tr>\n\t\t<tr>\n\t\t\t<td>Password:</td>\n\t\t\t<td><input type='password' ng-model='user_log.password'></td>\n\t\t</tr>\n\t</table>\n\t<button ng-click='login()'>Log In</button>\n</div>" >> entrance.html

			touch index.html
			echo "<h1>Users Index</h1>\n<table>\n\t<thead>\n\t\t<th>Username</th>\n\t\t<th>Password</th>\n\t\t<th>Actions</th>\n\t</thead>\n\t<tr ng-repeat='user in user_index'>\n\t\t<td>{{user.username}}</td>\n\t\t<td>\n\t\t\t<span ng-if='isbcrypt(user.password)' title='{{user.password}}'>&#x1f512;</span>\n\t\t\t<span ng-if='!isbcrypt(user.password)'>{{user.password}}</span>\n\t\t</td>\n\t\t<td>\n\t\t\t<a href='#' ng-click='user_delete(user._id)'>Delete</a>\n\t\t</td>\n\t</tr>\n</table>\n<button ng-click='print()'>Shortcut</button>" >> index.html

	cd ../..

	# app.js
	echo "\n//Combine these two blocks before running\n\nvar app = angular.module('app', ['ngRoute','ngCookies'])\n\napp.config(function(\$routeProvider) {\n\tvar \$cookies;\n\tangular.injector(['ngCookies']).invoke(['\$cookies', function(cookies) {\n\t\t\$cookies = cookies;\n\t}])\n\tif (\$cookies.get('user_id')) {\n\t\t\$routeProvider.when('/home',{\n\t\t\ttemplateUrl : 'partials/home.html',\n\t\t\tcontroller  : 'UsersController'\n\t\t})\n\t\t\$routeProvider.otherwise({\n\t\t\tredirectTo: '/home'\n\t\t})\n\t} else {\n\t\t\$routeProvider.when('/login',{\n\t\t\ttemplateUrl : 'partials/users/entrance.html',\n\t\t\tcontroller  : 'UsersController'\n\t\t})\n\t\t\$routeProvider.otherwise({\n\t\t\tredirectTo: '/login'\n\t\t})\n\t}\n\t\$routeProvider.when('/users',{\n\t\ttemplateUrl : 'partials/users/index.html',\n\t\tcontroller  : 'UsersController'\n\t})\n})" >> app.js

	# index.js
	echo "\n//Combine these two blocks before running\n\n\t\t<script type='text/javascript' src='angular-cookies/angular-cookies.js'></script>\n\t\t<script src='assets/factories/UserFactory.js'></script>\n\t\t<script src='assets/controllers/UsersController.js'></script>\n\t\t<a href='#!/users'>Users</a>" >> index.html

cd ..

cd server
	cd config

		# routes.js
		echo "\n\n//Combine these two blocks before running\nvar users = require('../controllers/users.js')\n{\n\tapp.get('/users', function(req, res) {\n\t\tconsole.log('routes: index')\n\t\tusers.index(req, res);\n\t});\n\n\tapp.get('/users/:id', function(req, res) {\n\t\tusers.show(req, res);\n\t});\n\n\tapp.post('/users', function(req, res) {\n\t\tif (req.body.action == 'register') {\n\t\t\tconsole.log('routes: register')\n\t\t\tusers.register(req, res);\n\t\t} else if (req.body.action == 'login') {\n\t\t\tconsole.log('routes: login')\n\t\t\tusers.login(req, res);\n\t\t}\n\t});\n\n\tapp.put('/users/:id', function(req, res) {\n\t\tusers.update(req, res);\n\t});\n\n\tapp.delete('/users/:id', function(req, res) {\n\t\tusers.delete(req, res);\n\t});\n\n}" >> routes.js

	cd ..

	cd controllers

		touch "users.js"
		echo "var USER  = require('../models/user.js')\nvar User  = USER.model\nvar equip = USER.equip\nvar valid = USER.valid\n\nvar users = {}\n\nvar data = {\n\t'request' : null,\n\t'success' : false,\n\t'user_id' : null,\n\t'invalid' : null,\n\t'account' : null,\n\t'dberror' : null,\n//\t'sescode' : null,\n}\n\nusers.login = function(request, response) {\n\tconsole.log('server: login')\n\tdata.request = 'login'\n\tUser.find({username: request.body.username},function(error,result) {\n\t\tif (error) {\n\t\t\tdata.dberror = error\n\t\t\tresponse.json(data)\n\t\t} else {\n\t\t\tvar user = result[0]\n\t\t\tdata.account = Boolean(user)\n\t\t\tif (user) {\n\t\t\t\tuser = equip(user)\n\t\t\t\tif (user.check(request.body.password)) {\n\t\t\t\t\tconsole.log('server: password correct')\n\t\t\t\t\tdata.success = true\n\t\t\t\t\tdata.user_id = user._id\n\t\t\t\t\tdata.invalid = false\n\t\t\t\t\tresponse.json(data)\n\t\t\t\t} else {\n\t\t\t\t\tconsole.log('server: password incorrect')\n\t\t\t\t\tdata.invalid = true\n\t\t\t\t\tresponse.json(data)\n\t\t\t\t}\n\t\t\t} else {\n\t\t\t\tconsole.log('server: no account')\n\t\t\t\tresponse.json(data)\n\t\t\t}\n\t\t}\n\t})\n}\n\nusers.register = function(request,response) {\n\tconsole.log('server: register')\n\tdata.request = 'register'\n\tUser.find({username: request.body.username},function(error,result) {\n\t\tvar user = result[0]\n\t\tdata.account = Boolean(user)\n\t\tif (user) {\n\t\t\tconsole.log('server: username exists')\n\t\t\tresponse.json(data)\n\t\t} else {\n\t\t\tvar new_user = new User({\n\t\t\t\tusername : request.body.username,\n\t\t\t\tpassword : request.body.password,\n\t\t\t})\n\t\t\tif (valid(new_user)) {\n\t\t\t\tconsole.log('server: creating account')\n\t\t\t\tnew_user.save(function(error,result) {\n\t\t\t\t\tif (error) {\n\t\t\t\t\t\tconsole.log('server:',500,error)\n\t\t\t\t\t\tdata.dberror = error\n\t\t\t\t\t\tresponse.json(data)\n\t\t\t\t\t} else {\n\t\t\t\t\t\tconsole.log('server:',201)\n\t\t\t\t\t\tdata.success = true\n\t\t\t\t\t\tresponse.json(data)\n\t\t\t\t\t}\n\t\t\t\t})\n\t\t\t} else {\n\t\t\t\tconsole.log('server: validation error')\n\t\t\t\tdata.invalid = true\n\t\t\t\tresponse.json(data)\n\t\t\t}\n\t\t}\n\t})\n}\n\nusers.index = function(request, response) {\n\tconsole.log('server: index')\n\tUser.find({},function(error,result) {\n\t\tconsole.log('server:',error,result)\n\t\tresponse.json({'users':result})\n\t})\n}\n\nusers.show = function(request, response) {\n\tvar id = request.params.id\n\tUser.find({'_id':id},function(error,result) {\n\t\tresponse.json(result)\n\t})\n}\n\nusers.update = function(request, response) {\n\tvar id = request.params.id\n\tvar query = request.body.query\n\tvar patch = request.body.patch\n\tUser.update(query,patch,function(error,result) {\n\t\tif (error) {\n\t\t\tconsole.log('server:',500,error)\n\t\t} else {\n\t\t\tconsole.log('server:',201.5)\n\t\t\tresponse.json(result)\n\t\t}\n\t})\n}\n\nusers.delete = function(request, response) {\n\tvar id = request.params.id\n\tUser.remove({'_id':id},function(error,result) {\n\t\tif (error) {\n\t\t\tconsole.log('server:',500,error)\n\t\t} else {\n\t\t\tconsole.log('server:',201.9)\n\t\t\tresponse.json(result)\n\t\t}\n\t})\n}\n\nmodule.exports = users" >> users.js

	cd ..

	cd models

		touch user.js
		echo "var mongoose = require('mongoose')\nvar bcrypt   = require('bcrypt')\n\nvar UserSchema = new mongoose.Schema({\n\tusername : String,\n\tpassword : String,\n},{\ttimestamps: { \n\t\tcreatedAt: 'created_at', \n\t\tupdatedAt: 'updated_at',\n\t}\n});\n\nUserSchema.pre('save',function(next) {\n\tthis.password = bcrypt.hashSync(this.password,bcrypt.genSaltSync(8))\n\t// console.log('model :',this)\n\tnext()\n})\n\nfunction equip(user) {\n\t// user = user[0]\n\tuser.check = function(password) {\n\t\treturn bcrypt.compareSync(password, user.password)\n\t}\n\treturn user\n}\n\nfunction valid(user) {\n\treturn Boolean(user.password)\n}\n\nmongoose.model('users',UserSchema);\n\nmodule.exports = {\n\t'model' : mongoose.model('users'),\n\t'equip' : equip,\n\t'valid' : valid,\n}" >> user.js

		touch session.js

cd ../..

echo "The following files must be rectified before application can be used:\n\n\t/client/index.html\n\t/client/app.js\n\t/server/config/routes.js\n"