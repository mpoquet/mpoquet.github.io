#! /usr/bin/env nix-shell
#! nix-shell ./rEnv.nix -i Rscript

# Parse arguments.
library(docopt, quietly=TRUE)
'Wrapper script around Rmarkdown.

Usage:
  call_rmarkdown.R <INPUT-FILE> <OUTPUT-FILE>

Options:
  -h --help     Show this screen.
' -> doc
arguments <- docopt(doc)
print(arguments)

# Real beginning of the script.
library(rmarkdown, quietly=TRUE)
rmarkdown::render(arguments$"<INPUT-FILE>",
    output_file=arguments$"<OUTPUT-FILE>",
    runtime="static"
)

