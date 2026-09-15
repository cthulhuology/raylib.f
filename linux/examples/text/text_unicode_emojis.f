\ Port of raylib examples/text/text_unicode_emojis.c
\ Partial: emoji BMFont + CJK/default fonts; simplified chat bubble (no full boxed wrap).

800 CONSTANT screenWidth
450 CONSTANT screenHeight
8 CONSTANT EMOJI_PER_WIDTH
4 CONSTANT EMOJI_PER_HEIGHT
32 CONSTANT #EMOJI

CREATE fontDefault 64 ALLOT
CREATE fontAsian 64 ALLOT
CREATE fontEmoji 64 ALLOT
CREATE hoveredPos 16 ALLOT
CREATE selectedPos 16 ALLOT
CREATE position 16 ALLOT
CREATE emojiRect 16 ALLOT
CREATE msgRect 16 ALLOT
CREATE tsz 16 ALLOT
CREATE a 16 ALLOT
CREATE b 16 ALLOT
CREATE c 16 ALLOT
CREATE textRect 16 ALLOT

\ emoji records: index(cell) message(cell) color(cell) = 24
24 CONSTANT /emo
CREATE emoji #EMOJI /emo * ALLOT
VARIABLE hovered
VARIABLE selected

: Rec! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: e[] ( i -- a ) /emo * emoji + ;
: eidx ( a -- a ) ;
: emsg ( a -- a ) cell+ ;
: ecol ( a -- a ) 2 cells + ;

\ 4-byte emoji samples (UTF-8) plus trailing 0 stored in a small table
CREATE emojiGlyphs
$F0 c, $9F c, $98 c, $80 c, 0 c,  \ grinning
$F0 c, $9F c, $98 c, $82 c, 0 c,
$F0 c, $9F c, $98 c, $8D c, 0 c,
$F0 c, $9F c, $98 c, $8E c, 0 c,
$F0 c, $9F c, $98 c, $B1 c, 0 c,
$F0 c, $9F c, $98 c, $A2 c, 0 c,
$F0 c, $9F c, $8D c, $95 c, 0 c,
$F0 c, $9F c, $8D c, $A6 c, 0 c,
$F0 c, $9F c, $92 c, $96 c, 0 c,
$F0 c, $9F c, $8C c, $9F c, 0 c,
$F0 c, $9F c, $8E c, $89 c, 0 c,
$F0 c, $9F c, $90 c, $B1 c, 0 c,
$F0 c, $9F c, $9A c, $80 c, 0 c,
$E2 c, $9D c, $A4 c, $00 c, 0 c,
$F0 c, $9F c, $8E c, $AE c, 0 c,
$F0 c, $9F c, $8E c, $B8 c, 0 c,

16 CONSTANT #GLYPHS
: glyph[] ( i -- z ) 5 * emojiGlyphs + ;

: msg[] ( i -- z )
   dup 0 = if drop z" Falsches Ueben von Xylophonmusik quaelt jeden groesseren Zwerg" else
   dup 1 = if drop z" raylib is a simple and easy-to-use library to enjoy videogames programming" else
   dup 2 = if drop z" Voix ambigue d'un coeur qui au zephyr prefere les jattes de kiwi" else
   dup 3 = if drop z" Benjamin pidio una bebida de kiwi y fresa" else
   drop z" Hello from a unicode emoji!"
   then then then then ;

: lang[] ( i -- z )
   dup 0 = if drop z" German" else
   dup 1 = if drop z" English" else
   dup 2 = if drop z" French" else
   dup 3 = if drop z" Spanish" else
   drop z" Emoji"
   then then then then ;

: RandomizeEmoji ( -- )
   -1 hovered !  -1 selected !
   45 360 GetRandomValue
   #EMOJI 0 do
      0 #GLYPHS 1- GetRandomValue i e[] eidx !
      0 4 GetRandomValue i e[] emsg !
      dup i 1+ * 360 mod s>f 0.6e 0.85e ColorFromHSV 0.8e Fade i e[] ecol !
   loop drop ;

: example
   FLAG_MSAA_4X_HINT FLAG_VSYNC_HINT or SetConfigFlags
   screenWidth screenHeight z" raylib [text] example - unicode emojis" InitWindow
   fontDefault z" /home/dave/Code/raylib/examples/text/resources/dejavu.fnt" LoadFont drop
   fontAsian z" /home/dave/Code/raylib/examples/text/resources/noto_cjk.fnt" LoadFont drop
   fontEmoji z" /home/dave/Code/raylib/examples/text/resources/symbola.fnt" LoadFont drop
   0e 0e hoveredPos Vector2!
   0e 0e selectedPos Vector2!
   RandomizeEmoji
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if RandomizeEmoji then
      MOUSE_BUTTON_LEFT IsMouseButtonPressed hovered @ -1 <> and hovered @ selected @ <> and if
         hovered @ selected !
         hoveredPos selectedPos 8 move
      then
      28.8e 10e position Vector2!
      -1 hovered !
      BeginDrawing
         RAYWHITE ClearBackground
         #EMOJI 0 do
            position v2x position v2y fontEmoji font_baseSize l@ s>f fdup emojiRect Rec!
            mouse@ emojiRect CheckCollisionPointRec 0= if
               fontEmoji i e[] eidx @ glyph[] position fontEmoji font_baseSize l@ s>f 1e
               selected @ i = if i e[] ecol @ else LIGHTGRAY 0.4e Fade then DrawTextEx
            else
               fontEmoji i e[] eidx @ glyph[] position fontEmoji font_baseSize l@ s>f 1e i e[] ecol @ DrawTextEx
               i hovered !
               position hoveredPos 8 move
            then
            i 0<> i EMOJI_PER_WIDTH mod 0= and if
               28.8e  position v2y fontEmoji font_baseSize l@ s>f f+ 24.25e f+  position Vector2!
            else
               position v2x fontEmoji font_baseSize l@ s>f f+ 28.8e f+  position v2y position Vector2!
            then
         loop
         selected @ -1 <> if
            selected @ e[] emsg @ >r
            tsz fontDefault r@ msg[] fontDefault font_baseSize l@ s>f 1e MeasureTextEx drop
            tsz sf@ 300e f> if tsz 4 + sf@ tsz sf@ 300e f/ f* tsz 4 + sf!  300e tsz sf! then
            tsz sf@ 160e f< if 160e tsz sf! then
            selectedPos v2x 38.8e f-  selectedPos v2y
            40e tsz sf@ f+  60e tsz 4 + sf@ f+  msgRect Rec!
            msgRect 12 + sf@ fnegate msgRect 4 + sf@ f+ msgRect 4 + sf!
            msgRect selected @ e[] ecol @ DrawRectangleRec
            fontDefault r> msg[]
            msgRect sf@ 10e f+ msgRect 4 + sf@ 15e f+ position Vector2!
            position fontDefault font_baseSize l@ s>f 1e WHITE DrawTextEx
            selected @ e[] emsg @ lang[]
            msgRect sf@ f>s 10 +  msgRect 4 + sf@ msgRect 12 + sf@ f+ f>s 18 -  10 RAYWHITE DrawText
         then
         z" These emojis have something to tell you, click each to find out!"
            screenWidth 650 - 2/ screenHeight 40 - 20 GRAY DrawText
         z" Each emoji is a unicode character from a font, not a texture... Press [SPACEBAR] to refresh"
            screenWidth 484 - 2/ screenHeight 16 - 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   fontDefault UnloadFont
   fontAsian UnloadFont
   fontEmoji UnloadFont
   CloseWindow ;

example-end
