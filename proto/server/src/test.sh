#! /bin/bash

curl -u sevauk:zulu -d "$(./produce_dummy_tree.py dummy_tree)" localhost:7641/session/join

nc -l 7642
echo "------------"
nc -l 7642
echo "------------"
nc -l 7642
