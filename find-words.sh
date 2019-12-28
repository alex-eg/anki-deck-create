#!/bin/bash
# Find all provided words

usage() {
    cat <<EOF
Usage: find-words.sh [options] word...
Options:
  --fuzzy        Find inexact matches.
  --lang=<lang>  Set language. Available options: ru, en
  --file=<file>  File with list of words to find. Must be one word per line,
                   lines starting with '#' are ignored.
EOF
}

words=""
options=""
lang="en"

if [[ $# -eq 0 ]]; then
    usage
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --fuzzy)
            fuzzy=1
            options="$options -v inexact=1"
            ;;
        --lang=*)
            lang=${1##*=}
            options="$options -v lang=$lang"
            ;;
        --file=*)
            file=${1##*=}
            words=$(sed 's/^#.*//' "$file" | tr '\n' ' ')
            ;;
        --*)
            usage
            exit 1
            ;;
        *)
            words="$1 $words"
            ;;
    esac
    shift
done

if [[ -z "$words" ]]; then
    usage
    exit 1
fi

gawk -f parse.awk $options JMdict $words
exit $?
