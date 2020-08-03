#!/usr/bin/env dbqn

# Process BQN runtime

impl ← •LNS •path∾"../impl.bqn"

chrs←⟨
  "+-×÷⋆√⌊⌈|¬∧∨<>≠=≤≥≡≢⊣⊢⥊∾≍↑↓↕⌽⍉/⍋⍒⊏⊑⊐⊒∊⍷⊔!"
  "˜˘¨⌜⁼´˝`"
  "∘○⊸⟜⌾⊘◶⎉⚇⍟"
⟩
nc ← ≠¨chrs
chr ← ∾chrs
itr ← 0⥊˜≠chr

init ← " "⊸∾¨(/⟜"_"¨nc/0‿1‿1)∾¨(nc/"FMD")∾¨(nc+´⊸↑⥊"ABC"∾⌜•a)
post ← ∾⟜" "¨/⟜"_"¨nc/0‿0‿1
names ← init∾¨(•UCS 48)∾¨post

Inc ← {
  i←⊑chr⊐𝕩
  n←0 ⋄ itr↩{n↩1+𝕩}⌾(i⊑⊢)itr
  names↩((i⊑init)∾(•UCS 48+n)∾i⊑post)⌾(i⊑⊢)names
}

# Required functionality passed in as an argument
pnam ← ⟨"IsArray", "Type", "Log"⟩∾names⊏˜chr⊐"!+-×÷⋆⌊=≤≢⥊⊑↕⌜`"


E_isdef ← (3≤≠)◶⟨0,∧´⟨chr," ","←↩"⟩∊˜¨3⊸↑⟩
E_proc ← {
  l←≠chr
  q←≠`𝕩∊"""'" ⋄ f←¬∨`q¬⊸∧𝕩='#'
  ∾ (((l×f/q)+chr⊸⊐) (≥⟜l)◶⟨⊑⟜names,⥊∘⊢⟩¨ ⊢) f/𝕩
}
E_redef ← { # handles [fmd] [←↩]
  tail ← E_proc 3↓𝕩 # must use old def
  Inc ⊑𝕩
  (E_proc 1↑𝕩) ∾ "←" ∾ tail
}

ref ← ∾ ∾⟜(•UCS 10)¨ ∾⟨
  ⟨"{"⟩
  ⟨"←𝕩"∾˜"⟨"∾"⟩"∾˜1↓∾","⊸∾¨pnam⟩
  E_isdef◶E_proc‿E_redef¨ impl∾<"⟨"∾"⟩"∾˜1↓⥊","⊸∾˘∾chrs
  ⟨"}"⟩
⟩