\ Port of raylib examples/shapes/shapes_logo_raylib_anim.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

VARIABLE logoX
VARIABLE logoY
VARIABLE frames
VARIABLE letters
VARIABLE topW
VARIABLE leftH
VARIABLE botW
VARIABLE rightH
VARIABLE state
FVARIABLE alpha
CREATE raytxt 8 ALLOT

: reset-logo
   0 frames !  0 letters !
   16 topW !  16 leftH !  16 botW !  16 rightH !
   1e alpha f!  0 state ! ;

: set-letters ( -- )
   s" raylib" raytxt swap move
   raytxt 6 + 0 swap c!
   letters @ 6 min raytxt + 0 swap c! ;

: example
   screenWidth 2/ 128 - logoX !
   screenHeight 2/ 128 - logoY !
   reset-logo
   screenWidth screenHeight z" raylib [shapes] example - logo raylib anim" InitWindow
   60 SetTargetFPS
   begin
      state @ 0 = if
         1 frames +!
         frames @ 120 = if 1 state ! 0 frames ! then
      else state @ 1 = if
         4 topW +!  4 leftH +!
         topW @ 256 = if 2 state ! then
      else state @ 2 = if
         4 botW +!  4 rightH +!
         botW @ 256 = if 3 state ! then
      else state @ 3 = if
         1 frames +!
         frames @ 12 / if 1 letters +! 0 frames ! then
         letters @ 10 >= if
            alpha f@ 0.02e f- alpha f!
            alpha f@ f0<= if 0e alpha f! 4 state ! then
         then
      else
         KEY_R IsKeyPressed if reset-logo then
      then then then then
      BeginDrawing
         RAYWHITE ClearBackground
         state @ 0 = if
            frames @ 15 / 2 mod if
               logoX @ logoY @ 16 16 BLACK DrawRectangle
            then
         else state @ 1 = if
            logoX @ logoY @ topW @ 16 BLACK DrawRectangle
            logoX @ logoY @ 16 leftH @ BLACK DrawRectangle
         else state @ 2 = if
            logoX @ logoY @ topW @ 16 BLACK DrawRectangle
            logoX @ logoY @ 16 leftH @ BLACK DrawRectangle
            logoX @ 240 + logoY @ 16 rightH @ BLACK DrawRectangle
            logoX @ logoY @ 240 + botW @ 16 BLACK DrawRectangle
         else state @ 3 = if
            logoX @ logoY @ topW @ 16 BLACK alpha f@ Fade DrawRectangle
            logoX @ logoY @ 16 + 16 leftH @ 32 - BLACK alpha f@ Fade DrawRectangle
            logoX @ 240 + logoY @ 16 + 16 rightH @ 32 - BLACK alpha f@ Fade DrawRectangle
            logoX @ logoY @ 240 + botW @ 16 BLACK alpha f@ Fade DrawRectangle
            GetScreenWidth 2/ 112 - GetScreenHeight 2/ 112 - 224 224 RAYWHITE alpha f@ Fade DrawRectangle
            set-letters
            raytxt GetScreenWidth 2/ 44 - GetScreenHeight 2/ 48 + 50 BLACK alpha f@ Fade DrawText
         else
            z" [R] REPLAY" 340 200 20 GRAY DrawText
         then then then then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
