\ Port of raylib examples/shapes/shapes_following_eyes.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE scleraL 8 ALLOT
CREATE scleraR 8 ALLOT
CREATE irisL 8 ALLOT
CREATE irisR 8 ALLOT
80e fconstant scleraR0
24e fconstant irisR0
FVARIABLE (ang)

: clamp-iris ( iris sclera -- )
   locals| sclera iris |
   iris sclera scleraR0 irisR0 f- CheckCollisionPointCircle if exit then
   iris v2y sclera v2y f-  iris v2x sclera v2x f- fatan2 (ang) f!
   sclera v2x (ang) f@ fcos scleraR0 irisR0 f- f* f+
   sclera v2y (ang) f@ fsin scleraR0 irisR0 f- f* f+
   iris Vector2! ;

: example
   screenWidth screenHeight z" raylib [shapes] example - following eyes" InitWindow
   GetScreenWidth 2/ s>f 100e f- GetScreenHeight 2/ s>f scleraL Vector2!
   GetScreenWidth 2/ s>f 100e f+ GetScreenHeight 2/ s>f scleraR Vector2!
   scleraL irisL 8 move
   scleraR irisR 8 move
   60 SetTargetFPS
   begin
      mouse@ irisL 8 move
      mouse@ irisR 8 move
      irisL scleraL clamp-iris
      irisR scleraR clamp-iris
      BeginDrawing
         RAYWHITE ClearBackground
         scleraL scleraR0 LIGHTGRAY DrawCircleV
         irisL irisR0 BROWN DrawCircleV
         irisL 10e BLACK DrawCircleV
         scleraR scleraR0 LIGHTGRAY DrawCircleV
         irisR irisR0 DARKGREEN DrawCircleV
         irisR 10e BLACK DrawCircleV
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
