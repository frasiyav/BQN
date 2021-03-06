# Format an array to a string including newlines
{
  F0←𝔽  # Format a number or operation to a string
  FmtAtom ← ≍ <⟜@◶⟨@⊸≠◶⟨"@","'"⊸(∾∾⊣)⟩,F0⟩

  # Vertical padding for arrays of rank greater than 2
  PadV ← {
    # Leading shape
    ls ← ¯1↓≢𝕩
    # Empty lines after each row: 1 if it's at the end of a 2-cell, plus
    # 1 if it's at the end of a 2-cell and a 3-cell, and so on
    p ← ⥊ +⎉¯1‿∞´ ×⌜˜`⌾⌽ (-1⌈ls)↑¨1
    # But none at the very end
    p ↩ 0⌾(¯1⊸⊑) p
    # If 𝕩 has cells, pad by selection; if it's empty, there are only
    # pads but selection would try to get cells (1⌈ above), so overtake.
    Pad ← {(»⊸<⊸×/0∾1+𝕨) ⊏ ' '¨∘⊏⊸∾𝕩}
    p (0<≠∘⊢)◶⟨+´⊸↑,Pad⟩ ((×´ls)∾¯1↑≢𝕩) ⥊ 𝕩
  }⍟(2 < =)

  # Horizontal padding: just some spaces on either side
  PadH ← { s←⟨≠𝕩,𝕨⟩⥊' ' ⋄ ∾≍⟨s,𝕩,s⟩ }

  Pad ← PadH⟜PadV

  # Add a frame to padded data
  Enframe ← ∨○(1⊸≠)⟜≠◶{∨´2=+`-˝"⟨⟩"=⌜⊏𝕩}‿1◶{
    # One-line version
    ≍"⟨"∾(¯1↓1↓⊏𝕩)∾"⟩"
  }‿{
    # General case
    l ← ¯1 ⊑ ≢𝕩
    ∾ ⟨
      ≍l↑∾⟨"┌",(5⊸<)◶⟨⥊"·─"⊏˜1⌊⊢,F0⟩𝕨⟩
      ((0⌈4⌊𝕨-1)⊑"·╵╎┆┊")⌾⊑ 𝕩
      ≍l-⊸↑"┘"
    ⟩
  }

  FmtEmpty ← (0‿0≢≢)◶("┌┐"≍"└┘")‿(((2≠=)∨0=≠)◶{
    '┐'⌾(0‿¯1⊸⊑) 2 Enframe 1 PadH " "¨𝕩
  }‿{
    ≍"⟨⟩"∾˜(1<≠)◶⟨"",'⥊'⌾(¯1⊸⊑)·∾·∾⟜"‿"¨F0¨⟩≢𝕩
  })

  PaddingJoin ← {1 PaddingJoin 𝕩}⊘{
    s ← ≢¨ 𝕩
    w ← (0<=)◶⟨⥊,⌈˝⍟(=-1˙)⟩1⊑¨s
    h ← ⌈˝⎉1⍟(0<=) ⊑¨s
    ∾⎉2 ≍⍟(0⌈2-=) (h ∾⌜ 𝕨×w¬(-𝕨×≠w)↑1) ↑¨ 𝕩
  }

  FmtMixed ← {
    (=𝕩) Enframe 2 Pad 𝕨 PaddingJoin Fmt¨𝕩
  }

  FmtSimple ← (≠(0⊸<+≤)+´)∘(⥊<@˙)◶{ # Depth 1
    # All characters
    k ← ∞⍟(0⊸=) -≠ c ← ¯1↓≢𝕩
    q ← '"'
    # Escape quotes in strings (rank 1) and substitute control chars
    # with control pictures for other ranks.
    CSub ← { 𝕩 + (𝕩(=×'␡'-⊢)@+127) + ('␀'-@)×𝕩<@+32 }
    𝕩 ↩ (1≠=)◶⟨(1+q=⊢)⊸/,Csub⟩ 𝕩
    r ← =𝕩
    (r Enframe 1 PadH PadV)⍟(1≠r) ≍ (c↑q) ∾⎉k 𝕩 ∾⎉k c-⊸↑q
  }‿{
    # Not homogeneous, or empty
    (∨´0=≢)◶FmtMixed‿FmtEmpty 𝕩
  }‿{
    # All numbers
    ¯1 FmtMixed 𝕩
  }

  # Format to character matrix
  Fmt ← (2⌊≡)◶FmtAtom‿FmtSimple‿FmtMixed

  # Convert to string
  ¯1↓·⥊ ∾⟜(@+10)˘∘Fmt
}
