run_client cli1
run_client cli2
sleep 0.5
cd /tmp/cli2/storeit
git init --bare
sleep 0.5
kill_client cli2
rm -rf /tmp/cli2
run_client cli2

#echo "sleeping for 15 secondes..."
#sleep 15
#run_client cli1 keep-files
#sleep 1
