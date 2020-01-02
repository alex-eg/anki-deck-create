Anki deck creator
-----
Super simple awk + bash tool for creating Anki decks of japanese words.

Finds dictionary entries for all provided japanese words.

Example usage:

	$ ./find-words.sh --lang=ru 悴む 悪人 上着 下着

    悴む
    かじかむ
    1) коченеть
    2) (см.) かじける
    ----------------------------------
    悪人
    あくにん
    злой человек; злодей, негодяй
    ----------------------------------
    下着
    したぎ
    {нижнее} бельё
    ----------------------------------
    上着
    上衣
    表着
    うわぎ
    じょうい
    1) пиджак; жакет; тужурка, китель
    2) одежда; верхнее кимоно
    ----------------------------------

Batch use
-----
To generate a deck for a lot of words, it's far more convenient to use input from file:

    $ cat ./word-list
    言彙力
    鼠
    新幹線

    $ ./find-words.sh --file=./words-list
    新幹線;しんかんせん;"Shinkansen
    bullet train"
    鼠;ねずみ;"mouse
    rat
    dark gray
    dark grey
    slate (color, colour)"
    語彙力;ごいりょく;"(the extent of) one's vocabulary"

Don't forget to set ';' as separator when importing resulting deck into the Anki.
