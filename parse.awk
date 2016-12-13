# Example usage:
# awk parse.awk JMdict 悪い 良い 国士無双 -- to find entries exactly
# matching input
# awk parse.awk -v inexact=1 JMdict 悪い 良い 国士無双 -- to find all
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

{
    for (w in Words) {
        if ($0 ~ Words[w]) {
            found = 1
            delete Words[w]
        }
    }
}

in_entry && /<gloss.*lang="rus">/ {
    gloss[gn++] = get_contents()
    next
}

in_entry && /<reb>/ {
    reb[rn++] = get_contents()
    next
}

in_entry && /<keb>/ {
    keb[kn++] = get_contents()
    next
}

/<entry>/ {
    in_entry = 1
    next
}

found && /<\/entry>/ {
    for (l in keb)
        print keb[l]
    for (l in reb)
        print reb[l]
    for (l in gloss)
        print gloss[l]
    print "----------------------------------"
    delete keb
    delete reb
    delete gloss
    found = 0
    next
}

/<\/entry>/ {
    in_entry = 0
    delete gloss
    delete keb
    delete reb
}

END {
    if (! is_empty(Words)) {
        print "Can't find following words:"
        for (w in Words)
            print "   " Words[w]
    }
}
