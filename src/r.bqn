# BQN runtime. Requires:
# IsArray Type Log  !+-×÷⋆⌊=≤≢⥊⊑↕⌜`

◶ ← {𝕨((𝕨𝔽𝕩)⊑𝕘){𝔽}𝕩}     # LIMITED to number left operand result
⊘ ← {𝕨((1{𝔽}𝕨)-0)◶𝔽‿𝔾 𝕩}
⊢ ← {𝕩}
⊣ ← {𝕩}⊘{𝕨}
˜ ← {𝕩𝔽𝕨⊣𝕩}
∘ ← {𝔽𝕨𝔾𝕩}
○ ← {(𝔾𝕨)𝔽𝔾𝕩}
⊸ ← {(𝔽𝕨⊣𝕩)𝔾𝕩}
⟜ ← {(𝕨⊣𝕩)𝔽𝔾𝕩}
⍟ ← {𝕨((𝕨𝔾𝕩)⊑⊢‿𝕗){𝔽}𝕩}   # LIMITED to boolean right operand result

# LIMITED to numeric arguments for scalar cases
< ← {⟨⟩⥊⟨𝕩⟩} ⊘ (1-≤˜)
> ←            (1-≤)
≢ ↩ IsArray◶⟨⟩‿≢   # LIMITED to monadic case
≠ ← (0<=)◶⟨1⋄0⊑≢⟩  # LIMITED to monadic case

_fold←{
  ! 1==𝕩
  l←≠v←𝕩 ⋄ F←𝔽
  r←𝕨 (0<l)◶{𝕩⋄Identity f}‿{l↩l-1⋄l⊑𝕩}⊘⊣ 𝕩
  {r↩(𝕩⊑v)F r}⌜(l-1)⊸-⌜↕l
  r
}
´ ← _fold


ToArray ← <⍟(1-IsArray)
Int←IsArray◶⟨⌊⊸=,0⟩
Nat←IsArray◶⟨0⊸≤×⌊⊸=,0⟩
Cell←{(𝕨⊸+⊑𝕩˜)⌜↕(≠𝕩)-𝕨}⟜≢

∾ ← {k←≠𝕨⋄k⊸≤◶⟨⊑⟜𝕨⋄-⟜k⊑𝕩˜⟩⌜↕k+≠𝕩}  # LIMITED to two vector arguments

_eachd←{
  _d←{ # Equal ranks
    p←≢𝕨
    ! 1(⊑⟜p=⊑⟜(≢𝕩))⊸×´↕=𝕨
    p⥊ (⊑⟜(⥊𝕨)𝔽⊑⟜(⥊𝕩))⌜↕1×´p
  }
  _e←{ # 𝕨 has smaller or equal rank
    p←≢𝕨 ⋄ k←=𝕨 ⋄ q←≢𝕩
    ! 1(⊑⟜p=⊑⟜q)⊸×´↕k
    l←1(q⊑˜k⊸+)⊸×´↕(=𝕩)-k
    a←⥊𝕨 ⋄ b←⥊𝕩
    q⥊⥊(≠a) (⊑⟜a𝔽l⊸×⊸+⊑b˜)⌜○↕ l
  }
  =○=◶⟨>○=◶⟨𝔽_e⋄𝔽˜_e˜⟩⋄𝔽_d⟩
}

_perv←{ # Pervasion
  R←𝔽{𝕨𝔽_perv𝕩}
  +○IsArray◶⟨𝔽⋄R⌜⊘(>○IsArray◶{𝕨{𝕗R𝕩}⌜𝕩}‿{𝕩{𝕩R𝕗}⌜𝕨})⋄R _eachd⟩
}

Cmp0 ← ≤˜-≤
Cmp1 ← (0<1×´≢∘⊢)◶⟨1, IsArray∘⊢◶(1-2×≤)‿{𝕨Cmp1𝕩}⟜(0⊑⥊)⟩
Cmp ← +○IsArray◶⟨
  Cmp0
  IsArray∘⊣◶⟨Cmp1,-Cmp1˜⟩
  {
    lc←𝕨CmpLen○≢𝕩
    cc ← (⊑⟜(⥊𝕨))⊸Cmp⟜(⊑⟜(⥊𝕩)) _getCellCmp´ lc
    Cc˜0
  }
⟩
_grade←{
  ! 1≤=𝕩
  m←1×´1 Cell 𝕩
  cc←m 𝔽○(⊑⟜(⥊𝕩)) _getCellCmp 0
  GT←Cc>0˜
  l←≠𝕩
  B←l⊸≤◶⊢‿l
  (↕l){
    i←-d←𝕨 ⋄ j←ei←ej←0
    e←3 ⋄ G←GT○(⊑⟜(m⊸×⌜⍟(1-m=1)𝕩)) ⋄ c←⟨G,0,1,2⟩
    s←(8≤d)⊑⟨+,{(𝕩-1){𝕩⋄e↩2⋄j↩i⋄i↩𝕩}⍟(1-G)⍟(1-e)𝕩}⟩
    N←{i↩d+𝕨⋄ej↩B d+ei↩B j↩d+𝕩⋄e↩l≤j⋄S ei⋄i R j}
    R←{𝕨e◶c𝕩}◶{e+↩2×ei=i↩1+𝕨⋄𝕨}‿{e+↩ej=j↩1+𝕩⋄𝕩}‿N
    {(i R j)⊑𝕩}⟜𝕩⌜𝕩
  }´(2⋆ni-1+⊢)⌜↕ni←-⌊-2 Log l+l=0
}

Indices←{
  ! 1==𝕩
  l←≠𝕩
  {
    ! 1×´Nat⌜𝕩
    k←l-1
    N ← ((⊢+-×0=𝕩⊑˜⊢)`k⊸-⌜↕l)⊑˜k-⊢  # Next nonzero
    E ← ⊑⟜(+`𝕩)
    ei←E i←N 0
    {{ei↩E i↩N𝕩+1⋄i}⍟(𝕩=ei)i}⌜↕E k
  }⍟(0<l)𝕩
}

Transpose←{
  l←≠𝕩 ⋄ m←1×´c←1 Cell 𝕩
  (c⥊↕m)(+⟜(m⊸×)⊑(⥊𝕩)˜)⌜↕l
}⍟(0<=)

SelSub←{
  ! IsArray 𝕨
  ! 1×´⥊Int⌜ 𝕨
  l←≠𝕩
  ! 1×´⥊ ((-l)⊸≤×l⊸>)⌜ 𝕨
  ((⊢+l×0>⊢)⌜𝕨)(1==𝕩)◶{
    c←1×´s←1 Cell 𝕩
    𝕨((⥊𝕩)⊑˜c⊸×⊸+)⌜s⥊↕c
  }‿{
    ⊑⟜𝕩⌜𝕨
  }𝕩
}

_under_←{
  i←↕l←1×´s←≢𝕩
  v←⥊𝕨𝔽○𝔾𝕩
  g←Cmp0 _grade gi←⥊𝔾s⥊i
  P←(≠g)⊸≤◶⟨(⊑⟜g)⊑gi˜,l⟩
  e←P j←0
  s⥊{e=𝕩}◶⟨⊑⟜(⥊𝕩),{𝕩⋄r←(j⊑g)⊑v⋄e↩P j↩1+j⋄r}⟩⌜i
}

¨ ↩ {(𝔽⌜)⊘(𝔽_eachd)○ToArray}

match←{(0⊑𝕨)◶(1⊑𝕨)‿𝕩}´⟨
  ⟨=○IsArray, 0⟩
  ⟨IsArray∘⊢, =⟩
  ⟨=○=      , 0⟩
  ⟨1×´=¨○≢  , 0⟩
  {1×´⥊𝕨Match¨𝕩}
⟩
Depth←IsArray◶0‿{1+0(⊣-≤×-)´Depth⌜⥊𝕩}

≡ ← Depth          ⊘ Match

Merge←{
  c←≢0⊑⥊𝕩
  ! 1×´(c≡≢)⌜⥊𝕩
  𝕩⊑⟜Deshape˜⌜c⥊↕1×´c
}⍟(0<≠∘⥊)⍟IsArray

+ ↩ + _perv
- ↩ - _perv
× ↩ (0⊸(<->) ⊘ ×) _perv
÷ ↩ ÷ _perv
⋆ ↩ ⋆ _perv
√ ← ⋆⟜(÷2)   ⊘ (⋆⟜÷˜)
| ← (×⟜×     ⊘ {𝕩-𝕨×⌊𝕩÷𝕨}) _perv
⌊ ↩ (⌊       ⊘ {(𝕨>𝕩)⊑𝕨‿𝕩}) _perv
⌈ ← (-∘⌊∘-   ⊘ {(𝕨<𝕩)⊑𝕨‿𝕩}) _perv
¬ ← 1+-
∧ ←            ×
∨ ←            (+-×)
< ↩ {⟨⟩⥊⟨𝕩⟩} ⊘ ((1-≤˜) _perv)
> ↩ Merge    ⊘ ((1-≤) _perv)
≠ ↩ ≠        ⊘ ((1-=) _perv)
= ↩ =        ⊘ (= _perv)
≥ ← !∘0      ⊘ (≤˜_perv)
≤ ↩ !∘0      ⊘ (≤ _perv)
identity ← (0⊑⟨!∘0⟩) {(0⊑𝕨){𝕗=𝕩}◶𝕩‿(1⊑𝕨)}´ ⟨+‿0,-‿0,×‿1,÷‿1,⋆‿1,√‿1,∧‿1,∨‿0,|‿0,⌊‿∞,⌈‿¯∞,<‿0,≤‿1,=‿1,≥‿1,>‿0,≠‿0⟩

Deshape←IsArray◶{⟨𝕩⟩}‿⥊
Reshape←{
  ! 1≥=𝕨
  𝕨↩Deshape 𝕨
  ! ∧´Nat⌜𝕨
  l←×´𝕨
  n←×´≢𝕩
  𝕨⥊{
    𝕩(0<n)◶⟨Type⊸(⊣⌜)⋄⥊⊸{⊑⟜𝕨⌜n|𝕩}⟩↕l
  }⍟(l≠n)𝕩
}⟜ToArray
⥊ ↩ Deshape        ⊘ ⥊

Range←{
  I←{!Nat𝕩⋄↕𝕩}
  M←{!1==𝕩⋄(<⟨⟩)⥊⊸∾⌜´I⌜𝕩}
  IsArray◶I‿M 𝕩
}

≢ ↩ ≢              ⊘ (¬Match)


Pair ← {⟨𝕩⟩} ⊘ {⟨𝕨,𝕩⟩}

≍ ← >∘Pair
_ranks ← {⟨2⟩⊘⟨1,0⟩((⊣-1+|)˜⟜≠⊑¨<∘⊢)⥊∘𝔽}
_depthOp_←{
  neg←0>n←𝕨𝔾_ranks𝕩 ⋄ F←𝔽
  _d←{
    R←(𝕗+neg)_d
    𝕨(×⟜2⊸+´2 Reshape (neg∧𝕗≥0)∨(0⌈𝕗)≥Pair○≡)◶(⟨R¨⋄R⟜𝕩⌜∘⊣⋄(𝕨R⊢)⌜∘⊢⋄F⟩)𝕩
  }
  𝕨 n _d 𝕩
}
⚇ ← _depthOp_
_rankOp_←{
  k←𝕨(Pair○= (0≤⊢)◶⟨⌊⟜-,0⌈-⟩¨ 𝔾_ranks)𝕩
  Enc←{
    f←⊑⟜(≢𝕩)⌜↕𝕨
    c←×´s←𝕨Cell𝕩
    f⥊⊑⟜(⥊𝕩)⌜∘((s⥊↕c)+c×⊢)⌜↕×´f
  }
  Enc↩(>⟜0+≥⟜=)◶⟨<⊢,Enc,<⌜⊢⟩
  > ((0⊑k)Enc𝕨) 𝔽¨ ((1-˜≠)⊸⊑k)Enc𝕩
}
⎉ ← _rankOp_
˘ ← {𝔽⎉¯1}
_insert←{
  ! 1≤=𝕩
  𝕨 𝔽´ <˘𝕩
}
˝ ← _insert


_onAxes_←{
  F←𝔽
  (𝔾<≡)∘⊣◶{ # One axis
    ! 1≤=𝕩
    𝕨F𝕩
  }‿{ # Multiple axes
    ! 1≥=𝕨
    ! 𝕨≤○≠≢𝕩
    l←≠𝕨 ⋄ W←⊑⟜(⥊𝕨)
    0{(W𝕨)F(1+𝕨)⊸𝕊˘⍟(𝕨<l-1)𝕩}⍟(0<l)𝕩
  }
}

Select←ToArray⊸(SelSub _onAxes_ 1)
⊏ ← 0⊸Select       ⊘ Select

JoinTo←∨○(1≠=)◶∾‿{
  s←𝕨Pair○≢𝕩
  a←1⌈´k←≠⌜s
  ! ∧´1≥a-k
  c←(k¬a)+⟜(↕a-1)⊸⊏¨s
  ! ≡´c
  l←+´(a=k)⊣◶1‿(0⊑⊢)¨s
  (⟨l⟩∾0⊑c)⥊𝕨∾○⥊𝕩
}

Take←{
  T←{
    ! Int 𝕨
    l←≠𝕩 ⋄ n←𝕨<0 ⋄ e←l⌊r←|𝕨 ⋄ s←⟨r⟩ ⋄ m←1
    i ← 𝕩{s∾↩c←1 Cell 𝕨⋄𝕩(×+⌜↕∘⊢)m↩×´c}⍟(1≠=𝕩) (l-e)+⍟n ↕e
    s⥊𝕩{(⥊𝕩)n◶⟨∾,∾˜⟩(0⊑⥊Type𝕗)⌜↕m×r-e}⍟(l<r) ⊑⟜(⥊𝕩)⌜i
  }
  𝕨 T _onAxes_ 0 ((1⌜∘↕0⌈𝕨-○≠⊢)⊸∾∘≢⥊⥊) 𝕩
}
Prefixes ← {!1≤=𝕩 ⋄ Take⟜𝕩⌜↕1+≠𝕩}
↑ ← Prefixes       ⊘ Take
Drop←{
  s←(≠𝕨)(⊣↑⊢∾˜·1⌜∘↕0⌈-⟜≠)≢𝕩
  ((s×¯1⋆𝕨>0)+(-s)⌈s⌊𝕨)↑𝕩
}
Suffixes ← {!1≤=𝕩 ⋄ Drop⟜𝕩⌜↕1+≠𝕩}
↓ ← Suffixes       ⊘ Drop

Windows←{
  ! IsArray 𝕩
  ! 1≥=𝕨
  ! 𝕨≤○≠≢𝕩
  ! ∧´Nat⌜⥊𝕨
  s←(≠𝕨)↑≢𝕩
  ! ∧´𝕨≤1+s
  𝕨{(∾⟜(𝕨≠⊸↓≢𝕩)∘≢⥊>)<⌜⊸⊏⟜𝕩¨s(¬+⌜○Range⊢)⥊𝕨}⍟(0<≠𝕨)𝕩
}

Reverse ← {!1≤=𝕩 ⋄ (-↕⊸¬≠𝕩)⊏𝕩}
Rotate ← {!Int𝕨 ⋄ l←≠𝕩⋄(l|𝕨+↕l)⊏𝕩} _onAxes_ 0

Rep ← Indices⊸⊏
Replicate ← {0<=𝕨}◶{𝕨⌜⊸Rep𝕩}‿{!𝕨=○≠𝕩⋄𝕨Rep𝕩} _onAxes_ (1-0=≠)

↕ ↩ Range          ⊘ Windows
⌽ ← Reverse        ⊘ Rotate
/ ← Indices        ⊘ Replicate

Join←(1≠=)◶⟨∨´1≠=⌜,1⟩◶{
  # List of lists
  i←j←¯1⋄e←⟨⟩⋄a←𝕩
  {{e↩a⊑˜i↩𝕩⋄j↩¯1}⍟(i⊸≠)𝕩⋄(j↩j+1)⊑e}⌜/≠⌜𝕩
}‿{
  # Multidimensional
  C←(<⟨⟩)⥊⊸∾⌜´⊢  # Cartesian array product
  ! IsArray 𝕩
  s←≢⌜𝕩
  d←≠0⊑⥊s
  ! ∧´⥊d=≠⌜s
  ! d≥=𝕩
  l←(≢𝕩){(𝕩⊑⟜≢a Pick1˜(j=𝕩)⊸×)⌜↕𝕨}¨j←↕r←=a←𝕩
  ! (r⊸↑⌜s)≡C l
  i←C{p←+´⌜↑𝕩⋄(↕0⊑⌽p)-𝕩/¯1↓p}⌜l
  >i<⌜⊸⊏¨l/𝕩
}⍟(0<≠∘⥊)

_group←{
  !1==𝕩⋄!∧´Int⌜𝕩⋄!∧´¯1≤𝕩
  d←(l←GroupLen𝕩)GroupOrd𝕩
  i←0⋄(𝔽{𝕩⋄(i↩i+1)⊢i⊑d}⌜∘↕)⌜l
}
GroupInds←{
  ! IsArray 𝕩
  G←⊢_group
  (1<≡)◶G‿((<<⟨⟩)⥊⊸∾⌜⌜´G⌜)𝕩
}
GroupGen←{
  ! IsArray 𝕩
  m←1<≡𝕨
  l←m◶≠‿{!1==𝕩⋄≠⌜𝕩}𝕨
  ! l≤○≠≢𝕩
  ! ∧´l=l≠⊸↑≢𝕩
  𝕨m◶(⊏⟜𝕩_group⊣)‿{
    ⊏⟜(𝕩⥊˜⟨×´l⟩∾(≠l)Cell𝕩)⌜ +⌜⌜´ (⌽×`⟨1⟩∾⌽1↓l) × ⊢_group⌜𝕨
  }𝕩
}

∾ ↩ Join           ⊘ JoinTo
⊔ ← GroupInds      ⊘ GroupGen

Pick1←{
  ! 1==𝕨
  ! 𝕨=○≠s←≢𝕩
  ! ∧´Int⌜𝕨
  ! ∧´𝕨(≥⟜-∧<)s
  𝕨↩𝕨+s×𝕨<0
  (⥊𝕩)⊑˜0(⊑⟜𝕨+⊑⟜s×⊢)´-↕⊸¬≠𝕨
}
Pickd←(∨´IsArray⌜∘⥊∘⊣)◶Pick1‿{Pickd⟜𝕩⌜𝕨}
Pick←IsArray◶⥊‿⊢⊸Pickd

# Searching
IndexOf←{
  c←1-˜=𝕨
  ! 0≤c
  𝕨 (0<≠𝕨)◶⟨0⎉c∘⊢,(+˝∧`)≢⌜○((0<c)◶⟨⊢,<⎉c⟩)⟩ ToArray𝕩
}
UniqueMask←{
  ! 1≤=𝕩
  u←0↑𝕩
  {(≠u)>0⊑⥊u IndexOf 𝕩}◶{u↩u∾𝕩⋄1}‿0˘𝕩
}
Find←{
  r←=𝕨
  ! r≤=𝕩
  𝕨 ≡⎉r (≢𝕨) ↕⎉r 𝕩
}

⊐ ← !∘0            ⊘ IndexOf
∊ ← UniqueMask     ⊘ (⊐˜<≠∘⊢)
⍷ ← ∊⊸/            ⊘ Find

ReorderAxes←{
  𝕩↩<⍟(0=≡)𝕩
  ! 1≥=𝕨
  𝕨↩⥊𝕨
  ! 𝕨≤○≠≢𝕩
  ! ∧´Nat⌜⥊𝕨
  r←(=𝕩)-+´¬∊𝕨
  ! ∧´𝕨<r
  𝕨↩𝕨∾𝕨(¬∘∊˜/⊢)↕r
  (𝕨⊸⊏Pick𝕩˜)⌜↕⌊´⌜𝕨⊔≢𝕩
}
⍉ ← Transpose      ⊘ ReorderAxes

# Sorting
CmpLen ← {
  e←𝕨-˜○(∨´0⊸=)𝕩
  𝕨(e=0)◶⟨0,e⟩‿{
    c←×𝕨-○≠𝕩
    r←𝕨⌊○≠𝕩
    l←𝕨{
      i←+´∧`𝕨=𝕩
      m←×´⊑⟜𝕨⌜↕i
      {c↩×-´𝕩⋄m↩m×⌊´𝕩}∘(⊑¨⟜𝕨‿𝕩)⍟(r⊸>)i
      m
    }○(((-1+↕r)+≠)⊸{⊑⟜𝕩⌜𝕨})𝕩
    ⟨l,c⟩
  }𝕩
}
_getCellCmp ← {
  Ci←𝔽⋄l←𝕨⋄c←𝕩
  Cc←{
    a←𝕨⋄b←𝕩
    S←(l⊸=)◶{S∘(1+𝕩)⍟(0⊸=)a Ci○(𝕩⊸+)b}‿c
    S 0
  }
  (1≠l)⊑(𝕩⍟(0⊸=)𝔽)‿Cc
}

_binSearch ← {
  B ← 𝔽
  {
    R←{𝕨{a←B m←𝕩+h←⌊𝕨÷2⋄(h+a×2|𝕨)R a⊑𝕩‿m}⍟(>⟜1)𝕩}
    1+(𝕩+1)R ¯1
  }⍟(0⊸<)
}
_bins←{
  c←1-˜=𝕨
  ! 0≤c
  ! c≤=𝕩
  lw←×´sw←1 Cell 𝕨
  cw←lw 𝔽○(⊑⟜(⥊𝕨)) _getCellCmp 0
  ! 0⊸<◶⟨1,∧´0≤˜·cw⟜(lw⊸+)⌜lw×↕∘-⟜1⟩≠𝕨
  cx←c-˜=𝕩
  sx←cx Cell 𝕩 ⋄ lc←sw CmpLen sx
  cc ← (⊑⟜(⥊𝕨))⊸𝔽⟜(⊑⟜(⥊𝕩)) _getCellCmp´ lc
  B←(×´sw)⊸×⊸Cc≤0˜
  (≠𝕨)⊸{B⟜𝕩 _binSearch 𝕨}⌜ (×´sx) × ⥊⟜(↕×´)⊑⟜(≢𝕩)⌜↕cx
}

⍋ ←   Cmp _grade   ⊘ (  Cmp _bins)
⍒ ← -∘Cmp _grade   ⊘ (-∘Cmp _bins)
∧ ↩ ⍋⊸⊏            ⊘ ∧
∨ ↩ ⍒⊸⊏            ⊘ ∨

OccurrenceCount ← ⊐˜(⊢-⊏)⍋∘⍋
ProgressiveIndexOf ← {𝕨⊐○(≍˘⟜OccurrenceCount𝕨⊸⊐)𝕩}
⊒ ← OccurrenceCount⊘ ProgressiveIndexOf

⊑ ↩ (0⊑⥊)          ⊘ Pick
◶ ↩ {𝕨((𝕨𝔽𝕩)⊑𝕘){𝔽}𝕩}  # Same definition, new Pick

inverse ← {(⊑(0⊏𝕩)⊐<) ⊑ ((1⊏𝕩)∾⟨!∘0⟩)˜} ⍉ (2∾˜2÷˜≠)⊸⥊ ⟨
  +, +⊘(-˜)
  -, -
  ×, ⊢⊘(÷˜)
  ÷, ÷
  ⋆, Log _perv
  √, ⋆⟜2⊘(⋆˜)
  ∧, ⊢⊘(÷˜)
  ∨, ⊢⊘(-˜÷1-⊢)
  <, {!IsArray𝕩⋄!0==𝕩⋄⊑𝕩}⊘(!∘0)
  /, {!(⍋≡↕∘≠)𝕩⋄≠⌜⊔𝕩}⊘(!∘0)
⟩
⁼ ← {Inverse 𝕗}

_repeat_←{
  n←𝕨𝔾𝕩
  l←u←0
  {!Int𝕩⋄l↩l⌊𝕩⋄u↩u⌈𝕩}⚇0 n
  a←𝕩⋄_p←{𝔽∘⊣`⟨a⟩∾↕0+𝕩}
  pos←(𝕨𝔽 ⊢)_p u
  neg←(𝕨𝔽⁼⊢)_p-l
  (|⊑<⟜0⊑pos‿neg˜)⚇0 n
}
⍟ ↩ _repeat_

⥊ ↩ Deshape        ⊘ Reshape
⌜ ↩ {𝔽⌜○ToArray}
⌾ ← _under_