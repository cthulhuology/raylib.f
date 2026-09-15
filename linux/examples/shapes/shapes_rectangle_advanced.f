\ Port of raylib examples/shapes/shapes_rectangle_advanced.c
\ rlgl custom gradient-rounded rect approximated with
\ DrawRectangleGradientH plus DrawRectangleRounded.

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE rec 16 ALLOT
FVARIABLE rH

: row-grad ( F: roundL roundR  left right -- )
   locals| left right |
   rec rec.x f>s rec rec.y f>s rec rec.w f>s rec rec.h f>s left right DrawRectangleGradientH
   rec fover fover fmax 36 left 0.25e Fade DrawRectangleRounded
   rec rec.x rec rec.y rec rec.h f+ 1e f+ rec rec.w rec rec.h rec Rectangle!
   fdrop fdrop ;

: example
   screenWidth screenHeight z" raylib [shapes] example - rectangle advanced" InitWindow
   60 SetTargetFPS
   begin
      GetScreenHeight 6 / s>f rH f!
      GetScreenWidth 4 / s>f
      GetScreenHeight 2/ s>f rH f@ 2.5e f* f-
      GetScreenWidth 2/ s>f rH f@ rec Rectangle!
      BeginDrawing
         RAYWHITE ClearBackground
         0.8e 0.8e BLUE RED row-grad
         0.5e 1e RED PINK row-grad
         1e 0.5e RED BLUE row-grad
         0e 1e BLUE BLACK row-grad
         1e 0e BLUE PINK row-grad
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
