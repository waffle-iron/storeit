#! /bin/bash

./canadian_http.py 7643&
curl -u sevauk:zulu -d "$(./produce_dummy_tree.py dummy_tree)" localhost:7641/session/join?7643
