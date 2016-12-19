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
    gn_en = 0
    kn = 0
    rn = 0
    delete gloss
    delete gloss_en
    delete keb
    delete reb
}

BEGIN {
    for (i = 2; i < ARGC; i++) {
        if (inexact)
            Words[ARGV[i]] = i - 1
        else
            Words[">" ARGV[i] "<"] = i - 1
        delete ARGV[i]
    }
    ARGC = 2
}

/(<keb>|<reb>)/ {
    for (w in Words) {
        if ($0 ~ w) {
            found = 1
            Found[w] = ++fn
        }
    }
}

/<gloss.*lang="rus">/ {
    gloss[gn++] = get_contents()
    next
}

/<gloss>/ {
    gloss_en[gn_en++] = get_contents()
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
    printf "%s;%s;\"", keb[0], reb[0]
    rest = 0
    if (! is_empty(gloss)) {
        for (l in gloss) {
            if (rest) printf "\n"
            printf "%s", gloss[l]
            rest = 1
        }
    } else {
        for (l in gloss_en) {
            if (rest) printf "\n"
            printf "%s", gloss_en[l]
            rest = 1
        }
    }
    printf "\"\n"
    found = 0
    clear_arrays()
    next
}

/<\/entry>/ {
    clear_arrays()
}

END {
    first = 1
    for (w in Words) {
        if (! (w in Found)) {
            if (first) {
                print "Can't find following words:"
                first = 0
            }
            print "   " w
        }
    }
}
