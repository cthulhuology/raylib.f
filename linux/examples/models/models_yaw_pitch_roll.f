\ Port of raylib examples/models/models_yaw_pitch_roll.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   0e 50e -120e :Camera.position
   0e  0e    0e :Camera.target
   0e  1e    0e :Camera.up
   30e          :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mdl 128 ALLOT
CREATE tex 32 ALLOT
0e -8e 0e Vector3: pos
CREATE pitch 4 ALLOT
CREATE roll 4 ALLOT
CREATE yaw 4 ALLOT

: damp ( F: v step -- v )
   fover f0> if f-  fdup f0< if fdrop 0e then
   else f+ fdup f0> if fdrop 0e then then ;

: example
   0e pitch sf!  0e roll sf!  0e yaw sf!
   screenWidth screenHeight z" raylib [models] example - yaw pitch roll" InitWindow
   mdl z" /home/dave/Code/raylib/examples/models/resources/models/obj/plane.obj" LoadModel drop
   tex z" /home/dave/Code/raylib/examples/models/resources/models/obj/plane_diffuse.png" LoadTexture drop
   mdl tex set-diffuse
   60 SetTargetFPS
   begin
      KEY_DOWN down if pitch sf@ 0.6e f+ pitch sf!
      else KEY_UP down if pitch sf@ 0.6e f- pitch sf!
      else pitch sf@ 0.3e damp pitch sf! then then
      KEY_S down if yaw sf@ 1e f- yaw sf!
      else KEY_A down if yaw sf@ 1e f+ yaw sf!
      else yaw sf@ 0.5e damp yaw sf! then then
      KEY_LEFT down if roll sf@ 1e f- roll sf!
      else KEY_RIGHT down if roll sf@ 1e f+ roll sf!
      else roll sf@ 0.5e damp roll sf! then then
      pitch sf@ deg>rad yaw sf@ deg>rad roll sf@ deg>rad mdl MatrixRotateXYZ drop
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl pos 1e WHITE DrawModel
            10 10e DrawGrid
         EndMode3D
         30 370 260 70 GREEN 0.5e Fade DrawRectangle
         30 370 260 70 DARKGREEN 0.5e Fade DrawRectangleLines
         z" Pitch controlled with: KEY_UP / KEY_DOWN" 40 380 10 DARKGRAY DrawText
         z" Roll controlled with: KEY_LEFT / KEY_RIGHT" 40 400 10 DARKGRAY DrawText
         z" Yaw controlled with: KEY_A / KEY_S" 40 420 10 DARKGRAY DrawText
         z" (c) WWI Plane Model created by GiaHanLam" screenWidth 240 - screenHeight 20 - 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   mdl UnloadModel
   tex UnloadTexture
   CloseWindow ;

example-end
