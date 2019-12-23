#!/bin/bash
# Find all provided words

usage() {
    cat <<EOF
Usage: find-words.sh [options] word...
Options:
  --fuzzy        Find inexact matches.
  --file=<file>  File with list of words to find. Must be one word per line,
                   lines starting with '#' are ignored.
EOF
}

words=""
options=""

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
