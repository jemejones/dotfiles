#!/usr/bin/env python

import sys
import os

LOG_FILE = os.path.join(os.path.dirname(__file__), 'copy_helper.log')

with open(LOG_FILE, 'w') as log_file:
    read_data = sys.stdin.read()
    sys.stdout.write(read_data)
    sys.stdout.flush()
    log_file.write('BEGIN\n')
    for c in read_data:
        char_to_print = ' ' if c.isspace() else c
        log_file.write(f'{char_to_print} - {ord(c)}\n')
    log_file.write('END\n')
    log_file.flush()
