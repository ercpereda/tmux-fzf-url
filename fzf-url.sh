#!/usr/bin/env bash
#===============================================================================
#   Author: Wenxuan
#    Email: wenxuangm@gmail.com
#  Created: 2018-04-06 12:12
#===============================================================================

fzf_cmd() {
    fzf-tmux -d 30% --multi --exit-0 --cycle --reverse --bind='ctrl-r:toggle-all' --bind='ctrl-s:toggle-sort'
}

if  hash xdg-open &>/dev/null; then
    open_cmd='nohup xdg-open'
elif hash open &>/dev/null; then
    open_cmd='open'
fi

content="$(tmux capture-pane -J -p)"
urls=($(echo "$content" |grep -oE '(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]'))
wwws=($(echo "$content" |grep -oE '(([a-zA-Z](-?[a-zA-Z0-9])*)\.)*[a-zA-Z](-?[a-zA-Z0-9])+\.[a-zA-Z]{2,}(/\S+)*' |sed 's/^\(.*\)$/http:\/\/\1/'))
ips=($(echo  "$content" |grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(:[0-9]{1,5})?(/\S+)*'          |sed 's/^\(.*\)$/http:\/\/\1/'))

merge() {
    for item in "$@" ; do
        echo "$item"
    done
}

merge "${urls[@]}" "${wwws[@]}" "${ips[@]}"|
    sort -u |
    nl -w3 -s '  ' |
    fzf_cmd |
    awk '{print $2}'|
    xargs -n1 -I {} $open_cmd {} &>/dev/null ||
    true
