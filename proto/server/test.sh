#! /bin/bash

echo "JOIN sevauk 7642 $(./produce_dummy_tree.py dummy_tree) $(cat CRLR.txt)" | nc localhost 7641 &&
nc -l 7642
