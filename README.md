# mpoquet.github.io
Website for Millian Poquet's personal pages.  
This website is built with [hugo](https://gohugo.io/) and uses the [blackburn](https://themes.gohugo.io/blackburn/) theme.

This repo contains two very different branches:
- **code**, which contains everything to generate the website
- **master**, which contains the website itself

### How to setup a similar website?
1. Follow Hugo's quick start [tutorial](https://gohugo.io/getting-started/quick-start/)
2. Configure your website so that everything is OK locally (``hugo server -D``)  
   This may involving hacking existing themes (copy ``themes/XXX/exampleSite`` into your own website then hack). 
3. Read this [tutorial](https://gohugo.io/hosting-and-deployment/hosting-on-github/) to host the website on github.  
   **Important note**: Setting the ``gh-pages`` branch as GitHub Pages source was impossible,  
   so I used ``code`` and ``master`` branches instead.

### How to update this website?
1. Hack files in the ``code`` branch.  
   Checking whether modifications work can be done via ``hugo server``.
2. Generate the static website: ``hugo``.
3. Switch to the ``master`` branch.
4. Move the static to master's branch root: ``\cp -rf ./public/* ./``.
5. Git fun on both branches.
