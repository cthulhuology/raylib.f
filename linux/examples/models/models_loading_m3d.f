\ Port of raylib examples/models/models_loading_m3d.c

800 CONSTANT screenWidth
450 CONSTANT screenHeight

Camera: camera
   1.5e 1.5e 1.5e :Camera.position
   0e 0.4e 0e     :Camera.target
   0e 1e 0e       :Camera.up
   45e            :Camera.fovy
   CAMERA_PERSPECTIVE :Camera.proj

CREATE mdl 128 ALLOT
0e 0e 0e Vector3: position
VARIABLE animsCount
VARIABLE animFrame
VARIABLE animId
VARIABLE anims
VARIABLE show-mesh
VARIABLE show-skel
VARIABLE anim-playing

: anim[] ( i -- a ) 56 * anims @ + ;

VARIABLE sk-poses
VARIABLE sk-bones
VARIABLE sk-n
VARIABLE sk-i

: draw-skel ( poses bones n -- )
   sk-n !  sk-bones !  sk-poses !
   0 sk-i !
   begin sk-i @ sk-n @ < while
      sk-poses @ sk-i @ 40 * +  0.04e 0.04e 0.04e RED DrawCube
      sk-bones @ sk-i @ 36 * + 32 + l@s dup 0< if drop else
         sk-poses @ sk-i @ 40 * +
         sk-poses @ rot 40 * +
         RED DrawLine3D
      then
      1 sk-i +!
   repeat ;

: example
   0 animsCount !  0 animFrame !  0 animId !
   1 show-mesh !  1 show-skel !  0 anim-playing !
   screenWidth screenHeight z" raylib [models] example - loading m3d" InitWindow
   mdl z" /home/dave/Code/raylib/examples/models/resources/models/m3d/cesium_man.m3d" LoadModel drop
   z" /home/dave/Code/raylib/examples/models/resources/models/m3d/cesium_man.m3d" animsCount LoadModelAnimations anims !
   DisableCursor
   60 SetTargetFPS
   begin
      camera CAMERA_FIRST_PERSON UpdateCamera
      animsCount @ if
         KEY_SPACE down KEY_N IsKeyPressed or if
            1 animFrame +!
            animFrame @ animId @ anim[] 4 + l@ >= if 0 animFrame ! then
            mdl animId @ anim[] animFrame @ UpdateModelAnimation
            1 anim-playing !
         then
         KEY_C IsKeyPressed if
            0 animFrame !
            animId @ 1+ animsCount @ mod animId !
            mdl animId @ anim[] 0 UpdateModelAnimation
            1 anim-playing !
         then
      then
      KEY_B IsKeyPressed if show-skel @ 0= show-skel ! then
      KEY_M IsKeyPressed if show-mesh @ 0= show-mesh ! then
      BeginDrawing
         RAYWHITE ClearBackground
         camera BeginMode3D
            show-mesh @ if mdl position 1e WHITE DrawModel then
            show-skel @ if
               mdl mdl.boneCount 1- 0 max
               anim-playing @ animsCount @ and if
                  animId @ anim[] modelAnimation_framePoses @ animFrame @ cells + @
                  animId @ anim[] modelAnimation_bones @
                  rot draw-skel
               else
                  mdl mdl.bindPose  mdl mdl.bones  rot draw-skel
               then
            then
            10 1e DrawGrid
         EndMode3D
         z" PRESS SPACE to PLAY MODEL ANIMATION" 10 GetScreenHeight 80 - 10 MAROON DrawText
         z" PRESS N to STEP ONE ANIMATION FRAME" 10 GetScreenHeight 60 - 10 DARKGRAY DrawText
         z" PRESS C to CYCLE THROUGH ANIMATIONS" 10 GetScreenHeight 40 - 10 DARKGRAY DrawText
         z" PRESS M to toggle MESH, B to toggle SKELETON DRAWING" 10 GetScreenHeight 20 - 10 DARKGRAY DrawText
         z" (c) CesiumMan model by KhronosGroup" GetScreenWidth 210 - GetScreenHeight 20 - 10 GRAY DrawText
      EndDrawing
   WindowShouldClose until
   anims @ animsCount @ UnloadModelAnimations
   mdl UnloadModel
   CloseWindow ;

example-end
