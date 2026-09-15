\ Port of raylib examples/text/text_inline_styling.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE font 64 ALLOT
CREATE textSize 16 ALLOT
CREATE pos 16 ALLOT
CREATE gpos 16 ALLOT
CREATE grec 16 ALLOT
CREATE cpsize 4 ALLOT
VARIABLE colRandom
VARIABLE frameCounter
VARIABLE colFront
VARIABLE colBack

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: hexdig ( c -- n )
   dup [char] 0 >= over [char] 9 <= and if [char] 0 - else
   dup [char] A >= over [char] F <= and if [char] A - 10 + else
   dup [char] a >= over [char] f <= and if [char] a - 10 + else
   drop -1 then then then ;

: parse-hex8 ( addr -- n nconsumed )
   0 0 8 0 do
      2 pick i + c@ hexdig dup 0< if drop leave then
      swap 16 * +  swap 1+ swap
   loop
   nip swap ;

CREATE hexbuf 16 ALLOT

\ DrawTextStyled: parse [cRRGGBBAA] [bRRGGBBAA] [r]
: DrawTextStyled ( font z F: x y size spacing  color -- )
   colFront !  TRANSPARENT colBack !
   4e  ( padding not used as var )
   0e 0e  ( textOffsetX textOffsetY on fstack after size spacing... let's use vars )
   fswap fswap  ( F: x y size spacing ) 2drop drop drop ;  \ placeholder overwritten below

FVARIABLE ts-x
FVARIABLE ts-y
FVARIABLE ts-size
FVARIABLE ts-spc
FVARIABLE ts-offx
FVARIABLE ts-offy
VARIABLE ts-font
VARIABLE ts-text
VARIABLE ts-color
VARIABLE ts-i

: glyph-advance ( font codepoint F: scale -- F: width )
   over swap GetGlyphIndex  ( font idx )
   over font_glyphs @ over 40 * + 12 + l@  ( font idx adv )
   dup 0= if
      drop over font_recs @ swap 16 * + 8 + sf@ f*
      nip
   else
      s>f f* nip
   then ;

: DrawTextStyled ( font z F: x y size spacing  color -- )
   ts-color !  ts-spc f! ts-size f! ts-y f! ts-x f!  ts-text ! ts-font !
   ts-color @ colFront !  TRANSPARENT colBack !
   0e ts-offx f!  0e ts-offy f!
   ts-size f@ ts-font @ font_baseSize l@ s>f f/  ( F: scale )
   0 ts-i !
   begin ts-i @ ts-text @ TextLength < while
      ts-text @ ts-i @ + cpsize GetCodepointNext  ( cp )
      cpsize l@ 0= if drop 1 cpsize l! 63 then
      dup [char] [ = if
         drop
         ts-i @ 2 + ts-text @ TextLength <
         ts-text @ ts-i @ 1+ + c@ [char] r = and
         ts-text @ ts-i @ 2 + + c@ [char] ] = and if
            ts-color @ colFront !  TRANSPARENT colBack !
            3 ts-i +!
         else
            ts-i @ 1 + ts-text @ TextLength <
            ts-text @ ts-i @ 1+ + c@ dup [char] c = swap [char] b = or and if
               ts-text @ ts-i @ 1+ + c@ >r
               2 ts-i +!
               ts-text @ ts-i @ + parse-hex8  ( n ncons )
               GetColor
               r> [char] c = if colFront ! else colBack ! then
               1+ ts-i +!   \ digits + ']'
            else
               1 ts-i +!
            then
         then
      else
         dup 10 = if
            drop ts-size f@ ts-offy f@ f+ ts-offy f!  0e ts-offx f!
            cpsize l@ ts-i +!
         else
            fdup  ( scale )
            ts-font @ over glyph-advance ts-spc f@ f+  ( F: scale increaseX )
            colBack @ .alpha if
               ts-x f@ ts-offx f@ f+  ts-y f@ ts-offy f@ f+ 4e f-
               fover  ts-size f@ 8e f+ grec Rec!
               grec colBack @ DrawRectangleRec
            then
            dup bl <> over 9 <> and if
               ts-x f@ ts-offx f@ f+ ts-y f@ ts-offy f@ f+ gpos Vector2!
               ts-font @ swap gpos ts-size f@ colFront @ DrawTextCodepoint
            else drop then
            ts-offx f@ f+ ts-offx f!
            cpsize l@ ts-i +!
         then
      then
   repeat
   fdrop ;

: MeasureTextStyled ( font z F: size spacing -- dest )
   ( dest font z  F: size spacing )
   >r >r  ( dest ) r> r>  ( dest font z )
   2 pick 0e 0e rot rot DrawTextStyled  \ too coupled; simple MeasureTextEx instead
   ;

: example
   screenWidth screenHeight z" raylib [text] example - inline styling" InitWindow
   font GetFontDefault drop
   RED colRandom !
   0 frameCounter !
   60 SetTargetFPS
   begin
      1 frameCounter +!
      frameCounter @ 20 mod 0= if
         0 255 GetRandomValue 0 255 GetRandomValue 0 255 GetRandomValue 255 RGBA colRandom !
      then
      BeginDrawing
         RAYWHITE ClearBackground
         font z" This changes the [cFF0000FF]foreground color[r] of provided text!!!"
            100e 80e 20e 2e BLACK DrawTextStyled
         font z" This changes the [bFF00FFFF]background color[r] of provided text!!!"
            100e 120e 20e 2e BLACK DrawTextStyled
         font z" This changes the [c00ff00ff][bff0000ff]foreground and background colors[r]!!!"
            100e 160e 20e 2e BLACK DrawTextStyled
         font z" Let's be CREATIVE !!!" 100e 220e 40e 2e colRandom @ DrawTextStyled
         textSize font z" Let's be CREATIVE !!!" 40e 2e MeasureTextEx drop
         100 220 textSize sf@ f>s textSize 4 + sf@ f>s GREEN DrawRectangleLines
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
