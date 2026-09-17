\ Port of raylib examples/shapes/shapes_rectangle_advanced.c
\ DrawRectangleRoundedGradientH implemented with rlBegin(RL_TRIANGLES)

800 CONSTANT screenWidth
450 CONSTANT screenHeight

CREATE rec 16 ALLOT

\ Point buffer: 12 Vector2 = 8 bytes each = 96 bytes
CREATE pt 96 ALLOT

\ Emit the 4 color components from a packed ABGR color via rlColor4ub
: emit-color ( color -- )
   >r  r@ .red  r@ .green  r@ .blue  r> .alpha  rlColor4ub ;

\ Accessors into pt[] array (each entry is 8 bytes: x float, y float)
: pt.x ( n -- ) ( F: -- x )  8 * pt + sf@ ;
: pt.y ( n -- ) ( F: -- y )  8 * pt + 4 + sf@ ;
: pt! ( n F: x y -- )  8 * pt + Vector2! ;

\ Emit rlVertex2f from pt[n]: load x then y, emit vertex
: vpt ( n -- )
   8 * pt +  dup sf@  4 + sf@  rlVertex2f ;

\ -------------------------------------------------------------------------
\ DrawRectangleRoundedGradientH
\ Stack:  rec segs left right  (with F: roundnessLeft roundnessRight)
\ -------------------------------------------------------------------------

FVARIABLE (rrx)   FVARIABLE (rry)
FVARIABLE (rrw)   FVARIABLE (rrh)
FVARIABLE (rnL)   FVARIABLE (rnR)
FVARIABLE (rL)    FVARIABLE (rR)
FVARIABLE (rstep)
FVARIABLE (rang)
FVARIABLE (rcx)   FVARIABLE (rcy)
FVARIABLE (rcr)
VARIABLE  (rsegs)
VARIABLE  (lcolor)
VARIABLE  (rcolor)
VARIABLE  (kcolor)   \ current corner color

\ Emit one arc triangle for the current corner
: arc-tri ( -- )
   (kcolor) @ emit-color
   (rcx) f@  (rcy) f@  rlVertex2f
   (rang) f@ (rstep) f@ f+ deg>rad fcos (rcr) f@ f* (rcx) f@ f+
   (rang) f@ (rstep) f@ f+ deg>rad fsin (rcr) f@ f* (rcy) f@ f+
   rlVertex2f
   (rang) f@ deg>rad fcos (rcr) f@ f* (rcx) f@ f+
   (rang) f@ deg>rad fsin (rcr) f@ f* (rcy) f@ f+
   rlVertex2f
   (rstep) f@ (rang) f@ f+ (rang) f! ;

\ Draw one corner arc: center=pt[ctr], start angle, color, radius
: draw-corner ( ctr F: start-angle -- )
   (rang) f!
   dup pt.x (rcx) f!
   pt.y    (rcy) f!
   (rsegs) @ 0 do  arc-tri  loop ;

: DrawRectangleRoundedGradientH ( rec segs left right F: roundL roundR -- )
   (rcolor) !  (lcolor) !  (rsegs) !
   (rnR) f!    (rnL) f!
   locals| rec |

   \ Load rectangle fields
   rec sf@       (rrx) f!
   rec 4 + sf@   (rry) f!
   rec 8 + sf@   (rrw) f!
   rec 12 + sf@  (rrh) f!

   \ Degenerate: both roundness <= 0 or rect too small -> plain gradient
   (rnL) f@ f0<= (rnR) f@ f0<= and
   (rrw) f@ 1e f< or
   (rrh) f@ 1e f< or
   if
      rec  (lcolor) @  (lcolor) @  (rcolor) @  (rcolor) @
      DrawRectangleGradientEx  exit
   then

   \ Clamp roundness to [0,1]
   (rnL) f@ 1e f> if 1e (rnL) f! then
   (rnR) f@ 1e f> if 1e (rnR) f! then

   \ Corner radii = recSize * roundness / 2  (recSize = min(w,h))
   (rrw) f@ (rrh) f@ fmin
   fdup (rnL) f@ f* 2e f/ (rL) f!
        (rnR) f@ f* 2e f/ (rR) f!

   (rL) f@ f0<= if 0e (rL) f! then
   (rR) f@ f0<= if 0e (rR) f! then
   (rL) f@ f0<= (rR) f@ f0<= and if exit then

   \ stepLength = 90 / segments
   90e (rsegs) @ s>f f/ (rstep) f!

   \ Compute the 12 reference points (see C code diagram)
   (rrx) f@ (rL) f@ f+                   (rry) f@                         0 pt!
   (rrx) f@ (rrw) f@ f+ (rR) f@ f-       (rry) f@                         1 pt!
   (rrx) f@ (rrw) f@ f+                  (rry) f@ (rR) f@ f+              2 pt!
   (rrx) f@ (rrw) f@ f+                  (rry) f@ (rrh) f@ f+ (rR) f@ f- 3 pt!
   (rrx) f@ (rrw) f@ f+ (rR) f@ f-       (rry) f@ (rrh) f@ f+            4 pt!
   (rrx) f@ (rL) f@ f+                   (rry) f@ (rrh) f@ f+            5 pt!
   (rrx) f@                               (rry) f@ (rrh) f@ f+ (rL) f@ f- 6 pt!
   (rrx) f@                               (rry) f@ (rL) f@ f+             7 pt!
   (rrx) f@ (rL) f@ f+                   (rry) f@ (rL) f@ f+             8 pt!
   (rrx) f@ (rrw) f@ f+ (rR) f@ f-       (rry) f@ (rR) f@ f+             9 pt!
   (rrx) f@ (rrw) f@ f+ (rR) f@ f-       (rry) f@ (rrh) f@ f+ (rR) f@ f- 10 pt!
   (rrx) f@ (rL) f@ f+                   (rry) f@ (rrh) f@ f+ (rL) f@ f- 11 pt!

   RL_TRIANGLES rlBegin

   \ Corner arcs: k=0 UL (P8, 180, left/rL), k=1 UR (P9, 270, right/rR)
   \              k=2 LR (P10, 0, right/rR), k=3 LL (P11, 90, left/rL)
   (lcolor) @ (kcolor) !  (rL) f@ (rcr) f!  8  180e draw-corner
   (rcolor) @ (kcolor) !  (rR) f@ (rcr) f!  9  270e draw-corner
   (rcolor) @ (kcolor) !  (rR) f@ (rcr) f!  10   0e draw-corner
   (lcolor) @ (kcolor) !  (rL) f@ (rcr) f!  11  90e draw-corner

   \ [2] Upper Rectangle: gradient left(P0,P8) -> right(P9,P1)
   (lcolor) @ emit-color   0 vpt   8 vpt
   (rcolor) @ emit-color   9 vpt
   (rcolor) @ emit-color   1 vpt
   (lcolor) @ emit-color   0 vpt
   (rcolor) @ emit-color   9 vpt

   \ [4] Right Rectangle: all right color (P9,P10,P3) (P2,P9,P3)
   (rcolor) @ emit-color
   9 vpt  10 vpt  3 vpt
   2 vpt   9 vpt  3 vpt

   \ [6] Bottom Rectangle: gradient left(P11,P5) -> right(P4,P10)
   (lcolor) @ emit-color  11 vpt   5 vpt
   (rcolor) @ emit-color   4 vpt
   (rcolor) @ emit-color  10 vpt
   (lcolor) @ emit-color  11 vpt
   (rcolor) @ emit-color   4 vpt

   \ [8] Left Rectangle: all left color (P7,P6,P11) (P8,P7,P11)
   (lcolor) @ emit-color
   7 vpt   6 vpt  11 vpt
   8 vpt   7 vpt  11 vpt

   \ [9] Middle Rectangle: gradient left(P8,P11) -> right(P10,P9)
   (lcolor) @ emit-color   8 vpt  11 vpt
   (rcolor) @ emit-color  10 vpt
   (rcolor) @ emit-color   9 vpt
   (lcolor) @ emit-color   8 vpt
   (rcolor) @ emit-color  10 vpt

   rlEnd ;

\ Advance rec.y by rec.h + 1, keeping x, w, h unchanged
: rec-next-row ( -- )
   rec rec.x  rec rec.y rec rec.h f+ 1e f+  rec rec.w  rec rec.h  rec Rectangle! ;

: example
   screenWidth screenHeight z" raylib [shapes] example - rectangle advanced" InitWindow
   60 SetTargetFPS
   begin
      \ width  = GetScreenWidth  / 2
      \ height = GetScreenHeight / 6
      \ x      = GetScreenWidth  / 4
      \ y      = GetScreenHeight / 2 - 5 * (height / 2)
      GetScreenWidth  s>f 4e f/
      GetScreenHeight s>f 2e f/  GetScreenHeight s>f 12e f/ 5e f* f-
      GetScreenWidth  s>f 2e f/
      GetScreenHeight s>f 6e f/
      rec Rectangle!

      BeginDrawing
         RAYWHITE ClearBackground
         rec 0.8e 0.8e 36 BLUE  RED   DrawRectangleRoundedGradientH  rec-next-row
         rec 0.5e 1e   36 RED   PINK  DrawRectangleRoundedGradientH  rec-next-row
         rec 1e   0.5e 36 RED   BLUE  DrawRectangleRoundedGradientH  rec-next-row
         rec 0e   1e   36 BLUE  BLACK DrawRectangleRoundedGradientH  rec-next-row
         rec 1e   0e   36 BLUE  PINK  DrawRectangleRoundedGradientH
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
