#!/bin/bash
# Find all provided words

words=""
options=""

while [[ $# -gt 0 ]]; do
        case $1 in
                --fuzzy)
                        fuzzy=1
                        options="$options -v inexact=1"
                        ;;
                *)
                        words="$1 $words"
                        ;;
        esac
        shift
done

gawk -f parse.awk $options JMdict $words
exit $?
