\ Port of raylib examples/shapes/shapes_rectangle_scaling.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
12 CONSTANT MARK

CREATE rec 16 ALLOT
CREATE mark 16 ALLOT
CREATE tri1 8 ALLOT
CREATE tri2 8 ALLOT
CREATE tri3 8 ALLOT
VARIABLE scaleReady
VARIABLE scaleMode

FVARIABLE (nw)  FVARIABLE (nh)
: rec-wh! ( F: w h -- )
   (nh) f! (nw) f!
   rec rec.x rec rec.y (nw) f@ (nh) f@ rec Rectangle! ;

: example
   screenWidth screenHeight z" raylib [shapes] example - rectangle scaling" InitWindow
   100e 100e 200e 80e rec Rectangle!
   false scaleReady !  false scaleMode !
   60 SetTargetFPS
   begin
      rec rec.x rec rec.w f+ MARK s>f f-
      rec rec.y rec rec.h f+ MARK s>f f-
      MARK s>f MARK s>f mark Rectangle!
      mouse@ mark CheckCollisionPointRec if
         true scaleReady !
         MOUSE_BUTTON_LEFT IsMouseButtonPressed if true scaleMode ! then
      else
         false scaleReady !
      then
      scaleMode @ if
         true scaleReady !
         mouse@ v2x rec rec.x f-  mouse@ v2y rec rec.y f-  rec-wh!
         rec rec.w MARK s>f f< if MARK s>f rec rec.h rec-wh! then
         rec rec.h MARK s>f f< if rec rec.w MARK s>f rec-wh! then
         rec rec.w GetScreenWidth s>f rec rec.x f- f> if
            GetScreenWidth s>f rec rec.x f- rec rec.h rec-wh! then
         rec rec.h GetScreenHeight s>f rec rec.y f- f> if
            rec rec.w GetScreenHeight s>f rec rec.y f- rec-wh! then
         MOUSE_BUTTON_LEFT IsMouseButtonReleased if false scaleMode ! then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         z" Scale rectangle dragging from bottom-right corner!" 10 10 20 GRAY DrawText
         rec GREEN 0.5e Fade DrawRectangleRec
         scaleReady @ if
            rec 1e RED DrawRectangleLinesEx
            rec rec.x rec rec.w f+ MARK s>f f-  rec rec.y rec rec.h f+  tri1 Vector2!
            rec rec.x rec rec.w f+  rec rec.y rec rec.h f+  tri2 Vector2!
            rec rec.x rec rec.w f+  rec rec.y rec rec.h f+ MARK s>f f-  tri3 Vector2!
            tri1 tri2 tri3 RED DrawTriangle
         then
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
