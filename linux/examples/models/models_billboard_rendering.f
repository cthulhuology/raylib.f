\ Port of raylib examples/models/models_billboard_rendering.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   5e 4e 5e :Camera.position
   0e 2e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE bill 32 ALLOT
0e 2e 0e Vector3: billStatic
1e 2e 1e Vector3: billRot
0e 1e 0e Vector3: billUp
CREATE source 16 ALLOT
CREATE size 8 ALLOT
CREATE origin 8 ALLOT
CREATE rotation 4 ALLOT

: example
   screenWidth screenHeight z" raylib [models] example - billboard rendering" InitWindow
   bill z" /home/dave/Code/raylib/examples/models/resources/billboard.png" LoadTexture drop
   0e 0e bill tex.w s>f bill tex.h s>f source Rectangle!
   source 8 + sf@ source 12 + sf@ f/  1e size Vector2!
   origin size 0.5e Vector2Scale drop
   0e rotation sf!
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      rotation sf@ 0.4e f+ rotation sf!
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            10 1e DrawGrid
            camera Camera.position billStatic Vector3Distance
            camera Camera.position billRot Vector3Distance
            f< if
               camera bill source billRot billUp size origin rotation sf@ WHITE DrawBillboardPro
               camera bill billStatic 2e WHITE DrawBillboard
            else
               camera bill billStatic 2e WHITE DrawBillboard
               camera bill source billRot billUp size origin rotation sf@ WHITE DrawBillboardPro
            then
         EndMode3D
         10 10 DrawFPS
      EndDrawing
   WindowShouldClose until
   bill UnloadTexture
   CloseWindow ;

example-end
