\ Port of raylib examples/shapes/shapes_digital_clock.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
0 CONSTANT CLOCK_ANALOG
1 CONSTANT CLOCK_DIGITAL

VARIABLE clockMode
VARIABLE secV  VARIABLE minV  VARIABLE hourV
FVARIABLE secA  FVARIABLE minA  FVARIABLE hourA
140 CONSTANT secLen  3 CONSTANT secTh
130 CONSTANT minLen  7 CONSTANT minTh
100 CONSTANT hourLen 7 CONSTANT hourTh
CREATE pos 8 ALLOT
CREATE orig 8 ALLOT
CREATE rec 16 ALLOT
VARIABLE dcol

: update-clock
   time&date drop drop drop  hourV ! minV ! secV !
   hourV @ 12 mod s>f 180e f* 6e f/
   minV @ 60 mod s>f 30e f* 60e f/ f+  90e f- hourA f!
   minV @ 60 mod s>f 6e f*
   secV @ 60 mod s>f 6e f* 60e f/ f+  90e f- minA f!
   secV @ 60 mod s>f 6e f* 90e f- secA f! ;

: draw-analog
   400e 240e pos Vector2!
   pos secLen s>f 40e f+ LIGHTGRAY DrawCircleV
   pos 12e GRAY DrawCircleV
   60 0 do
      pos v2x secLen s>f i 5 mod if 10e else 6e then f+
         6e i s>f f* 90e f- deg>rad fcos f* f+
      pos v2y secLen s>f i 5 mod if 10e else 6e then f+
         6e i s>f f* 90e f- deg>rad fsin f* f+
      v2a Vector2!
      pos v2x secLen 20 + s>f  6e i s>f f* 90e f- deg>rad fcos f* f+
      pos v2y secLen 20 + s>f  6e i s>f f* 90e f- deg>rad fsin f* f+
      v2b Vector2!
      v2a v2b i 5 mod if 1e else 3e then DARKGRAY DrawLineEx
   loop
   pos v2x pos v2y secLen s>f secTh s>f rec Rectangle!
   0e secTh 2/ s>f orig Vector2!
   rec orig secA f@ MAROON DrawRectanglePro
   pos v2x pos v2y minLen s>f minTh s>f rec Rectangle!
   0e minTh 2/ s>f orig Vector2!
   rec orig minA f@ DARKGRAY DrawRectanglePro
   pos v2x pos v2y hourLen s>f hourTh s>f rec Rectangle!
   0e hourTh 2/ s>f orig Vector2!
   rec orig hourA f@ BLACK DrawRectanglePro ;

: digit-bits ( n -- mask )
   dup 0 = if drop $3f else
   dup 1 = if drop $06 else
   dup 2 = if drop $5b else
   dup 3 = if drop $4f else
   dup 4 = if drop $66 else
   dup 5 = if drop $6d else
   dup 6 = if drop $7d else
   dup 7 = if drop $07 else
   dup 8 = if drop $7f else
              drop $6f then then then then then then then then then ;

: rect7 ( x y w h bit -- )
   if dcol @ else LIGHTGRAY 0.3e Fade then DrawRectangle ;

: draw-digit-at ( x y n -- )
   RED dcol !
   digit-bits >r
   2dup 20 + swap 20 + swap 60 20 r@ 1 and rect7
   2dup 80 + swap 40 + swap 20 60 r@ 2 and rect7
   2dup 80 + swap 140 + swap 20 60 r@ 4 and rect7
   2dup 20 + swap 200 + swap 60 20 r@ 8 and rect7
   2dup swap 140 + swap 20 60 r@ 16 and rect7
   2dup swap 40 + swap 20 60 r@ 32 and rect7
   2dup 20 + swap 120 + swap 60 20 r@ 64 and rect7
   2drop r> drop ;

: blink-col ( -- u )
   secV @ 2 mod if RED else LIGHTGRAY 0.3e Fade then ;

: draw-digital
   30 60 hourV @ 10 / draw-digit-at
   150 60 hourV @ 10 mod draw-digit-at
   270 130 12 blink-col DrawCircle
   270 210 12 blink-col DrawCircle
   290 60 minV @ 10 / draw-digit-at
   410 60 minV @ 10 mod draw-digit-at
   530 130 12 blink-col DrawCircle
   530 210 12 blink-col DrawCircle
   550 60 secV @ 10 / draw-digit-at
   670 60 secV @ 10 mod draw-digit-at ;

: hhmmss ( -- zaddr )
   hourV @ 10 / [char] 0 + pad c!
   hourV @ 10 mod [char] 0 + pad 1+ c!
   [char] : pad 2 + c!
   minV @ 10 / [char] 0 + pad 3 + c!
   minV @ 10 mod [char] 0 + pad 4 + c!
   [char] : pad 5 + c!
   secV @ 10 / [char] 0 + pad 6 + c!
   secV @ 10 mod [char] 0 + pad 7 + c!
   0 pad 8 + c!  pad ;

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shapes] example - digital clock" InitWindow
   CLOCK_DIGITAL clockMode !
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if
         clockMode @ CLOCK_DIGITAL = if CLOCK_ANALOG else CLOCK_DIGITAL then clockMode !
      then
      update-clock
      BeginDrawing
         RAYWHITE ClearBackground
         clockMode @ CLOCK_ANALOG = if draw-analog
         else
            draw-digital
            hhmmss dup 150 MeasureText GetScreenWidth swap - 2/ 300 150 BLACK DrawText
         then
         clockMode @ CLOCK_DIGITAL = if
            z" Press [SPACE] to switch clock mode: DIGITAL CLOCK" 10 10 20 DARKGRAY DrawText
         else
            z" Press [SPACE] to switch clock mode: ANALOGUE CLOCK" 10 10 20 DARKGRAY DrawText
         then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
