So we're gonna do semantic stuff! Basically we want to allow users to interact with an arbitrary ontology sitting somewhere.
This means mostly asking questions and explore the contents - probably through a graph or something, but that's not quite clear yet.

This MD is a work in progress. It's mean to contain a basic intro and some documentation about the quirks, if any, of getting things going.

<!-- MarkdownTOC depth = 2 -->

- Basic structure
- Getting started

<!-- /MarkdownTOC -->

This is an Angular app sitting on Rails. There's many reasons for this, but truthfully it boils down to the fact that I wanted to play with these technologies. The main semantic vodoo magic is sitting on a web service anyway.

## Basic structure

There's three main components here:

* **Semantic webservice**: currently Apache Marmotta. Can be found [here](http://marmotta.apache.org/). This sits somewhere on its own, hosts ontologies and the reasoners and accepts queries. These are not in the repo, by the way.
* **Front end**: it's a JS app, so yeah. We're going with Angular right now. Kinda arbitrarily. Interface only - ways to build questions and pretty graphs or something to show the answers. Not a lot of smartness going on here.
* **Back end**: Rails! Also kinda arbitrary, but it's so nice. It's pretty much just sitting between Marmotta and the clients, for somewhat obvious reasons. Gets the requests from the clients, translates them into proper Sparql queries and translates the results back into proper JSON things.

## Getting started

### Rails
Running the app should be fairly straightforward. It's currently being built on Windows (!), so there isn't any particularly fancy gem.
Tests are written with RSpec. That's about it.

Make sure you create your own **application.yml** with all the settings as per the sample and you should be fine.

### Marmotta
This might be a little trickier. A few gotchas during the installation process (on Windows - haven't had the chance to try things anywhere else):
* Make sure all the environment variables are set properly! These are **JAVA_HOME**, **JRE_HOME** and **CATALINA_HOME**. The Java stuff should be obvious, and the Catalina one should point to the Tomcat folder *in the marmotta installation folder* (as opposed to any other installation you may have);
* Apparently there's something going on with the CSS if you're using a certain version of Java. Don't know what to do about it yet.

### Ontology
Here's the fun part. The app is supposed to be pretty flexible when it comes to ontologies, but has some expectations.
...I'll put them here ASAP.
