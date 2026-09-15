\ Port of raylib examples/shapes/shapes_double_pendulum.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
30 CONSTANT SIM_STEPS
9.81e fconstant GRAVITY

CREATE prevPos 8 ALLOT
CREATE curPos 8 ALLOT
CREATE ep1 8 ALLOT
CREATE target 48 ALLOT
CREATE rec 16 ALLOT
CREATE orig 8 ALLOT
CREATE src 16 ALLOT
FVARIABLE l1  FVARIABLE mass1  FVARIABLE th1  FVARIABLE w1
FVARIABLE l2  FVARIABLE mass2  FVARIABLE th2  FVARIABLE w2
FVARIABLE L1s FVARIABLE L2s
FVARIABLE totalM
FVARIABLE step  FVARIABLE step2
FVARIABLE a1  FVARIABLE a2
FVARIABLE sinD  FVARIABLE cosD  FVARIABLE cos2D
20e fconstant lineThick
2e fconstant trailThick
0.01e fconstant fateAlpha

: pend-end ( dest F: l th -- )
   fover 10e f* fover fsin f*
   frot 10e f* frot fcos f*
   Vector2! ;

: dpend-end
   ep1 l1 f@ th1 f@ pend-end
   curPos l2 f@ th2 f@ pend-end
   ep1 v2x curPos v2x f+  ep1 v2y curPos v2y f+ curPos Vector2! ;

: sim-step
   th1 f@ th2 f@ f- fdup fsin sinD f! fdup fcos cosD f! 2e f* fcos cos2D f!
   GRAVITY fnegate 2e mass1 f@ f* mass2 f@ f+ f* th1 f@ fsin f*
   mass2 f@ GRAVITY f* th1 f@ 2e th2 f@ f* f- fsin f* f-
   2e sinD f@ f* mass2 f@ f*  w2 f@ fdup f* L2s f@ f*  w1 f@ fdup f* L1s f@ f* cosD f@ f* f+  f* f-
   L1s f@  2e mass1 f@ f* mass2 f@ f+ mass2 f@ cos2D f@ f* f- f*  f/
   a1 f!
   2e sinD f@ f*
   w1 f@ fdup f* L1s f@ f* totalM f@ f*
   GRAVITY totalM f@ f* th1 f@ fcos f* f+
   w2 f@ fdup f* L2s f@ f* mass2 f@ f* cosD f@ f* f+  f*
   L2s f@  2e mass1 f@ f* mass2 f@ f+ mass2 f@ cos2D f@ f* f- f*  f/
   a2 f!
   th1 f@ w1 f@ step f@ f* f+ a1 f@ 0.5e f* step2 f@ f* f+ th1 f!
   th2 f@ w2 f@ step f@ f* f+ a2 f@ 0.5e f* step2 f@ f* f+ th2 f!
   w1 f@ a1 f@ step f@ f* f+ w1 f!
   w2 f@ a2 f@ step f@ f* f+ w2 f! ;

: example
   FLAG_WINDOW_HIGHDPI SetConfigFlags
   screenWidth screenHeight z" raylib [shapes] example - double pendulum" InitWindow
   15e l1 f!  0.2e mass1 f!  170e deg>rad th1 f!  0e w1 f!
   15e l2 f!  0.1e mass2 f!  0e th2 f!  0e w2 f!
   l1 f@ 0.1e f* L1s f!
   l2 f@ 0.1e f* L2s f!
   mass1 f@ mass2 f@ f+ totalM f!
   dpend-end
   curPos v2x screenWidth 2/ s>f f+
   curPos v2y screenHeight 2/ s>f 100e f- f+ prevPos Vector2!
   target screenWidth screenHeight LoadRenderTexture drop
   target rtex TEXTURE_FILTER_BILINEAR SetTextureFilter
   60 SetTargetFPS
   begin
      GetFrameTime SIM_STEPS s>f f/ step f!
      step f@ fdup f* step2 f!
      SIM_STEPS 0 do sim-step loop
      dpend-end
      curPos v2x screenWidth 2/ s>f f+
      curPos v2y screenHeight 2/ s>f 100e f- f+ curPos Vector2!
      target BeginTextureMode
         0 0 screenWidth screenHeight BLACK fateAlpha Fade DrawRectangle
         prevPos trailThick RED DrawCircleV
         prevPos curPos trailThick 2e f* RED DrawLineEx
      EndTextureMode
      curPos prevPos 8 move
      BeginDrawing
         BLACK ClearBackground
         target rtex  target src flip-rt  origin2 WHITE DrawTextureRec
         screenWidth 2/ s>f  screenHeight 2/ s>f 100e f-
         10e l1 f@ f*  lineThick rec Rectangle!
         0e lineThick 0.5e f* orig Vector2!
         rec orig 90e th1 f@ rad>deg f- RAYWHITE DrawRectanglePro
         ep1 l1 f@ th1 f@ pend-end
         screenWidth 2/ s>f ep1 v2x f+  screenHeight 2/ s>f 100e f- ep1 v2y f+
         10e l2 f@ f*  lineThick rec Rectangle!
         rec orig 90e th2 f@ rad>deg f- RAYWHITE DrawRectanglePro
      EndDrawing
   WindowShouldClose until
   target UnloadRenderTexture
   CloseWindow ;

example-end
