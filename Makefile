# Note that this file will be removed once it's implemented into the rest of the project, where there will be a similar file that simpl runs the tests

# Runs the unit tests
test:
	RScript download_test_run.R

# Runs the download program
run:
	read -p "You are about to download a lot of data (~4 GB). •If you wish to continue, hit enter. •If you wish to exit, hit CTRL+C."
	RScript -e \
		'source("download.R"); runDownload(); runDownload2()'
clean:
	rm -f *.txt
	cd ./data; rm -f *.XPT