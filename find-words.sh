#!/bin/bash
# Find all provided words

usage() {
        cat <<EOF
Usage: find-words.sh [options] word...
Options:
  --fuzzy        Find inexact matches.

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

gawk -f parse.awk $options JMdict $words
exit $?
