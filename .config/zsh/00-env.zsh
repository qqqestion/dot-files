if [[ -t 0 ]]; then
	stty -ixon
fi

export LC_ALL=en_US.UTF-8
export PYTHONPATH="${PYTHONPATH}:/Library/Python/3.8/site-packages"
