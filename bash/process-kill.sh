ps -ef | sed 1d | fzf | awk '{print $2}' | xargs kill
