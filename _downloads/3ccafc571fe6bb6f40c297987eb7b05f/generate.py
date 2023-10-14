#!/usr/bin/env python3
# generate a ninja file that can build all variant combinations
inits = [
    ('nop', 'INIT_NOP'),
    ('nbf', 'INIT_UNBUFFERED'),
    ('lbf', 'INIT_LINE_BUFFERED'),
    ('fbf', 'INIT_FULLY_BUFFERED'),
]

prints = [
    ('nop', 'PRINT_NOP'),
    ('p', 'PRINT_PRINTF'),
    ('pf', 'PRINT_PRINTF_FFLUSH'),
    ('pn', 'PRINT_PRINTF_NEWLINE'),
    ('pnf', 'PRINT_PRINTF_NEWLINE_FFLUSH'),
    ('w', 'PRINT_WRITE'),
    ('wn', 'PRINT_WRITE_NEWLINE'),
]

exits = [
    ('exit', 'EXIT_EXIT'),
    ('_exit', 'EXIT__EXIT'),
    ('segv', 'EXIT_SEGFAULT'),
]

fins = [
    ('nop', 'FIN_NOP'),
    ('wait', 'FIN_WAITALL'),
]

ninja_header = '''cflags=-O2 -Wall -Wextra
init = INIT_NOP
print = PRINT_NOP
exit = EXIT_EXIT
fin = FIN_NOP

rule cc
  command = gcc ${cflags} -DINIT=${init} -DPRINT=${print} -DEXIT=${exit} -DFIN=${fin} -o $out $in
'''
rule_template = '''build {target}: cc base.c
  init = {init_macro}
  print = {print_macro}
  exit = {exit_macro}
  fin = {fin_macro}
'''

print(ninja_header)

for i in inits:
    for p in prints:
        for e in exits:
            for f in fins:
                print(rule_template.format(
                    target=f"{i[0]}-{p[0]}-{e[0]}-{f[0]}",
                    init_macro=i[1],
                    print_macro=p[1],
                    exit_macro=e[1],
                    fin_macro=f[1],
                ))
