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

		mkdir assets
		cd assets

			mkdir factories
			# cd factories

			mkdir controllers
			# cd controllers

		cd ..

		mkdir partials
		# cd partials

		mkdir static
		# cd static

		touch index.html

		touch app.js

	cd ..

	mkdir server
	cd server

		mkdir config
		cd config

			touch mongoose.js

			touch routes.js

		cd ..

		mkdir controllers
		# cd controllers

		mkdir models
		# cd models

	cd ..

	touch server.js

	touch .gitignore
	echo "*.pem\nnode_modules\nbower_components\nlink.txt" >> .gitignore

	echo "\n\tcd $project\n"