# Example usage:
# awk -f parse.awk JMdict 悪い 良い 国士無双 -- to find entries exactly
# matching input
# awk -f parse.awk -v inexact=1 JMdict 悪い 良い 国士無双 -- to find all
# mentions of provided words

function get_contents() {
    split($0, a, ">")
    return substr(a[2], 0, index(a[2], "<") - 1)
}

function is_empty(array) {
    for (i in array)
        return 0
    return 1
}

function clear_arrays() {
    gn = 0
    kn = 0
    rn = 0
    delete gloss
    delete keb
    delete reb
}

BEGIN {
    for (i = 2; i < ARGC; i++) {
        if (inexact)
            Words[i-2] = ARGV[i]
        else
            Words[i-2] = ">" ARGV[i] "<"
        delete ARGV[i]
    }
    ARGC = 2
}

/(<keb>|<reb>)/ {
    for (w in Words) {
        if ($0 ~ Words[w]) {
            found = 1
            delete Words[w]
        }
    }
}

/<gloss.*lang="rus">/ {
    gloss[gn++] = get_contents()
    next
}

/<reb>/ {
    reb[rn++] = get_contents()
    next
}

/<keb>/ {
    keb[kn++] = get_contents()
    next
}

found && /<\/entry>/ {
    if (is_empty(gloss)) {
        found = 0
        clear_arrays()
        next
    }
    printf "%s;%s;", keb[0], reb[0]
    for (l in gloss) printf "%s ", gloss[l]
    printf "\n"
    found = 0
    clear_arrays()
    next
}

/<\/entry>/ {
    clear_arrays()
}

END {
    if (! is_empty(Words)) {
        print "Can't find following words:"
        for (w in Words)
            print "   " Words[w]
    }
}
