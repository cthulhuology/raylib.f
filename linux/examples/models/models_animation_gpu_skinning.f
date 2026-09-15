\ Port of raylib examples/models/models_animation_gpu_skinning.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   5e 5e 5e :Camera.position
   0e 2e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mdl 128 ALLOT
CREATE shd 32 ALLOT
0e 0e 0e Vector3: position
VARIABLE animsCount
VARIABLE animIndex
VARIABLE animFrame
VARIABLE anims

: anim[] ( i -- a ) 56 * anims @ + ;

: example
   0 animsCount !  0 animIndex !  0 animFrame !
   screenWidth screenHeight z" raylib [models] example - animation gpu skinning" InitWindow
   mdl z" /home/dave/Code/raylib/examples/models/resources/models/gltf/greenman.glb" LoadModel drop
   shd z" /home/dave/Code/raylib/examples/models/resources/shaders/glsl330/skinning.vs"
       z" /home/dave/Code/raylib/examples/models/resources/shaders/glsl330/skinning.fs" LoadShader drop
   mdl 1 material[] shd 16 move
   z" /home/dave/Code/raylib/examples/models/resources/models/gltf/greenman.glb" animsCount LoadModelAnimations anims !
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_THIRD_PERSON UpdateCamera
      animsCount @ 0> if
         KEY_T IsKeyPressed if animIndex @ 1+ animsCount @ mod animIndex ! then
         KEY_G IsKeyPressed if animIndex @ animsCount @ + 1- animsCount @ mod animIndex ! then
         animIndex @ anim[] 4 + @
         animFrame @ 1+ swap mod animFrame !
         position .x position .y position .z mdl MatrixTranslate! drop
         mdl animIndex @ anim[] animFrame @ UpdateModelAnimationBones
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl 0 mesh[] mdl 1 material[] mdl DrawMesh
            10 1e DrawGrid
         EndMode3D
         z" Use the T/G to switch animation" 10 10 20 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   anims @ animsCount @ UnloadModelAnimations
   mdl UnloadModel
   shd UnloadShader
   CloseWindow ;

example-end
