\ Port of raylib examples/shapes/shapes_simple_particles.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
3000 CONSTANT MAXP
0 CONSTANT WATER
1 CONSTANT SMOKE
2 CONSTANT FIRE

\ Particle: type(8) pos(8) vel(8) radius(4) pad(4) color(8) life(4) pad(4) alive(8) = 56
56 CONSTANT /P
CREATE particles MAXP /P * ALLOT
VARIABLE head
VARIABLE tail
VARIABLE emissionRate
VARIABLE currentType
CREATE emitter 8 ALLOT
FVARIABLE (spd)

: p ( i -- a ) /P * particles + ;
: p.type ( a -- a ) ;
: p.pos ( a -- a ) 8 + ;
: p.vel ( a -- a ) 16 + ;
: p.rad ( a -- a ) 24 + ;
: p.col ( a -- a ) 32 + ;
: p.life ( a -- a ) 40 + ;
: p.alive ( a -- a ) 48 + ;

: add-particle ( -- a | 0 )
   head @ 1+ MAXP mod tail @ = if 0 else
      head @ p
      head @ 1+ MAXP mod head !
   then ;

: emit ( -- )
   add-particle dup 0= if drop exit then
   >r
   r@ p.pos emitter 8 move
   true r@ p.alive !
   0e r@ p.life sf!
   currentType @ r@ p.type !
   0 9 GetRandomValue s>f 5e f/ (spd) f!
   currentType @ WATER = if
      5e r@ p.rad sf!  BLUE r@ p.col !
   else currentType @ SMOKE = if
      7e r@ p.rad sf!  GRAY r@ p.col !
   else
      10e r@ p.rad sf!  YELLOW r@ p.col !  (spd) f@ 10e f/ (spd) f!
   then then
   0 359 GetRandomValue s>f deg>rad
   fdup fcos (spd) f@ f*  fswap fsin (spd) f@ f*
   r@ p.vel Vector2!
   r> drop ;

: update-particles
   tail @
   begin dup head @ <> while
      dup p >r
      r@ p.life sf@ 1e 60e f/ f+ r@ p.life sf!
      r@ p.type @ WATER = if
         r@ p.pos v2x r@ p.vel v2x f+ r@ p.pos sf!
         r@ p.vel v2y 0.2e f+ r@ p.vel 4 + sf!
         r@ p.pos v2y r@ p.vel v2y f+ r@ p.pos 4 + sf!
      else r@ p.type @ SMOKE = if
         r@ p.pos v2x r@ p.vel v2x f+ r@ p.pos sf!
         r@ p.vel v2y 0.05e f- r@ p.vel 4 + sf!
         r@ p.pos v2y r@ p.vel v2y f+ r@ p.pos 4 + sf!
         r@ p.rad sf@ 0.5e f+ r@ p.rad sf!
         r@ p.col @ dup 24 rshift $ff and 4 - dup 4 < if
            drop false r@ p.alive !
         else
            $ff and 24 lshift swap $00ffffff and or r@ p.col !
         then
      else
         r@ p.pos v2x r@ p.vel v2x f+ r@ p.life sf@ 215e f* fcos f+ r@ p.pos sf!
         r@ p.vel v2y 0.05e f- r@ p.vel 4 + sf!
         r@ p.pos v2y r@ p.vel v2y f+ r@ p.pos 4 + sf!
         r@ p.rad sf@ 0.15e f- r@ p.rad sf!
         r@ p.col @ dup 8 rshift $ff and 3 - 0 max
         8 lshift swap $ffff00ff and or r@ p.col !
         r@ p.rad sf@ 0.02e f<= if false r@ p.alive ! then
      then then
      r@ p.pos v2x r@ p.rad sf@ fnegate f<
      r@ p.pos v2x screenWidth s>f r@ p.rad sf@ f+ f> or
      r@ p.pos v2y r@ p.rad sf@ fnegate f< or
      r@ p.pos v2y screenHeight s>f r@ p.rad sf@ f+ f> or
      if false r@ p.alive ! then
      r> drop
      1+ MAXP mod
   repeat drop
   begin tail @ head @ <>  tail @ p p.alive @ 0=  and while
      tail @ 1+ MAXP mod tail !
   repeat ;

: draw-particles
   tail @
   begin dup head @ <> while
      dup p p.alive @ if
         dup p p.pos  over p p.rad sf@  2 pick p p.col @ DrawCircleV
      then
      1+ MAXP mod
   repeat drop ;

: example
   screenWidth screenHeight z" raylib [shapes] example - simple particles" InitWindow
   particles MAXP /P * erase
   0 head !  0 tail !
   -2 emissionRate !  WATER currentType !
   screenWidth 2/ s>f screenHeight 2/ s>f emitter Vector2!
   60 SetTargetFPS
   begin
      emissionRate @ 0< if
         0 emissionRate @ negate GetRandomValue 0= if emit then
      else
         emissionRate @ 1+ 0 do emit loop
      then
      update-particles
      KEY_UP IsKeyPressed if 1 emissionRate +! then
      KEY_DOWN IsKeyPressed if -1 emissionRate +! then
      KEY_RIGHT IsKeyPressed if currentType @ FIRE = if WATER else currentType @ 1+ then currentType ! then
      KEY_LEFT IsKeyPressed if currentType @ WATER = if FIRE else currentType @ 1- then currentType ! then
      MOUSE_BUTTON_LEFT IsMouseButtonDown if mouse@ emitter 8 move then
      BeginDrawing
         RAYWHITE ClearBackground
         draw-particles
         5 5 315 75 SKYBLUE 0.5e Fade DrawRectangle
         5 5 315 75 BLUE DrawRectangleLines
         z" CONTROLS:" 15 15 10 BLACK DrawText
         z" UP/DOWN: Change Particle Emission Rate" 15 35 10 BLACK DrawText
         z" LEFT/RIGHT: Change Particle Type (Water, Smoke, Fire)" 15 55 10 BLACK DrawText
         emissionRate @ 0< if
            z" Particles every N frames | Type:" 15 95 10 DARKGRAY DrawText
            emissionRate @ negate zint 130 95 10 DARKGRAY DrawText
         else
            z" N Particles per frame | Type:" 15 95 10 DARKGRAY DrawText
            emissionRate @ 1+ zint 20 95 10 DARKGRAY DrawText
         then
         currentType @ WATER = if z" WATER" else currentType @ SMOKE = if z" SMOKE" else z" FIRE" then then
         280 95 10 DARKGRAY DrawText
         screenWidth 80 - 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
