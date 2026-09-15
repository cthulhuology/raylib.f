\ Port of raylib examples/textures/textures_bunnymark.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
50000 CONSTANT MAX_BUNNIES
8192 CONSTANT MAX_BATCH_ELEMENTS

\ Bunny: pos(8) speed(8) color(4) pad(4) = 24
24 CONSTANT /bunny
CREATE texBunny 32 ALLOT
VARIABLE bunnies
VARIABLE bunniesCount

: b[] ( i -- a ) /bunny * bunnies @ + ;
: bpos ( a -- a ) ;
: bspd ( a -- a ) 8 + ;
: bcol ( a -- a ) 16 + ;

: n>z ( n -- z ) dup 0< if abs 1 else 0 then >r 0 <# #s r> if [char] - hold then #> zres ;

: example
   screenWidth screenHeight z" raylib [textures] example - bunnymark" InitWindow
   texBunny z" /home/dave/Code/raylib/examples/textures/resources/wabbit_alpha.png" LoadTexture drop
   MAX_BUNNIES /bunny * MemAlloc bunnies !
   0 bunniesCount !
   60 SetTargetFPS
   begin
      MOUSE_BUTTON_LEFT IsMouseButtonDown if
         100 0 do
            bunniesCount @ MAX_BUNNIES < if
               bunniesCount @ b[] >r
               mouse@ r@ bpos 8 move
               -250 250 GetRandomValue s>f 60e f/  -250 250 GetRandomValue s>f 60e f/  r@ bspd Vector2!
               50 240 GetRandomValue 80 240 GetRandomValue 100 240 GetRandomValue 255 RGBA r@ bcol l!
               r> drop
               1 bunniesCount +!
            then
         loop
      then
      bunniesCount @ 0 ?do
         i b[] >r
         r@ bpos v2x r@ bspd v2x f+  r@ bpos v2y r@ bspd v2y f+  r@ bpos Vector2!
         r@ bpos v2x texBunny texture_width l@ 2/ s>f f+ GetScreenWidth s>f f>
         r@ bpos v2x texBunny texture_width l@ 2/ s>f f+ f0< or if
            r@ bspd v2x fnegate r@ bspd v2y r@ bspd Vector2!
         then
         r@ bpos v2y texBunny texture_height l@ 2/ s>f f+ GetScreenHeight s>f f>
         r@ bpos v2y texBunny texture_height l@ 2/ s>f f+ 40e f- f0< or if
            r@ bspd v2x r@ bspd v2y fnegate r@ bspd Vector2!
         then
         r> drop
      loop
      BeginDrawing
         RAYWHITE ClearBackground
         bunniesCount @ 0 ?do
            texBunny  i b[] bpos v2x f>s  i b[] bpos v2y f>s  i b[] bcol l@ DrawTexture
         loop
         0 0 screenWidth 40 BLACK DrawRectangle
         z" bunnies: " 120 10 20 GREEN DrawText
         bunniesCount @ n>z 220 10 20 GREEN DrawText
         z" batched draw calls: " 320 10 20 MAROON DrawText
         1 bunniesCount @ MAX_BATCH_ELEMENTS / + n>z 530 10 20 MAROON DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   bunnies @ MemFree
   texBunny UnloadTexture
   CloseWindow ;

example-end
