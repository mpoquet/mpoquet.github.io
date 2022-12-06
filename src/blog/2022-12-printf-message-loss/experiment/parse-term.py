#!/usr/bin/env python3
import re
import sys

if len(sys.argv) != 2:
    print('usage: parse-temp.py <INPUT-FILE>', file=sys.stderr)
    sys.exit(1)

input_file = sys.argv[1]
run_regexp = re.compile('''^run (\w+)-(\w+)-(\w+)-(\w+) (\d+)$''')
(init_m, print_m, exit_m, fin_m, run_id) = [None, None, None, None, None]
msg_count = 0

print('''init,print,exit,fin,run,msg''')

with open(input_file, 'r') as f:
    for line in f:
        m = run_regexp.match(line)
        if m is not None:
            if init_m is not None:
                print(init_m, print_m, exit_m, fin_m, run_id, msg_count, sep=',')
                msg_count = 0
            (init_m, print_m, exit_m, fin_m, run_id) = m.groups()
        else:
            msg_count += len(line.strip())

    if init_m is not None:
        print(init_m, print_m, exit_m, fin_m, run_id, msg_count, sep=',')
