echo "Please enter a Project name:"
read project_name
echo "Please enter an app name\n[main]"
read app_name
if [[ "$app_name" = "" ]]; then
	app_name="main"
fi

# Replace this with the absolute path to wherever you have Django installed
source ~/Desktop/Education/CodingDojo/PYTHON/myEnvironments/djangoEnv/bin/activate

echo "Creating Project '$project_name' with single app '$app_name'"

echo "      invoke  django-admin startproject $project_name" ##
django-admin startproject $project_name

cd $project_name

	echo "      create  apps/" ##
	mkdir apps

	cd apps

		echo "      create  apps/__init__.py" ##
		touch __init__.py

		echo "      invoke  startapp $app_name" ##
		python ../manage.py startapp $app_name

		cd $app_name

			echo "      create  apps/$app_name/urls.py" ##
			touch urls.py
			echo "from django.conf.urls import url\nfrom . import views\n\nurlpatterns = [\n\turl(r'^$', views.index),\n\turl(r'^hot$', views.hot),\n\turl(r'^run$', views.run),\n]" >> urls.py

			echo "      modify  apps/$app_name/views.py" ##
			echo "from django.shortcuts import redirect\n# - - - - - HELPER FUNCTIONS - - - - -\n\n# Function for initializing session variables.\ndef seshinit(request, sesh, val=''):\n\tif sesh not in request.session:\n\t\trequest.session[sesh] = val\n\n# - - - - - DEVELOPER VIEWS - - - - -\n\ndef hot(request):\n\tseshinit(request,'command')\n\tcontext = {\n\t\t# Models\n\t\t'command': request.session['command']\n\t}\n\treturn render(request, \"$app_name/hot.html\", context)\n\ndef run(request):\n\tcommand = request.POST['command']\n\trequest.session['command'] = command\n\texec(command)\n\treturn redirect ('/hot')\n\ndef nuke(request):\n\t#.objects.all().delete()\n\treturn redirect ('/hot')\n\n# - - - - - APPLICATION VIEWS - - - - -\n\ndef index(request):\n\tcontext = {}\n\treturn render(request, \"$app_name/index.html\", context)" >> views.py

			echo "      create  apps/$app_name/templates/" ##
			mkdir templates
			cd templates

				echo "      create  apps/$app_name/templates/$app_name/" ##
				mkdir $app_name
				cd $app_name

					echo "      create  apps/$app_name/templates/$app_name/index.html" ##
					touch index.html
					echo "<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<meta charset=\"utf-8\">\n\t\t<title>$project_name</title>\n\t\t{% load staticfiles %}\n\t\t<script src=\"{% static '$app_name/js/script.js' %}\" charset=\"utf-8\"></script>\n\t\t<link rel=\"stylesheet\" type=\"text/css\" href=\"{% static '$app_name/css/style.css' %}\">\n\t</head>\n\t<body>\n\t\t<h1>$app_name#index</h1>\n\t\t<p>Find me in $project_name/apps/$app_name/templates/$app_name/index.html</p>\n\t</body>\n</html>" >> index.html

					echo "      create  apps/$app_name/templates/$app_name/hot.html" ##
					touch hot.html
					echo "Python Hot Code:\n<form action=\"/run\" method=\"post\">\n\t{% csrf_token %}\n\t<textarea name=\"command\" rows=\"10\" cols=\"50\" style=\"font-family: monospace;\">{{ command }}</textarea>\n\t<input type=\"submit\" value=\"RUN\">\n</form>" >> hot.html

			cd ../..

			echo "      create  apps/$app_name/static/" ##
			mkdir static
			cd static

				echo "      create  apps/$app_name/static/$app_name/" ##
				mkdir $app_name
				cd $app_name

					echo "      create  apps/$app_name/static/$app_name/css/" ##
					mkdir css
					cd css
						echo "      create  apps/$app_name/static/$app_name/css/style.css" ##
						touch style.css

					cd ..

					echo "      create  apps/$app_name/static/$app_name/js/" ##
					mkdir js
					cd js

						echo "      create  apps/$app_name/static/$app_name/js/script.js" ##
						touch script.js
						echo "console.log('JavaScript running at $project_name/apps/$app_name/static/$app_name/js/script.js')" >> script.js
					
					cd ..

					echo "      create  apps/$app_name/static/$app_name/images/" ##
					mkdir images
	
	cd ../../../../$project_name

	echo "      modify  $project_name/settings.py" ##
	echo "INSTALLED_APPS += ['apps.$app_name']" >> settings.py

	echo "      modify  $project_name/urls.py" ##
	echo "from django.conf.urls import include\nurlpatterns = [ url(r'^', include('apps.$app_name.urls')) ]" >> urls.py

	cd ..

echo "      create  g/" ##
mkdir g
cd g
	
	# echo "      create  g/app.sh" ##
	# touch app.sh
	# echo "" >> app.sh

	echo "      create  g/model.sh" ##
	touch model.sh
	echo "" >> model.sh

	echo "      create  g/view.sh" ##
	touch view.sh
	echo "" >> view.sh

	cd ..

echo "      create  .gitignore" ##
touch .gitignore
echo "# Ignore Unchained Generate Scripts\ng" >> .gitignore

echo "      python  manage.py migrate" ##
python manage.py migrate

echo "Enter project with this command:"
echo "cd $project_name"