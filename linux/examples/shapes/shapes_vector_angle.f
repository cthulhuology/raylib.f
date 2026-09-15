\ Port of raylib examples/shapes/shapes_vector_angle.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE v0 8 ALLOT
CREATE v1 8 ALLOT
CREATE v2 8 ALLOT
CREATE v1n 8 ALLOT
CREATE v2n 8 ALLOT
CREATE tmp 8 ALLOT
FVARIABLE angle
FVARIABLE startang
VARIABLE angleMode

: example
   screenWidth screenHeight z" raylib [shapes] example - vector angle" InitWindow
   screenWidth 2/ s>f screenHeight 2/ s>f v0 Vector2!
   100e 80e v2a Vector2!
   v1 v0 v2a Vector2Add drop
   0e angle f!  0 angleMode !
   60 SetTargetFPS
   begin
      angleMode @ 0 = if
         v0 v1 Vector2LineAngle rad>deg fnegate startang f!
      else 0e startang f! then
      mouse@ v2 8 move
      KEY_SPACE IsKeyPressed if angleMode @ 0= angleMode ! then
      angleMode @ 0 = MOUSE_BUTTON_RIGHT IsMouseButtonDown and if
         mouse@ v1 8 move then
      angleMode @ 0 = if
         tmp v1 v0 Vector2Subtract v1n swap Vector2Normalize drop
         tmp v2 v0 Vector2Subtract v2n swap Vector2Normalize drop
         v1n v2n Vector2Angle rad>deg angle f!
      else
         v0 v2 Vector2LineAngle rad>deg angle f!
      then
      BeginDrawing
         RAYWHITE ClearBackground
         angleMode @ 0 = if
            z" MODE 0: Angle between V1 and V2" 10 10 20 BLACK DrawText
            z" Right Click to Move V2" 10 30 20 DARKGRAY DrawText
            v0 v1 2e BLACK DrawLineEx
            v0 v2 2e RED DrawLineEx
            v0 40e startang f@ startang f@ angle f@ f+ 32 GREEN 0.6e Fade DrawCircleSector
         else
            z" MODE 1: Angle formed by line V1 to V2" 10 10 20 BLACK DrawText
            0 screenHeight 2/ screenWidth screenHeight 2/ LIGHTGRAY DrawLine
            v0 v2 2e RED DrawLineEx
            v0 40e startang f@ startang f@ angle f@ f- 32 GREEN 0.6e Fade DrawCircleSector
         then
         z" v0" v0 v2x f>s v0 v2y f>s 10 DARKGRAY DrawText
         angleMode @ 0 = if
            tmp v0 v1 Vector2Subtract drop
            tmp v2y f0> if
               z" v1" v1 v2x f>s v1 v2y f>s 10 - 10 DARKGRAY DrawText
            else
               z" v1" v1 v2x f>s v1 v2y f>s 10 DARKGRAY DrawText
            then
         then
         angleMode @ if
            z" v1" v0 v2x f>s 40 + v0 v2y f>s 10 DARKGRAY DrawText
         then
         z" v2" v2 v2x f>s 10 - v2 v2y f>s 10 - 10 DARKGRAY DrawText
         z" Press SPACE to change MODE" 460 10 20 DARKGRAY DrawText
         z" ANGLE:" 10 70 20 LIME DrawText
         angle f@ zf2 90 70 20 LIME DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
