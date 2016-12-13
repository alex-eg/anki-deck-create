# Example usage:
# awk parse.awk -v S=悪い JMdict -- to find entries exactly matching "悪い"
# awk parse.awk -v S=悪い -v inexact=1 JMdict -- to find all mentions of "悪い"

BEGIN {
    if (inexact)
        Match = S
    else
        Match = ">" S "<"
}

function get_contents() {
    split($0, a, ">")
    return substr(a[2], 0, index(a[2], "<") - 1)
}

$0 ~ Match {
    found = 1
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

/<entry>/ {
    in_entry = 1
    next
}

/<\/entry>/ {
    in_entry = 0
    delete gloss
    delete keb
    delete reb
}
