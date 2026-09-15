\ Port of raylib examples/shapes/shapes_starfield_effect.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
420 CONSTANT STAR_COUNT

CREATE stars STAR_COUNT 12 * ALLOT
CREATE spos STAR_COUNT 8 * ALLOT
FVARIABLE speed
VARIABLE drawLines
VARIABLE bgColor
CREATE startP 8 ALLOT

: star ( i -- a ) 12 * stars + ;
: sp ( i -- a ) 8 * spos + ;

: rand-star ( i -- )
   star >r
   screenWidth 2/ negate screenWidth 2/ GetRandomValue s>f
   screenHeight 2/ negate screenHeight 2/ GetRandomValue s>f
   1e r> Vector3! ;

: example
   screenWidth screenHeight z" raylib [shapes] example - starfield effect" InitWindow
   DARKBLUE BLACK 0.69e ColorLerp bgColor !
   10e 9e f/ speed f!
   true drawLines !
   STAR_COUNT 0 do i rand-star loop
   60 SetTargetFPS
   begin
      GetMouseWheelMove fdup f0= 0= if 2e f* 9e f/ speed f@ f+ speed f! else fdrop then
      speed f@ f0< if 0.1e speed f! then
      speed f@ 2e f> if 2e speed f! then
      KEY_SPACE IsKeyPressed if drawLines @ 0= drawLines ! then
      GetFrameTime
      STAR_COUNT 0 do
         i star v3z fover speed f@ f* f- i star 8 + sf!
         screenWidth 2/ s>f i star v3x i star v3z f/ f+
         screenHeight 2/ s>f i star v3y i star v3z f/ f+
         i sp Vector2!
         i star v3z f0<
         i sp v2x f0< or  i sp v2y f0< or
         i sp v2x screenWidth s>f f> or  i sp v2y screenHeight s>f f> or
         if i rand-star then
      loop
      fdrop
      BeginDrawing
         bgColor @ ClearBackground
         STAR_COUNT 0 do
            drawLines @ if
               i star v3z 1e 32e f/ f+ 0e 1e ClampF
               fdup i star v3z f- 0.001e f> if
                  screenWidth 2/ s>f i star v3x fover f/ f+
                  screenHeight 2/ s>f i star v3y frot f/ f+
                  startP Vector2!
                  startP i sp RAYWHITE DrawLineV
               else fdrop then
            else
               i star v3z 1e 5e Lerp
               i sp RAYWHITE DrawCircleV
            then
         loop
         z" [MOUSE WHEEL] Current Speed:" 10 40 20 RAYWHITE DrawText
         9e speed f@ f* 2e f/ zf0 340 40 20 RAYWHITE DrawText
         drawLines @ if z" [SPACE] Current draw mode: Lines" else z" [SPACE] Current draw mode: Circles" then
         10 70 20 RAYWHITE DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
