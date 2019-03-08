#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python36Packages.docopt

"""Prepend Nikola metadata to an HTML post file.

Usage:
  prepend_nikola_metadata.py <input-file> <output-file> [options]

Options:
  --title=<title> Post title. Default is deducted from <output-file>.
  --slug=<slug>   Post slug. Default is deducted from <output-file>.
  --date=<date>   Post date. Default is current date.
  --tags=<tags>   Post tags. Empty by default.
  --category=<category> Post category. Empty by default.
  --link=<link> Post link. Empty by default.
  --desc=<desc> Post description. Empty by default.
  --type=<type> Post type. "text" by default.
  -h --help       Show this screen.
"""
from docopt import docopt
import datetime
import os

def generate_html_comment(title, slug, date, tags, category, link, description, type_):
    return f'''<!--
.. title: {title}
.. slug: {slug}
.. date: {date}
.. tags: {tags}
.. category: {category}
.. link: {link}
.. description: {description}
.. type: {type_}
-->'''

def file_prefix(html_file):
    base = os.path.basename(html_file)
    return os.path.splitext(base)[0]

def prepend_content_to_file(filename_input, filename_output, header):
    with open(filename_output, 'w') as foutput:
        with open(filename_input, 'r+') as finput:
            content = finput.read()
        foutput.seek(0, 0)
        foutput.write(header + '\n' + content)

if __name__ == '__main__':
    arguments = docopt(__doc__)
    input_filename = arguments["<input-file>"]
    output_filename = arguments["<output-file>"]
    prefix = file_prefix(output_filename)

    title = prefix
    slug = prefix
    date = datetime.datetime.now().isoformat()
    tags = ""
    category = ""
    link = ""
    desc = ""
    type_ = ""

    if arguments["--title"] is not None:
        title = arguments["--title"]
    if arguments["--slug"] is not None:
        slug = arguments["--slug"]
    if arguments["--date"] is not None:
        date = arguments["--date"]
    if arguments["--tags"] is not None:
        tags = arguments["--tags"]
    if arguments["--category"] is not None:
        category = arguments["--category"]
    if arguments["--link"] is not None:
        link = arguments["--link"]
    if arguments["--desc"] is not None:
        desc = arguments["--desc"]
    if arguments["--type"] is not None:
        type_ = arguments["--type"]

    html_comment = generate_html_comment(title, slug, date, tags, category, link, desc, type_)
    prepend_content_to_file(input_filename, output_filename, html_comment)
