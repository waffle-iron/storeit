#!/bin/bash

SNAME=storeit
SPATH=$HOME/code/epitech/storeit/proto/server
CLIPATH=$HOME/code/epitech/storeit/proto/client
PORT=7643
FINDER=0

while getopts "f" opt; do
    case $opt in
      f)
         FINDER=1
         ;;
      \?)
         echo "Invalid option: -$OPTARG" >&2
         ;;
      esac
done


function run_in_tmux {
  tmux split-window -t $SNAME $*
  tmux select-layout tile
  sleep 0.1
}

function init_client {
  rm -rf /tmp/$1
  mkdir /tmp/$1
  cp -r $SPATH/testree /tmp/$1/storeit
  if [ $FINDER -eq 1 ]; then
    open /tmp/$1/storeit
  fi
}

function run_client {
  init_client $1
  pushd /tmp/$1
  run_in_tmux $CLIPATH/main.py $1 $((PORT++))
  popd
}

function kill_client {
  kill $(ps aux|grep -v grep | grep "main.py $1" | awk '{print $2}')
}


tmux new-session -d -s $SNAME $SPATH/main.py
sleep 0.5 # wait a little bit for the server to start:w
ps cax | grep postgres > /dev/null

if [ $? -eq 0 ]; then
  true
else
    postgres -D /usr/local/var/postgres&
fi

source ./simulation.sh
