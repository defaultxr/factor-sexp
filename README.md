# factor-sexp

A Factor vocabulary for parsing [symbolic expressions](https://en.wikipedia.org/wiki/S-expression) (also known as s-expressions or sexps), a la [Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language)).

Currently, the supported types are:
- integers
- floats
- ratios
- symbols (currently not converted into Factor symbols because of the differences in semantics between the two)
- strings
- lists

Factor already includes a `csexp` vocab, however this does not appear to be a standard s-expression parser. This vocab aims to be more customizable and complete. Ideally this vocab could be used as a base for a full Lisp interpreter/compiler in the future.

## Usage

The main words you're likely to want from this vocab are:

- `sexp-tokenizer` - Parse a string containing an s-expression into objects representing each token. Useful if you want to do custom conversion into another format.
- `parse-sexp` - Parse a string containing an s-expression into Factor objects. Useful if you just need a basic conversion into Factor data types.

Example usage:

```factor
! Load the vocab.
USE: sexp

"(1 3.14 2/3 \"hello\" foo (1 2 3))" sexp-tokenizer
! The result is a sexp-list tuple whose "elements" slot contains the elements of the list (which themselves are tuples representing the values in the list).

"(1 3.14 2/3 \"hello\" foo (1 2 3))" parse-sexp
! Result: { 1 3.14 2/3 "hello" T{ sexp-symbol { name "foo" } } { 1 2 3 } }
```

## Future

Things that still need to be done.

- Support more data types:
  - negative numbers (they are currently incorrectly parsed as symbols)
  - booleans (`t`/`nil` in Common Lisp, `#t`/`#f` in Scheme)
  - null (`nil` in Common Lisp, `#nil` in Scheme)
  - undefined/unspecified values (for Scheme(?))
  - complex numbers
  - characters (`#\a` in Common Lisp and Scheme, `?a` in Emacs Lisp)
  - cons cells (the `.` notation)
  - vectors (`#(1 2 3)` in Common Lisp and Scheme, `[1 2 3]` in lisps such as Emacs Lisp)
- Improve conversion of symbols into Factor symbols. Should they just be interned into custom vocab(s), or just kept as their own objects as they are currently? Perhaps make this customizable?
- Improve symbol parsing:
  - Currently, symbol parsing is done with a character class which only includes letters, numbers, dashes, etc. It should operate in a much more advanced way, rather than as a "whitelist".
  - Common Lisp allows any characters to be in a symbol, including spaces, parentheses, etc. Symbols containing "special characters" must be surrounded by pipes (`|`).
  - Handle reader case (i.e. Common Lisp reads all symbols in uppercase by default, but this can be customized).
  - Handle packages (Common Lisp allows a symbol's package to be specified with `:` or `::`, i.e. `foo::bar` refers to the symbol named `bar` in the `foo` package).
- Support more string escape sequences.
- Quote and quasiquote.
- Reader macros (In Common Lisp they look like `#N...`, where `N` is any character.)
  - It may be possible to parse some of them automatically/unambiguously; for example, `#xFF` is hex `FF`, which parses to `255` decimal, and `#b1111` is binary `1111`, which parses to `15` decimal. Not sure if this should be done in this vocab, or if it should be left up to the interpreter, since reader macros can be overridden.
- Support more lisp dialects: Common Lisp, Scheme, Emacs Lisp, Clojure, and more(?). It should be possible for the user to select which they are parsing. Perhaps have "presets", but allow the user to mix and match.
- Documentation.
- Tests.
