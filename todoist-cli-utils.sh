#!/bin/bash

function todoist-today() {
    todoist sync
    todoist l -f today
}

function todoist-soon() {
    todoist sync
    todoist l -f '(today) | (tomorrow) | (overdue)'
}

function todoist-work() {
    todoist sync
    todoist l -f '#Работа'
}

function todoist-c() {
    $@ | peco | awk ' {print $1}' | xargs -n 1 todoist c    
    todoist sync
}

function todoist-d() {
    $@ | peco | awk ' {print $1}' | xargs -n 1 todoist d
    todoist sync
}


function todoist-add() {
    read -r -p "Введите date или date string: " datestr
    PROJ=$(todoist projects | peco | awk '{ print $1 }')
    read -n 1 -p "Нужна метка? [Yy/Nn/Дд/Нн]:" label
    case $label in
        [YyДд]* ) label="-L "$(todoist labels | peco | awk 'BEGIN {ORS=","} { print $1 }');;
        [NnНн]* ) label="";;
        * ) echo "Ясно, ты ебан"; label="";;
    esac
    read -r -n1 -p "Приоритет? [1-4]:" prior

    if [[ $prior =~ ^[0-9]+ && prior -ge 1  && prior -ge 4 ]]; then
        prior="-p "$prior
    else
        prior=""
    fi

    todoist add "$1" -d "$datestr" $prior $label -P "$PROJ"
    todoist sync
}