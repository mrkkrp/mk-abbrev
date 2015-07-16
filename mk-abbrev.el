;;; mk-abbrev.el --- Peculiar way to use Emacs abbrevs -*- lexical-binding: t; -*-
;;
;; Copyright © 2015 Mark Karpov <markkarpov@openmailbox.org>
;;
;; Author: Mark Karpov <markkarpov@openmailbox.org>
;; URL: https://github.com/mrkkrp/mk-abbrev
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.4"))
;; Keywords: convenience, abbrev
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at your
;; option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;; Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along
;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; There are quite a few characters that don't belong to any particular
;; keyboard layout or language. To input them I use Emacs abbreviations.
;;
;; Note that abbreviations are better than key bindings à la C-x 8 …,
;; because the key bindings are hard to remember and their number is
;; insufficient. So, abbreviations with readable names in the the way to go.
;;
;; However the method of expansion of the abbreviations is not that good at
;; all. It's flawed at least in the following ways (*flawed* in the context
;; of my use-case, of course):
;;
;; 1. User cannot write and expand abbreviations in arbitrary context, he
;;    needs to surround them with «non-word-constituent-characters»: spaces
;;    or punctuation. So this thing won't work:
;;
;;    “It's difficultelli” ≠ “It's difficult…”
;;
;; 2. When using input method for non-Latin languages user needs to disable
;;    input method, type an abbreviation, enable input method again — this
;;    is rather awkward.
;;
;; I've written a function that performs insertion of abbreviation and its
;; expansion. This function solves all the problems. Just bind and call
;; `mk-abbrev-insert' and enter abbreviation, finish typing with SPC and
;; abbreviation will be inserted and expanded. Point is usually placed after
;; expansions, but the function is smart enough to place point in the middle
;; of two-character expansions that are pairs of quotes, like ‘«»’; wrapping
;; of selected text also works for this kind of expansions. Since user
;; writes abbreviation in the minibuffer, current input method has no
;; effect. Also, user can repeat insertion of previously used abbreviations
;; by pressing just one SPC entering empty input.

;;; Code:

(setq save-abbrevs nil)

(define-abbrev-table 'mk-abbrev-table
  '(("acc"  "́")  ; accent
    ("apeq" "≈")  ; approximately equal
    ("bot"  "⊥")  ; bottom
    ("bull" "•")  ; bullet
    ("copy" "©")  ; copyright sign
    ("dagg" "†")  ; dagger
    ("dagr" "‡")  ; crossed dagger
    ("dash" "—")  ; em dash
    ("dda"  "⇓")  ; double downwards arrow
    ("deg"  "°")  ; degree
    ("dla"  "⇐")  ; double leftwards arrow
    ("dqu"  "“”") ; double quotation marks
    ("dra"  "⇒")  ; double rightwards arrow
    ("dua"  "⇑")  ; double upwards arrow
    ("elli" "…")  ; ellipsis
    ("fleu" "❧")  ; fleuron
    ("guil" "«»") ; guillemets
    ("hash" "#")  ; number sign or hash sign
    ("id"   "≡")  ; identical to
    ("ineg" "∫")  ; integral
    ("ineq" "≠")  ; inequality
    ("inf"  "∞")  ; infinity
    ("inte" "‽")  ; interrobang
    ("intr" "·")  ; interpunct
    ("keyb" "⌨")  ; keyboard
    ("loze" "◊")  ; lozenge
    ("mnpl" "∓")  ; minus-plus
    ("mult" "×")  ; multiplication
    ("nabl" "∇")  ; nabla
    ("ndsh" "–")  ; en dash
    ("num"  "№")  ; numero sign
    ("obel" "÷")  ; obelus
    ("plmn" "±")  ; plus-minus
    ("pnd"  "£")  ; pound
    ("prod" "∏")  ; product
    ("qed"  "■")  ; quod erat demonstrandum
    ("root" "√")  ; root
    ("rub"  "₽")  ; Russian ruble
    ("sda"  "↓")  ; simple downwards arrow
    ("sect" "§")  ; section
    ("sgui" "‹›") ; single arrow guillements
    ("sla"  "←")  ; simple leftwards arrow
    ("squ"  "‘’") ; single quotation marks
    ("sra"  "→")  ; simple rightwards arrow
    ("srcp" "℗")  ; sound recording copyright symbol
    ("star" "★")  ; star
    ("sua"  "↑")  ; simple upwards arrow
    ("sum"  "∑")  ; summation
    ;; Greek alphabet
    ("alpha"   "α") ("Alpha"   "Α")
    ("beta"    "β") ("Beta"    "Β")
    ("gamma"   "Y") ("Gamma"   "Γ")
    ("delta"   "δ") ("Delta"   "Δ")
    ("epsilon" "ε") ("Epsilon" "Ε")
    ("zeta"    "ζ") ("Zeta"    "Ζ")
    ("eta"     "η") ("Eta"     "Η")
    ("theta"   "θ") ("Theta"   "Θ")
    ("iota"    "ι") ("Iota"    "Ι")
    ("kappa"   "κ") ("Kappa"   "Κ")
    ("lambda"  "λ") ("Lambda"  "Λ")
    ("mu"      "μ") ("Mu"      "Μ")
    ("nu"      "ν") ("Nu"      "Ν")
    ("xi"      "ξ") ("Xi"      "Ξ")
    ("omicron" "ο") ("Omicron" "Ο")
    ("pi"      "π") ("Pi"      "Π")
    ("rho"     "ρ") ("Rho"     "Ρ")
    ("sigma"   "σ") ("Sigma"   "Σ") ("fsigma" "ς")
    ("tau"     "τ") ("Tau"     "Τ")
    ("upsilon" "υ") ("Upsilon" "Υ")
    ("phi"     "φ") ("Phi"     "Φ")
    ("chi"     "χ") ("Chi"     "Χ")
    ("psi"     "ψ") ("Psi"     "Ψ")
    ("omega"   "ω") ("Omega"   "Ω"))
  "Abbreviations to insert some Unicode characters automatically.")

(defvar mk-abbrev-map (copy-keymap minibuffer-local-map)
  "This keymap is used when `mk-abbrev-insert' reads its argument.")

(define-key mk-abbrev-map (kbd "SPC") #'exit-minibuffer)

(defvar mk-abbrev-last nil
  "Name of last abbrev expanded with `mk-abbrev-insert' function.")

;;;###autoload
(defun mk-abbrev-insert (&optional abbrev)
  "Read name of abbreviation ABBREV and insert it.

If input is empty (or it's NIL if the function is called
non-interactively), insert last used abbreviation or if there is
no such abbreviation yet, do nothing.  Good when need to insert
abbreviation with activated input method.

This command is smart enough to place point inside abbreviations
that are pairs of quoting characters, otherwise point is placed
after the expansion.

If there is an active region and expansion is a pair of quoting
characters, wrap them around the region."
  (interactive
   (list
    (let ((input (read-from-minibuffer "Abbrev: " nil mk-abbrev-map)))
      (when (> (length input) 0)
        input))))
  (let* ((abbrev    (or abbrev mk-abbrev-last))
         (expansion (abbrev-expansion abbrev mk-abbrev-table))
         (pairp (and (= (length expansion) 2)
                     (eq (get-char-code-property
                          (elt expansion 0)
                          'general-category)
                         'Pi)
                     (eq (get-char-code-property
                          (elt expansion 1)
                          'general-category)
                         'Pf))))
    (when expansion
      (if (and pairp mark-active)
          (let ((beg (region-beginning))
                (end (1+ (region-end))))
            (goto-char beg)
            (insert (elt expansion 0))
            (goto-char end)
            (insert (elt expansion 1)))
        (insert expansion)
        (when pairp
          (backward-char 1)))
      (setf mk-abbrev-last abbrev))))

;;; mk-abbrev.el ends here
