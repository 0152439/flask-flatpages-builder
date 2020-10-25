#!/bin/bash 

# Inspiration:
# https://john-b-yang.github.io/flask-website/
# https://docs.github.com/en/github/importing-your-projects-to-github/adding-an-existing-project-to-github-using-the-command-line
# https://nicolas.perriault.net/code/2012/dead-easy-yet-powerful-static-website-generator-with-flask/

# Make this file executable: 
# chmod 700 flask_flatpages.sh
# Run this script:
# ./flask_flatpages.sh 'your_project_name'

# run Flask app:
# python app.py

# build static:
# python app.py build

# run build from server in command line: 
# cd build
# python3 -m http.server 8000

boolean_dev=true

cd ~/Desktop/Projects/Flask/
mkdir $1
cd $1

# mkdir flask_blog
# cd flask_blog

git init

python3 -m venv env
source env/bin/activate

pip install Flask Frozen-Flask Flask-FlatPages
touch app.py .gitignore README.md requirements.txt
python -m pip freeze > requirements.txt

echo "Create app.py"
echo 'import sys, os
from flask import Flask, render_template
from flask_flatpages import FlatPages
from flask_frozen import Freezer


DEBUG = True
FLATPAGES_AUTO_RELOAD = DEBUG
FLATPAGES_EXTENSION = ".md"

app = Flask(__name__)
app.config.from_object(__name__)
pages = FlatPages(app)
freezer = Freezer(app)


@app.route("/")
def index():
    return render_template("index.html",pages=pages)

@app.route("/<path:path>/")
def page(path):
    page = pages.get_or_404(path)
    return render_template("page.html", page=page)


@app.route("/welcome/")
def welcome():
    return "Welcome to my webpage!"

@app.route("/tag/<string:tag>/")
def tag(tag):
    tagged = [p for p in pages if tag in p.meta.get("tags", [])]
    return render_template("tag.html", pages=tagged, tag=tag)


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "build":
        freezer.freeze()
    else:
        app.run(port=8000)' > app.py

# Create directory structure:
echo "Create folder structure"
mkdir pages
mkdir templates
mkdir static
mkdir static/css
mkdir static/images

# Create some files:
echo "Create example-text"
touch pages/example-text.md
echo 'title: My First Entry
tags: [test]
date: 2018-01-01

**YEEEHA**

This is my **first** blog post ever! Welcome!

And this is the second line, that I added myself' > pages/example-text.md



echo "Create base.html"
touch templates/base.html
echo '<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="author" content="John Appleseed">
    <meta name="description" content="My test Blog">
    <title>This is my test Blog</title>
</head>

<body>
    <h1><a href="{{ url_for("index") }}">My test Blog</a></h1>

    <div>
        {% block content %}
        <p>Default Content</p>
        {% endblock content %}
    </div>
</body>
</html>' > templates/base.html



echo "Create page.html"
touch templates/page.html
echo '{% extends "base.html" %}

{% block content %}
    <h2>{{ page.title }}</h2>
    {{ page.html|safe }}
{% endblock content %}' > templates/page.html



echo "Create index.html"
touch templates/index.html
echo '
{% extends "base.html" %}

{% block content %}
    <h2>List of stuff</h2>
    {% with pages=pages  %}
        {% include "_list.html" %}
    {% endwith %}
{% endblock content %}
' > templates/index.html



echo "Create tag.html"
touch templates/tag.html
echo '{% extends "base.html" %}

{% block content %}
    <h2>List of stuff tagged <em>{{ tag }}</em></h2>
    {% with pages=pages  %}
        {% include "_list.html" %}
    {% endwith %}
{% endblock content %}' > templates/tag.html



echo "Create _list.html"
touch templates/_list.html
echo '<ul>
    {% for page in pages %}
        <li>
            <a href="{{ url_for("page", path=page.path) }}">{{ page.title }}</a>
        {% if page.meta.tags|length %}
            | Tagged:
            {% for page_tag in page.meta.tags %}
                <a href="{{ url_for("tag", tag=page_tag) }}">{{ page_tag }}</a>
            {% endfor %}
        {% endif %}
        </li>
    {% else %}
        <li>No page.</li>
    {% endfor %}
    </ul>' > templates/_list.html



echo "Create affiliate.html"
touch templates/affiliate.html
echo '<!DOCTYPE HTML>
 
<meta charset="UTF-8">
<meta http-equiv="refresh" content="1; url={{affiliate_link}}">
 
<script>
  window.location.href = "{{affiliate_link}}"
</script>
 
<title>Page Redirection</title>
 
If you are not redirected automatically, follow the <a href="{{affiliate_link}}">link to example</a>' > templates/affiliate.html

echo "Create style.css"
touch static/css/style.css
# TO DO

# TO DO: add to github