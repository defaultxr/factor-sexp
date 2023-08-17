! Copyright (C) 2023 modula t. worm.
! See https://factorcode.org/license.txt for BSD license.
USING: accessors arrays kernel math.parser multiline peg
peg.ebnf prettyprint sequences strings ;
IN: sexp

! FIX: how does this compare to the csexp vocab?
! csexp implements https://www.wikiwand.com/en/Canonical_S-expressions

GENERIC: sexp>factor ( sexp -- obj )

TUPLE: sexp-number value ;

M: sexp-number sexp>factor
    value>> ;

TUPLE: sexp-integer < sexp-number ;

TUPLE: sexp-float < sexp-number ;

TUPLE: sexp-ratio < sexp-number ;

TUPLE: sexp-symbol name package ;

M: sexp-symbol sexp>factor ;

TUPLE: sexp-string text ;

M: sexp-string sexp>factor
    text>> ;

TUPLE: sexp-list elements ;

M: sexp-list sexp>factor
    elements>> >array [ sexp>factor ] map ;

EBNF: sexp-tokenizer
[=[
     space = (" " | "\r" | "\t" | "\n")
     spaces = space* => [[ drop ignore ]]
     integer = [0-9]+ => [[ >string string>number sexp-integer boa ]]
     float = [0-9]* "." [0-9]+ => [[ V{ } [ append ] reduce >string string>number sexp-float boa ]]
     ratio = [0-9]+ "/" [0-9]+ => [[ V{ } [ append ] reduce >string string>number sexp-float boa ]]
     number = float | ratio | integer
     escaped-double-quote = "\\\"" => [[ 34 ]]
     string = "\"" ( escaped-double-quote | !("\"") .)* "\"" => [[ second >string sexp-string boa ]]
     symbol = [0-9a-zA-Z_-]+ => [[ >string sexp-symbol new swap >>name ]]
     atom = number | string | symbol
     list = "(" sexp* ")" => [[ second sexp-list boa ]]
     sexp = spaces ( atom | list ) spaces
 ]=]

: parse-sexp ( str -- obj ) ! Parse STR, a string containing an s-expression, into a Factor object.
    sexp-tokenizer sexp>factor ;
