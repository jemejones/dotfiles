#!/usr/bin/env python

import sys
import os

LOG_FILE = os.path.join(os.path.dirname(__file__), 'paste_helper.log')

with open(LOG_FILE, 'w') as log_file:
    buffer = sys.stdin.read()
    log_file.write('BEGIN RAW BUFFER\n')
    for c in buffer:
        char_to_print = ' ' if c.isspace() else c
        log_file.write(f'{char_to_print} - {ord(c)}\n')
    log_file.write('END RAW BUFFER\n')

    if buffer.endswith('\r\n'):
        log_file.write('buffer ended in cr lf - stripping')
        buffer = buffer[:-2]

    buffer = buffer.replace('\r\n', '\n')
    sys.stdout.write(buffer)
    sys.stdout.flush()
    log_file.write('BEGIN WRITE BUFFER\n')
    log_file.write(buffer)
    log_file.write('\nEND WRITE BUFFER\n')
    log_file.flush()
