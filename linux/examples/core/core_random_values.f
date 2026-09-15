\ Port of raylib examples/core/core_random_values.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE randValue
VARIABLE framesCounter

CREATE nbuf 64 ALLOT
: n>z ( n -- zaddr )
   dup abs s>d <# #s rot sign #> nbuf swap 2dup + 0 swap c! move nbuf ;

: example
   screenWidth screenHeight z" raylib [core] example - random values" InitWindow
   -8 5 GetRandomValue randValue !
   0 framesCounter !
   60 SetTargetFPS
   begin
      1 framesCounter +!
      framesCounter @ 120 / 2 mod 1 = if
         -8 5 GetRandomValue randValue !
         0 framesCounter !
      then
      BeginDrawing
         RAYWHITE ClearBackground
         z" Every 2 seconds a new random value is generated:" 130 100 20 MAROON DrawText
         randValue @ n>z 360 180 80 LIGHTGRAY DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
