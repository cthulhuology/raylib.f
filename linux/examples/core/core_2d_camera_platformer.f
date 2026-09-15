\ Port of raylib examples/core/core_2d_camera_platformer.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight
400e fconstant G
350e fconstant PLAYER_JUMP_SPD
200e fconstant PLAYER_HOR_SPD
5 CONSTANT envItemsLength

\ Player: Vector2 pos (8), float speed (4), int canJump (4) = 16
CREATE player 16 ALLOT
\ EnvItem: Rectangle (16) + int blocking (4) + pad (4) + Color cell (8) = 32
32 CONSTANT /env
CREATE envItems  envItemsLength /env * ALLOT
CREATE camera 24 ALLOT
CREATE playerRect 16 ALLOT
CREATE v-max 8 ALLOT
CREATE v-min 8 ALLOT
CREATE diff 8 ALLOT
CREATE tmpv 8 ALLOT
VARIABLE cameraOption

0e fvalue minSpeed
0e fvalue minEffectLength
0e fvalue fractionSpeed
0e fvalue evenOutSpeed
VARIABLE eveningOut
0e fvalue evenOutTarget
CREATE bbox 8 ALLOT
CREATE bboxWorldMin 8 ALLOT
CREATE bboxWorldMax 8 ALLOT

: Rectangle! ( a F: x y w h -- )
   dup 12 + sf!  dup 8 + sf!  dup 4 + sf!  sf! ;

: ply-pos player ;
: ply-spd player 8 + ;
: ply-jump player 12 + ;

: env ( i -- addr ) /env * envItems + ;
: env-rec ( i -- addr ) env ;
: env-block ( i -- addr ) env 16 + ;
: env-col ( i -- n ) env 24 + @ ;

: cam-off  camera ;
: cam-tgt  camera 8 + ;
: cam-rot  camera 16 + ;
: cam-zoom camera 20 + ;

: init-env
   0e 0e 1000e 400e  0 env-rec Rectangle!  0 0 env-block l!  LIGHTGRAY 0 env 24 + !
   0e 400e 1000e 200e  1 env-rec Rectangle!  1 1 env-block l!  GRAY 1 env 24 + !
   300e 200e 400e 10e  2 env-rec Rectangle!  1 2 env-block l!  GRAY 2 env 24 + !
   250e 300e 100e 10e  3 env-rec Rectangle!  1 3 env-block l!  GRAY 3 env 24 + !
   650e 300e 100e 10e  4 env-rec Rectangle!  1 4 env-block l!  GRAY 4 env 24 + ! ;

: UpdatePlayer ( F: delta -- )
   KEY_LEFT  down if ply-pos sf@ PLAYER_HOR_SPD fover f* f- ply-pos sf! then
   KEY_RIGHT down if ply-pos sf@ PLAYER_HOR_SPD fover f* f+ ply-pos sf! then
   KEY_SPACE down ply-jump l@ and if
      PLAYER_JUMP_SPD fnegate ply-spd sf!
      0 ply-jump l!
   then
   0  \ hitObstacle
   envItemsLength 0 ?do
      i env-block l@ if
         i env-rec sf@  ply-pos sf@ f<=
         i env-rec sf@ i env-rec 8 + sf@ f+  ply-pos sf@ f>= and
         i env-rec 4 + sf@  ply-pos 4 + sf@ f>= and
         i env-rec 4 + sf@  ply-pos 4 + sf@ ply-spd sf@ fover f* f+ f<= and if
            drop 1
            0e ply-spd sf!
            i env-rec 4 + sf@ ply-pos 4 + sf!
            leave
         then
      then
   loop
   0= if
      ply-pos 4 + sf@ ply-spd sf@ fover f* f+ ply-pos 4 + sf!
      ply-spd sf@ G fover f* f+ ply-spd sf!
      0 ply-jump l!
   else
      1 ply-jump l!
   then
   fdrop ;

: UpdateCameraCenter
   screenWidth 2/ s>f screenHeight 2/ s>f cam-off Vector2!
   ply-pos cam-tgt 8 move ;

0e fvalue minX
0e fvalue minY
0e fvalue maxX
0e fvalue maxY

: scan-map
   1000e to minX  1000e to minY  -1000e to maxX  -1000e to maxY
   envItemsLength 0 ?do
      i env-rec sf@ minX fmin to minX
      i env-rec sf@ i env-rec 8 + sf@ f+ maxX fmax to maxX
      i env-rec 4 + sf@ minY fmin to minY
      i env-rec 4 + sf@ i env-rec 12 + sf@ f+ maxY fmax to maxY
   loop ;

: UpdateCameraCenterInsideMap
   ply-pos cam-tgt 8 move
   screenWidth 2/ s>f screenHeight 2/ s>f cam-off Vector2!
   scan-map
   maxX maxY v-max Vector2!
   minX minY v-min Vector2!
   v-max dup camera GetWorldToScreen2D drop
   v-min dup camera GetWorldToScreen2D drop
   v-max v2x screenWidth s>f f< if
      screenWidth s>f  v-max v2x screenWidth 2/ s>f f- f-  cam-off sf!
   then
   v-max v2y screenHeight s>f f< if
      screenHeight s>f  v-max v2y screenHeight 2/ s>f f- f-  cam-off 4 + sf!
   then
   v-min v2x 0e f> if
      screenWidth 2/ s>f v-min v2x f- cam-off sf!
   then
   v-min v2y 0e f> if
      screenHeight 2/ s>f v-min v2y f- cam-off 4 + sf!
   then ;

: UpdateCameraCenterSmoothFollow ( F: delta -- )
   screenWidth 2/ s>f screenHeight 2/ s>f cam-off Vector2!
   diff ply-pos cam-tgt Vector2Subtract drop
   diff Vector2Length  \ F: delta length
   fdup minEffectLength f> if
      fswap  \ length delta
      fdup fractionSpeed f* minSpeed fmax  \ length delta speed
      f*     \ length speed*delta
      fswap f/  \ (speed*delta)/length
      tmpv diff fover Vector2Scale drop  fdrop
      cam-tgt dup tmpv Vector2Add drop
   else
      fdrop fdrop
   then ;

: UpdateCameraEvenOutOnLanding ( F: delta -- )
   screenWidth 2/ s>f screenHeight 2/ s>f cam-off Vector2!
   ply-pos sf@ cam-tgt sf!
   eveningOut @ if
      evenOutTarget cam-tgt 4 + sf@ f> if
         cam-tgt 4 + sf@ evenOutSpeed fover f* f+ cam-tgt 4 + sf!
         cam-tgt 4 + sf@ evenOutTarget f> if
            evenOutTarget cam-tgt 4 + sf!
            0 eveningOut !
         then
      else
         cam-tgt 4 + sf@ evenOutSpeed fover f* f- cam-tgt 4 + sf!
         cam-tgt 4 + sf@ evenOutTarget f< if
            evenOutTarget cam-tgt 4 + sf!
            0 eveningOut !
         then
      then
      fdrop
   else
      fdrop
      ply-jump l@  ply-spd sf@ f0= and  ply-pos 4 + sf@ cam-tgt 4 + sf@ f= 0= and if
         1 eveningOut !
         ply-pos 4 + sf@ to evenOutTarget
      then
   then ;

: UpdateCameraPlayerBoundsPush
   0.2e 0.2e bbox Vector2!
   1e bbox v2x f- 0.5e f* screenWidth s>f f*
   1e bbox v2y f- 0.5e f* screenHeight s>f f*
   tmpv Vector2!
   bboxWorldMin tmpv camera GetScreenToWorld2D drop
   1e bbox v2x f+ 0.5e f* screenWidth s>f f*
   1e bbox v2y f+ 0.5e f* screenHeight s>f f*
   tmpv Vector2!
   bboxWorldMax tmpv camera GetScreenToWorld2D drop
   1e bbox v2x f- 0.5e f* screenWidth s>f f*
   1e bbox v2y f- 0.5e f* screenHeight s>f f*
   cam-off Vector2!
   ply-pos sf@ bboxWorldMin v2x f< if ply-pos sf@ cam-tgt sf! then
   ply-pos 4 + sf@ bboxWorldMin v2y f< if ply-pos 4 + sf@ cam-tgt 4 + sf! then
   ply-pos sf@ bboxWorldMax v2x f> if
      bboxWorldMin v2x ply-pos sf@ bboxWorldMax v2x f- f+ cam-tgt sf!
   then
   ply-pos 4 + sf@ bboxWorldMax v2y f> if
      bboxWorldMin v2y ply-pos 4 + sf@ bboxWorldMax v2y f- f+ cam-tgt 4 + sf!
   then ;

: update-camera ( F: delta -- )
   cameraOption @ case
      0 of fdrop UpdateCameraCenter endof
      1 of fdrop UpdateCameraCenterInsideMap endof
      2 of UpdateCameraCenterSmoothFollow endof
      3 of UpdateCameraEvenOutOnLanding endof
      4 of fdrop UpdateCameraPlayerBoundsPush endof
      dup of fdrop endof
   endcase ;

: example
   400e 280e player Vector2!
   0e ply-spd sf!
   0 ply-jump l!
   init-env
   ply-pos cam-tgt 8 move
   screenWidth 2/ s>f screenHeight 2/ s>f cam-off Vector2!
   0e cam-rot sf!
   1e cam-zoom sf!
   0 cameraOption !
   30e to minSpeed
   10e to minEffectLength
   0.8e to fractionSpeed
   700e to evenOutSpeed
   0 eveningOut !
   screenWidth screenHeight z" raylib [core] example - 2d camera platformer" InitWindow
   60 SetTargetFPS
   begin
      GetFrameTime fdup UpdatePlayer
      cam-zoom sf@ GetMouseWheelMove 0.05e f* f+ cam-zoom sf!
      cam-zoom sf@ 3e f> if 3e cam-zoom sf! then
      cam-zoom sf@ 0.25e f< if 0.25e cam-zoom sf! then
      KEY_R IsKeyPressed 1 and if
         1e cam-zoom sf!
         400e 280e player Vector2!
      then
      KEY_C IsKeyPressed 1 and if
         cameraOption @ 1+ 5 mod cameraOption !
      then
      update-camera
      BeginDrawing
         LIGHTGRAY ClearBackground
         camera BeginMode2D
            envItemsLength 0 ?do
               i env-rec  i env-col  DrawRectangleRec
            loop
            ply-pos sf@ 20e f-  ply-pos 4 + sf@ 40e f-  40e 40e playerRect Rectangle!
            playerRect RED DrawRectangleRec
            ply-pos 5e GOLD DrawCircleV
         EndMode2D
         z" Controls:" 20 20 10 BLACK DrawText
         z" - Right/Left to move" 40 40 10 DARKGRAY DrawText
         z" - Space to jump" 40 60 10 DARKGRAY DrawText
         z" - Mouse Wheel to Zoom in-out, R to reset zoom" 40 80 10 DARKGRAY DrawText
         z" - C to change camera mode" 40 100 10 DARKGRAY DrawText
         z" Current camera mode:" 20 120 10 BLACK DrawText
         cameraOption @ case
            0 of z" Follow player center" 40 140 10 DARKGRAY DrawText endof
            1 of z" Follow player center, but clamp to map edges" 40 140 10 DARKGRAY DrawText endof
            2 of z" Follow player center; smoothed" 40 140 10 DARKGRAY DrawText endof
            3 of z" Follow player center horizontally; update player center vertically after landing" 40 140 10 DARKGRAY DrawText endof
            4 of z" Player push camera on getting too close to screen edge" 40 140 10 DARKGRAY DrawText endof
         endcase
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
