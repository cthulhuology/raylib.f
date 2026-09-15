\ Port of raylib examples/others/easings_testbed.c
\ Subset of reasings.h: linear, sine, cubic, quad.

800 CONSTANT screenWidth
450 CONSTANT screenHeight
20 CONSTANT FONT_SIZE

CREATE ball 8 ALLOT
CREATE t 4 ALLOT
CREATE dur 4 ALLOT
VARIABLE paused
VARIABLE boundedT
VARIABLE easingX
VARIABLE easingY

\ t b c d -- r    (all floats)
: EaseLinear ( F: t b c d -- r ) fswap f/ f* f+ ;
: EaseSineIn ( F: t b c d -- r )
   fswap f/ RPI 2e f/ f* fcos fnegate 1e f+ f* f+ ;
: EaseSineOut ( F: t b c d -- r )
   fswap f/ RPI 2e f/ f* fsin f* f+ ;
: EaseCubicIn ( F: t b c d -- r )
   fswap f/ fdup fdup f* f* f* f+ ;
: EaseCubicOut ( F: t b c d -- r )
   fswap f/ 1e f- fdup fdup f* f* 1e f+ f* f+ ;
: EaseQuadIn ( F: t b c d -- r )
   fswap f/ fdup f* f* f+ ;
: EaseQuadOut ( F: t b c d -- r )
   fswap f/ fdup 2e fswap f- f* f* f+ ;
: NoEase ( F: t b c d -- r ) fdrop fdrop fswap fdrop ;

0 CONSTANT E_NONE
1 CONSTANT E_LINEAR
2 CONSTANT E_SINEIN
3 CONSTANT E_SINEOUT
4 CONSTANT E_CUBICIN
5 CONSTANT E_CUBICOUT
6 CONSTANT E_QUADIN
7 CONSTANT E_QUADOUT
8 CONSTANT NUM_E

: ease-name ( i -- z )
   dup 0 = if drop z" None" else
   dup 1 = if drop z" EaseLinear" else
   dup 2 = if drop z" EaseSineIn" else
   dup 3 = if drop z" EaseSineOut" else
   dup 4 = if drop z" EaseCubicIn" else
   dup 5 = if drop z" EaseCubicOut" else
   dup 6 = if drop z" EaseQuadIn" else
              drop z" EaseQuadOut" then then then then then then then ;

: do-ease ( i F: t b c d -- r )
   >r
   r@ 0 = if NoEase else
   r@ 1 = if EaseLinear else
   r@ 2 = if EaseSineIn else
   r@ 3 = if EaseSineOut else
   r@ 4 = if EaseCubicIn else
   r@ 5 = if EaseCubicOut else
   r@ 6 = if EaseQuadIn else
             EaseQuadOut then then then then then then then
   r> drop ;

: example
   100e 100e ball Vector2!
   0e t sf!  300e dur sf!
   true paused !  true boundedT !
   E_NONE easingX !  E_NONE easingY !
   screenWidth screenHeight z" raylib [others] example - easings testbed" InitWindow
   60 SetTargetFPS
   begin
      KEY_T IsKeyPressed if boundedT @ 0= boundedT ! then
      KEY_RIGHT IsKeyPressed if easingX @ 1+ NUM_E mod easingX ! then
      KEY_LEFT IsKeyPressed if easingX @ NUM_E + 1- NUM_E mod easingX ! then
      KEY_DOWN IsKeyPressed if easingY @ 1+ NUM_E mod easingY ! then
      KEY_UP IsKeyPressed if easingY @ NUM_E + 1- NUM_E mod easingY ! then
      KEY_W IsKeyPressed if dur sf@ 20e f+ 10000e fmin dur sf! then
      KEY_Q IsKeyPressed if dur sf@ 20e f- 1e fmax dur sf! then
      KEY_ENTER IsKeyPressed if paused @ 0= paused ! then
      KEY_SPACE IsKeyPressed if
         0e t sf!  100e 100e ball Vector2!  true paused !
      then
      paused @ 0= if
         boundedT @ 0=  t sf@ dur sf@ f< or if
            t sf@ 100e 530e dur sf@ easingX @ do-ease
            t sf@ 100e 230e dur sf@ easingY @ do-ease
            ball Vector2!
            t sf@ 1e f+ t sf!
         then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         easingX @ ease-name 20 FONT_SIZE FONT_SIZE LIGHTGRAY DrawText
         easingY @ ease-name 20 FONT_SIZE 2 * FONT_SIZE LIGHTGRAY DrawText
         z" SPACE reset  ENTER play/pause  arrows choose easing" 20 FONT_SIZE 3 * 10 GRAY DrawText
         ball 30e MAROON DrawCircleV
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
