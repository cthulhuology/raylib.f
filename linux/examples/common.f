\ common.f -- shared include for raylib Forth examples
\
\ Each example defines example ( -- ).  If EXAMPLE-NO-RUN is defined
\ before including the example, example is not executed (compile check).

only forth also definitions
include /home/dave/forth/raylib.f/linux/raylib.f
/raylib
include /home/dave/forth/raylib.f/linux/raymath.f

WARNING OFF

\ GLFW/raylib leaves the terminal in raw mode on Linux.  There is no
\ raylib restore call; stty sane on the real tty after CloseWindow.
' CloseWindow CONSTANT 'rl-CloseWindow
: restore-tty ( -- )
   s" stty sane < /dev/tty 2>/dev/null" >SHELL DROP ;
: CloseWindow ( -- )
   'rl-CloseWindow execute  restore-tty ;

\ v2x/v2y consume the vector address; re-fetch src for each component.
: Vector2Rotate ( dest src F: ang -- dest )
   locals| src dest |
   fdup fcos (rc) sf!  fsin (rs) sf!
   src v2x (rc) sf@ f*  src v2y (rs) sf@ f* f-
   src v2y (rc) sf@ f*  src v2x (rs) sf@ f* f+
   dest Vector2!
   dest ;

\ raymath ClampF leaves an extra float; max(lo, min(v, hi)).
: ClampF ( F: v lo hi -- v )
   frot fswap fmin fmax ;

: f0<= ( F: r -- flag )  0e f<= ;
: f0>= ( F: r -- flag )  0e f>= ;
: f2/  ( F: r -- r/2 )  2e f/ ;
: f2*  ( F: r -- r*2 )  2e f* ;

3.141592653589793e fconstant RPI
RPI fconstant pi
: deg>rad ( F: d -- r ) RPI f* 180e f/ ;
: rad>deg ( F: r -- d ) 180e f* RPI f/ ;

: zres ( c-addr u -- zaddr )
   pad swap 2dup + >r move r> 0 swap c!  pad ;

CREATE v2a  16 ALLOT
CREATE v2b  16 ALLOT
CREATE v2c  16 ALLOT
CREATE v2d  16 ALLOT
CREATE v3a  16 ALLOT
CREATE v3b  16 ALLOT
CREATE v3c  16 ALLOT
CREATE v3d  16 ALLOT
CREATE reca 16 ALLOT
CREATE recb 16 ALLOT
CREATE mouse 16 ALLOT
CREATE ival  8 ALLOT
CREATE fval  8 ALLOT
CREATE fvec2 8 ALLOT
CREATE fvec3 16 ALLOT
CREATE fvec4 16 ALLOT
CREATE origin2 8 ALLOT
0e 0e origin2 Vector2!

: mouse@ ( -- addr )
   mouse GetMousePosition drop  mouse ;

: Rectangle! ( addr F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: rec.x ( a -- ) ( F: -- x )  sf@ ;
: rec.y ( a -- ) ( F: -- y )  4 + sf@ ;
: rec.w ( a -- ) ( F: -- w )  8 + sf@ ;
: rec.h ( a -- ) ( F: -- h )  12 + sf@ ;

: Vector4! ( addr F: x y z w -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: tex.w ( tex -- n ) 4 + l@ ;
: tex.h ( tex -- n ) 8 + l@ ;
: img.w ( img -- n ) 8 + l@ ;
: img.h ( img -- n ) 12 + l@ ;
: rtex ( rt -- tex ) 4 + ;
: rtex.w ( rt -- n ) 8 + l@ ;
: rtex.h ( rt -- n ) 12 + l@ ;

: mdl.meshCount ( mdl -- n ) 64 + l@ ;
: mdl.materialCount ( mdl -- n ) 68 + l@ ;
: mdl.meshes ( mdl -- a ) 72 + @ ;
: mdl.materials ( mdl -- a ) 80 + @ ;
: mdl.boneCount ( mdl -- n ) 96 + l@ ;
: mdl.bones ( mdl -- a ) 104 + @ ;
: mdl.bindPose ( mdl -- a ) 112 + @ ;
: mesh[] ( mdl i -- a ) swap mdl.meshes swap 120 * + ;
: material[] ( mdl i -- a ) swap mdl.materials swap 40 * + ;

: set-diffuse ( mdl tex -- )
   swap mdl.materials MATERIAL_MAP_DIFFUSE rot SetMaterialTexture ;

: set-mat-shader ( mdl shd -- )
   swap mdl.materials 16 move ;

: shd.locs ( shd -- a ) 8 + @ ;
: shd-loc! ( loc shd idx -- ) swap shd.locs swap 4 * + l! ;
: shd-loc@ ( shd idx -- loc ) swap shd.locs swap 4 * + l@ ;

: set-fval ( F: n -- addr ) fval sf!  fval ;
: set-ival ( n -- addr ) ival l!  ival ;

: flip-rt ( rt rec -- rec )
   0e 0e  2 pick rtex.w s>f  2 pick rtex.h s>f fnegate
   over Rectangle!  nip ;

: MatrixIdentity ( m -- m )
   dup 64 erase  1e dup sf!  1e dup 20 + sf!  1e dup 40 + sf!  1e dup 60 + sf! ;

: MatrixTranslate! ( m F: x y z -- m )
   dup MatrixIdentity drop
   dup 56 + sf!  dup 52 + sf!  dup 48 + sf! ;

CREATE (mx) 4 ALLOT  CREATE (my) 4 ALLOT  CREATE (mz) 4 ALLOT
CREATE (cx) 4 ALLOT  CREATE (sx) 4 ALLOT
CREATE (cy) 4 ALLOT  CREATE (sy) 4 ALLOT
CREATE (cz) 4 ALLOT  CREATE (sz) 4 ALLOT

\ Column-major MatrixRotateXYZ, matching raymath (angles in radians).
: MatrixRotateXYZ ( m F: ax ay az -- m )
   fnegate (mz) sf!  fnegate (my) sf!  fnegate (mx) sf!
   (mx) sf@ fdup fcos (cx) sf! fsin (sx) sf!
   (my) sf@ fdup fcos (cy) sf! fsin (sy) sf!
   (mz) sf@ fdup fcos (cz) sf! fsin (sz) sf!
   dup 64 erase
   (cz) sf@ (cy) sf@ f*  dup sf!
   (cz) sf@ (sy) sf@ f* (sx) sf@ f*  (sz) sf@ (cx) sf@ f* f-  dup 4 + sf!
   (cz) sf@ (sy) sf@ f* (cx) sf@ f*  (sz) sf@ (sx) sf@ f* f+  dup 8 + sf!
   (sz) sf@ (cy) sf@ f*  dup 16 + sf!
   (sz) sf@ (sy) sf@ f* (sx) sf@ f*  (cz) sf@ (cx) sf@ f* f+  dup 20 + sf!
   (sz) sf@ (sy) sf@ f* (cx) sf@ f*  (cz) sf@ (sx) sf@ f* f-  dup 24 + sf!
   (sy) sf@ fnegate  dup 32 + sf!
   (cy) sf@ (sx) sf@ f*  dup 36 + sf!
   (cy) sf@ (cx) sf@ f*  dup 40 + sf!
   1e dup 60 + sf! ;

\ ---- simplified rlights (max 4) ----
4 CONSTANT MAX_LIGHTS
0 CONSTANT LIGHT_DIRECTIONAL
1 CONSTANT LIGHT_POINT
VARIABLE #lights
56 CONSTANT /LIGHT
CREATE lights[]  MAX_LIGHTS /LIGHT * ALLOT

: light[] ( i -- a ) /LIGHT * lights[] + ;
: L.type ( a -- a ) ;
: L.enabled ( a -- a ) 4 + ;
: L.pos ( a -- a ) 8 + ;
: L.target ( a -- a ) 20 + ;
: L.color ( a -- a ) 32 + ;
: L.enLoc ( a -- a ) 36 + ;
: L.tyLoc ( a -- a ) 40 + ;
: L.posLoc ( a -- a ) 44 + ;
: L.tgtLoc ( a -- a ) 48 + ;
: L.colLoc ( a -- a ) 52 + ;

: light-en-name ( i -- z )
   dup 0 = if drop z" lights[0].enabled" else
   dup 1 = if drop z" lights[1].enabled" else
   dup 2 = if drop z" lights[2].enabled" else
              drop z" lights[3].enabled" then then then ;
: light-ty-name ( i -- z )
   dup 0 = if drop z" lights[0].type" else
   dup 1 = if drop z" lights[1].type" else
   dup 2 = if drop z" lights[2].type" else
              drop z" lights[3].type" then then then ;
: light-pos-name ( i -- z )
   dup 0 = if drop z" lights[0].position" else
   dup 1 = if drop z" lights[1].position" else
   dup 2 = if drop z" lights[2].position" else
              drop z" lights[3].position" then then then ;
: light-tgt-name ( i -- z )
   dup 0 = if drop z" lights[0].target" else
   dup 1 = if drop z" lights[1].target" else
   dup 2 = if drop z" lights[2].target" else
              drop z" lights[3].target" then then then ;
: light-col-name ( i -- z )
   dup 0 = if drop z" lights[0].color" else
   dup 1 = if drop z" lights[1].color" else
   dup 2 = if drop z" lights[2].color" else
              drop z" lights[3].color" then then then ;

: color>vec4 ( color dest -- )
   locals| dest color |
   color       $ff and s>f 255e f/  dest      sf!
   color  8 rshift $ff and s>f 255e f/  dest 4 +  sf!
   color 16 rshift $ff and s>f 255e f/  dest 8 +  sf!
   color 24 rshift $ff and s>f 255e f/  dest 12 + sf! ;

: UpdateLightValues ( shader light -- )
   locals| light shader |
   shader  light L.enLoc @  light L.enabled  SHADER_UNIFORM_INT SetShaderValue
   shader  light L.tyLoc @  light L.type     SHADER_UNIFORM_INT SetShaderValue
   shader  light L.posLoc @ light L.pos      SHADER_UNIFORM_VEC3 SetShaderValue
   shader  light L.tgtLoc @ light L.target   SHADER_UNIFORM_VEC3 SetShaderValue
   light L.color @ fvec4 color>vec4
   shader  light L.colLoc @  fvec4 SHADER_UNIFORM_VEC4 SetShaderValue ;

: CreateLight ( type pos target color shader -- light )
   #lights @ MAX_LIGHTS >= if 2drop drop 2drop  0 light[] exit then
   locals| shader color target pos type |
   #lights @ light[] >r
   color r@ L.color !
   pos    r@ L.pos    12 move
   target r@ L.target 12 move
   type r@ L.type !
   1 r@ L.enabled !
   shader  #lights @ light-en-name  GetShaderLocation  r@ L.enLoc !
   shader  #lights @ light-ty-name  GetShaderLocation  r@ L.tyLoc !
   shader  #lights @ light-pos-name GetShaderLocation  r@ L.posLoc !
   shader  #lights @ light-tgt-name GetShaderLocation  r@ L.tgtLoc !
   shader  #lights @ light-col-name GetShaderLocation  r@ L.colLoc !
   shader r@ UpdateLightValues
   1 #lights +!
   r> ;

: lights-reset  0 #lights ! ;

: zint ( n -- zaddr )
   dup abs s>d <# #s rot sign #>  over + 0 swap c! ;

: zf0 ( F: r -- zaddr )  fround f>s zint ;

: zf2 ( F: r -- zaddr )
   fdup f0< >r fabs 100e f* fround f>s
   s>d <# # # [char] . hold #s r> sign #>
   over + 0 swap c! ;

CREATE (dla) 8 ALLOT
CREATE (dlb) 8 ALLOT
FVARIABLE (dllen)
FVARIABLE (dldx)
FVARIABLE (dldy)
FVARIABLE (dldist)
FVARIABLE (dldash)
FVARIABLE (dlsp)

: DrawLineDashed ( start end dash space color -- )
   locals| color space dash end start |
   dash s>f (dldash) f!  space s>f (dlsp) f!
   start end Vector2Distance (dllen) f!
   (dllen) f@ (dldash) f@ (dlsp) f@ f+ f<
   (dldash) f@ f0<= or if
      start end color DrawLineV exit
   then
   end v2x start v2x f- (dllen) f@ f/ (dldx) f!
   end v2y start v2y f- (dllen) f@ f/ (dldy) f!
   0e (dldist) f!
   begin  (dldist) f@ (dllen) f@ f<  while
      (dldist) f@ (dldash) f@ f+ (dllen) f@ fmin
      start v2x (dldist) f@ (dldx) f@ f* f+
      start v2y (dldist) f@ (dldy) f@ f* f+  (dla) Vector2!
      start v2x fover (dldx) f@ f* f+
      start v2y fover (dldy) f@ f* f+  (dlb) Vector2!
      (dla) (dlb) color DrawLineV
      (dlsp) f@ f+ (dldist) f!
   repeat ;

FVARIABLE (et)  FVARIABLE (eb)  FVARIABLE (ec)  FVARIABLE (ed)
FVARIABLE (ep)  FVARIABLE (es)

: ease! ( F: t b c d -- )
   (ed) f! (ec) f! (eb) f! (et) f! ;

: EaseLinearIn ( F: t b c d -- r )
   ease!  (ec) f@ (et) f@ f* (ed) f@ f/ (eb) f@ f+ ;

: EaseSineOut ( F: t b c d -- r )
   ease!  (ec) f@ (et) f@ (ed) f@ f/ RPI f* 2e f/ fsin f* (eb) f@ f+ ;

: EaseCircOut ( F: t b c d -- r )
   ease!  (et) f@ (ed) f@ f/ 1e f- fdup f* 1e fswap f- fsqrt
   (ec) f@ f* (eb) f@ f+ ;

: EaseCubicOut ( F: t b c d -- r )
   ease!  (et) f@ (ed) f@ f/ 1e f- fdup fdup f* f* 1e f+
   (ec) f@ f* (eb) f@ f+ ;

: EaseQuadOut ( F: t b c d -- r )
   ease!  (et) f@ (ed) f@ f/ fdup 2e f- (ec) f@ fnegate f* f* (eb) f@ f+ ;

: EaseBounceOut ( F: t b c d -- r )
   ease!  (et) f@ (ed) f@ f/ (et) f!
   (et) f@ 1e 2.75e f/ f< if
      (ec) f@ 7.5625e (et) f@ fdup f* f* f* (eb) f@ f+
   else (et) f@ 2e 2.75e f/ f< if
      (et) f@ 1.5e 2.75e f/ f- (et) f!
      (ec) f@ 7.5625e (et) f@ fdup f* f* 0.75e f+ f* (eb) f@ f+
   else (et) f@ 2.5e 2.75e f/ f< if
      (et) f@ 2.25e 2.75e f/ f- (et) f!
      (ec) f@ 7.5625e (et) f@ fdup f* f* 0.9375e f+ f* (eb) f@ f+
   else
      (et) f@ 2.625e 2.75e f/ f- (et) f!
      (ec) f@ 7.5625e (et) f@ fdup f* f* 0.984375e f+ f* (eb) f@ f+
   then then then ;

: EaseElasticOut ( F: t b c d -- r )
   ease!
   (et) f@ f0= if (eb) f@ exit then
   (et) f@ (ed) f@ f/ fdup 1e f= if fdrop (eb) f@ (ec) f@ f+ exit then
   (et) f!
   (ed) f@ 0.3e f* (ep) f!  (ep) f@ 4e f/ (es) f!
   (ec) f@ 2e (et) f@ -10e f* f** f*
   (et) f@ (ed) f@ f* (es) f@ f- 2e RPI f* f* (ep) f@ f/ fsin f*
   (ec) f@ f+ (eb) f@ f+ ;

: EaseElasticIn ( F: t b c d -- r )
   ease!
   (et) f@ f0= if (eb) f@ exit then
   (et) f@ (ed) f@ f/ fdup 1e f= if fdrop (eb) f@ (ec) f@ f+ exit then
   1e f- (et) f!
   (ed) f@ 0.3e f* (ep) f!  (ep) f@ 4e f/ (es) f!
   (ec) f@ 2e (et) f@ 10e f* f** f*
   (et) f@ (ed) f@ f* (es) f@ f- 2e RPI f* f* (ep) f@ f/ fsin f*
   fnegate (eb) f@ f+ ;

: inside-rec ( rec -- flag )
   mouse@ swap CheckCollisionPointRec ;

: gui-slider ( rec var F: lo hi -- )
   locals| var rec |
   rec rec.x f>s rec rec.y f>s rec rec.w f>s rec rec.h f>s
   LIGHTGRAY DrawRectangle
   rec rec.x f>s rec rec.y f>s rec rec.w f>s rec rec.h f>s
   GRAY DrawRectangleLines
   rec inside-rec MOUSE_BUTTON_LEFT IsMouseButtonDown and if
      mouse@ v2x rec rec.x f- rec rec.w f/ 0e 1e ClampF
      frot frot fover f- frot f* f+ var sf!
   else fdrop fdrop then ;

: gui-check ( rec var zlabel -- )
   locals| lab var rec |
   rec inside-rec MOUSE_BUTTON_LEFT IsMouseButtonPressed and if
      var @ 0= var ! then
   rec rec.x f>s rec rec.y f>s rec rec.w f>s rec rec.h f>s
   var @ if DARKGRAY else RAYWHITE then DrawRectangle
   rec rec.x f>s rec rec.y f>s rec rec.w f>s rec rec.h f>s
   GRAY DrawRectangleLines
   lab rec rec.x f>s 28 + rec rec.y f>s 2 + 10 DARKGRAY DrawText ;

\ Look up EXAMPLE-NO-RUN and example at run time.  Compiling a call to
\ example here would fail because that word is defined by each example
\ file after this include.
: example-end
   s" EXAMPLE-NO-RUN" pad place  pad find nip if exit then
   s" example" evaluate
   restore-tty ;
