\ Port of raylib examples/textures/textures_textured_curve.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE texRoad      20 ALLOT
CREATE curveStart    8 ALLOT
CREATE curveStartTan 8 ALLOT
CREATE curveEnd      8 ALLOT
CREATE curveEndTan   8 ALLOT
CREATE mdelta        8 ALLOT

\ Scratch buffers for DrawTexturedCurve geometry
CREATE _prev     8 ALLOT
CREATE _cur      8 ALLOT
CREATE _perp     8 ALLOT   \ (-delta.y, delta.x) before normalize
CREATE _norm     8 ALLOT   \ normalized normal
CREATE _prevTan  8 ALLOT   \ previousTangent
CREATE _ppn      8 ALLOT   \ prevPosNormal
CREATE _pnn      8 ALLOT   \ prevNegNormal
CREATE _cpn      8 ALLOT   \ currentPosNormal
CREATE _cnn      8 ALLOT   \ currentNegNormal

VARIABLE showCurve
FVARIABLE curveWidth
VARIABLE curveSegments
VARIABLE selected   \ 0=none 1=start 2=startTan 3=end 4=endTan
VARIABLE tangentSet

\ Bezier scratch FVARIABLEs
FVARIABLE _bt     \ bezier t
FVARIABLE _bu     \ 1 - t
FVARIABLE _ba     \ (1-t)^3
FVARIABLE _bb     \ 3*(1-t)^2*t
FVARIABLE _bc     \ 3*(1-t)*t^2
FVARIABLE _bd     \ t^3

\ DrawTexturedCurve state FVARIABLEs
FVARIABLE _step
FVARIABLE _prevV   \ accumulated arc length (previousV)
FVARIABLE _v       \ current segment end arc length
FVARIABLE _dx      \ delta.x for current segment
FVARIABLE _dy      \ delta.y for current segment
FVARIABLE _vs      \ scratch scalar for v2scale-into

: n>z ( n -- z ) dup 0< if abs 1 else 0 then >r 0 <# #s r> if [char] - hold then #> zres ;

: sel-pt ( -- a )
   selected @ dup 1 = if drop curveStart else
   dup 2 = if drop curveStartTan else
   dup 3 = if drop curveEnd else
   drop curveEndTan then then then ;

\ Compute bezier coefficients into _ba _bb _bc _bd given _bt _bu
: bezier-coeffs ( -- )
   _bu f@  fdup f*            \ u^2
   fdup _bu f@ f*  _ba f!     \ _ba = u^3
   _bt f@ f*  3e f*  _bb f!   \ _bb = 3*u^2*t
   _bu f@ _bt f@ f*           \ u*t
   _bt f@ f*  3e f*  _bc f!   \ _bc = 3*u*t^2
   _bt f@  fdup f*
   _bt f@ f*  _bd f!          \ _bd = t^3
;

\ Compute bezier point at current _bt into _cur
: bezier-point ( -- )
   _ba f@ curveStart v2x f*
   _bb f@ curveStartTan v2x f* f+
   _bc f@ curveEndTan v2x f* f+
   _bd f@ curveEnd v2x f* f+
   _ba f@ curveStart v2y f*
   _bb f@ curveStartTan v2y f* f+
   _bc f@ curveEndTan v2y f* f+
   _bd f@ curveEnd v2y f* f+
   _cur Vector2! ;

\ Compute Vector2Scale into dest: dest = src * scalar (scalar in _vs)
\ Stack: dest src; _vs must be set before calling
: v2scale-into ( dest src -- dest )
   dup v2x _vs f@ f*     \ F: src.x*s   stack: dest src
   dup v2y _vs f@ f*     \ F: src.x*s  src.y*s   stack: dest src
   drop                   \ F: src.x*s  src.y*s   stack: dest
   dup 4 + sf!            \ store src.y*s at dest+4 (top of fstack = sy)
   dup sf! ;              \ store src.x*s at dest (sx)

\ Draw the textured bezier curve ribbon using rlgl
: DrawTexturedCurve ( -- )
   curveSegments @ s>f 1e fswap f/  _step f!

   \ previous = curveStartPosition
   curveStart v2x  curveStart v2y  _prev Vector2!

   \ previousTangent = {0,0}, previousV = 0
   0e 0e _prevTan Vector2!
   0e _prevV f!
   0 tangentSet !

   curveSegments @ 1 do
      \ t = step * i
      _step f@ i s>f f*  _bt f!
      1e _bt f@ f-  _bu f!

      bezier-coeffs
      bezier-point

      \ delta = current - previous
      _cur v2x _prev v2x f-  _dx f!
      _cur v2y _prev v2y f-  _dy f!

      \ perp = { -delta.y, delta.x }
      _dy f@ fnegate  _dx f@
      _perp Vector2!

      \ norm = normalize(perp)
      _norm _perp Vector2Normalize drop

      \ v = previousV + length(delta)
      _dx f@ fdup f*  _dy f@ fdup f* f+  fsqrt  _prevV f@ f+  _v f!

      \ On first segment, set previousTangent = normal
      tangentSet @ 0= if
         _norm v2x  _norm v2y  _prevTan Vector2!
         1 tangentSet !
      then

      \ Compute quad corners
      \ prevPosNormal = previous + previousTangent * curveWidth
      curveWidth f@  _vs f!
      _ppn _prevTan v2scale-into drop
      _ppn v2x _prev v2x f+  _ppn v2y _prev v2y f+  _ppn Vector2!

      \ prevNegNormal = previous + previousTangent * -curveWidth
      curveWidth f@ fnegate  _vs f!
      _pnn _prevTan v2scale-into drop
      _pnn v2x _prev v2x f+  _pnn v2y _prev v2y f+  _pnn Vector2!

      \ currentPosNormal = current + normal * curveWidth
      curveWidth f@  _vs f!
      _cpn _norm v2scale-into drop
      _cpn v2x _cur v2x f+  _cpn v2y _cur v2y f+  _cpn Vector2!

      \ currentNegNormal = current + normal * -curveWidth
      curveWidth f@ fnegate  _vs f!
      _cnn _norm v2scale-into drop
      _cnn v2x _cur v2x f+  _cnn v2y _cur v2y f+  _cnn Vector2!

      \ Draw segment as a quad
      texRoad l@ rlSetTexture
      RL_QUADS rlBegin
         255 255 255 255 rlColor4ub
         0e 0e 1e rlNormal3f

         0e _prevV f@ rlTexCoord2f
         _pnn v2x _pnn v2y rlVertex2f

         1e _prevV f@ rlTexCoord2f
         _ppn v2x _ppn v2y rlVertex2f

         1e _v f@ rlTexCoord2f
         _cpn v2x _cpn v2y rlVertex2f

         0e _v f@ rlTexCoord2f
         _cnn v2x _cnn v2y rlVertex2f
      rlEnd
      0 rlSetTexture

      \ Advance state for next segment
      _cur v2x  _cur v2y  _prev Vector2!
      _norm v2x  _norm v2y  _prevTan Vector2!
      _v f@  _prevV f!
   loop ;

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
         DrawTexturedCurve
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
      EndDrawing
   WindowShouldClose until
   texRoad UnloadTexture
   CloseWindow ;

example-end
