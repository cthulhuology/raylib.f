\ Port of raylib examples/models/models_animation_playing.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   10e 10e 10e :Camera.position
   0e  0e  0e  :Camera.target
   0e  1e  0e  :Camera.up
   45e         :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mdl 128 ALLOT
CREATE tex 32 ALLOT
0e 0e 0e Vector3: position
1e 0e 0e Vector3: axis
1e 1e 1e Vector3: scl
VARIABLE animsCount
VARIABLE anims
VARIABLE animFrame

: anim0 ( -- a ) anims @ ;

: example
   0 animsCount !  0 animFrame !
   screenWidth screenHeight z" raylib [models] example - animation playing" InitWindow
   mdl z" /home/dave/Code/raylib/examples/models/resources/models/iqm/guy.iqm" LoadModel drop
   tex z" /home/dave/Code/raylib/examples/models/resources/models/iqm/guytex.png" LoadTexture drop
   mdl tex set-diffuse
   z" /home/dave/Code/raylib/examples/models/resources/models/iqm/guyanim.iqm" animsCount LoadModelAnimations anims !
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FIRST_PERSON UpdateCamera
      KEY_SPACE down if
         1 animFrame +!
         mdl anim0 animFrame @ UpdateModelAnimation
         animFrame @ anim0 4 + @ >= if 0 animFrame ! then
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl position axis -90e scl WHITE DrawModelEx
            10 1e DrawGrid
         EndMode3D
         z" PRESS SPACE to PLAY MODEL ANIMATION" 10 10 20 MAROON DrawText
         z" (c) Guy IQM 3D model by @culacant" screenWidth 200 - screenHeight 20 - 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   tex UnloadTexture
   anims @ animsCount @ UnloadModelAnimations
   mdl UnloadModel
   CloseWindow ;

example-end
