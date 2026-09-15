\ Port of raylib examples/core/core_3d_camera_first_person.c
\ CameraYaw/CameraPitch (rcamera.h) omitted; orthographic uses a fixed isometric pose

800 CONSTANT screenWidth
450 CONSTANT screenHeight
20 CONSTANT MAX_COLUMNS

CREATE camera 44 ALLOT
VARIABLE cameraMode
CREATE heights  MAX_COLUMNS 4 * ALLOT
CREATE positions  MAX_COLUMNS 12 * ALLOT
CREATE colors  MAX_COLUMNS CELLS ALLOT
CREATE planePos 12 ALLOT
CREATE planeSize 8 ALLOT
CREATE wall 12 ALLOT

: col-h ( i -- addr ) 4 * heights + ;
: col-p ( i -- addr ) 12 * positions + ;
: col-c ( i -- addr ) CELLS colors + ;

: cam-pos camera ;
: cam-tgt camera Camera.target ;
: cam-up  camera Camera.up ;
: cam-fovy camera Camera.fovy ;
: cam-proj camera Camera.proj ;

: init-columns
   MAX_COLUMNS 0 ?do
      1 12 GetRandomValue s>f i col-h sf!
      -15 15 GetRandomValue s>f
      i col-h sf@ f2/
      -15 15 GetRandomValue s>f
      i col-p Vector3!
      20 255 GetRandomValue  10 55 GetRandomValue  30  255 RGBA  i col-c !
   loop ;

: mode-name ( -- z )
   cameraMode @ case
      CAMERA_FREE         of z" FREE" endof
      CAMERA_FIRST_PERSON of z" FIRST_PERSON" endof
      CAMERA_THIRD_PERSON of z" THIRD_PERSON" endof
      CAMERA_ORBITAL      of z" ORBITAL" endof
      dup of z" CUSTOM" endof
   endcase ;

: example
   0e 2e 4e cam-pos Vector3!
   0e 2e 0e cam-tgt Vector3!
   0e 1e 0e cam-up Vector3!
   60e cam-fovy sf!
   CAMERA_PERSPECTIVE cam-proj l!
   CAMERA_FIRST_PERSON cameraMode !
   init-columns
   screenWidth screenHeight z" raylib [core] example - 3d camera first person" InitWindow
   DisableCursor
   60 SetTargetFPS
   begin
      KEY_ONE IsKeyPressed 1 and if
         CAMERA_FREE cameraMode !
         0e 1e 0e cam-up Vector3!
      then
      KEY_TWO IsKeyPressed 1 and if
         CAMERA_FIRST_PERSON cameraMode !
         0e 1e 0e cam-up Vector3!
      then
      KEY_THREE IsKeyPressed 1 and if
         CAMERA_THIRD_PERSON cameraMode !
         0e 1e 0e cam-up Vector3!
      then
      KEY_FOUR IsKeyPressed 1 and if
         CAMERA_ORBITAL cameraMode !
         0e 1e 0e cam-up Vector3!
      then
      KEY_P IsKeyPressed 1 and if
         cam-proj l@ CAMERA_PERSPECTIVE = if
            CAMERA_THIRD_PERSON cameraMode !
            20e 20e 20e cam-pos Vector3!
            0e 2e 0e cam-tgt Vector3!
            0e 1e 0e cam-up Vector3!
            CAMERA_ORTHOGRAPHIC cam-proj l!
            20e cam-fovy sf!
         else
            CAMERA_THIRD_PERSON cameraMode !
            0e 2e 10e cam-pos Vector3!
            0e 2e 0e cam-tgt Vector3!
            0e 1e 0e cam-up Vector3!
            CAMERA_PERSPECTIVE cam-proj l!
            60e cam-fovy sf!
         then
      then
      camera cameraMode @ UpdateCamera
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            0e 0e 0e planePos Vector3!  32e 32e planeSize Vector2!
            planePos planeSize LIGHTGRAY DrawPlane
            -16e 2.5e 0e wall Vector3!  wall 1e 5e 32e BLUE DrawCube
            16e 2.5e 0e wall Vector3!   wall 1e 5e 32e LIME DrawCube
            0e 2.5e 16e wall Vector3!   wall 32e 5e 1e GOLD DrawCube
            MAX_COLUMNS 0 ?do
               i col-p  2e  i col-h sf@  2e  i col-c @  DrawCube
               i col-p  2e  i col-h sf@  2e  MAROON     DrawCubeWires
            loop
            cameraMode @ CAMERA_THIRD_PERSON = if
               cam-tgt 0.5e 0.5e 0.5e PURPLE DrawCube
               cam-tgt 0.5e 0.5e 0.5e DARKPURPLE DrawCubeWires
            then
         EndMode3D
         5 5 330 100 SKYBLUE 0.5e Fade DrawRectangle
         5 5 330 100 BLUE DrawRectangleLines
         z" Camera controls:" 15 15 10 BLACK DrawText
         z" - Move keys: W, A, S, D, Space, Left-Ctrl" 15 30 10 BLACK DrawText
         z" - Look around: arrow keys or mouse" 15 45 10 BLACK DrawText
         z" - Camera mode keys: 1, 2, 3, 4" 15 60 10 BLACK DrawText
         z" - Zoom keys: num-plus, num-minus or mouse scroll" 15 75 10 BLACK DrawText
         z" - Camera projection key: P" 15 90 10 BLACK DrawText
         600 5 195 100 SKYBLUE 0.5e Fade DrawRectangle
         600 5 195 100 BLUE DrawRectangleLines
         z" Camera status:" 610 15 10 BLACK DrawText
         z" - Mode: " 610 30 10 BLACK DrawText
         mode-name 670 30 10 BLACK DrawText
         z" - Projection: " 610 45 10 BLACK DrawText
         cam-proj l@ CAMERA_PERSPECTIVE = if z" PERSPECTIVE" else z" ORTHOGRAPHIC" then
         710 45 10 BLACK DrawText
      EndDrawing
   WindowShouldClose until
   CloseWindow ;

example-end
