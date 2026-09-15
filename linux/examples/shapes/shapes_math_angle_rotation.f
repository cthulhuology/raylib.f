\ Port of raylib examples/shapes/shapes_math_angle_rotation.c

720 CONSTANT screenWidth
400 CONSTANT screenHeight

CREATE center 8 ALLOT
150e fconstant lineLen
CREATE angles 4 CELLS ALLOT
CREATE endv 8 ALLOT
CREATE textv 8 ALLOT
FVARIABLE totalAngle

: angle-col ( i -- u )
   dup 0 = if drop GREEN else
   dup 1 = if drop ORANGE else
   dup 2 = if drop BLUE else
              drop MAGENTA then then then ;

: example
   screenWidth screenHeight z" raylib [shapes] example - math angle rotation" InitWindow
   60 SetTargetFPS
   screenWidth 2/ s>f screenHeight 2/ s>f center Vector2!
   0 angles 0 cells + !  30 angles 1 cells + !
   60 angles 2 cells + !  90 angles 3 cells + !
   0e totalAngle f!
   begin
      totalAngle f@ 1e f+ fdup 360e f>= if 360e f- then totalAngle f!
      BeginDrawing
         WHITE ClearBackground
         z" Fixed angles + rotating line" 10 10 20 LIGHTGRAY DrawText
         4 0 do
            angles i cells + @ s>f deg>rad
            fdup fcos lineLen f* center v2x f+
            fswap fsin lineLen f* center v2y f+ endv Vector2!
            center endv 5e i angle-col DrawLineEx
            angles i cells + @ s>f deg>rad
            fdup fcos lineLen 20e f+ f* center v2x f+
            fswap fsin lineLen 20e f+ f* center v2y f+ textv Vector2!
            angles i cells + @ zint textv v2x f>s textv v2y f>s 20 i angle-col DrawText
         loop
         totalAngle f@ deg>rad
         fdup fcos lineLen f* center v2x f+
         fswap fsin lineLen f* center v2y f+ endv Vector2!
         center endv 5e totalAngle f@ 0e 360e Wrap 0.8e 0.9e ColorFromHSV DrawLineEx
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
