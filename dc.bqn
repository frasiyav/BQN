⍝ Run with spec/dzref

_ur_ ← {(𝕘/⊸∾↕≠𝕩) ⊑¨∘⊔ (𝔽𝕘/𝕩)∾𝕩}

Base←{+⟜(𝕨⊸×)´⌽𝕩}
Enc2←{𝕨⥊2(|∾˜(𝕨-1)Enc2⌊∘÷˜)⍟(0<𝕨)𝕩}

nl‿tab←•UCS 10‿9
charSet←∾charGroups←⟨
  chF←"+-×÷⋆√⌊⌈|¬∧∨<>≠=≤≥≡≢⊣⊢⥊∾≍↑↓↕⌽⍉/⍋⍒⊏⊑⊐⊒∊⍷⊔" ⍝ Function
  "˜˘¨⌜⁼´`"             ⍝ Modifier
  "∘○⊸⟜⌾⊘◶⎉⚇⍟"          ⍝ Composition
  "𝕨𝕎𝕩𝕏𝕗𝔽𝕘𝔾"            ⍝ Input
  nl∾"⋄,"               ⍝ Separator
  "←↩→"                 ⍝ Gets
  "(){}⟨⟩"              ⍝ Bracket
  "‿"                   ⍝ Ligature
  •d ⍝ +⟜(↕10)⌾•UCS'0'  ⍝ Digit
  "¯.π∞"                ⍝ Numeric
  "_"∾' '(⊢∾+)⌾•UCS•a   ⍝ Alphabetic
  " "∾tab               ⍝ Whitespace
⍝ ⍝'" eliminated during tokenization
⟩
bF‿bM‿bC‿bI‿bS‿bG‿bB‿bL‿bD‿bN‿bA‿bW←⊔/≠¨charGroups
vi←+´≠¨8↑charGroups

Tokenize←{
  r←𝕩='⍝'⋄s←/(≠↑2⊸↓)⊸∧𝕩=⊑"'"⋄d←/𝕩='"'
  g←⍋q←∾⟨  s⋄¯1↓d⋄/r⟩ ⋄q↩g⊏q
  e← g⊏∾⟨2+s⋄ 1↓d⋄(⊢-¯1↓0∾⊢)∘⊏⟜(0∾+`r)⊸//(𝕩=nl)∾1⟩
  Se←{(⊏˜𝕨)Se𝕩∨(↕≠𝕩)∊𝕩/𝕨}⍟{0=⊑⌽𝕩}
  st←¯1↓Se⟜(1↑˜≠)∾⟜≠q⊸⍋¨e⋄b←st/q∾˘e
  ToI←¯1↓·≠¨∘⊔(≠𝕩)∾˜⥊⋄f←¬≠`ToI b
  cb←(¬(st/q)⊏r)/b
  nl←≠lu←⍷lit←𝕩⊔˜1-˜(+`ToI⊑˘cb)×≠`ToI cb
  cl←f/ToI⊑∘⌽˘cb
  args←charSet⊸⊐¨𝕨⋄c←charSet⊐f/𝕩
  w←(≠↑0∾⊢)⊸<l←c∊∾bD‿bN‿bA
  id←⍷args∾(bA∊˜w/c)⍒⊸⊏i←(1-˜l×+`w)⊔c
  nv←+´bA∊˜⊑¨id
  c↩(w∨¬l∨c∊bW)/(vi+id⊐i)_ur_ w(vi+(≠id)+lu⊐lit)_ur_ cl c
  c/˜↩¬(1∾1∾˜2⊸↓)⊸∧c∊bS
  ⟨c,nv,nv-≠args,(nv↓id)∾lu⟩
}

Parse←{
  a←𝕩∊(2↑bG)⋄at←1⌽a⋄𝕩/˜↩¬a⋄a/˜↩¬at
  l←≠𝕩⋄sep←𝕩∊bS⋄𝕩↩(bF⊑˜⥊chF⊐<'⊣')¨_ur_ sep 𝕩⋄sep∨↩𝕩=2⊑bB
  o←𝕩=0⊑bB⋄c←𝕩=1⊑bB⋄v←a-˜𝕩≥vi⋄f←¬o∨c∨v∨sep
  na←(2×sep)+f×1+l↑0∾c∨v
  d←+`o-c⋄fe←((⍋⍋d)⊏+`(⍋d)⊏o)⊏l∾(⍋⊏⟜d)⊸⊏/c
  fe⌊↩l-l↑⌽⌈`↕∘≠⊸×⌽1∾˜sep
  sel←¬∘⊏⟜(o∨c)⊸/⍋((f×fe)⌈↕l)-+`f-l↑≠¨⊔∧f/fe
  sel⊸⊏¨𝕩‿na
}

Hex←16 Base (•d∾"ABCDEF")⊸⊐

ReadNum←10 Base bD⊸⊐
GenF64←{
  0:8⥊0;
  l←2(⌊⋆⁼)𝕩
  (Hex"44")∾2 Base˘⌽8‿8(⊣⥊×´⊸↑)∾⟨⥊0,11 Enc2 1023+l,(0⌈l)Enc2𝕩⟩
}
MakeTab←{{⊑∘(∾⟜0)¨¯1↓(chF⊐𝕨)⊔○(∾⟜(≠chF))𝕩}○∾⟜(⥊¨∘⥊¨)´<˘⍉(2(÷˜∾⊣)≢)⊸⥊𝕩}
tab1←MakeTab⟨
  "⊣⊢"     , 2⥊<⟨⟩
  "|-⌈⌊√"  , (Hex"99")+(↕4)∾6
  "÷"      , <(Hex"10")∾0
  "¬"      , <∾⥊¨⟨Hex"9A",GenF64 1,Hex"A0"⟩
⟩
tab2←MakeTab⟨
  "⊣"      , Hex"1A"
  "+-×÷⌊⌈∧", (Hex"A0")+(↕6)∾2
  "¬"      , <∾⥊¨⟨Hex"A1",GenF64 1,Hex"A0"⟩
  "∨"      , <(Hex"10")∾1
⟩
fntab←⍉(0¨tab1)∾tab1≍tab2
f64←127-3

GenFn←{
  ⟨⟩GenFn𝕩;
  ⟨t,nVar,nLoc,lits⟩←𝕨Tokenize𝕩
  t⊏˜↩⍋+`-´<˘(2‿3⊏bB)=⌜t
  nd←+´c←t=3⊑bB
  t↩((vi+nVar+≠lits)+↕∘≠)_ur_ c t
  ⟨a,na⟩←Parse t
  ops←⥊∾⟨
    ∾⟜(0⥊˜3∾˜vi-≠)fntab
    ⍉(Hex¨"20"‿"22"‿"21")∾⌜↕nVar
    ⊣⌜⟜(↕3)(GenF64∘ReadNum¨lits)∾(Hex"10")∾¨3+↕nd
  ⟩
  (((≠∾∾)⟨nLoc∾f64⟩)∾(Hex"0B")∾˜∾)¨((⊢-˜¬×+`)a=2⊑bB)⊔(na+3×a)⊏ops
}

Gen←{
  LEB←{0:⥊0;(0∾˜128⥊˜1-˜≠)⊸+ 2 Base<˘ ⌽⍉ (⌽·∨`·⌽∨´˘)⊸/ 10‿7(⊣⥊×´⊸↑) ⌽64 Enc2 𝕩}
  C←LEB∘≠⊸∾
  S←∾⟜C
  V←≠∾∾
  I←C∘•UCS
  t‿n‿b←𝕩
  ∾⟨
   0∾(•UCS"asm")∾4↑1
   1 S V (96∾⟜∾C¨)¨t
   3 S V ⥊¨↕≠b
   7 S V ⥊<"fn"I⊸(⊣∾0∾⊢)n
  10 S V C¨ b
  ⟩
}

Compile←{
  body←GenFn 𝕩
  rcp←⟨"x"⟩ GenFn "1÷x"
  or←⟨"w","x"⟩ GenFn "(w+x)-w∧x"
  f←⟨rcp,or,body⟩
  Gen ⟨(≠¨f)/⟨1‿1,2‿1,0‿1⟩⥊¨¨f64 ⋄ 2 ⋄ ∾f⟩
}