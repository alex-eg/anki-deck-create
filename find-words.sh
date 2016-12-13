#!/bin/bash
# Find all provided words

gawk -f parse.awk JMdict $*
