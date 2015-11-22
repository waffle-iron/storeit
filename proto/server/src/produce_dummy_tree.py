#! /usr/bin/env python3

import os, sys

path = './' if len(sys.argv) == 1 else sys.argv[1] + '/'

def walk(indent, path):
    
    def printind(msg):
        print('{}{}'.format(' ' * indent, msg))

    for entry in os.scandir(path):
        printind('{')
        indent += 2
        printind('"path: {}{}",'.format(path, entry.name))
        printind('"metadata": "{}",'.format(entry.stat().st_mtime_ns))
        printind('"unique_hash": "TODO",')
        printind('"kind": "' + ('0' if entry.is_dir() else '1') + '",')
        printind('"files": [')
        if entry.is_dir():
            walk(indent + 2, path + entry.name + '/')
        printind(']')
        indent -= 2
        printind('},')


print('{')
walk(2, path)
print('}')
