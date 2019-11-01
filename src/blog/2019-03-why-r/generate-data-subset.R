#! /usr/bin/env nix-shell
#! nix-shell ../../../src/rEnv.nix -i Rscript

# Please ignore the shabang above if you are reading the R showcase.
# It is just Nix things to execute the script in a controled environment.

# These are the packages used by this script.
library(tidyverse) # life saver
library(docopt) # for fine command-line interface

# This is the script command-line.
'Stupid script to get a subset of athlete events.

Usage:
  generate-data-subset.R <INPUT-FILE> <OUTPUT-FILE>

Options:
  -h --help     Show this screen.
' -> doc
args <- docopt(doc)

# Read input data.
data = read_csv(args$"<INPUT-FILE>") %>%
    # Apply some filters to only keep some entries.
    # Only keep entries about females, in Winter, since 2000.
    filter(Sex == "F" & Season == "Winter" & Year >= 2000) %>%
    # Save the filtered data in another file.
    write_csv(args$"<OUTPUT-FILE>")
