\ Port of raylib examples/textures/textures_textured_curve.c
\ Partial: no rlgl ribbon; draws cubic bezier spline, handles, and road texture.

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE texRoad 32 ALLOT
CREATE curveStart 16 ALLOT
CREATE curveStartTan 16 ALLOT
CREATE curveEnd 16 ALLOT
CREATE curveEndTan 16 ALLOT
CREATE mdelta 16 ALLOT
CREATE tsz 16 ALLOT
VARIABLE showCurve
FVARIABLE curveWidth
VARIABLE curveSegments
VARIABLE selected   \ 0=none 1=start 2=startTan 3=end 4=endTan

: n>z ( n -- z ) dup 0< if abs 1 else 0 then >r 0 <# #s r> if [char] - hold then #> zres ;

: sel-pt ( -- a )
   selected @ dup 1 = if drop curveStart else
   dup 2 = if drop curveStartTan else
   dup 3 = if drop curveEnd else
   drop curveEndTan then then then ;

: example
   FLAG_VSYNC_HINT FLAG_MSAA_4X_HINT or SetConfigFlags
   screenWidth screenHeight z" raylib [textures] example - textured curve" InitWindow
   texRoad z" /home/dave/Code/raylib/examples/textures/resources/road.png" LoadTexture drop
   texRoad TEXTURE_FILTER_BILINEAR SetTextureFilter
   80e 100e curveStart Vector2!
   100e 300e curveStartTan Vector2!
   700e 350e curveEnd Vector2!
   600e 100e curveEndTan Vector2!
   0 showCurve !
   50e curveWidth f!
   24 curveSegments !
   0 selected !
   60 SetTargetFPS
   begin
      KEY_SPACE IsKeyPressed if showCurve @ 0= showCurve ! then
      KEY_EQUAL IsKeyPressed if curveWidth f@ 2e f+ curveWidth f! then
      KEY_MINUS IsKeyPressed if curveWidth f@ 2e f- curveWidth f! then
      curveWidth f@ 2e f< if 2e curveWidth f! then
      KEY_LEFT  IsKeyPressed if curveSegments @ 2 - curveSegments ! then
      KEY_RIGHT IsKeyPressed if curveSegments @ 2 + curveSegments ! then
      curveSegments @ 2 < if 2 curveSegments ! then
      MOUSE_LEFT_BUTTON IsMouseButtonDown 0= if 0 selected ! then
      selected @ if
         mdelta GetMouseDelta drop
         sel-pt dup mdelta Vector2Add drop
      then
      mouse@ curveStart 6e CheckCollisionPointCircle if 1 selected ! else
      mouse@ curveStartTan 6e CheckCollisionPointCircle if 2 selected ! else
      mouse@ curveEnd 6e CheckCollisionPointCircle if 3 selected ! else
      mouse@ curveEndTan 6e CheckCollisionPointCircle if 4 selected ! else
      then then then then
      BeginDrawing
         RAYWHITE ClearBackground
         \ Road sprite at the start as a stand-in for the textured ribbon
         texRoad curveStart v2x f>s curveStart v2y f>s WHITE DrawTexture
         curveStart curveEnd curveStartTan curveEndTan 2e BLUE DrawSplineSegmentBezierCubic
         showCurve @ if
            curveStart curveEnd curveStartTan curveEndTan 2e BLUE DrawSplineSegmentBezierCubic
         then
         curveStart curveStartTan SKYBLUE DrawLineV
         curveStartTan curveEndTan LIGHTGRAY 0.4e Fade DrawLineV
         curveEnd curveEndTan PURPLE DrawLineV
         mouse@ curveStart 6e CheckCollisionPointCircle if curveStart 7e YELLOW DrawCircleV then
         curveStart 5e RED DrawCircleV
         mouse@ curveStartTan 6e CheckCollisionPointCircle if curveStartTan 7e YELLOW DrawCircleV then
         curveStartTan 5e MAROON DrawCircleV
         mouse@ curveEnd 6e CheckCollisionPointCircle if curveEnd 7e YELLOW DrawCircleV then
         curveEnd 5e GREEN DrawCircleV
         mouse@ curveEndTan 6e CheckCollisionPointCircle if curveEndTan 7e YELLOW DrawCircleV then
         curveEndTan 5e DARKGREEN DrawCircleV
         z" Drag points to move curve, press SPACE to show/hide base curve" 10 10 10 DARKGRAY DrawText
         z" Curve width: " 10 30 10 DARKGRAY DrawText
         curveWidth f@ f>s n>z 100 30 10 DARKGRAY DrawText
         z" Curve segments: " 10 50 10 DARKGRAY DrawText
         curveSegments @ n>z 120 50 10 DARKGRAY DrawText
         z" Partial: rlgl textured ribbon not bound" 10 screenHeight 20 - 10 MAROON DrawText
      EndDrawing
   WindowShouldClose until
   texRoad UnloadTexture
   CloseWindow ;

example-end
