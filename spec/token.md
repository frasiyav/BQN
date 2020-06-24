This page describes BQN's token formation rules (token formation is also called scanning). Most tokens in BQN are a single character long, but quoted characters and strings, identifiers, and numbers can consist of multiple characters, and comments, spaces, and tabs are discarded during token formation.

BQN source code should be considered as a series of unicode code points. Here the separator between lines in a file is considered to be a single character, newline, even though some operating systems such as Windows typically represent it with a two-character CRLF sequence. Implementers should note that not all languages treat UTF code points as atomic, as exposing the UTF-8 or UTF-16 representation instead is common. For a language such as JavaScript that uses UTF-16, the double-struck characters `𝕨𝕎𝕩𝕏𝕗𝔽𝕘𝔾` are represented as two 16-bit surrogate characters, but BQN treats them as a single unit.

A BQN character literal consists of a single character between single quotes, such as `'a'`, and a string literal consists of any number of characters between double quotes, such as `""` or `"abc"`. Character and string literals take precedence with comments over other tokenization rules, so that `⍝` between quotes does not start a comment and whitespace between quotes is not removed, but a quote within a comment does not start a character literal. Almost any character can be included directly in a character or string literal without escaping. The only exception is the double quote character `"`, which must be written twice to include it in a string, as otherwise it would end the string instead. Character literals require no escaping at all, as the length is fixed. In particular, literals for the double and single quote characters are written `'''` and `'"'`, while length-1 strings containing these characters are `"'"` and `""""`.

A comment consists of the lamp character `⍝` and any following text until (not including) the next newline character. The initial `⍝` must not be part of a string literal started earlier. Comments are ignored entirely and do not form tokens.

Identifiers and numeric literals share the same token formation rule. These tokens are formed from the *numeric characters* `¯∞π.0123456789` and *alphabetic characters* `_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`. Any sequence of adjacent numeric and alphabetic characters forms a single token, which is a numeric literal if it begins with a numeric character and an identifier if it begins with an alphabetic character. Numeric literals are also subject to [numeric literal rules](literal.md), which specify which numeric literals are valid and which numbers they represent.

Following this step, the whitespace characters space and tab are ignored, and do not form tokens. Only these whitespace characters, and the newline character, which does form a token, are allowed.

Otherwise, a single character forms a token. Only the specified set of characters can be used; others result in an error. The classes of characters are given below.

| Class               | Characters
|---------------------|------------
| Function literal    | `+-×÷⋆√⌊⌈\|¬∧∨<>≠=≤≥≡≢⊣⊢⥊∾≍↑↓↕⌽⍉/⍋⍒⊏⊑⊐⊒∊⍷⊔`
| Modifier literal    | `` ˜˘¨⌜⁼´` ``
| Composition literal | `∘○⊸⟜⌾⎉⚇⍟`
| Parameter           | `𝕨𝕩𝕗𝕘𝕎𝕏𝔽𝔾`
| Punctuation         | `←↩→(){}⟨⟩‿⋄,` and newline

In the BQN [grammar specification](grammar.md), the three literal classes are grouped into terminals `Fl`, `_ml`, and `_cl`, while the punctuation characters are identified separately as keywords such as "←". The parameters are handled specially. The uppercase versions `𝕎𝕏𝔽𝔾` and lowercase versions `𝕨𝕩𝕗𝕘` are two spellings of the four underlying parameters.