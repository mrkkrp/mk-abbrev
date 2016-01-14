# MK Abbrev

[![License GPL 3](https://img.shields.io/badge/license-GPL_3-green.svg)](http://www.gnu.org/licenses/gpl-3.0.txt)
[![Build Status](https://travis-ci.org/mrkkrp/mk-abbrev.svg?branch=master)](https://travis-ci.org/mrkkrp/mk-abbrev)

There are quite a few characters that don't belong to any particular
keyboard layout or language. To input them I use Emacs abbreviations.

Here is the transformation table:

Abbreviation | Result Character | Name of the character
------------ | ---------------- | ---------------------
`acc`        | ́                | accent mark
`apeq`       | ≈                | approximately equal
`bot`        | ⊥                | bottom
`bull`       | •                | bullet
`copy`       | ©                | copyright sign
`dagg`       | †                | dagger
`dagr`       | ‡                | crossed dagger
`dash`       | —                | em dash
`dda`        | ⇓                | double downwards arrow
`deg`        | °                | degree
`dla`        | ⇐                | double leftwards arrow
`dqu`        | “”               | double quotation marks
`dra`        | ⇒                | double rightwards arrow
`dua`        | ⇑                | double upwards arrow
`elli`       | …                | ellipsis
`fleu`       | ❧                | fleuron
`guil`       | «»               | guillemets
`hash`       | #                | number sign or hash sign
`id`         | ≡                | identical to
`ineg`       | ∫                | integral
`ineq`       | ≠                | inequality
`inf`        | ∞                | infinity
`inte`       | ‽                | interrobang
`intr`       | ·                | interpunct
`keyb`       | ⌨                | keyboard
`loze`       | ◊                | lozenge
`mnpl`       | ∓                | minus-plus
`mult`       | ×                | multiplication
`nabl`       | ∇                | nabla
`ndsh`       | –                | en dash
`num`        | №                | numero sign
`obel`       | ÷                | obelus
`plmn`       | ±                | plus-minus
`pnd`        | £                | pound
`prod`       | ∏                | product
`qed`        | ■                | quod erat demonstrandum
`root`       | √                | root
`rub`        | ₽                | Russian ruble
`sda`        | ↓                | simple downwards arrow
`sect`       | §                | section
`squi`       | ‹›               | single arrow guillements
`sla`        | ←                | simple leftwards arrow
`squ`        | ‘’               | single quotation marks
`sra`        | →                | simple rightwards arrow
`srcp`       | ℗                | sound recording copyright
`star`       | ★                | star
`sua`        | ↑                | simple upwards arrow
`sum`        | ∑                | summation

There is also entire Greek alphabet:

Abbreviation | Letter | Abbreviation  | Letter
------------ | ------ | ------------  | ------
`Alpha`      | Α      | `alpha`       | α
`Beta`       | Β      | `beta`        | β
`Gamma`      | Γ      | `gamma`       | Y
`Delta`      | Δ      | `delta`       | δ
`Epsilon`    | Ε      | `epsilon`     | ε
`Zeta`       | Ζ      | `zeta`        | ζ
`Eta`        | Η      | `eta`         | η
`Theta`      | Θ      | `theta`       | θ
`Iota`       | Ι      | `iota`        | ι
`Kappa`      | Κ      | `kappa`       | κ
`Lambda`     | Λ      | `lambda`      | λ
`Mu`         | Μ      | `mu`          | μ
`Nu`         | Ν      | `nu`          | ν
`Xi`         | Ξ      | `xi`          | ξ
`Omicron`    | Ο      | `omicron`     | ο
`Pi`         | Π      | `pi`          | π
`Rho`        | Ρ      | `rho`         | ρ
`Sigma`      | Σ      | `sigma`       | σ
`Tau`        | Τ      | `tau`         | τ
`Upsilon`    | Υ      | `upsilon`     | υ
`Phi`        | Φ      | `phi`         | φ
`Chi`        | Χ      | `chi`         | χ
`Psi`        | Ψ      | `psi`         | ψ
`Omega`      | Ω      | `omega`       | ω

Final sigma ς is written as `fsigma`.

Note that abbreviations are better than key bindings à la <kbd>C-x 8
…</kbd>, because the key bindings are hard to remember and their number is
insufficient. So, abbreviations with readable names in the the way to go.

However the method of expansion of the abbreviations is not that good at
all. It's flawed at least in the following ways (*flawed* in the context of
my use-case, of course):

1. User cannot write and expand abbreviations in arbitrary context, he needs
   to surround them with «non-word-constituent-characters»: spaces or
   punctuation. So this thing won't work:

   ```
   “It's difficultelli” ≠ “It's difficult…”
   ```

2. When using input method for non-Latin languages user needs to disable
   input method, type an abbreviation, enable input method again — this is
   rather awkward.

I've written a function that performs insertion of abbreviation and its
expansion. This function solves all the problems. Just bind and call
`mk-abbrev-insert` and enter abbreviation, finish typing with <kbd>SPC</kbd>
and abbreviation will be inserted and expanded. Point is usually placed
after expansions, but the function is smart enough to place point in the
middle of two-character expansions that are pairs of quotes, like ‘«»’;
wrapping of selected text also works for this kind of expansions. Since user
writes abbreviation in the minibuffer, current input method has no
effect. Also, user can repeat insertion of previously used abbreviations by
pressing just one <kbd>SPC</kbd> entering empty input.

## Installation

Put it on your load path, then do `(require 'mk-abbrev)`.

This is probably not a good package for MELPA, so it's not there. However, I
prefer keep it as a separate repository and it's not going to be under
intensive development I guess, so you can just download or clone it.

## Usage

Just bind `mk-abbrev-insert` that's it:

```emacs-lisp
(global-set-key (kbd "menu SPC") #'mk-abbrev-insert)
```

## License

Copyright © 2015 Mark Karpov

Distributed under GNU GPL, version 3.
