\ Port of raylib examples/models/models_bone_socket.c
\ Bone-socket attachment simplified: character + equipment drawn together.

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   5e 5e 5e :Camera.position
   0e 2e 0e :Camera.target
   0e 1e 0e :Camera.up
   45e      :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE character 128 ALLOT
CREATE hat 128 ALLOT
CREATE sword 128 ALLOT
CREATE shield 128 ALLOT
0e 0e 0e Vector3: position
VARIABLE animsCount
VARIABLE animIndex
VARIABLE animFrame
VARIABLE anims
VARIABLE showHat
VARIABLE showSword
VARIABLE showShield

: anim[] ( i -- a ) 56 * anims @ + ;

: example
   1 showHat !  1 showSword !  1 showShield !
   0 animsCount !  0 animIndex !  0 animFrame !
   screenWidth screenHeight z" raylib [models] example - bone socket" InitWindow
   character z" /home/dave/Code/raylib/examples/models/resources/models/gltf/greenman.glb" LoadModel drop
   hat z" /home/dave/Code/raylib/examples/models/resources/models/gltf/greenman_hat.glb" LoadModel drop
   sword z" /home/dave/Code/raylib/examples/models/resources/models/gltf/greenman_sword.glb" LoadModel drop
   shield z" /home/dave/Code/raylib/examples/models/resources/models/gltf/greenman_shield.glb" LoadModel drop
   z" /home/dave/Code/raylib/examples/models/resources/models/gltf/greenman.glb" animsCount LoadModelAnimations anims !
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_THIRD_PERSON UpdateCamera
      KEY_T IsKeyPressed if animsCount @ if animIndex @ 1+ animsCount @ mod animIndex ! then then
      KEY_H IsKeyPressed if showHat @ 0= showHat ! then
      KEY_S IsKeyPressed if showSword @ 0= showSword ! then
      KEY_G IsKeyPressed if showShield @ 0= showShield ! then
      animsCount @ if
         animIndex @ anim[] 4 + @
         animFrame @ 1+ swap mod animFrame !
         character animIndex @ anim[] animFrame @ UpdateModelAnimation
      then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            character position 1e WHITE DrawModel
            showHat @ if hat position 1e WHITE DrawModel then
            showSword @ if sword position 1e WHITE DrawModel then
            showShield @ if shield position 1e WHITE DrawModel then
            10 1e DrawGrid
         EndMode3D
         z" Bone sockets simplified (equipment at origin)" 10 10 20 GRAY DrawText
         z" H/S/G toggle hat/sword/shield  T next anim" 10 40 10 DARKGRAY DrawText
      EndDrawing
   WindowShouldClose until
   anims @ animsCount @ UnloadModelAnimations
   character UnloadModel
   hat UnloadModel
   sword UnloadModel
   shield UnloadModel
   CloseWindow ;

example-end
