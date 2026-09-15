\ Port of raylib examples/models/models_tesseract_view.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   4e 4e 4e :Camera.position
   0e 0e 0e :Camera.target
   0e 0e 1e :Camera.up
   50e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE tess 16 16 * ALLOT
CREATE xformed 16 12 * ALLOT
CREATE wvals 16 4 * ALLOT
CREATE pxy 8 ALLOT
VARIABLE ti
VARIABLE tj
CREATE rotang 4 ALLOT

: tessi ( i -- a ) 16 * tess + ;
: xfi  ( i -- a ) 12 * xformed + ;
: wi   ( i -- a ) 4 * wvals + ;

: v4eq ( ia ib off -- f )
   rot rot tessi swap tessi swap rot
   >r
   over r@ + sf@
   dup  r> + sf@
   2drop
   f- fdup f0< if fnegate then 0.0001e f< ;

VARIABLE #same
: same3 ( ia ib -- f )
   0 #same !
   2dup 0 v4eq if 1 #same +! then
   2dup 4 v4eq if 1 #same +! then
   2dup 8 v4eq if 1 #same +! then
        12 v4eq if 1 #same +! then
   #same @ 3 = ;

: init-tess
   1e  1e  1e  1e  0 tessi Vector4!
   1e  1e  1e -1e  1 tessi Vector4!
   1e  1e -1e  1e  2 tessi Vector4!
   1e  1e -1e -1e  3 tessi Vector4!
   1e -1e  1e  1e  4 tessi Vector4!
   1e -1e  1e -1e  5 tessi Vector4!
   1e -1e -1e  1e  6 tessi Vector4!
   1e -1e -1e -1e  7 tessi Vector4!
  -1e  1e  1e  1e  8 tessi Vector4!
  -1e  1e  1e -1e  9 tessi Vector4!
  -1e  1e -1e  1e 10 tessi Vector4!
  -1e  1e -1e -1e 11 tessi Vector4!
  -1e -1e  1e  1e 12 tessi Vector4!
  -1e -1e  1e -1e 13 tessi Vector4!
  -1e -1e -1e  1e 14 tessi Vector4!
  -1e -1e -1e -1e 15 tessi Vector4! ;

CREATE (c) 4 ALLOT
CREATE (s) 4 ALLOT
: xform-one ( i -- )
   dup tessi >r
   rotang sf@ fdup fcos (c) sf! fsin (s) sf!
   r@ sf@ (c) sf@ f*  r@ 12 + sf@ (s) sf@ f* f-
   r@ 12 + sf@ (c) sf@ f*  r@ sf@ (s) sf@ f* f+
   pxy Vector2!
   3e pxy 4 + sf@ f- fdup f0= if fdrop 1e else 3e fswap f/ then
   pxy sf@ fover f*
   r@ 4 + sf@ fover f*
   r@ 8 + sf@ fover f*
   over xfi Vector3!
   pxy 4 + sf@ over wi sf!
   r> 2drop fdrop ;

: example
   init-tess
   screenWidth screenHeight z" raylib [models] example - tesseract view" InitWindow
   60 SetTargetFPS
   begin
      GetTime 45e f* deg>rad rotang sf!
      0 ti !
      begin ti @ 16 < while
         ti @ xform-one
         1 ti +!
      repeat
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            0 ti !
            begin ti @ 16 < while
               ti @ xfi
               ti @ wi sf@ fdup f0< if fnegate then 0.1e f*
               RED DrawSphere
               1 ti +!
            repeat
            0 ti !
            begin ti @ 16 < while
               0 tj !
               begin tj @ 16 < while
                  ti @ tj @ < if
                     ti @ tj @ same3 if
                        ti @ xfi tj @ xfi MAROON DrawLine3D
                     then
                  then
                  1 tj +!
               repeat
               1 ti +!
            repeat
         EndMode3D
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
