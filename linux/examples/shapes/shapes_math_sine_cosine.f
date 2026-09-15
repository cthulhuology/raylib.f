\ Port of raylib examples/shapes/shapes_math_sine_cosine.c
\ raygui widgets replaced with SPACE pause and auto-rotating angle

800 CONSTANT screenWidth
450 CONSTANT screenHeight
36 CONSTANT WAVE_POINTS

CREATE sinePts WAVE_POINTS 8 * ALLOT
CREATE cosPts WAVE_POINTS 8 * ALLOT
CREATE center 8 ALLOT
CREATE startR 16 ALLOT
CREATE point 8 ALLOT
CREATE p0 8 ALLOT
CREATE p1 8 ALLOT
FVARIABLE radius
FVARIABLE angle
VARIABLE pause
218 218 218 255 RGBA CONSTANT PANEL_LINE
232 232 232 255 RGBA CONSTANT PANEL_BG

: wp ( base i -- a ) 8 * + ;

: example
   FLAG_MSAA_4X_HINT SetConfigFlags
   screenWidth screenHeight z" raylib [shapes] example - math sine cosine" InitWindow
   screenWidth 2/ s>f 30e f- screenHeight 2/ s>f center Vector2!
   20e screenHeight 120 - s>f 200e 100e startR Rectangle!
   130e radius f!  0e angle f!  false pause !
   WAVE_POINTS 0 do
      i s>f WAVE_POINTS 1- s>f f/ 
      fdup 360e f* deg>rad
      startR rec.x fover startR rec.w f* f+
      startR rec.y startR rec.h 2e f/ f+ fover fsin startR rec.h 2e f/ f* f-
      sinePts i wp Vector2!
      startR rec.x fover startR rec.w f* f+
      startR rec.y startR rec.h 2e f/ f+ fover fcos startR rec.h 2e f/ f* f-
      cosPts i wp Vector2!
      fdrop fdrop
   loop
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if pause @ 0= pause ! then
      angle f@ pause @ 0= if 1e f+ then 0e 360e Wrap angle f!
      angle f@ deg>rad
      fdup fcos radius f@ f* center v2x f+
      fover fsin radius f@ f* fnegate center v2y f+
      point Vector2!
      fdrop
      BeginDrawing
         RAYWHITE ClearBackground
         580 0 580 GetScreenHeight PANEL_LINE DrawLine
         580 0 GetScreenWidth GetScreenHeight PANEL_BG DrawRectangle
         center radius f@ GRAY DrawCircleLinesV
         center v2x center v2y radius f@ f- p0 Vector2!
         center v2x center v2y radius f@ f+ p1 Vector2!
         p0 p1 1e GRAY DrawLineEx
         center v2x radius f@ f- center v2y p0 Vector2!
         center v2x radius f@ f+ center v2y p1 Vector2!
         p0 p1 1e GRAY DrawLineEx
         sinePts WAVE_POINTS 1e RED DrawSplineLinear
         cosPts WAVE_POINTS 1e BLUE DrawSplineLinear
         center v2x center v2y p0 Vector2!
         center v2x point v2y p1 Vector2!
         p0 p1 2e RED DrawLineEx
         center v2x center v2y p0 Vector2!
         point v2x center v2y p1 Vector2!
         p0 p1 2e BLUE DrawLineEx
         center point 2e BLACK DrawLineEx
         point 4e BLACK DrawCircleV
         center radius f@ 0.7e f* angle f@ fnegate 0e 36 LIME DrawCircleSectorLines
         z" SPACE pause" 640 70 10 DARKGRAY DrawText
         z" Angle" 640 40 10 LIME DrawText
         angle f@ zf0 700 40 10 LIME DrawText
         z" Sine" 640 190 10 RED DrawText
         angle f@ deg>rad fsin zf2 700 190 10 RED DrawText
         z" Cosine" 640 210 10 BLUE DrawText
         angle f@ deg>rad fcos zf2 700 210 10 BLUE DrawText
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
