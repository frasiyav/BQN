#! /usr/bin/env dbqn

compile ← •Import "c.bqn"
Comp ← ((<"runtime["∾⍕∾"]"˙)¨↕62)⊸Compile
FP ← ∞⊸=◶⟨⍕,"Infinity"⟩
Esc ← (⟨"\t","\n","\r","\'","\"""⟩∾<∘⥊)⊑˜("'"""∾˜@+9‿10‿13)⊑∘⊐⊢
Str ← "str("""∾(∾Esc¨)∾""")"˜
Char ← "'"(∾∾⊣)Esc
Fconst ← ≡◶⟨(⊑⍋)∘(∾⟜∞)◶⟨0⊸≤◶⟨"-"∾FP∘|,FP⟩,Char⟩⋄Str⋄⊑⟩
L ← "["∾"]"∾˜1↓·∾","⊸∾⟜⍕¨
J ← ∾∾⟜(@+10)¨
Fout ← ⟨⊢,Fconst,L⟩ {L𝕎¨𝕩}¨ ⊢
Frun ← ("provide.concat("∾∾⟜")")⌾(1⊸⊑) Fout
Long ← ∾ (1‿2/⟨"  new Uint8Array("∾∾⟜")"⋄((@+10)∾" ,")⊸∾⟩) {𝕎𝕩}¨ ⊢
• ← (⊑"r"‿"c"‿"fmt"⊐⊏)◶⟨
  {𝕩⋄ref‿len←•Import"pr.bqn"⋄Long Frun len⊸↓⌾(1⊸⊑)Comp ref}
  {𝕩⋄Long Fout Comp J •LNS "c.bqn"}
  {𝕩⋄Long Fout Comp J •LNS "fmt.bqn"}
  ¯1 ↓ · J L∘Fout∘Comp¨
⟩ •args
