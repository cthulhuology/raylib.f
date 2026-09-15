\ Port of raylib examples/models/models_loading_gltf.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   6e 6e 6e :Camera.position
   0e 2e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mdl 128 ALLOT
0e 0e 0e Vector3: position
VARIABLE animsCount
VARIABLE animIndex
VARIABLE animFrame
VARIABLE anims

: anim[] ( i -- a ) 56 * anims @ + ;

: example
   0 animsCount !  0 animIndex !  0 animFrame !
   screenWidth screenHeight z" raylib [models] example - loading gltf" InitWindow
   mdl z" /home/dave/Code/raylib/examples/models/resources/models/gltf/robot.glb" LoadModel drop
   z" /home/dave/Code/raylib/examples/models/resources/models/gltf/robot.glb" animsCount LoadModelAnimations anims !
   60 SetTargetFPS
   begin
      camera CAMERA_ORBITAL UpdateCamera
      animsCount @ 0> if
         MOUSE_BUTTON_RIGHT IsMouseButtonPressed if
            animIndex @ 1+ animsCount @ mod animIndex ! then
         MOUSE_BUTTON_LEFT IsMouseButtonPressed if
            animIndex @ animsCount @ + 1- animsCount @ mod animIndex ! then
         animIndex @ anim[] 4 + @  \ frameCount
         animFrame @ 1+ swap mod animFrame !
         mdl  animIndex @ anim[]  animFrame @  UpdateModelAnimation
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            mdl position 1e WHITE DrawModel
            10 1e DrawGrid
         EndMode3D
         z" Use the LEFT/RIGHT mouse buttons to switch animation" 10 10 20 GRAY DrawText
         z" Animation playing" 10 GetScreenHeight 20 - 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   anims @ animsCount @ UnloadModelAnimations
   mdl UnloadModel
   CloseWindow ;

example-end
