\ Port of raylib examples/core/core_3d_camera_fps.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

32e  fconstant GRAVITY
20e  fconstant MAX_SPEED
5e   fconstant CROUCH_SPEED
12e  fconstant JUMP_FORCE
150e fconstant MAX_ACCEL
0.86e fconstant FRICTION
0.98e fconstant AIR_DRAG
15e  fconstant CONTROL
0e   fconstant CROUCH_HEIGHT
1e   fconstant STAND_HEIGHT
0.5e fconstant BOTTOM_HEIGHT

CREATE player 40 ALLOT
: body-pos   player ;
: body-vel   player 12 + ;
: body-dir   player 24 + ;
: body-ground player 36 + ;

CREATE camera 44 ALLOT
CREATE lookRotation 8 ALLOT
CREATE lean 8 ALLOT
CREATE sensitivity 8 ALLOT
CREATE mouseDelta 8 ALLOT
CREATE inputv 8 ALLOT
CREATE front 12 ALLOT
CREATE rightv 12 ALLOT
CREATE desiredDir 12 ALLOT
CREATE hvel 12 ALLOT
CREATE tmp3 12 ALLOT
CREATE tmp3b 12 ALLOT
CREATE tmp3c 12 ALLOT
CREATE kxv 12 ALLOT
CREATE yawv 12 ALLOT
CREATE pitchv 12 ALLOT
CREATE upv 12 ALLOT
CREATE targetOff 12 ALLOT
CREATE planePos 12 ALLOT
CREATE planeSize 8 ALLOT
CREATE towerPos 12 ALLOT
CREATE towerSize 12 ALLOT
CREATE sun 12 ALLOT

0e fvalue headTimer
0e fvalue walkLerp
0e fvalue headLerp
0e fvalue rc
0e fvalue rs
0e fvalue kdot

VARIABLE sideway
VARIABLE forward
VARIABLE crouching
VARIABLE jumpPressed

: v3copy ( dest src -- dest )  over 12 move ;

: Vector3Negate ( dest src -- dest ) -1e Vector3Scale ;

\ Rodrigues: v' = v cos + (k×v) sin + k (k·v) (1-cos)
: Vector3RotateAxis ( dest src axis F: ang -- dest )
   locals| axis src dest |
   fdup fcos to rc  fsin to rs
   axis src Vector3DotProduct to kdot
   kxv axis src Vector3Cross drop
   tmp3 src rc Vector3Scale drop
   tmp3b kxv rs Vector3Scale drop
   tmp3c axis kdot 1e rc f- f* Vector3Scale drop
   tmp3 tmp3 tmp3b Vector3Add drop
   dest tmp3 tmp3c Vector3Add drop
   dest ;

: UpdateBody ( F: rot -- )
   sideway @ s>f  forward @ negate s>f inputv Vector2!
   GetFrameTime
   body-ground l@ 0= if
      body-vel 4 + sf@ GRAVITY fover f* f- body-vel 4 + sf!
   then
   body-ground l@ jumpPressed @ and if
      JUMP_FORCE body-vel 4 + sf!
      0 body-ground l!
   then
   fdup fsin  0e  fover fcos  front Vector3!
   fdup fnegate fcos  0e  fover fnegate fsin  rightv Vector3!
   inputv v2x rightv sf@ f*  inputv v2y front sf@ f* f+
   0e
   inputv v2x rightv 8 + sf@ f*  inputv v2y front 8 + sf@ f* f+
   desiredDir Vector3!
   body-dir dup desiredDir CONTROL fover f* Vector3Lerp drop
   body-ground l@ if FRICTION else AIR_DRAG then
   body-vel sf@ fover f*  0e  body-vel 8 + sf@ fover f*  hvel Vector3!  fdrop
   hvel Vector3Length fdup MAX_SPEED 0.01e f* f< if fdrop 0e 0e 0e hvel Vector3! else fdrop then
   hvel body-dir Vector3DotProduct
   crouching @ if CROUCH_SPEED else MAX_SPEED then
   fover f-  0e  MAX_ACCEL fover f*  ClampF
   body-dir sf@ fover f* hvel sf@ f+ hvel sf!
   body-dir 8 + sf@ f* hvel 8 + sf@ f+ hvel 8 + sf!
   fdrop
   hvel sf@ body-vel sf!
   hvel 8 + sf@ body-vel 8 + sf!
   body-pos sf@     body-vel sf@     fover f* f+ body-pos sf!
   body-pos 4 + sf@ body-vel 4 + sf@ fover f* f+ body-pos 4 + sf!
   body-pos 8 + sf@ body-vel 8 + sf@ fover f* f+ body-pos 8 + sf!
   fdrop
   body-pos 4 + sf@ 0e f<= if
      0e body-pos 4 + sf!
      0e body-vel 4 + sf!
      1 body-ground l!
   then
   fdrop ;

: UpdateCameraFPS
   0e 1e 0e upv Vector3!
   0e 0e -1e targetOff Vector3!
   yawv targetOff upv lookRotation sf@ Vector3RotateAxis drop
   rightv yawv upv Vector3Cross drop
   rightv dup Vector3Normalize drop
   lookRotation 4 + sf@ fnegate lean 4 + sf@ f-
   pi 2e f/ 0.0001e f- fnegate  pi 2e f/ 0.0001e f- ClampF
   pitchv yawv rightv fover Vector3RotateAxis drop  fdrop
   0e 1e 0e camera Camera.up Vector3!
   camera Camera.target  camera Camera.position  pitchv  Vector3Add drop ;

: DrawLevel
   25 -25 do
      25 -25 do
         j 1 and i 1 and and if
            i s>f 5e f*  0e  j s>f 5e f*  planePos Vector3!
            5e 5e planeSize Vector2!
            planePos planeSize 150 200 200 255 RGBA DrawPlane
         else
            j 1 and 0= i 1 and 0= and if
               i s>f 5e f*  0e  j s>f 5e f*  planePos Vector3!
               5e 5e planeSize Vector2!
               planePos planeSize LIGHTGRAY DrawPlane
            then
         then
      loop
   loop
   16e 32e 16e towerSize Vector3!
   16e 16e 16e towerPos Vector3!
   towerPos towerSize 150 200 200 255 RGBA DrawCubeV
   towerPos towerSize DARKBLUE DrawCubeWiresV
   towerPos sf@ fnegate towerPos sf!
   towerPos towerSize 150 200 200 255 RGBA DrawCubeV
   towerPos towerSize DARKBLUE DrawCubeWiresV
   towerPos 8 + sf@ fnegate towerPos 8 + sf!
   towerPos towerSize 150 200 200 255 RGBA DrawCubeV
   towerPos towerSize DARKBLUE DrawCubeWiresV
   towerPos sf@ fnegate towerPos sf!
   towerPos towerSize 150 200 200 255 RGBA DrawCubeV
   towerPos towerSize DARKBLUE DrawCubeWiresV
   300e 300e 0e sun Vector3!
   sun 100e RED DrawSphere ;

: example
   player 40 erase
   0.001e 0.001e sensitivity Vector2!
   0e 0e lookRotation Vector2!
   0e to headTimer  0e to walkLerp  STAND_HEIGHT to headLerp
   0e 0e lean Vector2!
   camera 44 erase
   60e camera Camera.fovy sf!
   CAMERA_PERSPECTIVE camera Camera.proj l!
   0e BOTTOM_HEIGHT headLerp f+  0e camera Camera.position Vector3!
   screenWidth screenHeight z" raylib [core] example - 3d camera fps" InitWindow
   DisableCursor
   60 SetTargetFPS
   begin
      mouseDelta GetMouseDelta drop
      lookRotation sf@ mouseDelta v2x sensitivity v2x f* f- lookRotation sf!
      lookRotation 4 + sf@ mouseDelta v2y sensitivity v2y f* f+ lookRotation 4 + sf!
      KEY_D down KEY_A down - sideway !
      KEY_W down KEY_S down - forward !
      KEY_LEFT_CONTROL down crouching !
      KEY_SPACE IsKeyPressed 1 and jumpPressed !
      lookRotation sf@ UpdateBody
      GetFrameTime
      headLerp  crouching @ if CROUCH_HEIGHT else STAND_HEIGHT then  20e fover f* Lerp to headLerp
      body-pos sf@  body-pos 4 + sf@ BOTTOM_HEIGHT headLerp f+ f+  body-pos 8 + sf@
      camera Camera.position Vector3!
      body-ground l@  forward @ sideway @ or and if
         headTimer fover 3e f* f+ to headTimer
         walkLerp 1e 10e fover f* Lerp to walkLerp
         camera Camera.fovy sf@ 55e 5e fover f* Lerp camera Camera.fovy sf!
      else
         walkLerp 0e 10e fover f* Lerp to walkLerp
         camera Camera.fovy sf@ 60e 5e fover f* Lerp camera Camera.fovy sf!
      then
      lean sf@     sideway @ s>f 0.02e f*  10e fover f* Lerp lean sf!
      lean 4 + sf@ forward @ s>f 0.015e f* 10e fover f* Lerp lean 4 + sf!
      fdrop
      UpdateCameraFPS
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            DrawLevel
         EndMode3D
         5 5 330 75 SKYBLUE 0.5e Fade DrawRectangle
         5 5 330 75 BLUE DrawRectangleLines
         z" Camera controls:" 15 15 10 BLACK DrawText
         z" - Move keys: W, A, S, D, Space, Left-Ctrl" 15 30 10 BLACK DrawText
         z" - Look around: arrow keys or mouse" 15 45 10 BLACK DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
