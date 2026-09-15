\ Port of raylib examples/shapes/shapes_colors_palette.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
21 CONSTANT MAX_COLORS

CREATE colors MAX_COLORS CELLS ALLOT
CREATE names  MAX_COLORS CELLS ALLOT
CREATE recs   MAX_COLORS 16 * ALLOT
CREATE cstate MAX_COLORS CELLS ALLOT

: rec-i ( i -- a ) 16 * recs + ;

: init-palette
   DARKGRAY colors 0 cells + !  MAROON colors 1 cells + !  ORANGE colors 2 cells + !
   DARKGREEN colors 3 cells + !  DARKBLUE colors 4 cells + !  DARKPURPLE colors 5 cells + !
   DARKBROWN colors 6 cells + !  GRAY colors 7 cells + !  RED colors 8 cells + !
   GOLD colors 9 cells + !  LIME colors 10 cells + !  BLUE colors 11 cells + !
   VIOLET colors 12 cells + !  BROWN colors 13 cells + !  LIGHTGRAY colors 14 cells + !
   PINK colors 15 cells + !  YELLOW colors 16 cells + !  GREEN colors 17 cells + !
   SKYBLUE colors 18 cells + !  PURPLE colors 19 cells + !  BEIGE colors 20 cells + !
   z" DARKGRAY" names 0 cells + !  z" MAROON" names 1 cells + !  z" ORANGE" names 2 cells + !
   z" DARKGREEN" names 3 cells + !  z" DARKBLUE" names 4 cells + !  z" DARKPURPLE" names 5 cells + !
   z" DARKBROWN" names 6 cells + !  z" GRAY" names 7 cells + !  z" RED" names 8 cells + !
   z" GOLD" names 9 cells + !  z" LIME" names 10 cells + !  z" BLUE" names 11 cells + !
   z" VIOLET" names 12 cells + !  z" BROWN" names 13 cells + !  z" LIGHTGRAY" names 14 cells + !
   z" PINK" names 15 cells + !  z" YELLOW" names 16 cells + !  z" GREEN" names 17 cells + !
   z" SKYBLUE" names 18 cells + !  z" PURPLE" names 19 cells + !  z" BEIGE" names 20 cells + !
   MAX_COLORS 0 do
      20e 100e i 7 mod s>f f* f+ 10e i 7 mod s>f f* f+
      80e 100e i 7 / s>f f* f+ 10e i 7 / s>f f* f+
      100e 100e i rec-i Rectangle!
      0 i cells cstate + !
   loop ;

: example
   init-palette
   screenWidth screenHeight z" raylib [shapes] example - colors palette" InitWindow
   60 SetTargetFPS
   begin
      MAX_COLORS 0 do
         mouse@ i rec-i CheckCollisionPointRec if 1 else 0 then
         i cells cstate + !
      loop
      BeginDrawing
         RAYWHITE ClearBackground
         z" raylib colors palette" 28 42 20 BLACK DrawText
         z" press SPACE to see all colors" GetScreenWidth 180 - GetScreenHeight 40 - 10 GRAY DrawText
         MAX_COLORS 0 do
            i rec-i  colors i cells + @
            i cells cstate + @ if 0.6e else 1e then Fade DrawRectangleRec
            KEY_SPACE down  i cells cstate + @ or if
               i rec-i rec.x f>s  i rec-i rec.y i rec-i rec.h f+ 26e f- f>s
               i rec-i rec.w f>s 20 BLACK DrawRectangle
               i rec-i 6e BLACK 0.3e Fade DrawRectangleLinesEx
               names i cells + @
               i rec-i rec.x i rec-i rec.w f+  names i cells + @ 10 MeasureText s>f f- 12e f- f>s
               i rec-i rec.y i rec-i rec.h f+ 20e f- f>s
               10 colors i cells + @ DrawText
            then
         loop
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
